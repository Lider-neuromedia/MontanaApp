import 'package:flutter/material.dart';
import 'package:montana_mobile/models/session.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class LoginProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  String _email = '';
  String _password = '';
  bool isLoading = false;

  get email => _email;
  get password => _password;

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  bool get isLoginDataValid {
    bool isValid = true;

    if (_email.trim().length == 0 || _password.trim().length == 0) {
      isValid = false;
    }
    if (_password.length < 6) {
      isValid = false;
    }
    if (!isEmailValid(_email)) {
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    Uri url = Uri.parse('$_url/auth/login');
    Map<String, String> headers = {
      'X-Requested-With': 'XMLHttpRequest',
    };
    Map<String, String> data = {
      'email': _email,
      'password': _password,
    };

    isLoading = true;
    notifyListeners();

    http.Response response = await http.post(url, headers: headers, body: data);
    final preferences = Preferences();

    if (response.statusCode != 200) {
      preferences.token = null;
      preferences.session = null;
    }

    if (response.statusCode == 200) {
      Session session = sessionFromJson(response.body);
      preferences.token = session.accessToken;
      preferences.session = session;
    }

    isLoading = false;
    notifyListeners();
  }

  void logout() {
    final preferences = Preferences();
    preferences.token = null;
    preferences.session = null;
    isLoading = false;
    notifyListeners();
  }
}
