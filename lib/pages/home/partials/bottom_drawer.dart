import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:montana_mobile/models/session.dart';
import 'package:montana_mobile/pages/session/login_page.dart';
import 'package:montana_mobile/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/home/partials/drawer_item.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';

class BottomDrawer extends StatelessWidget {
  const BottomDrawer({
    Key key,
    @required this.rol,
  }) : super(key: key);

  final double boxHeight = 150.0;
  final String rol;

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final size = MediaQuery.of(context).size;

    return AnimatedPositioned(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 250),
      left: 0,
      bottom: navigationProvider.showMore ? 0 : (boxHeight * -1),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: navigationProvider.showMore
              ? BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).textTheme.bodyText2.color.withAlpha(200),
              offset: Offset(0, 0),
              blurRadius: 5.0,
            ),
          ],
        ),
        height: boxHeight,
        width: size.width,
        child: Row(
          children: [
            DrawerItem(
              title: rol == Session.rolSeller ? 'Clientes' : 'Tiendas',
              iconData: rol == Session.rolSeller
                  ? Icons.account_circle_outlined
                  : Icons.storefront,
              active: navigationProvider.currentPage == 4,
              onTap: () => navigationProvider.currentPage = 4,
            ),
            SizedBox(width: 20.0),
            DrawerItem(
              title: 'PQRS',
              iconData: Octicons.comment_discussion,
              active: navigationProvider.currentPage == 5,
              onTap: () => navigationProvider.currentPage = 5,
            ),
            SizedBox(width: 20.0),
            DrawerItem(
              title: 'Ampliación\nde Cupo',
              iconData: Icons.tab_unselected,
              active: navigationProvider.currentPage == 6,
              onTap: () => navigationProvider.currentPage = 6,
            ),
            SizedBox(width: 20.0),
            DrawerItem(
              title: 'Cerrar Sesión',
              iconData: WebSymbols.logout,
              active: false,
              onTap: () {
                loginProvider.logout();
                navigationProvider.showMore = false;
                Navigator.of(context).pushReplacementNamed(LoginPage.route);
              },
            ),
          ],
        ),
      ),
    );
  }
}
