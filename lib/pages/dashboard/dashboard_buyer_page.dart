import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/dashboard/partials/buyer_card.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_data.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_statistic.dart';
import 'package:montana_mobile/pages/dashboard/partials/consolidated_orders.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/dashboard_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

class DashboardBuyerPage extends StatefulWidget {
  @override
  _DashboardBuyerPageState createState() => _DashboardBuyerPageState();
}

class _DashboardBuyerPageState extends State<DashboardBuyerPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      final connectionProvider =
          Provider.of<ConnectionProvider>(context, listen: false);
      dashboardProvider.loadDashboardResume(
          local: connectionProvider.isNotConnected);
    }();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const ScaffoldLogo(),
        actions: [const CartIcon()],
      ),
      body: RefreshIndicator(
        onRefresh: () => dashboardProvider.loadDashboardResume(
          local: connectionProvider.isNotConnected,
        ),
        color: Theme.of(context).primaryColor,
        child: _ResumeData(local: connectionProvider.isNotConnected),
      ),
    );
  }
}

class _ResumeData extends StatelessWidget {
  _ResumeData({Key key, @required this.local}) : super(key: key);

  final _preferences = Preferences();
  final bool local;

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final titleStyle = Theme.of(context).textTheme.headline5.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w600,
        );

    return ListView(
      children: [
        const SizedBox(height: 20.0),
        BuyerCard(client: _preferences.sessionCliente),
        _CardDataList(
          children: [
            CardData(
              title: "Cupo preaprobado",
              value: formatMoney(
                  dashboardProvider.clientResume.cupoPreaprobado.toDouble()),
              icon: Icons.sentiment_neutral_rounded,
              color: CustomTheme.yellowColor,
              isMain: false,
            ),
            CardData(
              title: "Cupo disponible",
              value: formatMoney(
                  dashboardProvider.clientResume.cupoDisponible.toDouble()),
              icon: Icons.sentiment_very_satisfied,
              color: CustomTheme.greenColor,
              isMain: false,
            ),
          ],
        ),
        _CardDataList(
          children: [
            CardData(
              title: "Saldo total deuda",
              value: formatMoney(
                  dashboardProvider.clientResume.saldoTotalDeuda.toDouble()),
              icon: Icons.error_outline,
              color: CustomTheme.purpleColor,
              isMain: false,
            ),
            CardData(
              title: "Saldo en mora",
              value: formatMoney(
                  dashboardProvider.clientResume.saldoMora.toDouble()),
              icon: Icons.sentiment_dissatisfied_rounded,
              color: CustomTheme.redColor,
              isMain: false,
            ),
          ],
        ),
        dashboardProvider.isLoading
            ? const LoadingContainer()
            : dashboardProvider.resume == null
                ? EmptyMessage(
                    onPressed: () =>
                        dashboardProvider.loadDashboardResume(local: local),
                    message: "No hay informaci??n.",
                  )
                : Column(
                    children: [
                      _CardDataList(children: [
                        CardStatistic(
                          isMain: true,
                          title: "Tiendas Creadas",
                          value: dashboardProvider.resume.cantidadTiendas,
                          label: "Tiendas",
                          icon: Icons.storefront,
                        ),
                        CardStatistic(
                          isMain: false,
                          icon: Octicons.comment_discussion,
                          title: "PQRS Generados",
                          value: dashboardProvider.resume.cantidadPqrs,
                          label: "PQRS",
                        ),
                      ]),
                      const SizedBox(height: 20.0),
                      Text(
                        "CONSOLIDADO PEDIDOS",
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      const ConsolidatedOrders(),
                      const SizedBox(height: 50.0),
                    ],
                  ),
      ],
    );
  }
}

class _CardDataList extends StatelessWidget {
  const _CardDataList({
    Key key,
    @required this.children,
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
