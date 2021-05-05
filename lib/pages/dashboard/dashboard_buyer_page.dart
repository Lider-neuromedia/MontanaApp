import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_data.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_statistic.dart';
import 'package:montana_mobile/pages/dashboard/partials/consolidated_orders.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

class DashboardBuyerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.headline5.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w600,
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ScaffoldLogo(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            BuyerCard(),
            _CardDataList(
              children: [
                CardData(
                  title: 'Cupo preaprobado',
                  value: '\$4.300.400',
                  icon: Icons.face,
                  color: CustomTheme.yellowColor,
                  isMain: false,
                ),
                CardData(
                  title: 'Cupo disponible',
                  value: '\$3.500.400',
                  icon: Icons.face,
                  color: CustomTheme.greenColor,
                  isMain: false,
                ),
                CardData(
                  title: 'Saldo total deuda',
                  value: '\$4.300.400',
                  icon: Icons.face,
                  color: CustomTheme.purpleColor,
                  isMain: false,
                ),
                CardData(
                  title: 'Saldo en mora',
                  value: '\$3.500.400',
                  icon: Icons.face,
                  color: CustomTheme.redColor,
                  isMain: false,
                ),
              ],
            ),
            SizedBox(height: 20.0),
            _ConsolidatedClients(),
            SizedBox(height: 40.0),
            Text('CONSOLIDADO PEDIDOS', style: titleStyle),
            SizedBox(height: 20.0),
            ConsolidatedOrders(),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}

class _CardDataList extends StatelessWidget {
  const _CardDataList({
    Key key,
    this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.0,
      padding: EdgeInsets.all(15.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        childAspectRatio: 16 / 6.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
        children: children,
      ),
    );
  }
}

class BuyerCard extends StatefulWidget {
  @override
  _BuyerCardState createState() => _BuyerCardState();
}

class _BuyerCardState extends State<BuyerCard> {
  bool _isOpen = false;

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
                  'Alfonso Bejarando',
                  'Cliente No. 338894840',
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
                children: <Widget>[
                  _BuyerField('Teléfono', '3001008574'),
                  _BuyerField('Correo Electrónico', 'alfonso@mail.com'),
                  _BuyerField('Tipo de Documento', 'Cédula de Ciudadanía'),
                  _BuyerField('Número de Documento', '1112456147'),
                  _BuyerField('Ciudad', 'Cali'),
                  _BuyerField('Nit', '1115741456-8'),
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

class _BuyerField extends StatelessWidget {
  _BuyerField(
    this.title,
    this.description, {
    Key key,
    this.titleBold,
  }) : super(key: key);

  final String title;
  final String description;
  bool titleBold;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle1 = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.textColor1,
        );
    TextStyle textStyle2 = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w600,
        );

    if (titleBold == null) {
      titleBold = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleBold ? textStyle2 : textStyle1),
        Text(description, style: titleBold ? textStyle1 : textStyle2),
      ],
    );
  }
}

class _ConsolidatedClients extends StatelessWidget {
  const _ConsolidatedClients({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CardStatistic(
          isMain: true,
          title: 'Tiendas Creadas',
          value: 12,
          label: 'Tiendas',
          icon: Icons.storefront,
        ),
        CardStatistic(
          isMain: false,
          icon: Icons.chat,
          title: 'PQRS Generados',
          value: 50,
          label: 'Tiendas',
        ),
      ],
    );
  }
}
