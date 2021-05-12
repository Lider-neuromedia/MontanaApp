import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/clients/partials/client_card.dart';
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

class ClientTemporal {
  int id;
  String name;
  String code;
  ClientTemporal(this.id, this.name, this.code);

  String get initials {
    List<String> words = name.split(" ");

    if (words.length == 1) {
      return words[0].substring(0, 2).toUpperCase();
    } else if (words.length > 1) {
      String c1 = words[0].substring(0, 1);
      String c2 = words[1].substring(0, 1);
      return "$c1$c2";
    }

    return 'CL';
  }
}

List<ClientTemporal> clientsListTest() {
  return [
    ClientTemporal(1, 'Bejarano Garavito Bladimiro Alfonso', '464648654'),
    ClientTemporal(2, 'Ana María Urrutia Vasquez', '134467465'),
    ClientTemporal(3, 'Alicia Maldonado', '213216545'),
    ClientTemporal(4, 'Luis Restrepo', '798161354'),
    ClientTemporal(5, 'Alfonso Sallas', '715689485'),
    ClientTemporal(6, 'Julian Linarez Gonzalez', '363546156'),
    ClientTemporal(7, 'Laura Osorio', '846434645'),
  ];
}
