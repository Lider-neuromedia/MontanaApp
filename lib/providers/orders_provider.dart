import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'dart:convert';

class OrdersProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  List<Pedido> _orders = [];

  final sortValues = [
    SortValue(SortValue.RECENT_FIRST, "Más Recientes"),
    SortValue(SortValue.LAST_FIRST, "Más Antigüos"),
    SortValue(SortValue.STATUS, "Entregados Primero"),
    SortValue(SortValue.STATUS_REVERSE, "Cancelados Primero"),
  ];

  String _sortBy = SortValue.RECENT_FIRST;
  bool _isLoading = false;

  OrdersProvider() {
    loadOrders();
  }

  bool get isLoading => _isLoading;
  List<Pedido> get orders => _orders;
  String get sortBy => _sortBy;

  set sortBy(String value) {
    _sortBy = value;
    sortOrders();
    notifyListeners();
  }

  Future<void> loadOrders() async {
    final preferences = Preferences();
    _orders = [];

    _isLoading = true;
    notifyListeners();

    Uri url = Uri.parse('$_url/pedidos');

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

  void sortOrders() {
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
