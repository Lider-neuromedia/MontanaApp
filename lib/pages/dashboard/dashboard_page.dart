import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/dashboard/card_statistic.dart';
import 'package:montana_mobile/pages/dashboard/circular_statistic.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

import 'card_data.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.headline5.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w600,
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ScaffoldLogo(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.0),
            Text('CONSOLIDADO COMISIONES', style: titleStyle),
            SizedBox(height: 20.0),
            CardData(
              title: 'Comisiones perdidas',
              value: '\$3.300.400',
              icon: Icons.face,
              color: CustomTheme.yellowColor,
              isMain: true,
            ),
            _CommisionsList(),
            SizedBox(height: 20.0),
            Text('CONSOLIDADO CLIENTES', style: titleStyle),
            SizedBox(height: 20.0),
            _ConsolidatedClients(),
            SizedBox(height: 40.0),
            Text('CONSOLIDADO PEDIDOS', style: titleStyle),
            SizedBox(height: 20.0),
            _ConsolidatedOrders(),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}

class _ConsolidatedOrders extends StatelessWidget {
  const _ConsolidatedOrders({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.45,
    );

    return Container(
      height: 200.0,
      child: PageView(
        pageSnapping: false,
        scrollDirection: Axis.horizontal,
        allowImplicitScrolling: false,
        controller: pageController,
        children: [
          CircularStatistic(
            title: 'Realizados',
            value: 324,
            color: CustomTheme.yellowColor,
          ),
          CircularStatistic(
            title: 'Aprobados',
            value: 304,
            color: CustomTheme.greenColor,
          ),
          CircularStatistic(
            title: 'Rechazados',
            value: 20,
            color: CustomTheme.redColor,
          ),
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CardData(
            title: 'Próximas a perder',
            value: '\$4.300.400',
            icon: Icons.face,
            color: CustomTheme.yellowColor,
            isMain: false,
          ),
          CardData(
            title: 'Comisiones ganadas',
            value: '\$3.500.400',
            icon: Icons.face,
            color: CustomTheme.greenColor,
            isMain: false,
          ),
        ],
      ),
    );
  }
}
