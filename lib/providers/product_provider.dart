import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ProductProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Producto _product;
  Producto get product => _product;

  Future<void> loadProduct(int productId, {@required bool local}) async {
    _product = null;
    _isLoading = true;
    notifyListeners();

    _product =
        local ? await getProductLocal(productId) : await getProduct(productId);

    _isLoading = false;
    notifyListeners();
  }

  Future<Producto> getProduct(int productoId) async {
    final url = Uri.parse("$_url/producto/$productoId");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseProductoFromJson(response.body).producto;
  }

  Future<Producto> getProductLocal(int id) async {
    final record = await DatabaseProvider.db.getRecordById("products", id);

    if (record == null) return null;

    Map<String, Object> recordTemp = Map<String, Object>.of(record);
    recordTemp["id_producto"] = recordTemp["id"];
    recordTemp["imagenes"] = jsonDecode(recordTemp["imagenes"]);
    return Producto.fromJson(recordTemp);
  }
}
