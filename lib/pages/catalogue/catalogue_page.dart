import 'package:flutter/material.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/pages/catalogue/catalogue_item.dart';

class CataloguePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Catalogue> catalogues = catalogueListTest();

    return Scaffold(
      appBar: AppBar(
        title: Text('Catalogo'),
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
