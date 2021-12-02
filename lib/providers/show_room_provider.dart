import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ShowRoomProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  final _preferences = Preferences();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Producto> _products = [];
  List<Producto> get products => _products;

  Future<void> loadShowRoomProducts({@required bool local}) async {
    _products = [];
    _isLoading = true;
    notifyListeners();

    _products =
        local ? await getShowRoomProductsLocal() : await getShowRoomProducts();

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Producto>> getShowRoomProducts() async {
    final url = Uri.parse('$_url/getProductsShowRoom');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseProductosFromJson(response.body).productos;
  }

  Future<List<Producto>> getShowRoomProductsLocal() async {
    final db = await DatabaseProvider.db.database;
    List<Map<String, Object>> list = await db.query(
      'products',
      where: 'tipo = ?',
      whereArgs: ['show room'],
    );

    List<Producto> products = List<Producto>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row['id_producto'] = row['id'];
      row['imagenes'] = jsonDecode(row['imagenes']);
      return Producto.fromJson(row);
    }));

    return products;
  }
}
