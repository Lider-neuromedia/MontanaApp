import 'package:flutter/material.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/utils/preferences.dart';

class CataloguesProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Catalogo> _catalogues = [];
  List<Catalogo> get catalogues => _catalogues;

  Future<void> loadCatalogues() async {
    _catalogues = [];
    _isLoading = true;
    notifyListeners();
    _catalogues = await getCatalogues();
    _isLoading = false;
    notifyListeners();
  }

  Future<List<Catalogo>> getCatalogues() async {
    final preferences = Preferences();
    final url = Uri.parse('$_url/catalogos');
    final response = await http.get(url, headers: preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseCatalogosFromJson(response.body).catalogos;
  }
}
