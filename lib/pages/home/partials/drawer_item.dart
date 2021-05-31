import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.all(18.0),
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
        const SizedBox(height: 10.0),
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
