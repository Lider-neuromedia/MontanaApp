import 'package:flutter/material.dart';

class ScaffoldLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage("assets/images/logo.png"),
      fit: BoxFit.contain,
      height: 24.0,
    );
  }
}
