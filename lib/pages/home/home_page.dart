import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/session/login_page.dart';
import 'package:montana_mobile/providers/session_provider.dart';
import 'package:montana_mobile/pages/home/partials/bottom_drawer.dart';
import 'package:montana_mobile/pages/home/partials/navigation_bar.dart';
import 'package:montana_mobile/pages/home/partials/pages.dart';

class HomePage extends StatefulWidget {
  static final String route = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      () async {
        final isValid = await SessionProvider().isUserSessionValid();

        if (!isValid) {
          Navigator.of(context).pushReplacementNamed(LoginPage.route);
        }
      }();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Pages(),
          BottomDrawer(),
        ],
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }
}
