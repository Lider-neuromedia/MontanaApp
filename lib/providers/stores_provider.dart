import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/utils/preferences.dart';

class StoresProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  final _preferences = Preferences();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Tienda> _stores = [];
  List<Tienda> get stores => _stores;

  String _search = '';
  String get search => _search;
  bool get isSearchActive => _search.isNotEmpty && searchStores.length == 0;

  set search(String value) {
    _search = value.toLowerCase();
    notifyListeners();
  }

  List<Tienda> get searchStores {
    return _stores.where((store) {
      bool match = false;

      String nombre = "${store.nombre.toLowerCase()}";
      String lugar = "${store.lugar.toLowerCase()}";
      String local = "${store.local.toLowerCase()}";
      String direccion = "${store.direccion.toLowerCase()}";
      String telefono = "${store.telefono.toLowerCase()}";
      String idCliente = "${store.cliente.toString().toLowerCase()}";
      String idTiendas = "${store.idTiendas.toString().toLowerCase()}";
      String stock = "${store.stock.toString().toLowerCase()}";

      if (nombre.indexOf(_search) != -1 ||
          lugar.indexOf(_search) != -1 ||
          local.indexOf(_search) != -1 ||
          direccion.indexOf(_search) != -1 ||
          telefono.indexOf(_search) != -1 ||
          idCliente.indexOf(_search) != -1 ||
          idTiendas.indexOf(_search) != -1 ||
          stock.indexOf(_search) != -1) {
        match = true;
      }

      return match;
    }).toList();
  }

  Future<void> loadStores() async {
    _stores = [];
    _search = '';
    _isLoading = true;
    notifyListeners();
    _stores = await getStores();
    _isLoading = false;
    notifyListeners();
  }

  Future<List<Tienda>> getStores() async {
    final url = Uri.parse('$_url/tiendas-cliente/${_preferences.session.id}');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseTiendasFromJson(response.body);
  }
}
