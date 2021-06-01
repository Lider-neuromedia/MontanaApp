import 'package:montana_mobile/models/session.dart';
import 'package:montana_mobile/pages/home/home_page.dart';
import 'package:montana_mobile/pages/session/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Preferences {
  static final Preferences _instance = Preferences._();

  factory Preferences() {
    return _instance;
  }

  Preferences._();

  SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get token {
    return _prefs.getString('token') ?? null;
  }

  set token(String value) {
    if (value == null) {
      _prefs.remove('token');
    } else {
      _prefs.setString('token', value);
    }
  }

  Session get session {
    final value = _prefs.getString('session') ?? null;
    return value != null ? sessionFromJson(value) : null;
  }

  set session(Session value) {
    if (value == null) {
      _prefs.remove('session');
    } else {
      _prefs.setString('session', json.encode(value.toJson()));
    }
  }

  String get initialPage {
    return session == null || token == null ? LoginPage.route : HomePage.route;
  }

  Map<String, String> get guestHeaders => {
        'X-Requested-With': 'XMLHttpRequest',
      };

  Map<String, String> get signedHeaders => {
        'content-type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer $token',
      };
}
