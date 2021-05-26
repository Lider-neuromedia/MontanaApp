import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ClientsProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];

  ClientsProvider() {
    loadClients();
  }

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
