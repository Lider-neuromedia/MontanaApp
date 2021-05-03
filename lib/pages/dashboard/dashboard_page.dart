import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/dashboard/card_statistic.dart';
import 'package:montana_mobile/pages/dashboard/circular_statistic.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

import 'card_data.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: CustomTheme.textColor1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ScaffoldLogo(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Text('CONSOLIDADO COMISIONES', style: titleStyle),
            SizedBox(height: 20.0),
            CardData(
              title: 'Comisiones perdidas',
              value: '\$3.300.400',
              icon: Icons.face,
              color: CustomTheme.yellowColor,
              isMain: true,
            ),
            commissionsList(),
            SizedBox(height: 40.0),
            Text('CONSOLIDADO CLIENTES', style: titleStyle),
            SizedBox(height: 20.0),
            consolidatedClients(),
            SizedBox(height: 40.0),
            Text('CONSOLIDADO PEDIDOS', style: titleStyle),
            SizedBox(height: 20.0),
            consolidatedOrders(),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Widget commissionsList() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
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

  Widget consolidatedClients() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CardStatistic(
          isMain: true,
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

  Widget consolidatedOrders() {
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
