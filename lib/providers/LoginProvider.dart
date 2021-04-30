import 'package:flutter/material.dart';
import 'package:montana_mobile/utils/utils.dart';

class LoginProvider with ChangeNotifier {
  String _email = '';
  String _password = '';

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

  bool login() {
    return false;
  }
}
