import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/dashboard/circular_statistic.dart';
import 'package:montana_mobile/theme/theme.dart';

class ConsolidatedOrders extends StatelessWidget {
  const ConsolidatedOrders({
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
