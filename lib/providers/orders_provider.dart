import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class OrdersProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final List<SortValue> sortValues = _sortValues;
  final _preferences = Preferences();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Pedido> _orders = [];
  List<Pedido> get orders => _orders;

  _Pagination _pagination = _Pagination();
  _Pagination get pagination => _pagination;

  String _sortBy = SortValue.RECENT_FIRST;
  String get sortBy => _sortBy;

  set sortBy(String value) {
    _sortBy = value;
    notifyListeners();
  }

  Future<void> loadOrders({@required bool local, bool refresh = false}) async {
    if (refresh) {
      _orders = [];
      _pagination = _Pagination();
    }

    _isLoading = true;
    notifyListeners();

    final responseOrders = local
        ? await getOrdersLocal(_pagination.currentPage + 1, _sortBy)
        : await getOrders(_pagination.currentPage + 1, _sortBy, "");

    if (responseOrders != null) {
      _pagination = _Pagination(
        currentPage: responseOrders.currentPage,
        lastPage: responseOrders.lastPage,
      );
      _orders.addAll(responseOrders.data);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Pedidos> getOrders(int page, String sort, String search) async {
    final url = Uri.parse("$_url/pedidos?page=$page&sort=$sort&search=$search");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseOrdersFromJson(response.body).pedidos;
  }

  Future<Pedidos> getOrdersLocal(int page, String sort) async {
    final db = await DatabaseProvider.db.database;

    final response = await db.rawQuery("select count(*) as total from orders");

    final int limit = 20;
    final int offset = (page - 1) * limit;
    final int total = response.first["total"];
    final int lastPage = (total / limit).ceil();

    String sortBy = "";

    if (sort == 'recientes') {
      sortBy = 'fecha desc';
    } else if (sort == 'ultimos') {
      sortBy = 'fecha asc';
    } else if (sort == 'entregados') {
      sortBy = 'estado asc';
    } else if (sort == 'cancelados') {
      sortBy = 'estado desc';
    }

    final list = await db.query(
      "orders",
      offset: offset,
      limit: limit,
      orderBy: sortBy,
    );

    final orders = List<Pedido>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row["id_pedido"] = row["id"];
      row["vendedor"] = jsonDecode(row["vendedor"]);
      row["cliente"] = jsonDecode(row["cliente"]);
      row["estado"] = jsonDecode(row["estado"]);
      row["detalles"] = jsonDecode(row["detalles"]);
      row["novedades"] = jsonDecode(row["novedades"]);
      return Pedido.fromJson(row);
    }));

    return Pedidos(
      currentPage: page,
      lastPage: lastPage,
      data: orders,
    );
  }
}

class SortValue {
  static const RECENT_FIRST = "recientes";
  static const LAST_FIRST = "ultimos";
  static const STATUS = "entregados";
  static const STATUS_REVERSE = "cancelados";

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

class _Pagination {
  int currentPage;
  int lastPage;

  _Pagination({this.currentPage = 0, this.lastPage = 1});

  bool isEndReached() {
    return currentPage >= lastPage;
  }

  bool isEndNotReached() {
    return currentPage < lastPage;
  }
}
