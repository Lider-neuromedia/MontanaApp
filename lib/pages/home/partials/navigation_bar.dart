import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
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
      currentIndex: navigationProvider.currentPage < 4
          ? navigationProvider.currentPage
          : 4,
      onTap: (int index) {
        if (index < 4) {
          navigationProvider.currentPage = index;
        } else {
          navigationProvider.showMore = !navigationProvider.showMore;
        }
      },
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
      backgroundColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.assignment),
          label: 'Catálogo',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Octicons.package),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.star_border_rounded),
          label: 'ShowRoom',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.add_circle_outline),
          label: 'Más',
        ),
      ],
    );
  }
}
