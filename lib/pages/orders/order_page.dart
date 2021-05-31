import 'package:flutter/material.dart';
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/orders/partials/order_detail_card.dart';
import 'package:montana_mobile/pages/orders/partials/products_table.dart';
import 'package:montana_mobile/providers/orders_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  static final String route = 'order';

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);
      _loadData(context);
    }();
  }

  void _loadData(BuildContext context) {
    final orderId = ModalRoute.of(context).settings.arguments as int;
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.loadOrder(orderId);
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orderId = ModalRoute.of(context).settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido'),
        actions: [
          const CartIcon(),
        ],
      ),
      body: ordersProvider.isOrderLoading
          ? const LoadingContainer()
          : ordersProvider.order == null
              ? EmptyMessage(
                  onPressed: () => ordersProvider.loadOrder(orderId),
                  message: 'No hay información.',
                )
              : RefreshIndicator(
                  onRefresh: () => ordersProvider.loadOrder(orderId),
                  color: Theme.of(context).primaryColor,
                  child: _OrderDetailContent(order: ordersProvider.order),
                ),
    );
  }
}

class _OrderDetailContent extends StatelessWidget {
  const _OrderDetailContent({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Pedido order;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: [
        _OrderTitle(order: order),
        const SizedBox(height: 20.0),
        _OrderDataList(
          children: [
            _OrderDetailData(
              title: 'Fecha de emisión del pedido:',
              value: formatDate(order.fecha),
            ),
            const SizedBox(height: 10.0),
            _OrderDetailData(
              title: 'Nombre comercial:',
              value: order.cliente.nombreCompleto,
            ),
            const SizedBox(height: 10.0),
            _OrderDetailData(
              title: 'Nit:',
              value: order.cliente.nit,
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        _OrderDetailCards(
          height: 270.0,
          children: [
            OrderDetailCard(
              title: 'Valor del pedido',
              value: formatMoney(order.total),
            ),
            OrderDetailCard(
              title: 'Método de pago',
              value: order.metodoPago,
            ),
            OrderDetailCard(
              title: 'Estado del pedido',
              value: order.estadoFormatted,
            ),
            OrderDetailCard(
              title: 'Descuento',
              value: "${order.descuento}%",
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        ProductsTable(products: order.productos),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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

  final Pedido order;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w700,
        );

    return Text(
      "PEDIDO #${order.codigo}",
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
