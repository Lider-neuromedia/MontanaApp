import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/home/home_page.dart';
import 'package:montana_mobile/pages/orders/order_create_page.dart';
import 'package:montana_mobile/pages/orders/order_page.dart';
import 'package:montana_mobile/pages/session/login_page.dart';
import 'package:montana_mobile/pages/session/password_page.dart';
import 'package:montana_mobile/pages/session/reset_password_page.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/utils/preferences.dart';

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
    return MaterialApp(
      title: 'Athletic Air',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme(),
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (_) => HomePage(),
        LoginPage.route: (_) => LoginPage(),
        PasswordPage.route: (_) => PasswordPage(),
        ResetPasswordPage.route: (_) => ResetPasswordPage(),
        OrderPage.route: (_) => OrderPage(),
        OrderCreatePage.route: (_) => OrderCreatePage(),
      },
    );
  }
}
