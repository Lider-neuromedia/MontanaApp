import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ClientsProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  List<Cliente> _clients = [];
  List<Cliente> _searchClients = [];
  bool _isLoading = false;
  String _search;

  ClientsProvider() {
    loadClients();
  }

  List<Cliente> get clients => _clients;
  bool get isLoading => _isLoading;
  String get search => _search;

  set search(String value) {
    _search = value;
    _searchClients = [];

    if (_search.isNotEmpty) {
      _searchClients = _clients.where((client) {
        bool match = false;

        if (client.nombreCompleto.indexOf(value) != -1) {
          match = true;
        } else if (client.email.indexOf(value) != -1) {
          match = true;
        } else if (client.dni.indexOf(value) != -1) {
          match = true;
        } else if (client.id.toString().indexOf(value) != -1) {
          match = true;
        } else if (client.getData('nit').indexOf(value) != -1) {
          match = true;
        } else if (client.getData('razon_social').indexOf(value) != -1) {
          match = true;
        } else if (client.getData('telefono').indexOf(value) != -1) {
          match = true;
        }

        return match;
      });
    }

    notifyListeners();
  }

  Future<void> loadClients() async {
    _clients = [];
    _isLoading = true;
    notifyListeners();
    _clients = await getClients();
    _isLoading = false;
    notifyListeners();
  }

  Future<List<Cliente>> getClients() async {
    final preferences = Preferences();
    final url = Uri.parse('$_url/clientes');
    final response = await http.get(url, headers: preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseClientesFromJson(response.body).clientes;
  }

  Future<Cliente> getClient(int id) async {
    final preferences = Preferences();
    final url = Uri.parse('$_url/cliente/$id');
    final response = await http.get(url, headers: preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseClienteFromJson(response.body);
  }
}
