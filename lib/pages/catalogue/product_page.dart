import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  static final String route = 'product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Producto'),
      ),
    );
  }
}
