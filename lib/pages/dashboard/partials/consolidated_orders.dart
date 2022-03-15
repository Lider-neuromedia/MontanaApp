import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/dashboard/partials/circular_statistic.dart';
import 'package:montana_mobile/providers/dashboard_provider.dart';
import 'package:montana_mobile/theme/theme.dart';

class ConsolidatedOrders extends StatelessWidget {
  const ConsolidatedOrders({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final pageController = PageController(
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
            title: "Realizados",
            value: dashboardProvider.resumen.cantidadPedidos.realizados,
            color: CustomTheme.yellowColor,
          ),
          CircularStatistic(
            title: "Aprobados",
            value: dashboardProvider.resumen.cantidadPedidos.aprobados,
            color: CustomTheme.greenColor,
          ),
          CircularStatistic(
            title: "Rechazados",
            value: dashboardProvider.resumen.cantidadPedidos.rechazados,
            color: CustomTheme.redColor,
          ),
          CircularStatistic(
            title: "Pendientes",
            value: dashboardProvider.resumen.cantidadPedidos.pendientes,
            color: CustomTheme.purpleColor,
          ),
        ],
      ),
    );
  }
}
