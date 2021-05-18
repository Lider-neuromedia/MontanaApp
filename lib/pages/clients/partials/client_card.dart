import 'package:flutter/material.dart';
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/pages/client/client_page.dart';
import 'package:montana_mobile/pages/clients/clients_page.dart';
import 'package:montana_mobile/theme/theme.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Cliente client;

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
              onTap: () => goToDetailClient(context),
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
                    Text(client.nombreCompleto, style: boldStyle),
                    Text(
                      "Nit. ${client.getData(Field.NIT)}",
                      style: normalStyle,
                    ),
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
                child: Text(client.iniciales, style: initialsStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goToDetailClient(BuildContext context) {
    Navigator.of(context).pushNamed(ClientPage.route);
  }
}
