import 'package:flutter/material.dart';
import 'package:montana_mobile/models/question.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/catalogue/partials/section_card.dart';
import 'package:montana_mobile/providers/rating_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class RatingForm extends StatelessWidget {
  const RatingForm({
    Key key,
    @required this.onCompleted,
  }) : super(key: key);

  final Function onCompleted;

  @override
  Widget build(BuildContext context) {
    final ratingProvider = Provider.of<RatingProvider>(context);
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );

    int index = 0;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10.0),
          Text(
            'Valorar Producto',
            style: titleStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: ratingProvider.preguntas.map((pregunta) {
              return _RateField(
                index: ++index,
                question: pregunta.question,
                currentValue: pregunta.respuesta,
                onChanged: (int value) {
                  ratingProvider.applyAnswer(pregunta.pregunta, value);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20.0),
          Center(
            child: ratingProvider.isLoadingSend
                ? const LoadingContainer()
                : ElevatedButton(
                    child: Text('Calificar'),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: StadiumBorder(),
                    ),
                    onPressed: ratingProvider.canSend
                        ? () => rateProduct(context, ratingProvider)
                        : null,
                  ),
          )
        ],
      ),
    );
  }

  void rateProduct(BuildContext context, RatingProvider ratingProvider) async {
    ratingProvider.isLoadingSend = true;
    final isSuccess = await ratingProvider.saveRating();
    ratingProvider.isLoadingSend = false;

    if (isSuccess) {
      showMessageDialog(
        context,
        'Listo',
        'Producto calificado',
        onAccept: onCompleted,
      );
    } else {
      showMessageDialog(context, 'Aviso', 'Datos de valoración incorrectos.');
    }
  }
}

class _RateField extends StatelessWidget {
  const _RateField({
    Key key,
    @required this.index,
    @required this.question,
    @required this.currentValue,
    @required this.onChanged,
  }) : super(key: key);

  final int index;
  final int currentValue;
  final Pregunta question;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.w700,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$index. ${question.pregunta}",
            style: subtitleStyle,
            textAlign: TextAlign.left,
          ),
          Row(
            children: [
              _StarIcon(
                active: currentValue >= 1,
                onPressed: () => onChanged(1),
              ),
              _StarIcon(
                active: currentValue >= 2,
                onPressed: () => onChanged(2),
              ),
              _StarIcon(
                active: currentValue >= 3,
                onPressed: () => onChanged(3),
              ),
              _StarIcon(
                active: currentValue >= 4,
                onPressed: () => onChanged(4),
              ),
              _StarIcon(
                active: currentValue >= 5,
                onPressed: () => onChanged(5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StarIcon extends StatelessWidget {
  const _StarIcon({
    Key key,
    @required this.active,
    @required this.onPressed,
  }) : super(key: key);

  final bool active;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: IconButton(
        onPressed: onPressed,
        color: Colors.transparent,
        icon: Icon(
          Icons.star,
          color: active ? CustomTheme.yellowColor : CustomTheme.greyColor,
        ),
      ),
    );
  }
}
