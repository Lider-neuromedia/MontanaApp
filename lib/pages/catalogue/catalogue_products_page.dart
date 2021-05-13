import 'package:flutter/material.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/pages/catalogue/partials/product_item.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';

class CatalogueProductsPage extends StatelessWidget {
  static final String route = 'catalogue-products';

  @override
  Widget build(BuildContext context) {
    final ProductsScreenArguments args =
        ModalRoute.of(context).settings.arguments as ProductsScreenArguments;

    Catalogo catalogue = args.catalogue;
    List<Product> products = productsListTest();

    return Scaffold(
      appBar: AppBar(
        title: Text(catalogue.titulo),
        actions: [
          CartIcon(),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20.0),
        itemCount: products.length,
        itemBuilder: (_, index) {
          return ProductItem(
            product: products[index],
            isShowRoom: false,
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 30.0);
        },
      ),
    );
  }
}

class ProductsScreenArguments {
  final Catalogo catalogue;
  final bool showRoom;

  ProductsScreenArguments(
    this.catalogue,
    this.showRoom,
  );
}
