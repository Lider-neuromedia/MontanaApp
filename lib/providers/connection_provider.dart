import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/models/client_wallet_resume.dart';
import 'package:montana_mobile/providers/quota_provider.dart';
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/providers/dashboard_provider.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/providers/stores_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class ConnectionProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  static Future<void> syncDataNow(BuildContext context) async {
    final preferences = Preferences();
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    if (connectionProvider.isSyncing) return;
    if (preferences.token == null) return;
    if (!preferences.canSync) return;

    await connectionProvider.syncData(
      dashboardProvider: Provider.of<DashboardProvider>(context, listen: false),
      storesProvider: Provider.of<StoresProvider>(context, listen: false),
      cartProvider: Provider.of<CartProvider>(context, listen: false),
      quotaProvider: Provider.of<QuotaProvider>(context, listen: false),
    );
  }

  bool _isConnected = true;
  bool get isConnected => _isConnected;
  bool get isNotConnected => !_isConnected;

  set isConnected(bool isConnected) {
    _isConnected = isConnected;
    notifyListeners();
  }

  String _message = "";
  String get message => _message;

  set message(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;
  bool get isNotSyncing => !_isSyncing;

  set isSyncing(bool isSyncing) {
    _isSyncing = isSyncing;
    notifyListeners();
  }

  Future<void> syncData({
    @required DashboardProvider dashboardProvider,
    @required StoresProvider storesProvider,
    @required CartProvider cartProvider,
    @required QuotaProvider quotaProvider,
  }) async {
    isSyncing = true;

    try {
      message = "Sincronizando tiendas.";
      await storesProvider.syncDeletedStoresInLocal();

      message = "Sincronizando pedidos offline.";
      await cartProvider.syncOfflineOrdersInLocal();

      message = "Sincronizando solicitudes de aplicación de cupo offline.";
      await quotaProvider.syncOfflineQuotasInLocal();
    } catch (ex, stacktrace) {
      print(ex);
      print(stacktrace);
    }

    try {
      await _downloadData(dashboardProvider: dashboardProvider);
      _preferences.lastSync = DateTime.now();
    } catch (ex, stacktrace) {
      print(ex);
      print(stacktrace);

      message = "Sync Error. Limpiando DB.";
      await DatabaseProvider.db.cleanTables();
    }

    isSyncing = false;
    message = "";
  }

  Future<void> _downloadData(
      {@required DashboardProvider dashboardProvider}) async {
    message = "Limpiando base de datos.";
    await DatabaseProvider.db.cleanTables();

    message = "Descargando resumen de dashboard.";
    final resume = await dashboardProvider.getDashboardResume();
    message = "Guardando resumen de dashboard.";
    await DatabaseProvider.db.saveOrUpdateDashboardResume(resume);

    message = "Descargando carteras.";
    final resumes = await _getResumeClientsWallets();
    message = "Guardando carteras.";
    await DatabaseProvider.db.saveOrUpdateResumeClientWallets(resumes);

    message = "Descargando Clientes.";
    final clients = await _getClients();
    message = "Guardando Clientes (${clients.length}).";
    await DatabaseProvider.db.saveOrUpdateClients(clients);

    message = "Descargando Tiendas.";
    final clientsIds = clients.map((x) => x.id).toList();
    final stores = await _getStores(clientsIds);
    message = "Guardando Tiendas (${stores.length}).";
    await DatabaseProvider.db.saveOrUpdateStores(stores);

    message = "Guardando Pedidos.";
    final orders = await _getOrders();
    message = "Guardando Pedidos (${orders.length}).";
    await DatabaseProvider.db.saveOrUpdateOrders(orders);

    message = "Descargando Catálogos.";
    final catalogues = await _getCatalogues();
    final showRoomCataloguesIds = catalogues
        .where((x) => x.tipo == "show room")
        .toList()
        .map((x) => x.id)
        .toList();
    message = "Guardando Catálogos (${catalogues.length}).";
    await DatabaseProvider.db.saveOrUpdateCatalogues(catalogues);

    message = "Descargando Productos.";
    final products = await _getProducts();
    final productsPages = (products.length / 500).ceil();
    int pStart, pEnd;
    message = "Guardando Productos (${products.length}).";

    for (var page = 0; page < productsPages; page++) {
      pStart = page * 500;
      pEnd = pStart + 499;
      pEnd = productsPages - 1 == page ? products.length : pEnd;
      final subProducts = products.getRange(pStart, pEnd).toList();
      message = "Guardando Productos ${products.length}, $pStart - $pEnd.";

      await DatabaseProvider.db
          .saveOrUpdateProducts(subProducts, showRoomCataloguesIds);
      await Future.delayed(Duration(milliseconds: 100));
    }

    message = "Guardando Imágenes.";
    final images = await _getImagenes();
    final imagesPages = (images.length / 5).ceil();
    int iStart, iEnd;
    message = "Guardando Imágenes (${images.length}).";

    for (var page = 0; page < imagesPages; page++) {
      iStart = page * 5;
      iEnd = iStart + 4;
      iEnd = imagesPages - 1 == page ? images.length : iEnd;
      final subImages = images.getRange(iStart, iEnd).toList();
      message = "Guardando Imágenes ${images.length}, $iStart - $iEnd.";

      await _downloadImages(subImages);
      await Future.delayed(Duration(milliseconds: 200));
    }

    // TODO: Datos no usados
    // await _downloadQuestions(cataloguesProvider, ratingProvider);
    // await _downloadRatings(ratingProvider);

    message = "Descarga completada.";
    await Future.delayed(Duration(milliseconds: 300));
  }

  Future<void> _downloadImages(List<String> images) async {
    List<Future<void>> imagesFuture = [];
    images = images.toSet().toList();

    for (var image in images) {
      if (image.isNotEmpty) {
        imagesFuture.add(DatabaseProvider.db.saveImage(image));
      }
    }

    await Future.wait(imagesFuture);
  }

  Future<List<Producto>> _getProducts() async {
    final url = Uri.parse("$_url/offline/productos");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];

    return List<Producto>.from(
      json.decode(response.body).map((x) => Producto.fromJson(x)),
    );
  }

  Future<List<Catalogo>> _getCatalogues() async {
    final url = Uri.parse("$_url/offline/catalogos");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];

    return List<Catalogo>.from(
      json.decode(response.body).map((x) => Catalogo.fromJson(x)),
    );
  }

  Future<List<Usuario>> _getClients() async {
    final url = Uri.parse("$_url/offline/clientes");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];

    return List<Usuario>.from(
      json.decode(response.body).map((x) => Usuario.fromJson(x)),
    );
  }

  Future<List<Tienda>> _getStores(List<int> clientsIds) async {
    final params = clientsIds.map((x) => "clientes_ids[]=$x").join("&");
    final url = Uri.parse("$_url/offline/tiendas?$params");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];

    return List<Tienda>.from(
      json.decode(response.body).map((x) => Tienda.fromJson(x)),
    );
  }

  Future<List<Pedido>> _getOrders() async {
    final url = Uri.parse("$_url/offline/pedidos");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];

    return List<Pedido>.from(
      json.decode(response.body).map((x) => Pedido.fromJson(x)),
    );
  }

  Future<List<String>> _getImagenes() async {
    final url = Uri.parse("$_url/offline/imagenes");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];

    return List<String>.from(json.decode(response.body).map((x) => x));
  }

  Future<List<ResumenCarteraCliente>> _getResumeClientsWallets() async {
    final url = Uri.parse("$_url/offline/resumenes-cartera");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];

    return List<ResumenCarteraCliente>.from(json
        .decode(response.body)
        .map((x) => ResumenCarteraCliente.fromJson(x)));
  }

  /// TODO: Datos no usados
  // Future<void> _downloadQuestions(
  //   CataloguesProvider cataloguesProvider,
  //   RatingProvider ratingProvider,
  // ) async {
  //   message = "Descargando preguntas.";
  //   final catalogues = await cataloguesProvider.getCataloguesLocal();
  //   List<Future<List<Pregunta>>> questionsFuture = [];
  //   List<Future<void>> questionsFutureDB = [];

  //   for (final x in catalogues) {
  //     questionsFuture.add(ratingProvider.getQuestions(x.id));
  //   }

  //   List<List<Pregunta>> questionsFutureResults =
  //       await Future.wait(questionsFuture);

  //   for (final questions in questionsFutureResults) {
  //     questionsFutureDB.add(
  //       DatabaseProvider.db.saveOrUpdateQuestions(questions),
  //     );
  //   }

  //   await Future.wait(questionsFutureDB);
  // }

  /// TODO: Datos no usados
  // Future<void> _downloadRatings(RatingProvider ratingProvider) async {
  //   message = "Descargando ratings.";
  //   final products = await DatabaseProvider.db.getProducts();

  //   List<Future<Rating>> ratingsFuture = [];
  //   List<Future<void>> ratingsFutureDB = [];

  //   for (final x in products) {
  //     ratingsFuture.add(ratingProvider.getRatings(x.id));
  //   }
  //   List<Rating> ratingsFutureResults = await Future.wait(ratingsFuture);

  //   for (final x in ratingsFutureResults) {
  //     if (x != null) {
  //       ratingsFutureDB.add(DatabaseProvider.db.saveOrUpdateRating(x));
  //     }
  //   }
  //   await Future.wait(ratingsFutureDB);
  // }
}
