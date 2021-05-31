import 'package:flutter/material.dart';

class ScaffoldLogo extends StatelessWidget {
  const ScaffoldLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: const AssetImage("assets/images/logo.png"),
      fit: BoxFit.contain,
      height: 24.0,
    );
  }
}
