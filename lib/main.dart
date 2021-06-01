import 'package:flutter/material.dart';
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
import 'package:montana_mobile/theme/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/utils/preferences.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final preferences = Preferences();
  await preferences.initialize();
  await (SessionProvider()).isUserSessionValid();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();

    return MultiProvider(
      providers: [
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
      ],
      child: MaterialApp(
        title: 'Athletic Air',
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
        },
      ),
    );
  }
}
