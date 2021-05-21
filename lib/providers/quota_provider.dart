import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:http/http.dart' as http;
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/models/session.dart';
import 'package:montana_mobile/providers/validation_field.dart';
import 'package:montana_mobile/utils/preferences.dart';

class QuotaProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];

  String _getFileName(File file) {
    if (file == null) return null;
    List list = List.from(file.path.split('/').reversed);
    return list[0];
  }

  File _docIdentidad;
  File get docIdentidad => _docIdentidad;
  String get descriptionIdentidad => _getFileName(_docIdentidad);

  File _docRut;
  File get docRut => _docRut;
  String get descriptionRut => _getFileName(_docRut);

  File _docCamaraCom;
  File get docCamaraCom => _docCamaraCom;
  String get descriptionCamaraCom => _getFileName(_docCamaraCom);

  set docIdentidad(File value) {
    _docIdentidad = value;
    notifyListeners();
  }

  set docRut(File value) {
    _docRut = value;
    notifyListeners();
  }

  set docCamaraCom(File value) {
    _docCamaraCom = value;
    notifyListeners();
  }

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

  ValidationField _monto = ValidationField();
  String get monto => _monto.value;
  String get montoError => _monto.error;
  TextEditingController _montoController = TextEditingController(text: '0');
  TextEditingController get montoController => _montoController;

  set monto(String value) {
    final errorInteger = ValidationField.validateInteger(value);
    final errorIntRange = ValidationField.validateIntRange(value, min: 0);

    if (errorInteger != null) {
      _monto = ValidationField(error: errorInteger);
    } else if (errorIntRange != null) {
      _monto = ValidationField(error: errorIntRange);
    } else {
      _monto = ValidationField(value: value);
    }

    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get canSend {
    if (_isLoading) return false;
    if (_monto.isEmptyAndHasError()) return false;
    if (clienteId == null) return false;
    if (_docIdentidad == null) return false;
    if (_docRut == null) return false;
    if (_docCamaraCom == null) return false;
    return true;
  }

  Future<bool> createQuotaExpansion() async {
    final preferences = Preferences();
    final user = preferences.session as Session;
    final url = Uri.parse('$_url/ampliacion-cupo');
    final Map<String, dynamic> data = {
      'monto': _monto.value,
      'vendedor': user.id,
      'cliente': clienteId,
      'doc_identidad': null,
      'doc_rut': null,
      'doc_camara_com': null,
    };

    final response = await http.post(
      url,
      headers: preferences.guestHeaders,
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }
}
