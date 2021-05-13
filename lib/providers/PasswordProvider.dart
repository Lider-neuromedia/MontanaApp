import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:flutter/material.dart';
import 'package:montana_mobile/providers/ValidationField.dart';
import 'package:montana_mobile/utils/preferences.dart';

class PasswordProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];

  ValidationField _email = ValidationField();
  bool _isLoading = false;

  String get email => _email.value;
  String get emailError => _email.error;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set email(String value) {
    final errorLength = ValidationField.validateLength(value, max: 100);
    final errorEmail = ValidationField.validateEmail(value);

    if (errorLength != null) {
      _email = ValidationField(error: errorLength);
    } else if (errorEmail != null) {
      _email = ValidationField(error: errorEmail);
    } else {
      _email = ValidationField(value: value);
    }

    notifyListeners();
  }

  bool get canSend {
    bool isValid = true;

    if (_isLoading) {
      isValid = false;
    }
    if (_email.error != null) {
      isValid = false;
    }
    if (_email.value == null) {
      isValid = false;
    }

    return isValid;
  }

  Future<bool> requestResetEmail() async {
    Uri url = Uri.parse('$_url/password/email');
    Map<String, String> headers = {
      'X-Requested-With': 'XMLHttpRequest',
    };
    Map<String, String> data = {
      'email': _email.value,
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: data,
    );

    return response.statusCode == 200;
  }
}