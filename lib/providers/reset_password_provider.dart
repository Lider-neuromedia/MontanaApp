import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/providers/validation_field.dart';
import 'package:http/http.dart' as http;
import 'package:montana_mobile/utils/preferences.dart';

class ResetPasswordProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];

  ValidationField _token = ValidationField();
  ValidationField _email = ValidationField();
  ValidationField _password = ValidationField();
  ValidationField _passwordConfirmation = ValidationField();
  bool _isLoading = false;

  String get token => _token.value;
  String get tokenError => _token.error;

  String get email => _email.value;
  String get emailError => _email.error;

  String get password => _password.value;
  String get passwordError => _password.error;

  String get passwordConfirmation => _passwordConfirmation.value;
  String get passwordConfirmationError => _passwordConfirmation.error;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set token(String value) {
    final errorLength = ValidationField.validateLength(value, max: 100);

    if (errorLength != null) {
      _token = ValidationField(error: errorLength);
    } else {
      _token = ValidationField(value: value);
    }

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

  set password(String value) {
    final errorLength = ValidationField.validateLength(value, min: 6, max: 30);
    final errorConfirm = ValidationField.validateConfirmEquals(
        value, _passwordConfirmation.value);

    if (errorLength != null) {
      _password = ValidationField(error: errorLength);
    } else if (errorConfirm != null) {
      _password = ValidationField(error: errorConfirm);
    } else {
      _password = ValidationField(value: value);
    }

    notifyListeners();
  }

  set passwordConfirmation(String value) {
    final errorLength = ValidationField.validateLength(value, min: 6, max: 30);
    final errorConfirm =
        ValidationField.validateConfirmEquals(value, _password.value);

    if (errorLength != null) {
      _passwordConfirmation = ValidationField(error: errorLength);
    } else if (errorConfirm != null) {
      _passwordConfirmation = ValidationField(error: errorConfirm);
    } else {
      _passwordConfirmation = ValidationField(value: value);
    }

    notifyListeners();
  }

  bool get canSend {
    bool isValid = true;

    if (_isLoading) {
      isValid = false;
    }
    if (_token.isEmptyAndHasError() ||
        _email.isEmptyAndHasError() ||
        _password.isEmptyAndHasError() ||
        _passwordConfirmation.isEmptyAndHasError()) {
      isValid = false;
    }

    return isValid;
  }

  Future<bool> resetPassword() async {
    final preferences = Preferences();
    final url = Uri.parse('$_url/password/reset');
    final Map<String, String> data = {
      'token': _token.value,
      'email': _email.value,
      'password': _password.value,
      'password_confirmation': _passwordConfirmation.value,
    };

    http.Response response =
        await http.post(url, headers: preferences.guestHeaders, body: data);

    return response.statusCode == 200;
  }
}
