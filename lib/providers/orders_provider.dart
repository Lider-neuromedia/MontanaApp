import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/utils/preferences.dart';

class OrdersProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  final List<SortValue> sortValues = _sortValues;

  OrdersProvider() {
    loadOrders();
  }

  Pedido _order;
  Pedido get order => _order;

  List<Pedido> _orders = [];
  List<Pedido> get orders => _orders;

  String _sortBy;
  String get sortBy => _sortBy;

  bool _isLoading = false;
  bool _isOrderLoading = false;
  bool get isLoading => _isLoading;
  bool get isOrderLoading => _isOrderLoading;

  set sortBy(String value) {
    _sortBy = value;
    _sortOrders();
    notifyListeners();
  }

  Future<void> loadOrders() async {
    _orders = [];
    _isLoading = true;
    notifyListeners();
    _orders = await getOrders();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadOrder(int orderId) async {
    _order = null;
    _isOrderLoading = true;
    notifyListeners();
    _order = await getOrder(orderId);
    _isOrderLoading = false;
    notifyListeners();
  }

  Future<List<Pedido>> getOrders() async {
    final prefs = Preferences();
    final url = Uri.parse('$_url/pedidos');
    final response = await http.get(url, headers: prefs.signedHeaders);

    if (response.statusCode != 200) return [];
    return responsePedidosFromJson(response.body).pedidos;
  }

  Future<Pedido> getOrder(int orderId) async {
    final prefs = Preferences();
    final url = Uri.parse('$_url/pedidos/$orderId');
    final response = await http.get(url, headers: prefs.signedHeaders);

    if (response.statusCode != 200) return null;
    return responsePedidoFromJson(response.body).pedido;
  }

  void _sortOrders() {
    _orders.sort((Pedido order, Pedido previus) {
      if (_sortBy == SortValue.RECENT_FIRST) {
        return order.fecha.compareTo(previus.fecha) * -1;
      }
      if (_sortBy == SortValue.LAST_FIRST) {
        return order.fecha.compareTo(previus.fecha);
      }
      if (_sortBy == SortValue.STATUS) {
        return order.idEstado.compareTo(previus.idEstado);
      }
      if (_sortBy == SortValue.STATUS_REVERSE) {
        return order.idEstado.compareTo(previus.idEstado) * -1;
      }
      return 0;
    });
  }

  void sortOrderProductsBy(String value, bool desc) {
    _order.productos.sort((PedidoProducto product, PedidoProducto previus) {
      int compare = 0;

      if (value == 'reference') {
        compare = product.referencia.compareTo(previus.referencia);
      }
      if (value == 'place') {
        compare = product.lugar.compareTo(previus.lugar);
      }

      return desc ? compare : compare * -1;
    });
    notifyListeners();
  }

  void sortOrderProductsByPlace(String place) {}
}

class SortValue {
  static const RECENT_FIRST = "1";
  static const LAST_FIRST = "2";
  static const STATUS = "3";
  static const STATUS_REVERSE = "4";

  String id;
  String value;

  SortValue(this.id, this.value);
}

final List<SortValue> _sortValues = [
  SortValue(SortValue.RECENT_FIRST, "Más Recientes"),
  SortValue(SortValue.LAST_FIRST, "Más Antigüos"),
  SortValue(SortValue.STATUS, "Entregados Primero"),
  SortValue(SortValue.STATUS_REVERSE, "Cancelados Primero"),
];
