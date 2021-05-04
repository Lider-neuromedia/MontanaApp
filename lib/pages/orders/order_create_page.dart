import 'package:flutter/material.dart';

class OrderCreatePage extends StatelessWidget {
  static final String route = 'order-create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Pedido'),
      ),
    );
  }
}
