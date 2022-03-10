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
  ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;

  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);
      _loadData(context);
    }();
  }

  void _loadData(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    ordersProvider.loadOrders(
        local: connectionProvider.isNotConnected, refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final loadFromLocal = connectionProvider.isNotConnected;
    final orders = ordersProvider.orders;

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!ordersProvider.isLoading &&
            ordersProvider.pagination.isEndNotReached()) {
          ordersProvider.loadOrders(local: loadFromLocal);
        }
      }

      if (_scrollController.position.pixels > 1000 && !_showScrollButton) {
        setState(() => _showScrollButton = true);
      }
      if (_scrollController.position.pixels <= 1000 && _showScrollButton) {
        setState(() => _showScrollButton = false);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
        actions: [const CartIcon()],
      ),
      // floatingActionButton: _CreateOrderButton(),
      floatingActionButton: _showScrollButton
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.arrow_upward),
              mini: true,
              onPressed: () => _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => ordersProvider.loadOrders(
          local: loadFromLocal,
          refresh: true,
        ),
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            _OrdersFilter(),
            orders.isEmpty && !ordersProvider.isLoading
                ? EmptyMessage(
                    message: "No hay pedidos.",
                    onPressed: () => ordersProvider.loadOrders(
                      local: loadFromLocal,
                      refresh: true,
                    ),
                  )
                : Container(),
            orders.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(
                          bottom: 100.0, right: 10.0, left: 10.0, top: 10.0),
                      separatorBuilder: (_, i) => const SizedBox(height: 10.0),
                      itemCount: orders.length,
                      itemBuilder: (_, i) => OrderItem(order: orders[i]),
                    ),
                  )
                : Container(),
            ordersProvider.isLoading && orders.isNotEmpty
                ? const LoadingContainer()
                : Container()
          ],
        ),
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
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final loadFromLocal = connectionProvider.isNotConnected;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 5.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Ordenar por:", style: textStyle),
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
            onChanged: (String value) {
              ordersProvider.sortBy = value;
              ordersProvider.loadOrders(
                local: loadFromLocal,
                refresh: true,
              );
            },
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
