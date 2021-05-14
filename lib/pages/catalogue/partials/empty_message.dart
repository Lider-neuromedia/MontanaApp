import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    Key key,
    @required this.message,
    @required this.onPressed,
  }) : super(key: key);
  final String message;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
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
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 15.0),
            ElevatedButton(
              child: Icon(Icons.refresh),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shape: CircleBorder(),
              ),
              onPressed: onPressed,
            )
          ],
        ),
      ),
    );
  }
}