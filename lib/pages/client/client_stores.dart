import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/client/partials/store_card.dart';
import 'package:montana_mobile/providers/client_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';

class ClientStores extends StatelessWidget {
  const ClientStores({Key key, @required this.client}) : super(key: key);

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
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: LoadingContainer(),
          );
        } else if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text("No hay tiendas para mostrar."),
            ),
          );
        }

        final tiendas = snapshot.data ?? [];

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, int i) => const SizedBox(height: 20.0),
          padding: const EdgeInsets.only(bottom: 30.0),
          itemCount: tiendas.length,
          itemBuilder: (_, int i) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 0.0,
            ),
            child: StoreCard(
              store: tiendas[i],
              index: i + 1,
            ),
          ),
        );
      },
    );
  }
}
