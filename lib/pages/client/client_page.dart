import 'package:flutter/material.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/providers/client_provider.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/client/partials/store_card.dart';
import 'package:montana_mobile/pages/dashboard/partials/buyer_card.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_data.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/theme/theme.dart';

class ClientPage extends StatelessWidget {
  static final String route = "client-detail";

  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final clientProvider = Provider.of<ClientProvider>(context);
    final client = ModalRoute.of(context).settings.arguments as Usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cliente"),
      ),
      body: FutureBuilder(
        future: connectionProvider.isNotConnected
            ? clientProvider.getClientLocal(client.id)
            : clientProvider.getClient(client.id),
        builder: (_, AsyncSnapshot<Usuario> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingContainer();
          } else if (!snapshot.hasData) {
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
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final clientProvider = Provider.of<ClientProvider>(context);

    return FutureBuilder(
      future: connectionProvider.isNotConnected
          ? clientProvider.getClientStoresLocal(client.id)
          : clientProvider.getClientStores(client.id),
      builder: (_, AsyncSnapshot<List<Tienda>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingContainer();
        } else if (!snapshot.hasData) {
          return Center(
            child: Text("No hay información de tiendas."),
          );
        }

        final tiendas = snapshot.data ?? [];

        return ListView.separated(
          separatorBuilder: (_, int i) => const SizedBox(height: 20.0),
          padding: const EdgeInsets.only(bottom: 30.0),
          itemCount: tiendas.length,
          itemBuilder: (_, int i) {
            const padding = const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 0.0,
            );
            final storeCard = StoreCard(
              store: tiendas[i],
              index: i + 1,
            );

            return i == 0
                ? _ClientData(
                    client: client,
                    child: Padding(
                      padding: padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _StoresTitle(title: "Tiendas"),
                          storeCard,
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: padding,
                    child: storeCard,
                  );
          },
        );
      },
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
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Text(title, style: titleStyle),
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
            // TODO: obtener datos desde el API.
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
