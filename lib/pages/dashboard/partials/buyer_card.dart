import 'package:flutter/material.dart';
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/theme/theme.dart';

class BuyerCard extends StatefulWidget {
  const BuyerCard({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Cliente client;

  @override
  _BuyerCardState createState() => _BuyerCardState();
}

class _BuyerCardState extends State<BuyerCard> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
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
                  title: widget.client.nombreCompleto,
                  description: 'Cliente Nit. ${widget.client.getData('nit')}',
                  titleBold: true,
                ),
              );
            },
            body: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 2.0,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              child: Column(
                children: [
                  _CardDataRow([
                    _BuyerField(
                      title: 'Teléfono',
                      description: widget.client.getData('telefono'),
                      titleBold: false,
                    ),
                    _BuyerField(
                      title: 'Correo electrónico',
                      description: widget.client.email,
                      titleBold: false,
                    ),
                  ]),
                  _CardDataRow([
                    _BuyerField(
                      title: 'Tipo de documento',
                      description: widget.client.tipoIdentificacion,
                      titleBold: false,
                    ),
                    _BuyerField(
                      title: 'Número de documento',
                      description: widget.client.dni,
                      titleBold: false,
                    ),
                  ]),
                  _CardDataRow([
                    _BuyerField(
                      title: 'Dirección',
                      description: widget.client.getData('direccion'),
                      titleBold: false,
                    ),
                    _BuyerField(
                      title: 'Nit',
                      description: widget.client.getData('nit'),
                      titleBold: false,
                    ),
                  ]),
                ],
              ),
            ),
            isExpanded: _isOpen,
          )
        ],
      ),
    );
  }
}

class _CardDataRow extends StatelessWidget {
  const _CardDataRow(this.children, {Key key}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: children[0],
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: children[1],
          ),
        ),
      ],
    );
  }
}

class _BuyerField extends StatelessWidget {
  _BuyerField({
    Key key,
    @required this.title,
    @required this.description,
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
