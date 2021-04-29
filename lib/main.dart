import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/home_page.dart';
import 'package:montana_mobile/pages/session/login_page.dart';
import 'package:montana_mobile/pages/session/password_page.dart';
import 'package:montana_mobile/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athletic Air',
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.route,
      theme: customTheme,
      routes: {
        HomePage.route: (_) => HomePage(),
        LoginPage.route: (_) => LoginPage(),
        PasswordPage.route: (_) => PasswordPage(),
      },
    );
  }
}
