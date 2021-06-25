import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/dashboard_resume.dart';
import 'package:montana_mobile/utils/preferences.dart';

class DashboardProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  final _preferences = Preferences();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DashboardResumen _resumen;
  DashboardResumen get resumen => _resumen;

  Future<void> loadDashboardResume() async {
    _resumen = null;
    _isLoading = true;
    notifyListeners();
    _resumen = await getDashboardResume();
    _isLoading = false;
    notifyListeners();
  }

  Future<DashboardResumen> getDashboardResume() async {
    final url = Uri.parse('$_url/dashboard-resumen');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return dashboardResumenFromJson(response.body);
  }
}
