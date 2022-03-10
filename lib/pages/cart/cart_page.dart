import 'package:flutter/material.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/providers/client_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttericon/maki_icons.dart';
import 'package:montana_mobile/pages/cart/checkout_modal.dart';
import 'package:montana_mobile/pages/catalogue/partials/action_button.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:montana_mobile/widgets/image_widget.dart';

class CartPage extends StatelessWidget {
  static final String route = "cart";

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Bolsa de Compras"),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartProvider.cart.products.length == 0
                ? const _EmptyCartMessage()
                : ListView.separated(
                    itemCount: cartProvider.cart.products.length,
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (_, int index) {
                      return _CartItem(
                          cartProduct: cartProvider.products[index]);
                    },
                    separatorBuilder: (_, int index) {
                      return const SizedBox(height: 20.0);
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

class _EmptyCartMessage extends StatelessWidget {
  const _EmptyCartMessage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Text("Bolsa de compras vacía."),
    );
  }
}

class ClientDescription extends StatelessWidget {
  const ClientDescription({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final regularStyle = Theme.of(context).textTheme.subtitle1;
    final mainStyle = Theme.of(context).textTheme.headline6.copyWith(
          fontWeight: FontWeight.w700,
        );
    final clientProvider = Provider.of<ClientProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return FutureBuilder(
      future: connectionProvider.isNotConnected
          ? clientProvider.getClientLocal(cartProvider.clientId)
          : clientProvider.getClient(cartProvider.clientId),
      builder: (_, AsyncSnapshot<Usuario> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (!snapshot.hasData) {
          return Container();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Cliente", style: regularStyle),
            Text("${snapshot.data.name}", style: mainStyle),
          ],
        );
      },
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
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: CustomTheme.greyColor,
            width: 2.0,
          ),
        ),
      ),
      child: Column(
        children: [
          ClientDescription(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Total", style: regularStyle),
              Text(formatMoney(cart.total), style: mainStyle),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ActionButton(
            label: "Limpiar",
            icon: Maki.trash,
            borderColor: CustomTheme.redColor,
            backgroundColor: Colors.grey[200],
            iconColor: CustomTheme.redColor,
            textColor: CustomTheme.redColor,
            onPressed: () => cartProvider.cleanCart(),
          ),
          ActionButton(
            label: "Finalizar el pedido",
            icon: Icons.check,
            borderColor: CustomTheme.green2Color,
            backgroundColor: CustomTheme.green2Color,
            iconColor: Colors.white,
            textColor: Colors.white,
            onPressed: cartProvider.canFinalize
                ? () => openFinalizeOrder(context)
                : null,
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
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          topRight: const Radius.circular(30.0),
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
    return Stack(
      children: [
        InkWell(
          onTap: () => openAddProductModal(context, cartProduct.product),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
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
        ),
        Positioned(
          top: 0.0,
          right: -8.0,
          child: ElevatedButton(
            onPressed: () {
              final cartProvider =
                  Provider.of<CartProvider>(context, listen: false);
              cartProvider.removeCompleteProduct(cartProduct);
            },
            child: Icon(Icons.clear, size: 18.0),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              fixedSize: const Size(30.0, 30.0),
              padding: EdgeInsets.all(0.0),
              shape: CircleBorder(),
              elevation: 0.0,
            ),
          ),
        ),
      ],
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
        cartProduct.product.image.isNotEmpty
            ? Container(
                child: ImageWidget(
                  imageUrl: cartProduct.product.image,
                  fit: BoxFit.cover,
                ),
                height: 60,
                width: 60,
              )
            : Container(),
        const SizedBox(width: 25.0),
        Text(
          "Ref: ${cartProduct.product.referencia}",
          style: titleStyle,
        ),
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
    final local = cartStore.store.local != null ? cartStore.store.local : "";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Text("${cartStore.store.lugar}", style: boldStyle),
          const SizedBox(width: 5.0),
          Text("$local", style: regularStyle),
          Expanded(child: Container()),
          Text("${cartStore.quantity}", style: mainStyle),
        ],
      ),
    );
  }
}
