import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    Key key,
    @required this.message,
    @required this.onPressed,
    this.hasBgDark = false,
  }) : super(key: key);

  final String message;
  final Function onPressed;
  final bool hasBgDark;

  @override
  Widget build(BuildContext context) {
    TextStyle messageStyle = Theme.of(
      context,
    ).textTheme.subtitle1;

    if (hasBgDark) {
      messageStyle = Theme.of(
        context,
      ).textTheme.subtitle1.copyWith(color: Colors.white);
    }

    return Center(
      child: SizedBox(
        width: 230.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message,
              style: messageStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: onPressed,
              child: const Icon(Icons.refresh),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shape: const CircleBorder(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
