import 'package:flutter/material.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/providers/login_provider.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';
import 'package:montana_mobile/pages/session/login_page.dart';
import 'package:montana_mobile/pages/home/partials/drawer_item.dart';

class BottomDrawer extends StatelessWidget {
  const BottomDrawer({Key key}) : super(key: key);

  final double boxHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final size = MediaQuery.of(context).size;

    final preferences = Preferences();
    final user = preferences.session;
    String homeTitle = 'Home';
    IconData homeIcon = Icons.home;

    if (user != null) {
      homeTitle = user.isVendedor ? 'Clientes' : 'Tiendas';
      homeIcon =
          user.isVendedor ? Icons.account_circle_outlined : Icons.storefront;
    }

    return AnimatedPositioned(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 250),
      left: 0,
      bottom: navigationProvider.showMore ? 0 : (boxHeight * -1),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 15.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: navigationProvider.showMore
              ? const BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
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
              title: homeTitle,
              iconData: homeIcon,
              active: navigationProvider.currentPage == 4,
              onTap: user == null
                  ? null
                  : () => navigationProvider.currentPage = 4,
            ),
            const SizedBox(width: 15.0),
            // TODO: Botón de PQRS ocultado.
            // DrawerItem(
            //   title: 'PQRS',
            //   iconData: Octicons.comment_discussion,
            //   active: navigationProvider.currentPage == 5,
            //   onTap: () => navigationProvider.currentPage = 5,
            // ),
            // const SizedBox(width: 15.0),
            DrawerItem(
              title: 'Ampliación\nde Cupo',
              iconData: Icons.tab_unselected,
              active: navigationProvider.currentPage == 6,
              onTap: () => navigationProvider.currentPage = 6,
            ),
            const SizedBox(width: 15.0),
            DrawerItem(
              title: 'Sincronizar',
              iconData: Icons.sync,
              active: navigationProvider.currentPage == 7,
              onTap: () => navigationProvider.currentPage = 7,
            ),
            const SizedBox(width: 15.0),
            DrawerItem(
              title: 'Cerrar Sesión',
              iconData: WebSymbols.logout,
              active: false,
              onTap: () {
                navigationProvider.showMore = false;

                _confirmLogout(context, () {
                  loginProvider.logout();
                  Navigator.of(context).pushReplacementNamed(LoginPage.route);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, Function onAccept) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text("¿Realmente desea cerrar su sesión de usuario?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 30.0),
            TextButton(
              child: Text(
                "Si",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onAccept();
              },
            ),
          ],
        );
      },
    );
  }
}
