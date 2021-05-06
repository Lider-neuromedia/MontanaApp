import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/cart/cart_page.dart';

class CartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int count = 3;
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w700,
        );
    return TextButton.icon(
      onPressed: () => Navigator.of(context).pushNamed(CartPage.route),
      icon: Icon(Icons.shopping_bag_outlined),
      style: TextButton.styleFrom(
        primary: Colors.white,
      ),
      label: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 2.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(3.0),
          ),
        ),
        child: Text(count.toString(), style: textStyle),
      ),
    );
  }
}
