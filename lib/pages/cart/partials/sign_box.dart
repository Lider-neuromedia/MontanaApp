import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class SignBox extends StatefulWidget {
  @override
  _SignBoxState createState() => _SignBoxState();
}

class _SignBoxState extends State<SignBox> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    // onDrawStart: () => print('onDrawStart called!'),
    // onDrawEnd: () => print('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    // _controller.addListener(() => print('Value changed'));
  }

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
          Signature(
            controller: _controller,
            backgroundColor: Colors.white,
            height: 250,
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: CustomTheme.greyColor,
                  width: 1.0,
                ),
              ),
            ),
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
                  FontAwesome5.trash_alt,
                  isMain: false,
                  onPressed: () => _cleanSign(),
                ),
              ],
            ),
          ),
          // CurrentSign(),
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
        setState(() {
          _controller.clear();
        });

        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        cartProvider.sign = null;

        cartProvider.sign = File.fromRawPath(data);
      }
    }
  }
}

class CurrentSign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.sign == null
        ? Container(child: Text('No hay firma todavía.'))
        : FadeInImage(
            placeholder: AssetImage("assets/images/placeholder.png"),
            image: MemoryImage(cartProvider.sign.readAsBytesSync()),
            width: double.infinity,
            fit: BoxFit.contain,
          );
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
        iconSize: 34.0,
      ),
    );
  }
}
