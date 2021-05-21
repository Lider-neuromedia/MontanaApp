import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final bool blocked = onPressed == null;

    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: blocked ? Colors.grey : Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3.0,
                  color: blocked ? Colors.grey : Colors.red,
                  offset: Offset(2.0, 0.0),
                ),
              ],
            ),
            padding: EdgeInsets.all(5.0),
            child: Icon(icon, color: Colors.white),
          ),
          Text(label),
          Container(
            width: 30,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(icon, color: Colors.transparent),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(
          left: 0.0,
          right: 0.0,
        ),
        side: BorderSide(
          color: blocked ? Colors.grey : Theme.of(context).primaryColor,
        ),
        shape: StadiumBorder(),
        primary: blocked ? Colors.grey : Theme.of(context).primaryColor,
      ),
    );
  }
}
