import 'package:flutter/material.dart';
import 'package:montana_mobile/models/client_wallet_resume.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_data.dart';
import 'package:montana_mobile/providers/client_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class WalletResume extends StatelessWidget {
  const WalletResume({Key key, @required this.client}) : super(key: key);

  final Usuario client;

  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final clientProvider = Provider.of<ClientProvider>(context);

    return FutureBuilder(
      future: connectionProvider.isNotConnected
          ? clientProvider.getResumeClientWalletLocal(client.id)
          : clientProvider.getResumeClientWallet(client.id),
      builder: (_, AsyncSnapshot<ResumenCarteraCliente> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: LoadingContainer()),
          );
        } else if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: Text("No hay información de cartera.")),
          );
        }

        final resumen = snapshot.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardDataList(
              children: [
                CardData(
                  title: "Cupo preaprobado",
                  value: formatMoney(resumen.cupoPreaprobado.toDouble()),
                  icon: Icons.sentiment_neutral_rounded,
                  color: CustomTheme.yellowColor,
                  isMain: false,
                ),
                CardData(
                  title: "Cupo disponible",
                  value: formatMoney(resumen.cupoDisponible.toDouble()),
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
                  value: formatMoney(resumen.saldoTotalDeuda.toDouble()),
                  icon: Icons.error_outline,
                  color: CustomTheme.purpleColor,
                  isMain: false,
                ),
                CardData(
                  title: "Saldo en mora",
                  value: formatMoney(resumen.saldoMora.toDouble()),
                  icon: Icons.sentiment_dissatisfied_rounded,
                  color: CustomTheme.redColor,
                  isMain: false,
                ),
              ],
            ),
          ],
        );
      },
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
