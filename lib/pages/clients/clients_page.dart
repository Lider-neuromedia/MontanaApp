import 'package:flutter/material.dart';
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/clients/partials/client_card.dart';
import 'package:montana_mobile/pages/clients/partials/search_box.dart';
import 'package:montana_mobile/providers/clients_provider.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';
import 'package:provider/provider.dart';

class ClientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Colors.white,
        );
    final ClientsProvider clientsProvider =
        Provider.of<ClientsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: ScaffoldLogo(),
        actions: [
          TextButton(
            child: Text('Listado de clientes', style: titleStyle),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: null,
          ),
          SizedBox(width: 10.0),
        ],
        elevation: 0,
      ),
      body: clientsProvider.isLoading
          ? const LoadingContainer()
          : clientsProvider.clients.length == 0
              ? EmptyMessage(
                  onPressed: () => clientsProvider.loadClients(),
                  message: 'No hay clientes encontrados.',
                )
              : RefreshIndicator(
                  onRefresh: () => clientsProvider.loadClients(),
                  color: Theme.of(context).primaryColor,
                  child: _ClientsContent(
                    clients: clientsProvider.clients,
                  ),
                ),
    );
  }
}

class _ClientsContent extends StatelessWidget {
  const _ClientsContent({
    Key key,
    @required this.clients,
  }) : super(key: key);

  final List<Cliente> clients;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBox(),
        Expanded(
          child: ListView.separated(
            itemCount: clients.length,
            padding: EdgeInsets.all(15.0),
            itemBuilder: (_, int index) => ClientCard(
              client: clients[index],
            ),
            separatorBuilder: (_, int index) {
              return SizedBox(height: 5.0);
            },
          ),
        ),
      ],
    );
  }
}
