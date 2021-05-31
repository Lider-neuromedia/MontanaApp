import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_data.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_statistic.dart';
import 'package:montana_mobile/pages/dashboard/partials/consolidated_orders.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

class DashboardSellerPage extends StatelessWidget {
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
          const SizedBox(height: 30.0),
          Text(
            'CONSOLIDADO COMISIONES',
            style: titleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Center(
            child: CardData(
              title: 'Comisiones perdidas',
              value: '\$3.300.400',
              icon: Icons.sentiment_dissatisfied_rounded,
              color: CustomTheme.yellowColor,
              isMain: true,
            ),
          ),
          _CommisionsList(
            children: [
              CardData(
                title: 'Próximas a perder',
                value: '\$4.300.400',
                icon: Icons.sentiment_neutral_rounded,
                color: CustomTheme.yellowColor,
                isMain: false,
              ),
              CardData(
                title: 'Comisiones ganadas',
                value: '\$3.500.400',
                icon: Icons.sentiment_very_satisfied,
                color: CustomTheme.greenColor,
                isMain: false,
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Text('CONSOLIDADO CLIENTES', style: titleStyle),
          const SizedBox(height: 20.0),
          _ConsolidatedClients(),
          const SizedBox(height: 40.0),
          Text('CONSOLIDADO PEDIDOS', style: titleStyle),
          const SizedBox(height: 20.0),
          ConsolidatedOrders(),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }
}

class _ConsolidatedClients extends StatelessWidget {
  const _ConsolidatedClients({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CardStatistic(
          isMain: false,
          title: 'Clientes Generados',
          subtitle: 'Último mes',
          value: 84,
          label: 'Clientes',
        ),
        CardStatistic(
          isMain: false,
          title: 'Clientes Atendidos',
          subtitle: 'Último mes',
          value: 16,
          label: 'Clientes',
        ),
      ],
    );
  }
}

class _CommisionsList extends StatelessWidget {
  const _CommisionsList({
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
        items.add(const SizedBox(width: 10.0));
      }
    });

    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      ),
    );
  }
}
