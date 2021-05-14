import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/utils/preferences.dart';

class OrdersProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  List<Pedido> _orders = [];
  bool _isLoading = false;

  OrdersProvider() {
    loadOrders();
  }

  bool get isLoading => _isLoading;

  List<Pedido> get orders => _orders;

  Future<void> loadOrders() async {
    final preferences = Preferences();
    _orders = [];

    _isLoading = true;
    notifyListeners();

    Uri url = Uri.parse('$_url/catalogos');

    http.Response response = await http.get(
      url,
      headers: preferences.httpSignedHeaders,
    );

    if (response.statusCode == 200) {
      ResponseOrders responseCatalogos = responsePedidosFromJson(response.body);
      _orders = responseCatalogos.pedidos;
    }

    _isLoading = false;
    notifyListeners();
  }
}
