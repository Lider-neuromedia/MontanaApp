import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/message.dart';
import 'package:montana_mobile/providers/validation_field.dart';
import 'package:montana_mobile/utils/preferences.dart';

class MessageProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  final _preferences = Preferences();

  int _userId;
  int get userId => _userId;

  set userId(int value) {
    _userId = value;
    notifyListeners();
  }

  int _pqrsId;
  int get pqrsId => _pqrsId;

  set pqrsId(int value) {
    _pqrsId = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
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
    if (_message.isEmptyOrHasError()) return false;
    if (_userId == null) return false;
    if (_pqrsId == null) return false;
    return true;
  }

  Future<Mensaje> createMessage() async {
    final url = Uri.parse('$_url/newMessage');
    final Map<String, dynamic> data = {
      'mensaje': _message.value,
      'usuario': _userId,
      'pqrs': _pqrsId,
    };
    final response = await http.post(
      url,
      headers: _preferences.signedHeaders,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) return null;
    return responseMensajeFromJson(response.body).mensaje;
  }
}
