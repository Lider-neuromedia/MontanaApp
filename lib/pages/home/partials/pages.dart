import 'package:flutter/material.dart';
import 'package:montana_mobile/models/session.dart';
import 'package:montana_mobile/pages/catalogue/catalogue_page.dart';
import 'package:montana_mobile/pages/catalogue/show_room_page.dart';
import 'package:montana_mobile/pages/clients/clients_page.dart';
import 'package:montana_mobile/pages/dashboard/dashboard_buyer_page.dart';
import 'package:montana_mobile/pages/dashboard/dashboard_seller_page.dart';
import 'package:montana_mobile/pages/orders/orders_page.dart';
import 'package:montana_mobile/pages/pqrs/pqrs_page.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

class Pages extends StatelessWidget {
  Pages({
    Key key,
    @required this.rol,
  }) : super(key: key);

  final String rol;

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    final List<Widget> _pages = [
      rol == Session.rolSeller ? DashboardSellerPage() : DashboardBuyerPage(),
      CataloguePage(),
      OrdersPage(),
      ShowRoomPage(),
      rol == Session.rolSeller
          ? ClientsPage()
          : PlaceHolderPage(background: Colors.green, title: 'Tiendas'),
      PqrsPage(),
      PlaceHolderPage(background: Colors.indigo, title: 'Ampliación'),
    ];

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
