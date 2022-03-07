import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class CurrentSign extends StatelessWidget {
  const CurrentSign({
    Key key,
    @required this.signData,
    @required this.onDeleteSign,
  }) : super(key: key);

  final Uint8List signData;
  final Function onDeleteSign;

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
        children: [
          Material(
            child: IconButton(
              icon: const Icon(Icons.cancel),
              color: CustomTheme.textColor1,
              onPressed: onDeleteSign,
            ),
          ),
          Divider(
            thickness: 1.0,
            color: CustomTheme.greyColor,
          ),
          Image.memory(
            signData,
            fit: BoxFit.contain,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
