import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/session.dart';
import 'package:montana_mobile/providers/validation_field.dart';
import 'package:montana_mobile/services/push_notification_service.dart';
import 'package:montana_mobile/utils/preferences.dart';

class LoginProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  ValidationField _email = ValidationField();
  String get email => _email.value;
  String get emailError => _email.error;

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

  ValidationField _password = ValidationField();
  String get password => _password.value;
  String get passwordError => _password.error;

  set password(String value) {
    final errorLength = ValidationField.validateLength(value, max: 100, min: 6);

    if (errorLength != null) {
      _password = ValidationField(error: errorLength);
    } else {
      _password = ValidationField(value: value);
    }

    notifyListeners();
  }

  bool get canSend {
    bool isValid = true;

    if (_email.isEmptyOrHasError() || _password.isEmptyOrHasError()) {
      isValid = false;
    } else if (_isLoading) {
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    final url = Uri.parse("$_url/auth/login");
    final Map<String, String> data = {
      "email": _email.value,
      "password": _password.value,
    };
    final response = await http.post(
      url,
      headers: _preferences.guestHeaders,
      body: data,
    );

    if (response.statusCode != 200) {
      _preferences.token = null;
      _preferences.session = null;
    }

    if (response.statusCode == 200) {
      Session session = sessionFromJson(response.body);
      _preferences.token = session.accessToken;
      _preferences.session = session;

      await PushNotificationService.saveDeviceToken();
    }

    notifyListeners();
  }

  void logout() {
    _preferences.token = null;
    _preferences.session = null;
    notifyListeners();
  }
}
