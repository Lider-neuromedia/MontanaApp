import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ClientProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  Future<Usuario> getClient(int id) async {
    final url = Uri.parse("$_url/cliente/$id");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseUsuarioFromJson(response.body);
  }

  Future<Usuario> getClientLocal(int id) async {
    bool exists = await DatabaseProvider.db.existsRecordById("clients", id);

    if (!exists) return null;

    final record = await DatabaseProvider.db.getRecordById("clients", id);
    Map<String, Object> recordTemp = Map<String, Object>.of(record);
    recordTemp["datos"] = jsonDecode(recordTemp["datos"]);
    recordTemp["vendedor"] = jsonDecode(recordTemp["vendedor"]);
    recordTemp["tiendas"] = jsonDecode(recordTemp["tiendas"]);
    recordTemp["pedidos"] = jsonDecode(recordTemp["pedidos"]);
    return Usuario.fromJson(recordTemp);
  }

  Future<List<Tienda>> getClientStores(int clientId) async {
    final url = Uri.parse("$_url/tiendas-cliente/$clientId");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseTiendasFromJson(response.body);
  }

  Future<List<Tienda>> getClientStoresLocal(int clientId) async {
    final db = await DatabaseProvider.db.database;
    List<Map<String, Object>> list = await db.query(
      "stores",
      where: "cliente = ?",
      whereArgs: [clientId],
    );

    List<Tienda> stores = List<Tienda>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row["id_tiendas"] = row["id"];
      return Tienda.fromJson(row);
    }));

    return stores;
  }
}
