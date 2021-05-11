import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    Key key,
    @required this.client,
  }) : super(key: key);

  final ClientTemporal client;

  @override
  Widget build(BuildContext context) {
    final TextStyle normalStyle = Theme.of(context).textTheme.subtitle1;
    final TextStyle boldStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.bold,
        );
    final TextStyle initialsStyle =
        Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: CustomTheme.greyColor,
            offset: Offset(0.0, 3.0),
            blurRadius: 6.0,
          )
        ],
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            clipBehavior: Clip.none,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              onTap: () {},
              child: Ink(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  bottom: 15.0,
                  top: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.name, style: boldStyle),
                    Text("Cliente No. ${client.code}", style: normalStyle),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 10.0,
            top: -15.0,
            child: Container(
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(client.initials, style: initialsStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClientTemporal {
  String name;
  String code;
  ClientTemporal(this.name, this.code);

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
    ClientTemporal('Bejarano Garavito Bladimiro Alfonso', '464648654'),
    ClientTemporal('Ana María Urrutia Vasquez', '134467465'),
    ClientTemporal('Alicia Maldonado', '213216545'),
    ClientTemporal('Luis Restrepo', '798161354'),
    ClientTemporal('Alfonso Sallas', '715689485'),
    ClientTemporal('Julian Linarez Gonzalez', '363546156'),
    ClientTemporal('Laura Osorio', '846434645'),
  ];
}
