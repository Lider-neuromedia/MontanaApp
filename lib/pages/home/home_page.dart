import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/home/navigation_bar.dart';
import 'package:montana_mobile/pages/home/pages.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';

class HomePage extends StatelessWidget {
  static final String route = '/';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Athletic Air'),
        ),
        body: Pages(),
        bottomNavigationBar: NavigationBar(),
      ),
    );
  }
}
