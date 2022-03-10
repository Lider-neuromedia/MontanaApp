import 'package:flutter/material.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/clients/partials/client_card.dart';
import 'package:montana_mobile/providers/clients_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';
import 'package:montana_mobile/widgets/search_box.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      final clientsProvider =
          Provider.of<ClientsProvider>(context, listen: false);
      final connectionProvider =
          Provider.of<ConnectionProvider>(context, listen: false);
      clientsProvider.loadClients(local: connectionProvider.isNotConnected);
    }();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Colors.white,
        );
    final clientsProvider = Provider.of<ClientsProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const ScaffoldLogo(),
        actions: [
          TextButton(
            onPressed: null,
            child: Text("Listado de clientes", style: titleStyle),
            style: TextButton.styleFrom(primary: Colors.white),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: clientsProvider.isLoading
          ? const LoadingContainer()
          : clientsProvider.clients.length == 0
              ? EmptyMessage(
                  message: "No hay clientes encontrados.",
                  onPressed: () => clientsProvider.loadClients(
                    local: connectionProvider.isNotConnected,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => clientsProvider.loadClients(
                    local: connectionProvider.isNotConnected,
                  ),
                  color: Theme.of(context).primaryColor,
                  child: _ClientsContent(),
                ),
    );
  }
}

class _ClientsContent extends StatelessWidget {
  const _ClientsContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clientsProvider = Provider.of<ClientsProvider>(context);

    return Column(
      children: [
        SearchBox(
          value: clientsProvider.search,
          onChanged: (String value) {
            clientsProvider.search = value;
          },
        ),
        clientsProvider.isSearchActive
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("No hay coincidencias."),
                ),
              )
            : Container(),
        clientsProvider.search.isEmpty
            ? ClientsListResults(clients: clientsProvider.clients)
            : ClientsListResults(clients: clientsProvider.searchClients),
      ],
    );
  }
}

class ClientsListResults extends StatelessWidget {
  const ClientsListResults({
    Key key,
    @required this.clients,
  }) : super(key: key);

  final List<Usuario> clients;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: clients.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (_, int i) => ClientCard(client: clients[i]),
        separatorBuilder: (_, int i) => const SizedBox(height: 5.0),
      ),
    );
  }
}
