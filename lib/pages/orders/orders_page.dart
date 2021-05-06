import 'package:flutter/material.dart';
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/pages/cart/cart_page.dart';
import 'package:montana_mobile/pages/catalogue/start_order_modal.dart';
import 'package:montana_mobile/pages/orders/partials/order_item.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
        actions: [
          CartIcon(),
        ],
      ),
      body: Column(
        children: [
          _OrdersFilter(),
          _ListOrders(),
        ],
      ),
      floatingActionButton: _CreateOrderButton(),
    );
  }
}

class _ListOrders extends StatelessWidget {
  const _ListOrders({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Order> orders = ordersListTest();
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
          bottom: 100.0,
        ),
        itemCount: orders.length,
        itemBuilder: (_, index) {
          return OrderItem(
            order: orders[index],
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 10.0);
        },
      ),
    );
  }
}

class _CreateOrderButton extends StatelessWidget {
  const _CreateOrderButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.add),
      onPressed: () => openStartOrder(context),
    );
  }

  void openStartOrder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (_) {
        return StartOrderModal(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(CartPage.route);
          },
        );
      },
    );
  }
}

class _OrdersFilter extends StatefulWidget {
  _OrdersFilter({
    Key key,
  }) : super(key: key);

  @override
  __OrdersFilterState createState() => __OrdersFilterState();
}

class __OrdersFilterState extends State<_OrdersFilter> {
  String dropdownValue;
  final List<String> values = ['Más recientes'];

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 5.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Ordenar por:', style: textStyle),
          SizedBox(width: 10.0),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            elevation: 16,
            style: textStyle,
            underline: Container(
              height: 2,
              color: CustomTheme.greyColor,
            ),
            onChanged: (String newValue) {
              setState(() => dropdownValue = newValue);
            },
            items: values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
