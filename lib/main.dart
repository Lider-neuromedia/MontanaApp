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
import 'package:montana_mobile/providers/LoginProvider.dart';
import 'package:montana_mobile/providers/PasswordProvider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/utils/preferences.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final preferences = Preferences();
  await preferences.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
      ],
      child: MaterialApp(
        title: 'Athletic Air',
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.theme(),
        initialRoute: LoginPage.route,
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
