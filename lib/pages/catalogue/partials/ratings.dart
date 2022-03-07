import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/catalogue/partials/section_card.dart';
import 'package:montana_mobile/providers/rating_provider.dart';
import 'package:montana_mobile/theme/theme.dart';

class Ratings extends StatelessWidget {
  const Ratings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ratingProvider = Provider.of<RatingProvider>(context);
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.grey2Color,
        );
    final subtitle2Style = Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.w700,
        );
    int index = 0;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10.0),
          Text(
            "Valoraciones",
            textAlign: TextAlign.left,
            style: titleStyle,
          ),
          Text(
            "${ratingProvider.rating.cantidadValoraciones} valoraciones",
            textAlign: TextAlign.left,
            style: subtitleStyle,
          ),
          const SizedBox(height: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: ratingProvider.rating.valoraciones.map<Widget>((rating) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "${++index}. ${rating.pregunta}",
                    textAlign: TextAlign.left,
                    style: subtitle2Style,
                  ),
                  const SizedBox(height: 5.0),
                  _StarsRating(activeStars: rating.calificacion),
                  const SizedBox(height: 10.0),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class _StarsRating extends StatelessWidget {
  const _StarsRating({
    Key key,
    @required this.activeStars,
  }) : super(key: key);

  final int activeStars;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          _StarIcon(active: activeStars >= 1),
          _StarIcon(active: activeStars >= 2),
          _StarIcon(active: activeStars >= 3),
          _StarIcon(active: activeStars >= 4),
          _StarIcon(active: activeStars >= 5),
        ],
      ),
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
