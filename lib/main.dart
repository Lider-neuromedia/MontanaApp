import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/home_page.dart';
import 'package:montana_mobile/pages/session/login_page.dart';
import 'package:montana_mobile/pages/session/password_page.dart';
import 'package:montana_mobile/pages/session/reset_password_page.dart';
import 'package:montana_mobile/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athletic Air',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme(),
      initialRoute: LoginPage.route,
      routes: {
        HomePage.route: (_) => HomePage(),
        LoginPage.route: (_) => LoginPage(),
        PasswordPage.route: (_) => PasswordPage(),
        ResetPasswordPage.route: (_) => ResetPasswordPage(),
      },
    );
  }
}
