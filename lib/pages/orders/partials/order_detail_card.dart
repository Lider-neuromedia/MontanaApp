import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class OrderDetailCard extends StatelessWidget {
  const OrderDetailCard({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w700,
        );
    final valueStyle = Theme.of(context).textTheme.headline5.copyWith(
          fontWeight: FontWeight.w700,
        );

    return Card(
      elevation: 5.0,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: 3.0,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 10.0,
            ),
            child: Text(
              title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            color: CustomTheme.greyColor,
            height: 1.0,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 11.0,
            ),
            child: Text(
              value,
              style: valueStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
