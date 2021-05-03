import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/home/bottom_drawer.dart';
import 'package:montana_mobile/pages/home/navigation_bar.dart';
import 'package:montana_mobile/pages/home/pages.dart';
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
            Pages(),
            BottomDrawer(),
          ],
        ),
        bottomNavigationBar: NavigationBar(),
      ),
    );
  }
}
