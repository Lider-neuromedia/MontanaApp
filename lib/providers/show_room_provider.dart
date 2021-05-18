import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ShowRoomProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  bool _isLoading = false;
  List<Producto> _products = [];

  ShowRoomProvider() {
    loadShowRoomProducts();
  }

  bool get isLoading => _isLoading;
  List<Producto> get products => _products;

  Future<void> loadShowRoomProducts() async {
    _products = [];
    _isLoading = true;
    notifyListeners();
    _products = await getShowRoomProducts();
    _isLoading = false;
    notifyListeners();
  }

  Future<List<Producto>> getShowRoomProducts() async {
    final preferences = Preferences();
    final url = Uri.parse('$_url/getProductsShowRoom');
    final response = await http.get(url, headers: preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseProductosFromJson(response.body).productos;
  }
}
