import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/pages/stores/store_form_page.dart';
import 'package:montana_mobile/providers/dashboard_provider.dart';
import 'package:montana_mobile/providers/store_provider.dart';
import 'package:montana_mobile/providers/stores_provider.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
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
import 'package:montana_mobile/providers/quota_provider.dart';
import 'package:montana_mobile/providers/rating_provider.dart';
import 'package:montana_mobile/providers/reset_password_provider.dart';
import 'package:montana_mobile/providers/session_provider.dart';
import 'package:montana_mobile/providers/show_room_provider.dart';
import 'package:montana_mobile/services/push_notification_service.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final preferences = Preferences();
  await preferences.initialize();
  await (SessionProvider()).isUserSessionValid();
  await PushNotificationService.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => CataloguesProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => ShowRoomProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => ClientsProvider()),
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

  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      final navProvider =
          Provider.of<NavigationProvider>(context, listen: false);
      final pqrsProvider = Provider.of<PqrsProvider>(context, listen: false);

      PushNotificationService.messageStream.listen((message) {
        final currentRoute = historyObserver.top.settings.name;

        if (message.data['type'] == 'pqrs-message') {
          final idPqrs = pqrsProvider.ticket?.idPqrs;
          final messageIdPqrs = int.parse(message.data['id_pqrs']);

          // Mostrar snackbar.
          if (currentRoute != MessagesPage.route ||
              (currentRoute == MessagesPage.route && idPqrs != messageIdPqrs)) {
            _scaffoldKey.currentState.showSnackBar(snackbar(
              message.notification.title,
              message.notification.body,
              label: 'Aceptar',
              action: () {},
            ));
          }

          // Si la ruta es el listado de pqrs se recarga.
          if (currentRoute == HomePage.route && navProvider.currentPage == 5) {
            pqrsProvider.loadTickets();
          }

          // Si la ruta es la pantalla de mensajes del pqrs actual se recarga.
          if (currentRoute == MessagesPage.route && idPqrs == messageIdPqrs) {
            pqrsProvider.loadTicket(idPqrs);
          }
        }
      });
    }();
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
      title: 'Montana Group',
      debugShowCheckedModeBanner: false,
      theme: (CustomTheme()).theme,
      initialRoute: preferences.initialPage,
      routes: {
        HomePage.route: (_) => HomePage(),
        LoginPage.route: (_) => LoginPage(),
        PasswordPage.route: (_) => PasswordPage(),
        ResetPasswordPage.route: (_) => ResetPasswordPage(),
        OrderPage.route: (_) => OrderPage(),
        CatalogueProductsPage.route: (_) => CatalogueProductsPage(),
        ProductPage.route: (_) => ProductPage(),
        CartPage.route: (_) => CartPage(),
        ClientPage.route: (_) => ClientPage(),
        CreatePqrsPage.route: (_) => CreatePqrsPage(),
        MessagesPage.route: (_) => MessagesPage(),
        StoreFormPage.route: (_) => StoreFormPage(),
      },
    );
  }
}
