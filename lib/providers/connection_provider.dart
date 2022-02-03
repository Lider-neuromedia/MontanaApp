import 'package:flutter/material.dart';
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/models/question.dart';
import 'package:montana_mobile/models/rating.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/providers/catalogues_provider.dart';
import 'package:montana_mobile/providers/clients_provider.dart';
import 'package:montana_mobile/providers/dashboard_provider.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/providers/orders_provider.dart';
import 'package:montana_mobile/providers/products_provider.dart';
import 'package:montana_mobile/providers/rating_provider.dart';
import 'package:montana_mobile/providers/show_room_provider.dart';
import 'package:montana_mobile/providers/stores_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:provider/provider.dart';

class ConnectionProvider with ChangeNotifier {
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
      showRoomProvider: Provider.of<ShowRoomProvider>(context, listen: false),
      productsProvider: Provider.of<ProductsProvider>(context, listen: false),
      clientsProvider: Provider.of<ClientsProvider>(context, listen: false),
      ratingProvider: Provider.of<RatingProvider>(context, listen: false),
      storesProvider: Provider.of<StoresProvider>(context, listen: false),
      ordersProvider: Provider.of<OrdersProvider>(context, listen: false),
      cartProvider: Provider.of<CartProvider>(context, listen: false),
      cataloguesProvider:
          Provider.of<CataloguesProvider>(context, listen: false),
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
    @required CataloguesProvider cataloguesProvider,
    @required ProductsProvider productsProvider,
    @required ClientsProvider clientsProvider,
    @required RatingProvider ratingProvider,
    @required ShowRoomProvider showRoomProvider,
    @required StoresProvider storesProvider,
    @required CartProvider cartProvider,
    @required OrdersProvider ordersProvider,
  }) async {
    isSyncing = true;

    try {
      await _uploadData(
        storesProvider: storesProvider,
        cartProvider: cartProvider,
      );
    } catch (ex, stacktrace) {
      print(ex);
      print(stacktrace);
    }

    try {
      await _downloadData(
        dashboardProvider: dashboardProvider,
        cataloguesProvider: cataloguesProvider,
        productsProvider: productsProvider,
        clientsProvider: clientsProvider,
        ratingProvider: ratingProvider,
        showRoomProvider: showRoomProvider,
        storesProvider: storesProvider,
        cartProvider: cartProvider,
        ordersProvider: ordersProvider,
      );

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

  Future<void> _uploadData({
    @required StoresProvider storesProvider,
    @required CartProvider cartProvider,
  }) async {
    message = "Sincronizando tiendas.";
    await storesProvider.syncDeletedStoresInLocal();

    message = "Sincronizando pedidos offline.";
    await cartProvider.syncOfflineOrdersInLocal();
  }

  Future<void> _downloadData({
    @required DashboardProvider dashboardProvider,
    @required CataloguesProvider cataloguesProvider,
    @required ProductsProvider productsProvider,
    @required ClientsProvider clientsProvider,
    @required RatingProvider ratingProvider,
    @required ShowRoomProvider showRoomProvider,
    @required StoresProvider storesProvider,
    @required CartProvider cartProvider,
    @required OrdersProvider ordersProvider,
  }) async {
    List<String> images = [];

    message = "Limpiando base de datos.";
    await DatabaseProvider.db.cleanTables();

    message = "Descargando resumen de dashboard.";
    final resume = await dashboardProvider.getDashboardResume();
    await DatabaseProvider.db.saveOrUpdateDashboardResume(resume);

    await _downloadClientsAndStores(clientsProvider, cartProvider);

    images.addAll(
      await _downloadCatalogues(cataloguesProvider),
    );
    images.addAll(
      await _downloadProducts(cataloguesProvider, productsProvider),
    );
    images.addAll(
      await _downloadShowRoom(showRoomProvider, productsProvider),
    );

    await _downloadQuestions(cataloguesProvider, ratingProvider);
    await _downloadRatings(ratingProvider);
    await _downloadOrders(ordersProvider);
    await _downloadImages(images);
  }

  Future<List<String>> _downloadProducts(
    CataloguesProvider cataloguesProvider,
    ProductsProvider productsProvider,
  ) async {
    List<String> images = [];
    List<Future<List<Producto>>> productsFuture = [];
    List<Future<Producto>> productFuture = [];
    List<Future<void>> productFutureDB = [];

    message = "Descargando productos.";
    final catalogues = await cataloguesProvider.getCataloguesLocal();

    for (final c in catalogues) {
      productsFuture.add(productsProvider.getProductsByCatalogue(c.id));
    }

    List<List<Producto>> productsFutureResults =
        await Future.wait(productsFuture);

    for (List<Producto> products in productsFutureResults) {
      for (final p in products) {
        productFuture.add(productsProvider.getProduct(p.idProducto));
      }
    }

    List<Producto> productFutureResults = await Future.wait(productFuture);

    for (final product in productFutureResults) {
      productFutureDB.add(
        DatabaseProvider.db.saveOrUpdateProduct(product, false),
      );

      images.add(product.image);
      for (final image in product.imagenes) {
        images.add(image.image);
      }
    }

    await Future.wait(productFutureDB);
    return images;
  }

  Future<List<String>> _downloadShowRoom(
    ShowRoomProvider showRoomProvider,
    ProductsProvider productsProvider,
  ) async {
    List<String> images = [];
    List<Future<Producto>> productsFuture = [];
    List<Future<void>> productsFutureDB = [];

    message = "Descargando ShowRoom.";
    final showRoomProducts = await showRoomProvider.getShowRoomProducts();

    for (final srp in showRoomProducts) {
      productsFuture.add(productsProvider.getProduct(srp.idProducto));
    }

    List<Producto> productsFutureResults = await Future.wait(productsFuture);

    for (final x in productsFutureResults) {
      productsFutureDB.add(DatabaseProvider.db.saveOrUpdateProduct(x, true));
      images.add(x.image);

      for (final image in x.imagenes) {
        images.add(image.image);
      }
    }

    await Future.wait(productsFutureDB);
    return images;
  }

  Future<List<String>> _downloadCatalogues(
      CataloguesProvider cataloguesProvider) async {
    List<String> images = [];

    message = "Descargando catálogos.";
    final catalogues = await cataloguesProvider.getCatalogues();
    await DatabaseProvider.db.saveOrUpdateCatalogues(catalogues);

    for (var catalogue in catalogues) {
      images.add(catalogue.imagen);
    }

    return images;
  }

  Future<void> _downloadImages(List<String> images) async {
    List<Future<void>> imagesFuture = [];
    images = images.toSet().toList();
    message = "Descargando ${images.length} imagenes.";

    for (var image in images) {
      imagesFuture.add(DatabaseProvider.db.saveImage(image));
    }

    await Future.wait(imagesFuture);
  }

  Future<void> _downloadQuestions(
    CataloguesProvider cataloguesProvider,
    RatingProvider ratingProvider,
  ) async {
    message = "Descargando preguntas.";
    final catalogues = await cataloguesProvider.getCataloguesLocal();
    List<Future<List<Pregunta>>> questionsFuture = [];
    List<Future<void>> questionsFutureDB = [];

    for (final x in catalogues) {
      questionsFuture.add(ratingProvider.getQuestions(x.id));
    }

    List<List<Pregunta>> questionsFutureResults =
        await Future.wait(questionsFuture);

    for (final questions in questionsFutureResults) {
      questionsFutureDB.add(
        DatabaseProvider.db.saveOrUpdateQuestions(questions),
      );
    }

    await Future.wait(questionsFutureDB);
  }

  Future<void> _downloadClientsAndStores(
    ClientsProvider clientsProvider,
    CartProvider cartProvider,
  ) async {
    message = "Descargando clientes de vendedor.";
    final sellerClients = await clientsProvider.getSellerClients();

    List<Future<Cliente>> clientsFuture = [];
    List<Future<List<Tienda>>> storesFuture = [];
    List<Future<void>> clientsFutureDB = [];
    List<Future<void>> storesFutureDB = [];

    for (final sc in sellerClients) {
      clientsFuture.add(clientsProvider.getClient(sc.id));
      storesFuture.add(cartProvider.getClientStores(sc.id));
    }

    List<Cliente> clientsFutureResults = await Future.wait(clientsFuture);
    for (final client in clientsFutureResults) {
      clientsFutureDB.add(DatabaseProvider.db.saveOrUpdateClient(client));
    }
    await Future.wait(clientsFutureDB);

    message = "Descargando tiendas de clientes.";
    List<List<Tienda>> storesFutureResults = await Future.wait(storesFuture);
    for (final stores in storesFutureResults) {
      storesFutureDB.add(DatabaseProvider.db.saveOrUpdateStores(stores));
    }
    await Future.wait(storesFutureDB);
  }

  Future<void> _downloadRatings(RatingProvider ratingProvider) async {
    message = "Descargando ratings.";
    final products = await DatabaseProvider.db.getProducts();

    List<Future<Rating>> ratingsFuture = [];
    List<Future<void>> ratingsFutureDB = [];

    for (final x in products) {
      ratingsFuture.add(ratingProvider.getRatings(x.idProducto));
    }
    List<Rating> ratingsFutureResults = await Future.wait(ratingsFuture);

    for (final x in ratingsFutureResults) {
      if (x != null) {
        ratingsFutureDB.add(DatabaseProvider.db.saveOrUpdateRating(x));
      }
    }
    await Future.wait(ratingsFutureDB);
  }

  Future<void> _downloadOrders(OrdersProvider ordersProvider) async {
    message = "Descargando pedidos.";
    final orders = await ordersProvider.getOrders();

    List<Future<Pedido>> ordersFuture = [];
    List<Future<void>> ordersFutureDB = [];

    for (var x in orders) {
      ordersFuture.add(ordersProvider.getOrder(x.idPedido));
    }
    List<Pedido> ordersFutureResults = await Future.wait(ordersFuture);

    for (var x in ordersFutureResults) {
      ordersFutureDB.add(DatabaseProvider.db.saveOrUpdateOrder(x));
    }
    await Future.wait(ordersFutureDB);
  }
}
