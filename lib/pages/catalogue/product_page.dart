import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/pages/catalogue/add_product_modal.dart';
import 'package:montana_mobile/pages/catalogue/partials/comments.dart';
import 'package:montana_mobile/pages/catalogue/partials/ratings.dart';
import 'package:montana_mobile/pages/catalogue/partials/section_card.dart';
import 'package:montana_mobile/pages/catalogue/start_order_modal.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';

class ProductPage extends StatelessWidget {
  static final String route = 'product';

  @override
  Widget build(BuildContext context) {
    Producto product; // = productTest();

    return Scaffold(
      backgroundColor: CustomTheme.grey3Color,
      appBar: AppBar(
        title: Text('Detalle de Producto'),
        actions: [
          CartIcon(),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  _GalleryProduct(product: product),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    color: Colors.grey,
                    width: double.infinity,
                    height: 1.0,
                  ),
                  _ProductTitle(product: product),
                  SizedBox(height: 20.0),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10.0),
                        Text(
                          product.descripcion,
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Ratings(),
                  SizedBox(height: 20.0),
                  Comments(),
                  SizedBox(height: 120.0),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10.0),
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Añadir al pedido'),
                onPressed: () => openStartOrder(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: CustomTheme.green2Color,
                ),
              ),
            ),
          ),
        ],
      ),
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

class _ProductTitle extends StatelessWidget {
  const _ProductTitle({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Producto product;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.w700,
        );
    final TextStyle totalStyle = Theme.of(context).textTheme.headline5.copyWith(
          fontWeight: FontWeight.w900,
        );
    final TextStyle priceStyle = Theme.of(context).textTheme.subtitle1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            product.nombre,
            style: titleStyle,
            softWrap: true,
          ),
        ),
        SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatMoney(product.total), style: totalStyle),
            Text(formatMoney(product.precio), style: priceStyle),
          ],
        ),
      ],
    );
  }
}

class _GalleryProduct extends StatelessWidget {
  const _GalleryProduct({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Producto product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: FadeInImage(
                placeholder: AssetImage("assets/images/placeholder.png"),
                image: NetworkImage(product.image),
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          product.imagenes.length == 0
              ? Container()
              : Container(
                  height: 50.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: product.imagenes.length,
                    itemBuilder: (_, int index) {
                      return Container(
                        child: InkWell(
                          onTap: () {
                            print(product.imagenes[index].image);
                          },
                          child: FadeInImage(
                            placeholder:
                                AssetImage("assets/images/placeholder.png"),
                            image: NetworkImage(product.imagenes[index].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, int index) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          color: CustomTheme.greyColor,
                          height: 25.0,
                          width: 1.0,
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
