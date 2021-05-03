import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/dashboard/card_statistic.dart';
import 'package:montana_mobile/pages/dashboard/circular_statistic.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: CustomTheme.textColor1);

    PageController pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.45,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ScaffoldLogo(),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.0),
          Text('CONSOLIDADO COMISIONES', style: titleStyle),
          SizedBox(height: 40.0),
          Text('CONSOLIDADO CLIENTES', style: titleStyle),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          ),
          SizedBox(height: 40.0),
          Text('CONSOLIDADO PEDIDOS', style: titleStyle),
          SizedBox(height: 20.0),
          Container(
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
          ),
        ],
      ),
    );
  }
}
