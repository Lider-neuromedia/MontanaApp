import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/utils/preferences.dart';

class SessionProvider {
  final String _url = dotenv.env['API_URL'];
  final _preferences = Preferences();

  Future<bool> isUserSessionValid() async {
    final url = Uri.parse('$_url/auth/getUserSesion');

    if (_preferences.token == null || _preferences.session == null) {
      _preferences.token = null;
      _preferences.session = null;
      return false;
    }

    try {
      final response = await http.get(url, headers: _preferences.signedHeaders);

      if (response.statusCode == 403 || response.statusCode == 401) {
        _preferences.token = null;
        _preferences.session = null;
        return false;
      }
    } catch (error) {}

    return true;
  }
}
