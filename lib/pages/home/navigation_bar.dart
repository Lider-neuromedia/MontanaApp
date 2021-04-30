import 'package:flutter/material.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return BottomNavigationBar(
      currentIndex: navigationProvider.currentPage,
      onTap: (int index) {
        if (index < 4) {
          navigationProvider.currentPage = index;
        } else {
          // TODO: Mostrar navegación extra.
        }
      },
      type: BottomNavigationBarType.fixed,
      elevation: 5.0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Catálogo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.unarchive_outlined),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border_rounded),
          label: 'ShowRoom',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Más',
        ),
      ],
    );
  }
}
