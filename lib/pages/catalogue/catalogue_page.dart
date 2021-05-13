import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/catalogue_item.dart';
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
            ? const _LoadingContainer()
            : cataloguesProvider.catalogues.length == 0
                ? const _EmptyMessage()
                : const _CataloguesList(),
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 230.0,
        child: Text(
          'No hay catálogos disponibles.\nPuede arrastrar la pantalla hacia bajo para recargar.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}

class _LoadingContainer extends StatelessWidget {
  const _LoadingContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).primaryColor,
        ),
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
