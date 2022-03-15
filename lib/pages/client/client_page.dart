import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/client/client_stores.dart';
import 'package:montana_mobile/pages/client/wallet_resume.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/providers/client_provider.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/dashboard/partials/buyer_card.dart';
import 'package:montana_mobile/providers/connection_provider.dart';

class ClientPage extends StatelessWidget {
  static final String route = "client-detail";

  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final clientProvider = Provider.of<ClientProvider>(context);
    final client = ModalRoute.of(context).settings.arguments as Usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cliente"),
      ),
      body: FutureBuilder(
        future: connectionProvider.isNotConnected
            ? clientProvider.getClientLocal(client.id)
            : clientProvider.getClient(client.id),
        builder: (_, AsyncSnapshot<Usuario> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingContainer();
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No hay información de cliente."),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BuyerCard(client: client),
                WalletResume(client: client),
                const SizedBox(height: 10.0),
                const _StoresTitle(title: "Tiendas"),
                const SizedBox(height: 10.0),
                ClientStores(client: client),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StoresTitle extends StatelessWidget {
  const _StoresTitle({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );

    return Center(
      child: Text(title, style: titleStyle),
    );
  }
}
