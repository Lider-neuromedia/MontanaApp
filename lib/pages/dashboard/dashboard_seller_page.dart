import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_data.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_statistic.dart';
import 'package:montana_mobile/pages/dashboard/partials/consolidated_orders.dart';
import 'package:montana_mobile/pages/dashboard/partials/filter_ready_clients_modal.dart';
import 'package:montana_mobile/providers/dashboard_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';
import 'package:provider/provider.dart';

class DashboardSellerPage extends StatefulWidget {
  @override
  _DashboardSellerPageState createState() => _DashboardSellerPageState();
}

class _DashboardSellerPageState extends State<DashboardSellerPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      dashboardProvider.loadDashboardResume();
    }();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const ScaffoldLogo(),
        actions: [
          const CartIcon(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => dashboardProvider.loadDashboardResume(),
        color: Theme.of(context).primaryColor,
        child: ListView(
          children: [
            const SizedBox(height: 30.0),
            const Center(
              child: const _SectionTitle('CONSOLIDADO COMISIONES'),
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
            dashboardProvider.isLoading
                ? const LoadingContainer()
                : dashboardProvider.resumen == null
                    ? EmptyMessage(
                        onPressed: () =>
                            dashboardProvider.loadDashboardResume(),
                        message: 'No hay información.',
                      )
                    : Column(
                        children: [
                          const _SectionTitle('CONSOLIDADO CLIENTES'),
                          const SizedBox(height: 20.0),
                          _ConsolidatedClients(),
                          const SizedBox(height: 40.0),
                          const _SectionTitle('CONSOLIDADO PEDIDOS'),
                          const SizedBox(height: 20.0),
                          ConsolidatedOrders(),
                          const SizedBox(height: 50.0),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.value, {Key key}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline5.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w600,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(value, style: titleStyle),
    );
  }
}

class _ConsolidatedClients extends StatelessWidget {
  const _ConsolidatedClients({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardStatistic(
          isMain: false,
          title: 'Clientes Generados',
          value: dashboardProvider.resumen.cantidadClientes,
          label: 'Clientes',
        ),
        CardStatistic(
          isMain: false,
          title: 'Clientes Atendidos',
          subtitle: dashboardProvider.currentClientsReadyDate != null
              ? dashboardProvider.currentClientsReadyDate
              : 'Último mes',
          value: dashboardProvider.resumen.cantidadClientesAtendidos,
          label: 'Clientes',
          onTap: () => openFilterReadyClientsModal(context),
        ),
      ],
    );
  }
}

class _CommisionsList extends StatelessWidget {
  const _CommisionsList({
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
