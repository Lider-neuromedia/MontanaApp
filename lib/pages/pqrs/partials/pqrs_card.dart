import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/pqrs/pqrs_page.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';

class PqrsCard extends StatelessWidget {
  const PqrsCard({
    Key key,
    this.pqrs,
  }) : super(key: key);

  final PqrsTemporal pqrs;

  @override
  Widget build(BuildContext context) {
    final TextStyle trailingText =
        Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.w700,
              color: CustomTheme.textColor3,
            );
    final TextStyle titleText = Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.w700,
          color: CustomTheme.grey2Color,
        );
    final TextStyle subtitleText =
        Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.w400,
              color: CustomTheme.grey2Color,
            );
    return ListTile(
      onTap: () {},
      title: Text(pqrs.client.name, style: titleText),
      subtitle: Text("#${pqrs.client.code}", style: subtitleText),
      leading: _IconPqrsCard(pqrs: pqrs),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.more_horiz,
            color: CustomTheme.textColor3,
          ),
          Text(
            formatDate(pqrs.datedAt),
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
    @required this.pqrs,
  }) : super(key: key);

  final PqrsTemporal pqrs;

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                pqrs.client.initials,
                style: Theme.of(context).textTheme.headline4.copyWith(
                      fontWeight: FontWeight.w400,
                      fontFamily: CustomTheme.familySourceSansPro,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            top: 0.0,
            child: _CircleStatus(
                color: pqrs.status == 'cerrado'
                    ? CustomTheme.redColor
                    : CustomTheme.green3Color),
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
