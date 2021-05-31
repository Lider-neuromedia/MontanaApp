import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class CardData extends StatelessWidget {
  const CardData({
    Key key,
    @required this.title,
    @required this.value,
    @required this.icon,
    @required this.color,
    @required this.isMain,
  }) : super(key: key);

  final bool isMain;
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        isMain
            ? _ContentMain(title: title, value: value, icon: icon)
            : _ContentNormal(title: title, value: value),
        Positioned(
          left: 5.0,
          top: -5.0,
          child: isMain
              ? Container()
              : _CardDataIcon(
                  icon: icon,
                  color: color,
                  size: 24.0,
                  isMain: false,
                ),
        ),
      ],
    );
  }
}

class _ContentMain extends StatelessWidget {
  const _ContentMain({
    Key key,
    @required this.title,
    @required this.value,
    @required this.icon,
  }) : super(key: key);

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Colors.white,
        );
    final valueStyle = Theme.of(context).textTheme.headline4.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        );
    return Container(
      width: size.width - 30.0,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(color: Colors.grey[200], width: 2.0),
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: titleStyle),
              Text(value, style: valueStyle),
            ],
          ),
          _CardDataIcon(
            color: Theme.of(context).primaryColor,
            icon: icon,
            size: 50.0,
            isMain: true,
          ),
        ],
      ),
    );
  }
}

class _ContentNormal extends StatelessWidget {
  const _ContentNormal({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.textColor1,
        );
    final valueStyle = Theme.of(context).textTheme.headline5.copyWith(
          fontWeight: FontWeight.w700,
          color: CustomTheme.textColor1,
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[200],
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: Text(title, style: titleStyle),
          ),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}

class _CardDataIcon extends StatelessWidget {
  const _CardDataIcon({
    Key key,
    @required this.icon,
    @required this.color,
    @required this.size,
    @required this.isMain,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final double size;
  final bool isMain;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: isMain ? Theme.of(context).primaryColor : Colors.white,
        border: Border.all(
          color: color,
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(
          const Radius.circular(5.0),
        ),
      ),
      child: Icon(
        icon,
        size: size,
        color: isMain ? Colors.white : color,
      ),
    );
  }
}
