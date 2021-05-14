import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ProductsProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  List<Producto> _products = [];
  List<Producto> _showRoomProducts = [];
  bool _isLoadingProducts = false;
  bool _isLoadingShowRoom = false;

  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingShowRoom => _isLoadingShowRoom;

  List<Producto> get products => _products;
  List<Producto> get showRoomProducts => _showRoomProducts;

  Future<void> loadProducts(int catalogId) async {
    final preferences = Preferences();
    _products = [];

    _isLoadingProducts = true;
    notifyListeners();

    Uri url = Uri.parse('$_url/productos/$catalogId');

    http.Response response = await http.get(
      url,
      headers: preferences.httpSignedHeaders,
    );

    if (response.statusCode == 200) {
      ResponseProductos responseProductos =
          responseProductosFromJson(response.body);
      _products = responseProductos.productos;
    }

    _isLoadingProducts = false;
    notifyListeners();
  }

  Future<void> loadShowRoomProducts() async {
    final preferences = Preferences();
    _showRoomProducts = [];

    _isLoadingShowRoom = true;
    notifyListeners();

    Uri url = Uri.parse('$_url/getProductsShowRoom');

    http.Response response = await http.get(
      url,
      headers: preferences.httpSignedHeaders,
    );

    if (response.statusCode == 200) {
      ResponseProductos responseProductos =
          responseProductosFromJson(response.body);
      _showRoomProducts = responseProductos.productos;
    }

    _isLoadingShowRoom = false;
    notifyListeners();
  }
}