import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/providers/client_provider.dart';
import 'package:montana_mobile/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
// import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/dashboard_provider.dart';
import 'package:montana_mobile/providers/store_provider.dart';
import 'package:montana_mobile/providers/stores_provider.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/providers/catalogues_provider.dart';
import 'package:montana_mobile/providers/clients_provider.dart';
import 'package:montana_mobile/providers/login_provider.dart';
import 'package:montana_mobile/providers/message_provider.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';
import 'package:montana_mobile/providers/orders_provider.dart';
import 'package:montana_mobile/providers/password_provider.dart';
import 'package:montana_mobile/providers/pqrs_provider.dart';
import 'package:montana_mobile/providers/pqrs_ticket_provider.dart';
import 'package:montana_mobile/providers/products_provider.dart';
import 'package:montana_mobile/providers/product_provider.dart';
import 'package:montana_mobile/providers/quota_provider.dart';
import 'package:montana_mobile/providers/rating_provider.dart';
import 'package:montana_mobile/providers/reset_password_provider.dart';
import 'package:montana_mobile/providers/session_provider.dart';
import 'package:montana_mobile/providers/show_room_provider.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/pages/stores/store_form_page.dart';
import 'package:montana_mobile/pages/cart/cart_page.dart';
import 'package:montana_mobile/pages/catalogue/catalogue_products_page.dart';
import 'package:montana_mobile/pages/catalogue/product_page.dart';
import 'package:montana_mobile/pages/client/client_page.dart';
import 'package:montana_mobile/pages/home/home_page.dart';
import 'package:montana_mobile/pages/orders/order_page.dart';
import 'package:montana_mobile/pages/pqrs/create_pqrs_page.dart';
import 'package:montana_mobile/pages/pqrs/messages_page.dart';
import 'package:montana_mobile/pages/session/login_page.dart';
import 'package:montana_mobile/pages/session/password_page.dart';
import 'package:montana_mobile/pages/session/reset_password_page.dart';
import 'package:montana_mobile/services/push_notification_service.dart';
import 'package:montana_mobile/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final preferences = Preferences();
  await preferences.initialize();
  await (SessionProvider()).isUserSessionValid();
  await PushNotificationService.initializeApp();
  // await DatabaseProvider.db.dropDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => CataloguesProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ShowRoomProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ClientsProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => PqrsProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => PqrsTicketProvider()),
        ChangeNotifierProvider(create: (_) => QuotaProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
        ChangeNotifierProvider(create: (_) => StoresProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final historyObserver = NavigationHistoryObserver();
  StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();

    () async {
      final connectivityResult = await (Connectivity().checkConnectivity());
      final isConnected = connectivityResult != ConnectivityResult.none;
      _updateConnectionProvider(connectivityResult != ConnectivityResult.none);

      if (isConnected) ConnectionProvider.syncDataNow(context);

      await Future.delayed(Duration.zero);
      initPushNotifications(context);
    }();

    _subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult connectivity) {
        final isConnected = connectivity != ConnectivityResult.none;
        _updateConnectionProvider(isConnected);

        if (isConnected) ConnectionProvider.syncDataNow(context);
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void initPushNotifications(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    final pqrsProvider = Provider.of<PqrsProvider>(context, listen: false);
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    PushNotificationService.messageStream.listen((message) {
      final currentRoute = historyObserver.top.settings.name;

      if (message.data["type"] == "pqrs-message") {
        final idPqrs = pqrsProvider.ticket?.idPqrs;
        final messageIdPqrs = int.parse(message.data["id_pqrs"]);

        // Mostrar snackbar.
        if (currentRoute != MessagesPage.route ||
            (currentRoute == MessagesPage.route && idPqrs != messageIdPqrs)) {
          _scaffoldKey.currentState.showSnackBar(snackbar(
            message.notification.title,
            message.notification.body,
            label: "Aceptar",
            action: () {},
          ));
        }

        // Si la ruta es el listado de pqrs se recarga.
        if (currentRoute == HomePage.route && navProvider.currentPage == 5) {
          pqrsProvider.loadTickets(local: connectionProvider.isNotConnected);
        }

        // Si la ruta es la pantalla de mensajes del pqrs actual se recarga.
        if (currentRoute == MessagesPage.route && idPqrs == messageIdPqrs) {
          pqrsProvider.loadTicket(
            idPqrs,
            local: connectionProvider.isNotConnected,
          );
        }
      }
    });
  }

  void _updateConnectionProvider(bool isConnected) {
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);
    connectionProvider.isConnected = isConnected;
  }

  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      scaffoldMessengerKey: _scaffoldKey,
      navigatorObservers: [NavigationHistoryObserver()],
      title: "Montana Group",
      debugShowCheckedModeBanner: false,
      theme: (CustomTheme()).theme,
      initialRoute: preferences.initialPage,
      routes: {
        HomePage.route: (_) => _ScreenWrapper(child: HomePage()),
        LoginPage.route: (_) => _ScreenWrapper(child: LoginPage()),
        PasswordPage.route: (_) => _ScreenWrapper(child: PasswordPage()),
        ResetPasswordPage.route: (_) =>
            _ScreenWrapper(child: ResetPasswordPage()),
        OrderPage.route: (_) => _ScreenWrapper(child: OrderPage()),
        CatalogueProductsPage.route: (_) =>
            _ScreenWrapper(child: CatalogueProductsPage()),
        ProductPage.route: (_) => _ScreenWrapper(child: ProductPage()),
        CartPage.route: (_) => _ScreenWrapper(child: CartPage()),
        ClientPage.route: (_) => _ScreenWrapper(child: ClientPage()),
        CreatePqrsPage.route: (_) => _ScreenWrapper(child: CreatePqrsPage()),
        MessagesPage.route: (_) => _ScreenWrapper(child: MessagesPage()),
        StoreFormPage.route: (_) => _ScreenWrapper(child: StoreFormPage()),
      },
    );
  }
}

class _ScreenWrapper extends StatelessWidget {
  const _ScreenWrapper({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return connectionProvider.isConnected && connectionProvider.isNotSyncing
        ? child
        : Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: child),
                connectionProvider.isSyncing
                    ? connectionProvider.message.isNotEmpty
                        ? AppMessage(message: connectionProvider.message)
                        : AppMessage(message: "Sincronizando datos.")
                    : AppMessage(message: "Sin conexión."),
              ],
            ),
          );
  }
}

class AppMessage extends StatelessWidget {
  const AppMessage({Key key, @required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
