import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/catalogue_page.dart';
import 'package:montana_mobile/pages/catalogue/show_room_page.dart';
import 'package:montana_mobile/pages/clients/clients_page.dart';
import 'package:montana_mobile/pages/dashboard/dashboard_buyer_page.dart';
import 'package:montana_mobile/pages/dashboard/dashboard_seller_page.dart';
import 'package:montana_mobile/pages/orders/orders_page.dart';
import 'package:montana_mobile/pages/pqrs/pqrs_page.dart';
import 'package:montana_mobile/pages/quota_expansion/quota_expansion_page.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:provider/provider.dart';

class Pages extends StatelessWidget {
  const Pages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final preferences = Preferences();

    final List<Widget> _pages = [
      preferences.session.isVendedor
          ? DashboardSellerPage()
          : DashboardBuyerPage(),
      CataloguePage(),
      OrdersPage(),
      ShowRoomPage(),
      preferences.session.isVendedor
          ? ClientsPage()
          : _PlaceHolderPage(
              background: Colors.green,
              title: 'Tiendas',
            ),
      PqrsPage(),
      QuotaExpansionPage(),
    ];

    return _pages[navigationProvider.currentPage];
  }
}

class _PlaceHolderPage extends StatelessWidget {
  const _PlaceHolderPage({
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
