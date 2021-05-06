import 'package:flutter/material.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';

class ProductPage extends StatelessWidget {
  static final String route = 'product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Producto'),
        actions: [
          CartIcon(),
        ],
      ),
    );
  }
}
