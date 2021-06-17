import 'package:flutter/material.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/pages/catalogue/product_page.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key key,
    @required this.product,
    @required this.isShowRoom,
  }) : super(key: key);

  final Producto product;
  final bool isShowRoom;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle1 = textTheme.headline5.copyWith(
      color: isShowRoom ? Colors.white : CustomTheme.textColor1,
      fontWeight: FontWeight.w700,
    );
    final textStyle2 = textTheme.bodyText1.copyWith(
      color: isShowRoom ? Colors.white : CustomTheme.textColor1,
    );

    return Container(
      decoration: BoxDecoration(
        color: isShowRoom ? Colors.transparent : Colors.white,
        border: !isShowRoom ? null : Border.all(color: CustomTheme.goldColor),
        boxShadow: isShowRoom
            ? []
            : [
                BoxShadow(color: Colors.grey, blurRadius: 6.0),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(product.nombre, style: textStyle1),
            const SizedBox(height: 10.0),
            isShowRoom
                ? Container()
                : Text("Ref: ${product.referencia}", style: textStyle2),
            const SizedBox(height: 15.0),
            product.image == null
                ? Container()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: FadeInImage(
                      placeholder:
                          const AssetImage("assets/images/placeholder.png"),
                      image: NetworkImage(product.image),
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(formatMoney(product.precio), style: textStyle1),
                isShowRoom
                    ? Container()
                    : Text("Stock: ${product.stock} cajas", style: textStyle2),
              ],
            ),
            const SizedBox(height: 15.0),
            _ProductButton(
              mainColor:
                  isShowRoom ? Colors.white : Theme.of(context).primaryColor,
              secondColor: isShowRoom
                  ? Theme.of(context).textTheme.bodyText1.color
                  : Colors.white,
              icon: Icons.remove_red_eye_outlined,
              label: 'Ver Producto',
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ProductPage.route,
                  arguments: ProductPageArgs(
                    product.idProducto,
                    product.catalogo,
                  ),
                );
              },
            ),
            const SizedBox(height: 15.0),
            _ProductButton(
              mainColor: isShowRoom
                  ? CustomTheme.goldColor
                  : Theme.of(context).primaryColor,
              secondColor: isShowRoom
                  ? Theme.of(context).textTheme.bodyText1.color
                  : Colors.white,
              icon: Icons.shopping_bag_outlined,
              label: 'Añadir al Pedido',
              onPressed: () => openStartOrderModal(
                context,
                onContinue: () => openAddProductModal(context, product),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductButton extends StatelessWidget {
  const _ProductButton({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.onPressed,
    @required this.mainColor,
    @required this.secondColor,
  }) : super(key: key);

  final Function onPressed;
  final String label;
  final IconData icon;
  final Color mainColor;
  final Color secondColor;

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
              color: mainColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(15.0),
            child: Icon(icon, color: secondColor),
          ),
          Text(label),
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Icon(icon, color: Colors.transparent),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.only(left: 0.0, right: 10.0),
        side: BorderSide(
          color: mainColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: mainColor,
      ),
    );
  }
}
