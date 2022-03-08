import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ShowRoomProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Producto> _products = [];
  List<Producto> get products => _products;

  _Pagination _pagination = _Pagination();
  _Pagination get pagination => _pagination;

  Future<void> loadShowRoomProducts(
      {@required bool local, bool refresh = false}) async {
    if (refresh) {
      _products = [];
      _pagination = _Pagination();
    }

    _isLoading = true;
    notifyListeners();

    if (local) {
      _products = await getShowRoomProductsLocal();
    } else {
      final responseProducts =
          await getShowRoomProducts(_pagination.currentPage + 1, "");

      if (responseProducts != null) {
        _pagination = _Pagination(
          currentPage: responseProducts.currentPage,
          lastPage: responseProducts.lastPage,
        );
        _products.addAll(responseProducts.data);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Productos> getShowRoomProducts(int page, String search) async {
    final path = "$_url/getProductsShowRoom?page=$page&search=$search";
    final url = Uri.parse(path);
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseProductosFromJson(response.body).productos;
  }

  Future<List<Producto>> getShowRoomProductsLocal() async {
    final db = await DatabaseProvider.db.database;
    List<Map<String, Object>> list = await db.query(
      "products",
      where: "tipo = ?",
      whereArgs: ["show room"],
    );

    List<Producto> products = List<Producto>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row["id_producto"] = row["id"];
      row["imagenes"] = jsonDecode(row["imagenes"]);
      return Producto.fromJson(row);
    }));

    return products;
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
