import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/clients/clients_page.dart';
import 'package:montana_mobile/pages/pqrs/partials/pqrs_card.dart';
import 'package:montana_mobile/pages/pqrs/partials/pqrs_filter.dart';
import 'package:montana_mobile/pages/pqrs/partials/search_box.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

class PqrsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PqrsTemporal> pqrsList = pqrsListTest();

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
          PqrsFilter(),
          Expanded(
            child: ListView.separated(
              itemCount: pqrsList.length,
              padding: EdgeInsets.symmetric(vertical: 15.0),
              itemBuilder: (_, int index) {
                return PqrsCard(pqrs: pqrsList[index]);
              },
              separatorBuilder: (_, int index) {
                return SizedBox(height: 20.0);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PqrsTemporal {
  int id;
  String code;
  DateTime datedAt;
  String status;
  ClientTemporal client;
  PqrsSellerTemporal seller;

  PqrsTemporal(this.id, this.code, this.datedAt, this.status);
}

class PqrsSellerTemporal {
  String name;
  String lastname;
  PqrsSellerTemporal(this.name, this.lastname);
}

List<PqrsTemporal> pqrsListTest() {
  List clients = clientsListTest();
  List<PqrsTemporal> pqrsList = [];

  clients.asMap().forEach((index, client) {
    final id = ((index + 1) * 2);
    final code = ((index + 5) * 798).toString();
    final datedAt = DateTime(2021, index + 1, index + 2 * 3);
    final status = index % 2 == 0 ? 'cerrado' : 'abierto';

    final pqrs = PqrsTemporal(id, code, datedAt, status);
    pqrs.seller = PqrsSellerTemporal('Oscar', 'Delmiro');
    pqrs.client = client;

    pqrsList.add(pqrs);
  });

  return pqrsList;
}
