import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ClientsProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  final _preferences = Preferences();

  List<Cliente> _clients = [];
  List<Cliente> get clients => _clients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _search = '';
  String get search => _search;
  bool get isSearchActive => _search.isNotEmpty && searchClients.length == 0;

  set search(String value) {
    _search = value.toLowerCase();
    notifyListeners();
  }

  List<Cliente> get searchClients {
    return _clients.where((client) {
      bool match = false;
      String name = "${client.nombreCompleto.toLowerCase()}";
      String email = "${client.email.toLowerCase()}";
      String dni = "${client.dni.toLowerCase()}";
      String id = "${client.id.toString().toLowerCase()}";
      String nit = "${client.getData('nit').toLowerCase()}";
      String razonSocial = "${client.getData('razon_social').toLowerCase()}";
      String phone = "${client.getData('telefono').toLowerCase()}";

      if (name.indexOf(_search) != -1 ||
          email.indexOf(_search) != -1 ||
          dni.indexOf(_search) != -1 ||
          id.indexOf(_search) != -1 ||
          nit.indexOf(_search) != -1 ||
          razonSocial.indexOf(_search) != -1 ||
          phone.indexOf(_search) != -1) {
        match = true;
      }

      return match;
    }).toList();
  }

  Future<void> loadClients({@required bool local}) async {
    _clients = [];
    _search = '';
    _isLoading = true;
    notifyListeners();

    _clients = local ? await getSellerClientsLocal() : await getSellerClients();

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Cliente>> getSellerClients() async {
    final user = _preferences.session;
    final url = Uri.parse('$_url/clientes-asignados/${user.id}');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseVendedorClientesFromJson(response.body);
  }

  Future<List<Cliente>> getSellerClientsLocal() async {
    final db = await DatabaseProvider.db.database;
    final list = await db.query('clients');

    var clients = List<Cliente>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row['user_data'] = jsonDecode(row['user_data']);
      row['vendedor'] = jsonDecode(row['vendedor']);
      row['tiendas'] = jsonDecode(row['tiendas']);
      row['pedidos'] = jsonDecode(row['pedidos']);
      return Cliente.fromJson(row);
    }));

    return clients;
  }

  Future<Cliente> getClient(int id) async {
    final url = Uri.parse('$_url/cliente/$id');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseClienteFromJson(response.body);
  }

  Future<Cliente> getClientLocal(int id) async {
    bool exists = await DatabaseProvider.db.existsRecordById('clients', id);

    if (!exists) return null;

    final record = await DatabaseProvider.db.getRecordById('clients', id);
    Map<String, Object> recordTemp = Map<String, Object>.of(record);
    recordTemp['user_data'] = jsonDecode(recordTemp['user_data']);
    recordTemp['vendedor'] = jsonDecode(recordTemp['vendedor']);
    recordTemp['tiendas'] = jsonDecode(recordTemp['tiendas']);
    recordTemp['pedidos'] = jsonDecode(recordTemp['pedidos']);
    return Cliente.fromJson(recordTemp);
  }
}
