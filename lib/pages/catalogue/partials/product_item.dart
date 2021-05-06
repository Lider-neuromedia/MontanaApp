import 'package:flutter/material.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/pages/catalogue/add_product_modal.dart';
import 'package:montana_mobile/pages/catalogue/product_page.dart';
import 'package:montana_mobile/pages/catalogue/start_order_modal.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key key,
    this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    TextStyle textStyle1 = textTheme.headline5.copyWith(
      color: CustomTheme.textColor1,
      fontWeight: FontWeight.w700,
    );
    TextStyle textStyle2 = textTheme.bodyText1.copyWith();
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(product.name, style: textStyle1),
            SizedBox(height: 10.0),
            Text("Ref: ${product.reference}", style: textStyle2),
            SizedBox(height: 15.0),
            FadeInImage(
              placeholder: AssetImage("assets/images/placeholder.png"),
              image: NetworkImage(product.image),
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(formatMoney(product.price), style: textStyle1),
                Text("Stock: ${product.stock} cajas", style: textStyle2),
              ],
            ),
            SizedBox(height: 15.0),
            _ProductButton(
              icon: Icons.remove_red_eye_outlined,
              label: 'Ver Producto',
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ProductPage.route,
                  arguments: product,
                );
              },
            ),
            SizedBox(height: 15.0),
            _ProductButton(
              icon: Icons.shopping_bag_outlined,
              label: 'Añadir a Pedido',
              onPressed: () => onAddProduct(context),
            ),
          ],
        ),
      ),
    );
  }

  void onAddProduct(BuildContext context) {
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
            openAddProduct(context);
          },
        );
      },
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

class _ProductButton extends StatelessWidget {
  const _ProductButton({
    Key key,
    @required this.label,
    @required this.icon,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(15.0),
            child: Icon(icon, color: Colors.white),
          ),
          Text(label),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Icon(icon, color: Colors.transparent),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.only(left: 0.0, right: 10.0),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: Theme.of(context).primaryColor,
      ),
    );
  }
}
