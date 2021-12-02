import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/providers/database_provider.dart';
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

  Future<void> loadStores({@required bool local}) async {
    _stores = [];
    _search = '';
    _isLoading = true;
    notifyListeners();

    _stores = local ? await getStoresLocal() : await getStores();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> makeDeleteStore(int id, {@required bool local}) async {
    _isLoading = true;
    notifyListeners();

    final isSuccess =
        local ? await deleteStoreLocal(id) : await deleteStore(id);
    await loadStores(local: local);

    return isSuccess;
  }

  Future<List<Tienda>> getStores() async {
    final url = Uri.parse('$_url/tiendas-cliente/${_preferences.session.id}');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseTiendasFromJson(response.body);
  }

  Future<List<Tienda>> getStoresLocal() async {
    final list = await DatabaseProvider.db.getRecords(
      'stores',
      withDeleted: false,
    );

    List<Tienda> stores = List<Tienda>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row['id_tiendas'] = row['id'];
      return Tienda.fromJson(row);
    }));

    return stores;
  }

  Future<bool> deleteStore(int id) async {
    final url = Uri.parse('$_url/delete-tiendas');
    final Map<String, dynamic> data = {
      'tiendas': [id],
    };

    final response = await http.post(
      url,
      headers: _preferences.signedHeaders,
      body: json.encode(data),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteStoreLocal(int id) async {
    await DatabaseProvider.db.checkRecordToDelete('stores', id);
    return true;
  }

  Future<void> syncDeletedStoresInLocal() async {
    final db = await DatabaseProvider.db.database;
    final records = await db.query(
      'stores',
      columns: ['id', 'check_delete'],
      where: 'check_delete = ?',
      whereArgs: [1],
    );

    if (records.isEmpty) return;

    for (final record in records) {
      final storeId = record['id'];
      final isSuccessResponse = await deleteStore(storeId);

      if (isSuccessResponse) {
        await DatabaseProvider.db.deleteRecord('stores', storeId);
      }
    }
  }
}
