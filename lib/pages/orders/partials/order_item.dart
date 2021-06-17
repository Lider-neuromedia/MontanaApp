import 'package:flutter/material.dart';
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/pages/orders/order_page.dart';
import 'package:montana_mobile/utils/utils.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Pedido order;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    TextStyle textStyle1 = textTheme.headline6.copyWith(
      color: textTheme.subtitle1.color,
      fontWeight: FontWeight.w700,
    );
    TextStyle textStyle2 = textTheme.subtitle1;
    TextStyle textStyle3 = textTheme.subtitle1.copyWith(
      color: Theme.of(context).primaryColor,
    );
    TextStyle textStyle4 = textTheme.subtitle1.copyWith(
      color: Colors.white,
    );

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            OrderPage.route,
            arguments: order.idPedido,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Cliente: ${order.clienteNombre}", style: textStyle1),
              const SizedBox(height: 5.0),
              Text("Pedido #${order.codigo}", style: textStyle2),
              const SizedBox(height: 5.0),
              Text(formatDate(order.fecha), style: textStyle2),
              const SizedBox(height: 5.0),
              Text(formatMoney(order.total), style: textStyle3),
              const SizedBox(height: 10.0),
              Container(
                child: Text(order.estadoFormatted, style: textStyle4),
                color: order.estadoColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
