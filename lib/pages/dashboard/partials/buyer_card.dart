import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class BuyerCard extends StatefulWidget {
  @override
  _BuyerCardState createState() => _BuyerCardState();
}

class _BuyerCardState extends State<BuyerCard> {
  bool _isOpen = false;
  final client = getClientDataTest();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.only(top: 10.0, left: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[200],
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.all(0),
        expansionCallback: (i, isOpen) {
          setState(() => _isOpen = !_isOpen);
        },
        children: [
          ExpansionPanel(
            headerBuilder: (_, bool isOpen) {
              return Container(
                child: _BuyerField(
                  client.name,
                  'Cliente No. ${client.code}',
                  titleBold: true,
                ),
              );
            },
            body: Container(
              height: 160.0,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 2.0,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                childAspectRatio: 16 / 3.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: client.data
                    .map(
                      (item) => _BuyerField(
                        item.key,
                        item.value,
                        titleBold: false,
                      ),
                    )
                    .toList(),
              ),
            ),
            isExpanded: _isOpen,
          )
        ],
      ),
    );
  }
}

class _BuyerField extends StatelessWidget {
  _BuyerField(
    this.title,
    this.description, {
    Key key,
    @required this.titleBold,
  }) : super(key: key);

  final String title;
  final String description;
  final bool titleBold;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle1 = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.textColor1,
        );
    TextStyle textStyle2 = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w600,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleBold ? textStyle2 : textStyle1,
        ),
        Text(
          description,
          style: titleBold ? textStyle1 : textStyle2,
        ),
      ],
    );
  }
}

ClientTemporal getClientDataTest() {
  return ClientTemporal(
    name: 'Alfonso Bejarando',
    code: '338894840',
    data: [
      ClientDataTemporal(
        key: 'Teléfono',
        value: '3001008574',
      ),
      ClientDataTemporal(
        key: 'Correo Electrónico',
        value: 'alfonso@mail.com',
      ),
      ClientDataTemporal(
        key: 'Tipo de Documento',
        value: 'Cédula de Ciudadanía',
      ),
      ClientDataTemporal(
        key: 'Número de Documento',
        value: '1112456147',
      ),
      ClientDataTemporal(
        key: 'Ciudad',
        value: 'Cali',
      ),
      ClientDataTemporal(
        key: 'Nit',
        value: '1115741456-8',
      ),
    ],
  );
}

class ClientTemporal {
  String name;
  String code;
  List<ClientDataTemporal> data;

  ClientTemporal({
    @required this.name,
    @required this.code,
    @required this.data,
  });
}

class ClientDataTemporal {
  String key;
  String value;

  ClientDataTemporal({
    @required this.key,
    @required this.value,
  });
}
