import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/catalogue_item.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/providers/catalogues_provider.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:provider/provider.dart';

class CataloguePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CataloguesProvider cataloguesProvider =
        Provider.of<CataloguesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo'),
        actions: [
          CartIcon(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => cataloguesProvider.loadCatalogues(),
        color: Theme.of(context).primaryColor,
        child: cataloguesProvider.isLoading
            ? const LoadingContainer()
            : cataloguesProvider.catalogues.length == 0
                ? EmptyMessage(
                    onPressed: () => cataloguesProvider.loadCatalogues(),
                    message: 'No hay catálogos disponibles.',
                  )
                : const _CataloguesList(),
      ),
    );
  }
}

class _CataloguesList extends StatelessWidget {
  const _CataloguesList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CataloguesProvider cataloguesProvider =
        Provider.of<CataloguesProvider>(context);

    return ListView.separated(
      padding: EdgeInsets.all(20.0),
      itemCount: cataloguesProvider.catalogues.length,
      itemBuilder: (_, index) {
        return CatalogueItem(
          catalogue: cataloguesProvider.catalogues[index],
        );
      },
      separatorBuilder: (_, index) {
        return SizedBox(height: 30.0);
      },
    );
  }
}
