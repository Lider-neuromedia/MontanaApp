import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/cart/cart_page.dart';
import 'package:montana_mobile/providers/cart_provider.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartCount = cartProvider.products.length;
    final textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w700,
        );

    return cartProvider.products.length == 0
        ? Container()
        : TextButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(CartPage.route),
            icon: const Icon(Icons.shopping_bag_outlined),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            label: Container(
              child: Text("$cartCount", style: textStyle),
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 2.0,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(3.0),
                ),
              ),
            ),
          );
  }
}
