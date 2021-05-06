import 'package:flutter/material.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/pages/catalogue/partials/catalogue_item.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';

class CataloguePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Catalogue> catalogues = catalogueListTest();

    return Scaffold(
      appBar: AppBar(
        title: Text('Catalogo'),
        actions: [
          CartIcon(),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20.0),
        itemCount: catalogues.length,
        itemBuilder: (_, index) {
          return CatalogueItem(
            catalogue: catalogues[index],
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 30.0);
        },
      ),
    );
  }
}
