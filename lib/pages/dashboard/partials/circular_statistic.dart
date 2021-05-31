import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class CircularStatistic extends StatelessWidget {
  const CircularStatistic({
    Key key,
    @required this.title,
    @required this.value,
    @required this.color,
  }) : super(key: key);

  final String title;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).textTheme.bodyText2.color.withAlpha(200),
            offset: Offset(0, 0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 5.0),
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(200),
              offset: Offset(0, 0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$value",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: CustomTheme.textColor1),
            ),
            Text(title, style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
      ),
    );
  }
}
