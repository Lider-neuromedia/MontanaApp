import 'package:flutter/material.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:provider/provider.dart';

class CurrentSign extends StatelessWidget {
  const CurrentSign({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomTheme.greyColor,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Material(
            child: IconButton(
              icon: const Icon(Icons.cancel),
              color: CustomTheme.textColor1,
              onPressed: () => cartProvider.signData = null,
            ),
          ),
          Divider(thickness: 1.0, color: CustomTheme.greyColor),
          Image.memory(
            cartProvider.signData,
            fit: BoxFit.contain,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
