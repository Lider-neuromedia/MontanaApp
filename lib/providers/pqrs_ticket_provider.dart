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

  int _vendedorId;
  int get vendedorId => _vendedorId;

  set vendedorId(int value) {
    _vendedorId = value;
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
    if (_pqrsType.isEmptyAndHasError()) return false;
    if (_message.isEmptyAndHasError()) return false;
    if (_vendedorId == null) return false;
    if (_clienteId == null) return false;
    return true;
  }

  Future<bool> createPqrs() async {
    final preferences = Preferences();
    final url = Uri.parse('$_url/pqrs');
    final Map<String, dynamic> data = {
      'mensaje': _message.value,
      'tipo': _pqrsType.value,
      'vendedor': vendedorId,
      'cliente': clienteId,
    };

    final response = await http.post(url,
        headers: preferences.signedHeaders, body: jsonEncode(data));

    return response.statusCode == 200;
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
