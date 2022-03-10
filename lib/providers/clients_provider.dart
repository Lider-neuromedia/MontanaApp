import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ClientsProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  List<Usuario> _clients = [];
  List<Usuario> get clients => _clients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _search = "";
  String get search => _search;
  bool get isSearchActive => _search.isNotEmpty && searchClients.length == 0;

  set search(String value) {
    _search = value.trim().toLowerCase();
    notifyListeners();
  }

  List<Usuario> get searchClients =>
      _clients.where((client) => client.hasMatch(_search)).toList();

  Future<void> loadClients({@required bool local}) async {
    _clients = [];
    _search = "";
    _isLoading = true;
    notifyListeners();

    _clients = local ? await getSellerClientsLocal() : await getSellerClients();

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Usuario>> getSellerClients() async {
    final user = _preferences.session;
    final url = Uri.parse("$_url/clientes-asignados/${user.id}");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseVendedorClientesFromJson(response.body);
  }

  Future<List<Usuario>> getSellerClientsLocal() async {
    final db = await DatabaseProvider.db.database;
    final list = await db.query("clients");

    var clients = List<Usuario>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row["datos"] = jsonDecode(row["datos"]);
      row["vendedor"] = jsonDecode(row["vendedor"]);
      row["tiendas"] = jsonDecode(row["tiendas"]);
      row["pedidos"] = jsonDecode(row["pedidos"]);
      return Usuario.fromJson(row);
    }));

    return clients;
  }
}
