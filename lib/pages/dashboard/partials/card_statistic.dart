import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:montana_mobile/theme/theme.dart';

class CardStatistic extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final String label;
  final bool isMain;
  final IconData icon;
  final Function onTap;

  const CardStatistic({
    Key key,
    @required this.isMain,
    @required this.title,
    this.subtitle,
    @required this.value,
    @required this.label,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mainColor = Theme.of(context).primaryColor;
    final textColor = isMain ? Colors.white : mainColor;
    final bgColor = isMain ? mainColor : Colors.white;
    final titleStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: textColor,
        );

    return Container(
      padding: const EdgeInsets.all(10.0),
      width: (size.width / 2) - 20.0,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.grey[200], width: 2.0),
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon == null
              ? Text(title, style: titleStyle)
              : Row(
                  children: [
                    Icon(icon, color: isMain ? Colors.white : mainColor),
                    const SizedBox(width: 10.0),
                    Text(title, style: titleStyle),
                  ],
                ),
          subtitle == null
              ? Container()
              : InkWell(
                  onTap: onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(subtitle, style: subtitleStyle),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: textColor,
                      ),
                    ],
                  ),
                ),
          const SizedBox(height: 10.0),
          Center(
            child: _CardChart(
              isMain: isMain,
              value: value,
              label: label,
            ),
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}

class _CardChart extends StatelessWidget {
  const _CardChart({
    Key key,
    @required this.value,
    @required this.label,
    @required this.isMain,
  }) : super(key: key);

  final int value;
  final String label;
  final bool isMain;

  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).primaryColor;
    final textColor = isMain ? Colors.white : mainColor;
    final bgColor = isMain ? mainColor : Colors.white;

    final valueStyle = Theme.of(context).textTheme.headline4.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        );
    final labelStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: textColor,
        );

    return Stack(
      children: [
        new CircularPercentIndicator(
          radius: 145.0,
          lineWidth: 5.0,
          animation: true,
          percent: 1,
          center: chartData(
            valueStyle: valueStyle,
            labelStyle: labelStyle,
            bgColor: bgColor,
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: textColor.withAlpha(50),
          progressColor: textColor,
        ),
      ],
    );
  }

  Widget chartData(
      {TextStyle valueStyle, TextStyle labelStyle, Color bgColor}) {
    return Container(
      child: Container(
        height: 110.0,
        width: 110.0,
        decoration: BoxDecoration(
          border: isMain
              ? null
              : Border.all(
                  color: Colors.grey[200],
                  width: 2.0,
                ),
          shape: BoxShape.circle,
          color: isMain ? CustomTheme.mainDarkColor : bgColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("$value", style: valueStyle),
            Text(label, style: labelStyle),
          ],
        ),
      ),
    );
  }
}
