import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/models/order_product.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class OrderProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  Pedido _order;
  Pedido get order => _order;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadOrder(int orderId, {@required bool local}) async {
    _order = null;
    _isLoading = true;
    notifyListeners();

    _order = local ? await getOrderLocal(orderId) : await getOrder(orderId);

    _isLoading = false;
    notifyListeners();
  }

  Future<Pedido> getOrder(int orderId) async {
    final url = Uri.parse("$_url/pedidos/$orderId");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseOrderFromJson(response.body).pedido;
  }

  Future<Pedido> getOrderLocal(orderId) async {
    final record = await DatabaseProvider.db.getRecordById("orders", orderId);

    if (record == null) return null;

    Map<String, Object> row = Map<String, Object>.of(record);
    row["id_pedido"] = row["id"];
    row["info_cliente"] = jsonDecode(row["info_cliente"]);
    row["productos"] = jsonDecode(row["productos"]);
    row["novedades"] = jsonDecode(row["novedades"]);
    return Pedido.fromJson(row);
  }

  void sortOrderProductsBy(String value, bool desc) {
    _order.detalles.sort((PedidoProducto product, PedidoProducto previus) {
      int compare = 0;

      if (value == "reference") {
        compare = product.referencia.compareTo(previus.referencia);
      }
      if (value == "place") {
        compare = product.lugar.compareTo(previus.lugar);
      }

      return desc ? compare : compare * -1;
    });
    notifyListeners();
  }
}
