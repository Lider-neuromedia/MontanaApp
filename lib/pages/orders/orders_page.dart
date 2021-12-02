import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/orders/partials/order_item.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/orders_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      final connectionProvider =
          Provider.of<ConnectionProvider>(context, listen: false);
      ordersProvider.loadOrders(local: connectionProvider.isNotConnected);
    }();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
        actions: [
          const CartIcon(),
        ],
      ),
      // floatingActionButton: _CreateOrderButton(),
      body: ordersProvider.isLoading
          ? const LoadingContainer()
          : ordersProvider.orders.length == 0
              ? EmptyMessage(
                  onPressed: () => ordersProvider.loadOrders(
                    local: connectionProvider.isNotConnected,
                  ),
                  message: 'No hay pedidos.',
                )
              : RefreshIndicator(
                  onRefresh: () => ordersProvider.loadOrders(
                    local: connectionProvider.isNotConnected,
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      _OrdersFilter(),
                      _ListOrders(),
                    ],
                  ),
                ),
    );
  }
}

class _ListOrders extends StatelessWidget {
  const _ListOrders({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
          bottom: 100.0,
        ),
        itemCount: ordersProvider.orders.length,
        itemBuilder: (_, index) => OrderItem(
          order: ordersProvider.orders[index],
        ),
        separatorBuilder: (_, i) => const SizedBox(height: 10.0),
      ),
    );
  }
}

// TODO: Botón de crear orden oculto.
// class _CreateOrderButton extends StatelessWidget {
//   const _CreateOrderButton({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       backgroundColor: Theme.of(context).primaryColor,
//       child: const Icon(Icons.add),
//       onPressed: () => openStartOrderModal(
//         context,
//         onContinue: () => Navigator.of(context).pushNamed(CartPage.route),
//       ),
//     );
//   }
// }

class _OrdersFilter extends StatefulWidget {
  _OrdersFilter({Key key}) : super(key: key);

  @override
  __OrdersFilterState createState() => __OrdersFilterState();
}

class __OrdersFilterState extends State<_OrdersFilter> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.subtitle1;
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 5.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Ordenar por:', style: textStyle),
          const SizedBox(width: 10.0),
          DropdownButton<String>(
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            elevation: 16,
            style: textStyle,
            underline: Container(
              color: CustomTheme.greyColor,
              height: 2,
            ),
            onChanged: (String value) => ordersProvider.sortBy = value,
            value: ordersProvider.sortBy,
            items: ordersProvider.sortValues
                .map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value.id,
                child: Text(value.value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
