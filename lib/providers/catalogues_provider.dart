import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:http/http.dart' as http;
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class CataloguesProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Catalogo> _catalogues = [];
  List<Catalogo> get catalogues => _catalogues;

  Future<void> loadCatalogues({@required bool local}) async {
    _catalogues = [];
    _isLoading = true;
    notifyListeners();

    _catalogues = local ? await getCataloguesLocal() : await getCatalogues();

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Catalogo>> getCatalogues() async {
    final url = Uri.parse("$_url/consumerCatalogos");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseCatalogosFromJson(response.body).catalogos;
  }

  Future<List<Catalogo>> getCataloguesLocal() async {
    final db = await DatabaseProvider.db.database;
    List<Map<String, Object>> list = await db.query("catalogues");
    var catalogues = List<Catalogo>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row["id_catalogo"] = row["id"];
      return Catalogo.fromJson(row);
    }));
    return catalogues;
  }
}
