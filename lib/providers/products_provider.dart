import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ProductsProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Producto> _products = [];
  List<Producto> get products => _products;

  _Pagination _pagination = _Pagination();
  _Pagination get pagination => _pagination;

  String _search = "";
  String get search => _search;

  set search(String value) {
    _search = value.toLowerCase();
    notifyListeners();
  }

  Future<void> loadProducts(int catalogId,
      {@required bool local, bool refresh = false}) async {
    if (refresh) {
      _products = [];
      _pagination = _Pagination();
    }

    _isLoading = true;
    notifyListeners();

    final responseProducts = local
        ? await getProductsByCatalogueLocal(
            catalogId, _pagination.currentPage + 1, search)
        : await getProductsByCatalogue(
            catalogId, _pagination.currentPage + 1, search);

    if (responseProducts != null) {
      _pagination = _Pagination(
        currentPage: responseProducts.currentPage,
        lastPage: responseProducts.lastPage,
      );
      _products.addAll(responseProducts.data);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Productos> getProductsByCatalogue(
      int catalogId, int page, String search) async {
    final path = "$_url/productos/$catalogId?page=$page&search=$search";
    final url = Uri.parse(path);
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseProductosFromJson(response.body).productos;
  }

  Future<Productos> getProductsByCatalogueLocal(
      int id, int page, String search) async {
    final db = await DatabaseProvider.db.database;
    List<Map<String, Object>> list, response;

    if (search.isEmpty) {
      response = await db.rawQuery("""
        select count(*) as total
        from products
        where catalogo = ?1""", [id]);
    } else {
      response = await db.rawQuery("""
        select count(*) as total
        from products
        where catalogo = ?1 and (
            nombre LIKE ?2
            or codigo LIKE ?2
            or referencia LIKE ?2
            or precio LIKE ?2
            or descripcion LIKE ?2
            or sku LIKE ?2
            or total LIKE ?2
            or marca LIKE ?2
            or marca_id LIKE ?2
          )""", [id, "%$search%"]);
    }

    final int limit = 20;
    final int offset = (page - 1) * limit;
    final int total = response.first["total"];
    final int lastPage = (total / limit).ceil();

    if (search.isEmpty) {
      list = await db.query(
        "products",
        where: "catalogo = :id",
        whereArgs: [id],
        offset: offset,
        limit: limit,
      );
    } else {
      list = await db.query(
        "products",
        where: """catalogo = ?1 and (
          nombre LIKE ?2
          or codigo LIKE ?2
          or referencia LIKE ?2
          or precio LIKE ?2
          or descripcion LIKE ?2
          or sku LIKE ?2
          or total LIKE ?2
          or marca LIKE ?2
          or marca_id LIKE ?2
        )""",
        whereArgs: [id, "%$search%"],
        offset: offset,
        limit: limit,
      );
    }

    List<Producto> products = List<Producto>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row["id_producto"] = row["id"];
      row["imagenes"] = jsonDecode(row["imagenes"]);
      row["marca"] = jsonDecode(row["marca"]);
      return Producto.fromJson(row);
    }));

    return Productos(
      currentPage: page,
      lastPage: lastPage,
      data: products,
    );
  }
}

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
