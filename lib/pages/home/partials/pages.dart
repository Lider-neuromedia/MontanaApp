import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/catalogue_page.dart';
import 'package:montana_mobile/pages/catalogue/show_room_page.dart';
import 'package:montana_mobile/pages/clients/clients_page.dart';
import 'package:montana_mobile/pages/dashboard/dashboard_buyer_page.dart';
import 'package:montana_mobile/pages/dashboard/dashboard_seller_page.dart';
import 'package:montana_mobile/pages/orders/orders_page.dart';
import 'package:montana_mobile/pages/pqrs/pqrs_page.dart';
import 'package:montana_mobile/pages/quota_expansion/quota_expansion_page.dart';
import 'package:montana_mobile/pages/stores/stores_page.dart';
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
      preferences.session.isVendedor ? ClientsPage() : StoresPage(),
      PqrsPage(),
      QuotaExpansionPage(),
    ];

    return _pages[navigationProvider.currentPage];
  }
}
