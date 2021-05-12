import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/section_card.dart';
import 'package:montana_mobile/theme/theme.dart';

class Ratings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );
    final TextStyle subtitleStyle =
        Theme.of(context).textTheme.bodyText1.copyWith(
              color: CustomTheme.grey2Color,
            );

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Text('Valoraciones', style: titleStyle),
          Text('18 comentarios', style: subtitleStyle),
          SizedBox(height: 10.0),
          _Rating(activeStars: 5, count: 30, totalCount: 70),
          SizedBox(height: 5.0),
          _Rating(activeStars: 4, count: 15, totalCount: 70),
          SizedBox(height: 5.0),
          _Rating(activeStars: 3, count: 10, totalCount: 70),
          SizedBox(height: 5.0),
          _Rating(activeStars: 2, count: 11, totalCount: 70),
          SizedBox(height: 5.0),
          _Rating(activeStars: 1, count: 4, totalCount: 70),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({
    Key key,
    @required this.activeStars,
    @required this.count,
    @required this.totalCount,
  }) : super(key: key);

  final int activeStars;
  final int count;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.grey2Color,
          fontSize: 12.0,
        );
    int percentage = (count * 100 / totalCount).round();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              _StarIcon(active: activeStars >= 1),
              _StarIcon(active: activeStars >= 2),
              _StarIcon(active: activeStars >= 3),
              _StarIcon(active: activeStars >= 4),
              _StarIcon(active: activeStars >= 5),
            ],
          ),
        ),
        SizedBox(width: 5.0),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(1.0),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(
                  flex: percentage,
                  child: Container(
                    height: 8.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  flex: 100 - percentage,
                  child: Container(
                    height: 10.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 5.0),
        Container(
          width: 100.0,
          child: Text("$count valoraciones", style: textStyle),
        ),
      ],
    );
  }
}

class _StarIcon extends StatelessWidget {
  const _StarIcon({
    Key key,
    @required this.active,
  }) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star,
      color: active ? CustomTheme.yellowColor : CustomTheme.greyColor,
    );
  }
}
