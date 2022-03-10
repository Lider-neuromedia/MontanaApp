import 'package:flutter/material.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/client/partials/store_card.dart';
import 'package:montana_mobile/pages/dashboard/partials/buyer_card.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_data.dart';
import 'package:montana_mobile/providers/clients_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/theme/theme.dart';

class ClientPage extends StatelessWidget {
  static final String route = "client-detail";

  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final clientsProvider = Provider.of<ClientsProvider>(context);
    final client = ModalRoute.of(context).settings.arguments as Usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cliente"),
      ),
      body: FutureBuilder(
        future: connectionProvider.isNotConnected
            ? clientsProvider.getClientLocal(client.id)
            : clientsProvider.getClient(client.id),
        builder: (_, AsyncSnapshot<Usuario> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingContainer();
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text("No hay información de cliente."),
            );
          }

          return _ClientContent(client: snapshot.data);
        },
      ),
    );
  }
}

class _ClientContent extends StatelessWidget {
  const _ClientContent({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Usuario client;

  @override
  Widget build(BuildContext context) {
    // final tiendas = client.tiendas;
    final tiendas = [];

    // TODO: cargar tiendas de cliente con request por separado.
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 30.0),
      itemCount: tiendas.length,
      itemBuilder: (_, int i) {
        if (i == 0) {
          return _ClientData(
            client: client,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30.0),
                  const _StoresTitle(title: "Tiendas"),
                  const SizedBox(height: 20.0),
                  StoreCard(
                    store: tiendas[i],
                    index: i + 1,
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 0.0,
          ),
          child: StoreCard(
            store: tiendas[i],
            index: i + 1,
          ),
        );
      },
      separatorBuilder: (_, int i) => const SizedBox(height: 20.0),
    );
  }
}

class _StoresTitle extends StatelessWidget {
  const _StoresTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6.copyWith(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _ClientData extends StatelessWidget {
  const _ClientData({
    Key key,
    @required this.client,
    @required this.child,
  }) : super(key: key);

  final Usuario client;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20.0),
        BuyerCard(client: client),
        _CardDataList(
          children: [
            CardData(
              title: "Cupo preaprobado",
              value: "\$4.300.400",
              icon: Icons.sentiment_neutral_rounded,
              color: CustomTheme.yellowColor,
              isMain: false,
            ),
            CardData(
              title: "Cupo disponible",
              value: "\$3.500.400",
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
              value: "\$4.300.400",
              icon: Icons.error_outline,
              color: CustomTheme.purpleColor,
              isMain: false,
            ),
            CardData(
              title: "Saldo en mora",
              value: "\$3.500.400",
              icon: Icons.sentiment_dissatisfied_rounded,
              color: CustomTheme.redColor,
              isMain: false,
            ),
          ],
        ),
        child,
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
