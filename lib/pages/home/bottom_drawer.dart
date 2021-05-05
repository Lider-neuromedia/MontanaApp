import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';

class BottomDrawer extends StatelessWidget {
  const BottomDrawer({
    Key key,
  }) : super(key: key);

  final double boxHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    var size = MediaQuery.of(context).size;

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
              title: 'Tiendas',
              iconData: Icons.storefront,
              active: navigationProvider.currentPage == 4,
              onTap: () => navigationProvider.currentPage = 4,
            ),
            SizedBox(width: 20.0),
            DrawerItem(
              title: 'PQRS',
              iconData: Icons.chat_outlined,
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
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key key,
    @required this.title,
    @required this.iconData,
    @required this.active,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final bool active;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).textTheme.bodyText2.color,
                  offset: Offset(0, 1.0),
                  blurRadius: 3.0,
                ),
              ],
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: active
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.bodyText2.color,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active
                ? Theme.of(context).primaryColor
                : Theme.of(context).textTheme.bodyText2.color,
          ),
        ),
      ],
    );
  }
}
