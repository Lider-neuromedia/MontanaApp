import 'package:flutter/material.dart';
import 'package:montana_mobile/models/message.dart';
import 'package:montana_mobile/theme/theme.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key key,
    @required this.message,
    @required this.leftSide,
  }) : super(key: key);

  final Mensaje message;
  final bool leftSide;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: leftSide
            ? [
                _AvatarMessage(message: message, leftSide: leftSide),
                SizedBox(width: 15.0),
                _MessageBox(message: message, leftSide: leftSide),
              ]
            : [
                _MessageBox(message: message, leftSide: leftSide),
                SizedBox(width: 15.0),
                _AvatarMessage(message: message, leftSide: leftSide),
              ],
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  const _MessageBox({
    Key key,
    @required this.message,
    @required this.leftSide,
  }) : super(key: key);

  final Mensaje message;
  final bool leftSide;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: leftSide
              ? Theme.of(context).textTheme.bodyText1.color
              : Colors.white,
        );
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: Text("${message.mensaje}", style: textStyle),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: leftSide ? Colors.white : CustomTheme.blue2Color,
            ),
          ),
          Positioned(
            right: !leftSide ? -20.0 : null,
            left: leftSide ? -20.0 : null,
            top: 0.0,
            child: Icon(
              leftSide ? Icons.arrow_left_outlined : Icons.arrow_right_outlined,
              color: leftSide ? Colors.white : CustomTheme.blue2Color,
              size: 35.0,
            ),
          )
        ],
      ),
    );
  }
}

class _AvatarMessage extends StatelessWidget {
  const _AvatarMessage({
    Key key,
    @required this.message,
    @required this.leftSide,
  }) : super(key: key);

  final Mensaje message;
  final bool leftSide;

  @override
  Widget build(BuildContext context) {
    final avatarStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        );
    final timeStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.w700,
        );

    return Column(
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: leftSide ? CustomTheme.blue3Color : CustomTheme.mainColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text("${message.iniciales}", style: avatarStyle),
          ),
        ),
        SizedBox(height: 5.0),
        Text("${message.hora}", style: timeStyle),
      ],
    );
  }
}
