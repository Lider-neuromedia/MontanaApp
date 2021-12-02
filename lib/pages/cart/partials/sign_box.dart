import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/theme/theme.dart';

class SignBox extends StatefulWidget {
  @override
  _SignBoxState createState() => _SignBoxState();
}

class _SignBoxState extends State<SignBox> {
  final SignatureController _controller = SignatureController(
    exportBackgroundColor: Colors.white,
    penColor: Colors.black,
    penStrokeWidth: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomTheme.greyColor,
          width: 1.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _ActionButton(
                  FontAwesome5.check_circle,
                  isMain: true,
                  onPressed: () => _acceptSign(context),
                ),
                _ActionButton(
                  Icons.cancel,
                  isMain: false,
                  onPressed: () => _cleanSign(),
                ),
              ],
            ),
          ),
          Divider(thickness: 1.0, color: CustomTheme.greyColor),
          Signature(
            controller: _controller,
            backgroundColor: Colors.white,
            height: 250,
          ),
        ],
      ),
    );
  }

  void _cleanSign() {
    setState(() => _controller.clear());
  }

  void _acceptSign(BuildContext context) async {
    if (_controller.isNotEmpty) {
      final Uint8List data = await _controller.toPngBytes();

      if (data != null) {
        setState(() => _controller.clear());
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        cartProvider.signData = data;
      }
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton(
    this.icon, {
    Key key,
    @required this.onPressed,
    @required this.isMain,
  }) : super(key: key);

  final Function onPressed;
  final IconData icon;
  final bool isMain;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: IconButton(
        icon: Icon(icon),
        color: isMain ? CustomTheme.mainColor : CustomTheme.textColor1,
        onPressed: onPressed,
        iconSize: 30.0,
      ),
    );
  }
}
