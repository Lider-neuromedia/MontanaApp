import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static final String route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Athletic Air'),
      ),
      body: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
