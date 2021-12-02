import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/providers/validation_field.dart';
import 'package:montana_mobile/utils/preferences.dart';

class PqrsTicketProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  final List<PqrsType> pqrsTypes = _pqrsTypes;
  final _preferences = Preferences();

  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  set clientes(List<Cliente> list) {
    _clientes = list;
    notifyListeners();
  }

  int _clienteId;
  int get clienteId => _clienteId;

  set clienteId(int value) {
    _clienteId = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  ValidationField _pqrsType = ValidationField();
  String get pqrsType => _pqrsType.value;
  String get pqrsTypeError => _pqrsType.error;

  set pqrsType(String value) {
    bool errorValidType = false;

    pqrsTypes.forEach((type) {
      if (type.id == value) {
        errorValidType = true;
      }
    });

    if (!errorValidType) {
      _pqrsType = ValidationField(error: 'Tipo de pqrs incorrecto.');
    } else {
      _pqrsType = ValidationField(value: value);
    }

    notifyListeners();
  }

  ValidationField _message = ValidationField();
  String get message => _message.value;
  String get messageError => _message.error;

  set message(String value) {
    final errorLength = ValidationField.validateLength(value, min: 1);

    if (errorLength != null) {
      _message = ValidationField(error: errorLength);
    } else {
      _message = ValidationField(value: value);
    }

    notifyListeners();
  }

  bool get canSend {
    if (_isLoading) return false;
    if (_pqrsType.isEmptyOrHasError()) return false;
    if (_message.isEmptyOrHasError()) return false;
    if (_preferences.session.isVendedor && _clienteId == null) return false;
    return true;
  }

  Future<bool> createPqrs({@required bool local}) async {
    final url = Uri.parse('$_url/pqrs');
    Map<String, dynamic> data = {
      'mensaje': _message.value,
      'tipo': _pqrsType.value,
    };

    if (_preferences.session.isVendedor) {
      data['vendedor'] = _preferences.session.id;
      data['cliente'] = clienteId;
    } else {
      final sellerId = local ? await getSellerIdLocal() : await getSellerId();

      if (sellerId == null) return false;

      data['vendedor'] = sellerId;
      data['cliente'] = _preferences.session.id;
    }

    final response = await http.post(
      url,
      headers: _preferences.signedHeaders,
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }

  Future<int> getSellerId() async {
    final url = Uri.parse('$_url/vendedor-asignado');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;

    final decodedResponse = json.decode(response.body);
    return decodedResponse['id'];
  }

  Future<int> getSellerIdLocal() async {
    // TODO
    return null;
  }
}

class PqrsType {
  static const QUEJA_RETRASO = "queja_retraso";

  String id;
  String value;

  PqrsType(this.id, this.value);
}

final List<PqrsType> _pqrsTypes = [
  PqrsType(PqrsType.QUEJA_RETRASO, 'Queja por retrasos'),
];
