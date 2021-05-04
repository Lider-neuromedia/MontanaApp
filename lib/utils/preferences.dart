import 'package:montana_mobile/models/session.dart';
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

  get token {
    return _prefs.getString('token') ?? null;
  }

  set token(value) {
    if (value == null) {
      _prefs.remove('token');
    } else {
      _prefs.setString('token', value);
    }
  }

  get session {
    var value = _prefs.getString('session') ?? null;
    return value != null ? sessionFromJson(value) : null;
  }

  set session(value) {
    if (value == null) {
      _prefs.remove('session');
    } else {
      _prefs.setString('session', json.encode(value.toJson()));
    }
  }
}