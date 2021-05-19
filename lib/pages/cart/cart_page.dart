import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/cart/checkout_modal.dart';
import 'package:montana_mobile/pages/catalogue/add_product_modal.dart';
import 'package:montana_mobile/pages/catalogue/partials/action_button.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';

class CartPage extends StatelessWidget {
  static final String route = 'cart';

  @override
  Widget build(BuildContext context) {
    final _Order order = cartDataTest();
    return Scaffold(
      appBar: AppBar(
        title: Text('Bolsa de Compras'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: order.items.length,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (_, int index) => _CartItem(
                orderItem: order.items[index],
              ),
              separatorBuilder: (_, int index) {
                return SizedBox(height: 20.0);
              },
            ),
          ),
          _CartTotals(order: order),
          _CartActions(),
        ],
      ),
    );
  }
}

class _CartTotals extends StatelessWidget {
  const _CartTotals({
    Key key,
    @required this.order,
  }) : super(key: key);

  final _Order order;

  @override
  Widget build(BuildContext context) {
    final regularStyle = Theme.of(context).textTheme.subtitle1;
    final mainStyle = Theme.of(context).textTheme.headline6.copyWith(
          fontWeight: FontWeight.w700,
        );

    double total = 0;
    order.items.forEach((item) {
      item.stockStores.forEach((stock) {
        total += stock.subtotal;
      });
    });

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: CustomTheme.greyColor,
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Total', style: regularStyle),
          Text(formatMoney(total), style: mainStyle),
        ],
      ),
    );
  }
}

class _CartActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ActionButton(
            label: "Finalizar el pedido",
            icon: Icons.add,
            borderColor: CustomTheme.green2Color,
            backgroundColor: CustomTheme.green2Color,
            iconColor: Colors.white,
            textColor: Colors.white,
            onPressed: () => openFinalizeOrder(context),
          ),
          ActionButton(
            label: "Cancelar",
            icon: Icons.close,
            borderColor: CustomTheme.redColor,
            backgroundColor: Colors.grey[200],
            iconColor: CustomTheme.redColor,
            textColor: CustomTheme.redColor,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void openFinalizeOrder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (_) => CheckoutModal(),
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({
    Key key,
    @required this.orderItem,
  }) : super(key: key);

  final _OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openAddProduct(context),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomTheme.greyColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          children: [
            _CartItemHeader(orderItem: orderItem),
            Divider(
              color: CustomTheme.greyColor,
              height: 20.0,
              thickness: 2.0,
            ),
            Column(
              children: orderItem.stockStores
                  .map((item) => _CartItemStock(stockStore: item))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void openAddProduct(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (_) {
        return AddProductModal();
      },
    );
  }
}

class _CartItemHeader extends StatelessWidget {
  const _CartItemHeader({
    Key key,
    this.orderItem,
  }) : super(key: key);

  final _OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: FadeInImage(
              placeholder: AssetImage("assets/images/placeholder.png"),
              image: NetworkImage(orderItem.image),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 25.0),
        Text("Ref: ${orderItem.reference}", style: titleStyle),
      ],
    );
  }
}

class _CartItemStock extends StatelessWidget {
  const _CartItemStock({
    Key key,
    this.stockStore,
  }) : super(key: key);

  final _OrderStockStore stockStore;

  @override
  Widget build(BuildContext context) {
    final regularStyle = Theme.of(context).textTheme.subtitle1;
    final boldStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.bold,
        );
    final mainStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Text(stockStore.place, style: boldStyle),
          SizedBox(width: 5.0),
          Text(stockStore.local, style: regularStyle),
          Expanded(child: Container()),
          Text("${stockStore.quantity}", style: mainStyle),
        ],
      ),
    );
  }
}

class _Order {
  _Order({this.id, this.items});

  int id;
  List<_OrderItem> items;
}

class _OrderItem {
  _OrderItem({this.id, this.reference, this.image, this.stockStores});

  int id;
  String reference;
  String image;
  List<_OrderStockStore> stockStores;
}

class _OrderStockStore {
  _OrderStockStore({
    this.place,
    this.local,
    this.quantity,
    this.subtotal,
  });

  String place;
  String local;
  int quantity;
  int subtotal;
}

_Order cartDataTest() {
  return _Order(
    id: 1,
    items: [
      _OrderItem(
        id: 1,
        reference: '389y903uweiru',
        image:
            'http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/002/002-0.jpeg',
        stockStores: [
          _OrderStockStore(
              place: 'CC Único',
              local: 'L 204',
              subtotal: 200000,
              quantity: 20),
          _OrderStockStore(
              place: 'San Andresito',
              local: 'L 118',
              subtotal: 200000,
              quantity: 55),
          _OrderStockStore(
              place: 'CC Unicentro',
              local: 'L 204',
              subtotal: 200000,
              quantity: 23),
          _OrderStockStore(
              place: 'Granada',
              local: 'Calle 4 No. 6 - 89',
              subtotal: 200000,
              quantity: 23),
        ],
      ),
      _OrderItem(
        id: 2,
        reference: '3hyd938y38938',
        image:
            'http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/001/001-0.png',
        stockStores: [
          _OrderStockStore(
              place: 'San Andresito',
              local: 'L 118',
              subtotal: 200000,
              quantity: 55),
          _OrderStockStore(
              place: 'CC Único',
              local: 'L 204',
              subtotal: 200000,
              quantity: 20),
        ],
      ),
      _OrderItem(
        id: 3,
        reference: '28dy93gd393e3',
        image:
            'http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/002/002-0.jpeg',
        stockStores: [
          _OrderStockStore(
              place: 'Granada',
              local: 'Calle 4 No. 6 - 89',
              subtotal: 200000,
              quantity: 23),
          _OrderStockStore(
              place: 'CC Unicentro',
              local: 'L 204',
              subtotal: 200000,
              quantity: 23),
          _OrderStockStore(
              place: 'CC Único',
              local: 'L 204',
              subtotal: 200000,
              quantity: 20),
        ],
      ),
    ],
  );
}
