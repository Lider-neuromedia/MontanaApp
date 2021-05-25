import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/cart/checkout_modal.dart';
import 'package:montana_mobile/pages/catalogue/add_product_modal.dart';
import 'package:montana_mobile/pages/catalogue/partials/action_button.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  static final String route = 'cart';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bolsa de Compras'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cartProvider.cart.products.length,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (_, int index) {
                return _CartItem(cartProduct: cartProvider.products[index]);
              },
              separatorBuilder: (_, int index) {
                return SizedBox(height: 20.0);
              },
            ),
          ),
          _CartTotals(cart: cartProvider.cart),
          _CartActions(),
        ],
      ),
    );
  }
}

class _CartTotals extends StatelessWidget {
  const _CartTotals({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final regularStyle = Theme.of(context).textTheme.subtitle1;
    final mainStyle = Theme.of(context).textTheme.headline6.copyWith(
          fontWeight: FontWeight.w700,
        );

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
          Text(formatMoney(cart.total), style: mainStyle),
        ],
      ),
    );
  }
}

class _CartActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

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
            onPressed: cartProvider.canFinalize
                ? () => openFinalizeOrder(context)
                : null,
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
    @required this.cartProduct,
  }) : super(key: key);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openAddProduct(context),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
            color: CustomTheme.greyColor,
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            _CartItemHeader(cartProduct: cartProduct),
            Divider(
              color: CustomTheme.greyColor,
              height: 20.0,
              thickness: 2.0,
            ),
            Column(
              children: cartProduct.stores.map((store) {
                return _CartItemStock(cartStore: store);
              }).toList(),
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
        return AddProductModal(product: cartProduct.product);
      },
    );
  }
}

class _CartItemHeader extends StatelessWidget {
  const _CartItemHeader({
    Key key,
    this.cartProduct,
  }) : super(key: key);

  final CartProduct cartProduct;

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
              image: NetworkImage(cartProduct.product.image),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 25.0),
        Text("Ref: ${cartProduct.product.referencia}", style: titleStyle),
      ],
    );
  }
}

class _CartItemStock extends StatelessWidget {
  const _CartItemStock({
    Key key,
    @required this.cartStore,
  }) : super(key: key);

  final CartStore cartStore;

  @override
  Widget build(BuildContext context) {
    final regularStyle = Theme.of(context).textTheme.subtitle1;
    final boldStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.bold,
        );
    final mainStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Text("${cartStore.store.lugar}", style: boldStyle),
          SizedBox(width: 5.0),
          Text("${cartStore.store.local}", style: regularStyle),
          Expanded(child: Container()),
          Text("${cartStore.quantity}", style: mainStyle),
        ],
      ),
    );
  }
}
