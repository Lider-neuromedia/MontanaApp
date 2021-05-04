import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/catalogue.dart';
import 'package:montana_mobile/pages/dashboard/dashboard_buyer_page.dart';
import 'package:montana_mobile/pages/dashboard/dashboard_seller_page.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

class Pages extends StatelessWidget {
  Pages({
    Key key,
  }) : super(key: key);

  final List<Widget> _pages = [
    DashboardSellerPage(), // DashboardBuyerPage(),
    CataloguePage(),
    PlaceHolderPage(background: Colors.pink, title: 'Pedidos'),
    PlaceHolderPage(background: Colors.cyan, title: 'Show Room'),
    PlaceHolderPage(background: Colors.green, title: 'Tiendas'),
    PlaceHolderPage(background: Colors.orange, title: 'PQRS'),
    PlaceHolderPage(background: Colors.indigo, title: 'Ampliación'),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return _pages[navigationProvider.currentPage];
  }
}

class PlaceHolderPage extends StatelessWidget {
  const PlaceHolderPage({
    Key key,
    this.background,
    this.title,
  }) : super(key: key);

  final Color background;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 34.0,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
