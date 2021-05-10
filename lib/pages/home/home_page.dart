import 'package:flutter/material.dart';
import 'package:montana_mobile/models/session.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/home/partials/bottom_drawer.dart';
import 'package:montana_mobile/pages/home/partials/navigation_bar.dart';
import 'package:montana_mobile/pages/home/partials/pages.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';

class HomePage extends StatefulWidget {
  static final String route = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            Pages(rol: Session.rolSeller),
            BottomDrawer(),
          ],
        ),
        bottomNavigationBar: NavigationBar(),
      ),
    );
  }
}
