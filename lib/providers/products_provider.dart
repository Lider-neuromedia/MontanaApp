import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ProductsProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  List<Producto> _products = [];
  bool _isLoadingProducts = false;
  bool _isLoadingProduct = false;
  Producto _product;

  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingProduct => _isLoadingProduct;
  Producto get product => _product;
  List<Producto> get products => _products;

  Future<void> loadProducts(int catalogId) async {
    _products = [];
    _isLoadingProducts = true;
    notifyListeners();
    _products = await getProducts(catalogId);
    _isLoadingProducts = false;
    notifyListeners();
  }

  Future<void> loadProduct(int productId) async {
    _product = null;
    _isLoadingProduct = true;
    notifyListeners();
    _product = await getProduct(productId);
    _isLoadingProduct = false;
    notifyListeners();
  }

  Future<List<Producto>> getProducts(int catalogId) async {
    final preferences = Preferences();
    final url = Uri.parse('$_url/productos/$catalogId');
    final response = await http.get(url, headers: preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseProductosFromJson(response.body).productos;
  }

  Future<Producto> getProduct(int productoId) async {
    final prefs = Preferences();
    final url = Uri.parse('$_url/producto/$productoId');
    final response = await http.get(url, headers: prefs.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseProductoFromJson(response.body).producto;
  }
}
