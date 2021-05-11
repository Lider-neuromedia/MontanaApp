import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/clients/partials/client_card.dart';
import 'package:montana_mobile/pages/clients/partials/clients_filter.dart';
import 'package:montana_mobile/pages/clients/partials/search_box.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

class ClientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<ClientTemporal> clients = clientsListTest();

    return Scaffold(
      appBar: AppBar(
        title: ScaffoldLogo(),
        actions: [
          TextButton(
            child: Text(
              'Listado de clientes',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.white,
                  ),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: null,
          ),
          SizedBox(width: 10.0),
        ],
        elevation: 0,
      ),
      body: Column(
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
      ),
    );
  }
}
