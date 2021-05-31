import 'package:flutter/material.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/pages/catalogue/partials/action_button.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:provider/provider.dart';

class AddProductModal extends StatefulWidget {
  const AddProductModal({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Producto product;

  @override
  _AddProductModalState createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  CartProvider _cartProvider;
  List<Tienda> _stores = [];
  bool _loading = false;

  int get totalAddStock => _stores.length > 0
      ? _stores.map((store) => store.stock).reduce((a, b) => a + b)
      : 0;

  int get availableStock {
    int productStock = _cartProvider != null
        ? _cartProvider.cart.getProductStock(widget.product.idProducto)
        : 0;
    return widget.product.stock - (totalAddStock + productStock);
  }

  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);
      _cartProvider = Provider.of<CartProvider>(context, listen: false);
      setState(() => _loading = true);

      final stores = await _cartProvider.getStores(_cartProvider.clientId);

      setState(() {
        _stores = stores;
        _loading = false;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<Widget> storesList = [
      const _LabelField(label: 'REFERENCIA'),
      const SizedBox(height: 5.0),
      _BoxField(
        child: _ValueField(value: widget.product.referencia),
      ),
      const SizedBox(height: 15.0),
      const _LabelField(label: 'STOCK DISPONIBLE'),
      const SizedBox(height: 5.0),
      _BoxField(
        child: _ValueField(value: "$availableStock"),
      ),
      const SizedBox(height: 15.0),
      const _LabelField(label: 'TIENDAS'),
    ];

    _stores.asMap().forEach((int index, store) {
      storesList.add(const SizedBox(height: 15.0));
      storesList.add(_BoxField(
        child: _ProductStoreStock(
          store: store,
          onChangeStock: (int stock) {
            setState(() => store.stock = stock);
          },
        ),
      ));
    });

    storesList.add(const SizedBox(height: 25.0));

    return Container(
      height: size.height * 0.85,
      color: Colors.white,
      child: _loading
          ? const LoadingContainer()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: storesList,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 25.0,
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ActionButton(
                        label: "Añadir al pedido",
                        icon: Icons.add,
                        borderColor: CustomTheme.green2Color,
                        backgroundColor: CustomTheme.green2Color,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        onPressed: totalAddStock > 0 && availableStock >= 0
                            ? () => _addProduct(context, _cartProvider)
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
                ),
              ],
            ),
    );
  }

  void _addProduct(BuildContext context, CartProvider cartProvider) {
    _stores.asMap().forEach((int index, Tienda store) {
      if (store.stock > 0) {
        cartProvider.addProduct(widget.product, store, store.stock);
      }
    });

    Navigator.pop(context);
  }
}

class _ProductStoreStock extends StatelessWidget {
  const _ProductStoreStock({
    Key key,
    @required this.store,
    @required this.onChangeStock,
  }) : super(key: key);

  final Tienda store;
  final Function(int) onChangeStock;

  @override
  Widget build(BuildContext context) {
    final regularStyle = Theme.of(context).textTheme.bodyText1;
    final boldStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.bold,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${store.lugar}", style: boldStyle),
            Text("${store.local}", style: regularStyle),
          ],
        ),
        Expanded(child: Container()),
        _StockButton(
          icon: Icons.remove,
          onPressed:
              store.stock > 0 ? () => onChangeStock(store.stock - 1) : null,
        ),
        _BoxField(
          child: Text("${store.stock}", style: regularStyle),
        ),
        _StockButton(
          icon: Icons.add,
          onPressed: () => onChangeStock(store.stock + 1),
        ),
      ],
    );
  }
}

class _StockButton extends StatelessWidget {
  const _StockButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(icon, size: 20.0),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(3.0),
        minimumSize: const Size(0, 0),
      ),
    );
  }
}

class _LabelField extends StatelessWidget {
  const _LabelField({
    Key key,
    @required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Theme.of(context).primaryColor,
        );
    return Text(label, style: labelStyle);
  }
}

class _ValueField extends StatelessWidget {
  const _ValueField({
    Key key,
    @required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.textColor1,
        );
    return Text(value, style: valueStyle);
  }
}

class _BoxField extends StatelessWidget {
  const _BoxField({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: CustomTheme.greyColor,
          width: 1.0,
        ),
      ),
    );
  }
}
