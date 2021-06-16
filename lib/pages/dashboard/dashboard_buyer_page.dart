import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:montana_mobile/pages/dashboard/partials/buyer_card.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_data.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_statistic.dart';
import 'package:montana_mobile/pages/dashboard/partials/consolidated_orders.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

class DashboardBuyerPage extends StatelessWidget {
  final _preferences = Preferences();
  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline5.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w600,
        );

    return Scaffold(
      appBar: AppBar(
        title: const ScaffoldLogo(),
        actions: [
          const CartIcon(),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20.0),
          BuyerCard(client: _preferences.sessionCliente),
          _CardDataList(
            children: [
              CardData(
                title: 'Cupo preaprobado',
                value: '\$4.300.400',
                icon: Icons.sentiment_neutral_rounded,
                color: CustomTheme.yellowColor,
                isMain: false,
              ),
              CardData(
                title: 'Cupo disponible',
                value: '\$3.500.400',
                icon: Icons.sentiment_very_satisfied,
                color: CustomTheme.greenColor,
                isMain: false,
              ),
            ],
          ),
          _CardDataList(
            children: [
              CardData(
                title: 'Saldo total deuda',
                value: '\$4.300.400',
                icon: Icons.error_outline,
                color: CustomTheme.purpleColor,
                isMain: false,
              ),
              CardData(
                title: 'Saldo en mora',
                value: '\$3.500.400',
                icon: Icons.sentiment_dissatisfied_rounded,
                color: CustomTheme.redColor,
                isMain: false,
              ),
            ],
          ),
          _CardDataList(children: [
            CardStatistic(
              isMain: true,
              title: 'Tiendas Creadas',
              value: 12,
              label: 'Tiendas',
              icon: Icons.storefront,
            ),
            CardStatistic(
              isMain: false,
              icon: Octicons.comment_discussion,
              title: 'PQRS Generados',
              value: 50,
              label: 'Tiendas',
            ),
          ]),
          const SizedBox(height: 20.0),
          Text(
            'CONSOLIDADO PEDIDOS',
            style: titleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          ConsolidatedOrders(),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }
}

class _CardDataList extends StatelessWidget {
  const _CardDataList({
    Key key,
    this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    children.asMap().forEach((index, item) {
      items.add(Expanded(child: item));
      if (index < children.length - 1) {
        items.add(const SizedBox(width: 15.0));
      }
    });

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }
}
