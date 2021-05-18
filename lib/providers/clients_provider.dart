import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ClientsProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  List<Cliente> _clients = [];
  bool _isLoading = false;

  ClientsProvider() {
    loadClients();
  }

  List<Cliente> get clients => _clients;
  bool get isLoading => _isLoading;

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
}
