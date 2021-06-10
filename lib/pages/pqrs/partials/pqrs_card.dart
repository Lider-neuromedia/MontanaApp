import 'package:flutter/material.dart';
import 'package:montana_mobile/models/ticket.dart';
import 'package:montana_mobile/pages/pqrs/messages_page.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';

class PqrsCard extends StatelessWidget {
  const PqrsCard({
    Key key,
    @required this.ticket,
  }) : super(key: key);

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final trailingText = Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.w700,
          color: CustomTheme.textColor3,
        );
    final titleText = Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.w700,
          color: CustomTheme.grey2Color,
        );
    final subtitleText = Theme.of(context).textTheme.subtitle2.copyWith(
          fontWeight: FontWeight.w400,
          color: CustomTheme.grey2Color,
        );

    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          MessagesPage.route,
          arguments: ticket.idPqrs,
        );
      },
      title: Text(ticket.clienteNombre, style: titleText),
      subtitle: Text("#${ticket.codigo}", style: subtitleText),
      leading: _IconPqrsCard(ticket: ticket),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.more_horiz,
            color: CustomTheme.textColor3,
          ),
          Text(
            formatDate(ticket.fechaRegistro),
            style: trailingText,
          ),
        ],
      ),
    );
  }
}

class _IconPqrsCard extends StatelessWidget {
  const _IconPqrsCard({
    Key key,
    @required this.ticket,
  }) : super(key: key);

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline4.copyWith(
          fontWeight: FontWeight.w400,
          fontFamily: CustomTheme.familySourceSansPro,
          color: Colors.white,
        );

    return Container(
      height: 65.0,
      width: 65.0,
      child: Stack(
        children: [
          Container(
            height: 65.0,
            width: 65.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(ticket.iniciales, style: textStyle),
            ),
          ),
          Positioned(
            left: 0.0,
            top: 0.0,
            child: _CircleStatus(
              color: ticket.estado == 'cerrado'
                  ? CustomTheme.redColor
                  : CustomTheme.green3Color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleStatus extends StatelessWidget {
  const _CircleStatus({
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      width: 20.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: CustomTheme.textColor1,
          width: 4.0,
        ),
      ),
    );
  }
}
