import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.onPressed,
    @required this.borderColor,
    @required this.backgroundColor,
    @required this.textColor,
    @required this.iconColor,
  }) : super(key: key);

  final Function onPressed;
  final String label;
  final IconData icon;
  final Color borderColor;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(
          right: 10.0,
          left: 0.0,
        ),
        side: BorderSide(
          color: onPressed == null ? Colors.grey : borderColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: onPressed == null ? Colors.grey : backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: onPressed == null ? Colors.grey : borderColor,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3.0,
                  color: CustomTheme.greyColor,
                  offset: Offset(2.0, 0.0),
                ),
              ],
            ),
            padding: const EdgeInsets.all(5.0),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 10.0),
          Text(
            label,
            style: TextStyle(color: textColor),
          ),
          const SizedBox(width: 5.0),
        ],
      ),
    );
  }
}
