import 'package:montana_mobile/utils/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class SessionProvider {
  final String _url = dotenv.env['API_URL'];
  final _preferences = Preferences();

  Future<bool> isUserSessionValid() async {
    final url = Uri.parse('$_url/auth/getUserSesion');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode == 403 || response.statusCode == 401) {
      _preferences.token = null;
      _preferences.session = null;
      return false;
    }

    return true;
  }
}
