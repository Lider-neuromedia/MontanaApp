import 'package:flutter/material.dart';
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/pages/orders/partials/order_detail_card.dart';
import 'package:montana_mobile/pages/orders/partials/products_table.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';

class OrderPage extends StatelessWidget {
  static final String route = 'order';

  @override
  Widget build(BuildContext context) {
    Order order = orderDetailTest();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido'),
        actions: [
          CartIcon(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ),
              child: Column(
                children: [
                  _OrderTitle(order: order),
                  SizedBox(height: 20.0),
                  _OrderDataList(
                    children: [
                      _OrderDetailData(
                        title: 'Fecha de emisión del pedido:',
                        value: formatDate(order.date),
                      ),
                      SizedBox(height: 10.0),
                      _OrderDetailData(
                        title: 'Nombre comercial:',
                        value: order.client.fullname,
                      ),
                      SizedBox(height: 10.0),
                      _OrderDetailData(
                        title: 'Nit:',
                        value: order.client.nit,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  _OrderDetailCards(
                    height: 270.0,
                    children: [
                      OrderDetailCard(
                        title: 'Valor del pedido',
                        value: formatMoney(order.total),
                      ),
                      OrderDetailCard(
                        title: 'Método de pago',
                        value: order.paymentMethod,
                      ),
                      OrderDetailCard(
                        title: 'Estado del pedido',
                        value: order.status.statusFormatted,
                      ),
                      OrderDetailCard(
                        title: 'Descuento',
                        value: "${order.discount}%",
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ProductsTable(
                    products: order.products,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderDataList extends StatelessWidget {
  const _OrderDataList({
    Key key,
    this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: children,
      ),
    );
  }
}

class _OrderDetailCards extends StatelessWidget {
  const _OrderDetailCards({
    Key key,
    @required this.children,
    @required this.height,
  }) : super(key: key);

  final List<Widget> children;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      height: height,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 16 / 10.5,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        children: children,
      ),
    );
  }
}

class _OrderTitle extends StatelessWidget {
  const _OrderTitle({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w700,
        );

    return Text(
      "PEDIDO #${order.code}",
      textAlign: TextAlign.center,
      style: titleStyle,
    );
  }
}

class _OrderDetailData extends StatelessWidget {
  const _OrderDetailData({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w700,
        );
    final valueStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: CustomTheme.textColor1,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: titleStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}
