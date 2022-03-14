import 'dart:convert';
import 'package:montana_mobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:montana_mobile/models/session.dart';
import 'package:montana_mobile/pages/home/home_page.dart';
import 'package:montana_mobile/pages/session/login_page.dart';

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

  DateTime get lastSync {
    final temp = _prefs.getString("last_sync");

    if (temp == null || temp.isEmpty) {
      return DateTime.now().subtract(Duration(minutes: 30));
    }

    return DateTime.parse(_prefs.getString("last_sync"));
  }

  int get lastSyncInMinutes => DateTime.now().difference(lastSync).inMinutes;
  int get lastSyncInSeconds => DateTime.now().difference(lastSync).inSeconds;
  bool get canSync => DateTime.now().difference(lastSync).inSeconds >= 60;

  set lastSync(DateTime value) {
    if (value == null) {
      _prefs.remove("last_sync");
    } else {
      _prefs.setString("last_sync", value.toIso8601String());
    }
  }

  String get token {
    return _prefs.getString("token") ?? null;
  }

  set token(String value) {
    if (value == null) {
      _prefs.remove("token");
    } else {
      _prefs.setString("token", value);
    }
  }

  Session get session {
    final value = _prefs.getString("session") ?? null;
    return value != null ? sessionFromJson(value) : null;
  }

  set session(Session value) {
    if (value == null) {
      _prefs.remove("session");
    } else {
      _prefs.setString("session", json.encode(value.toJson()));
    }
  }

  Usuario get sessionCliente {
    if (session == null) return null;

    return Usuario(
      id: session.id,
      rolId: session.rol,
      name: session.name,
      apellidos: session.apellidos,
      email: session.email,
      dni: session.dni,
      datos: session.datos,
      tipoIdentificacion: session.tipoIdentificacion,
    );
  }

  String get initialPage {
    return session == null || token == null ? LoginPage.route : HomePage.route;
  }

  Map<String, String> get guestHeaders => {
        "X-Requested-With": "XMLHttpRequest",
      };

  Map<String, String> get signedHeaders => {
        "content-type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Authorization": "Bearer $token",
      };
}
