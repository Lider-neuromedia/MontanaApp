import 'package:flutter/material.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/utils/preferences.dart';

class CataloguesProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  List<Catalogo> _catalogues = [];
  bool _isLoading = false;

  CataloguesProvider() {
    loadCatalogues();
  }

  bool get isLoading => _isLoading;

  List<Catalogo> get catalogues => _catalogues;

  Future<void> loadCatalogues() async {
    final preferences = Preferences();
    _catalogues = [];

    _isLoading = true;
    notifyListeners();

    Uri url = Uri.parse('$_url/catalogos');

    http.Response response =
        await http.get(url, headers: preferences.httpSignedHeaders);

    if (response.statusCode == 200) {
      ResponseCatalogos responseCatalogos =
          responseCatalogosFromJson(response.body);
      _catalogues = responseCatalogos.catalogos;
    }

    _isLoading = false;
    notifyListeners();
  }
}
