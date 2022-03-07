import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/providers/catalogues_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/pages/catalogue/partials/catalogue_item.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';

class CataloguePage extends StatefulWidget {
  @override
  _CataloguePageState createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);
      final cataloguesProvider =
          Provider.of<CataloguesProvider>(context, listen: false);
      final connectionProvider =
          Provider.of<ConnectionProvider>(context, listen: false);

      cataloguesProvider.loadCatalogues(
          local: connectionProvider.isNotConnected);
    }();
  }

  @override
  Widget build(BuildContext context) {
    final cataloguesProvider = Provider.of<CataloguesProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Catálogo"),
        actions: [
          const CartIcon(),
        ],
      ),
      body: cataloguesProvider.isLoading
          ? const LoadingContainer()
          : cataloguesProvider.catalogues.length == 0
              ? EmptyMessage(
                  onPressed: () => cataloguesProvider.loadCatalogues(
                    local: connectionProvider.isNotConnected,
                  ),
                  message: "No hay catálogos disponibles.",
                )
              : RefreshIndicator(
                  onRefresh: () => cataloguesProvider.loadCatalogues(
                    local: connectionProvider.isNotConnected,
                  ),
                  color: Theme.of(context).primaryColor,
                  child: _CataloguesList(
                    catalogues: cataloguesProvider.catalogues,
                  ),
                ),
    );
  }
}

class _CataloguesList extends StatelessWidget {
  const _CataloguesList({
    Key key,
    @required this.catalogues,
  }) : super(key: key);

  final List<Catalogo> catalogues;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: catalogues.length,
      separatorBuilder: (_, i) => const SizedBox(height: 30.0),
      itemBuilder: (_, i) {
        return CatalogueItem(
          key: UniqueKey(),
          catalogue: catalogues[i],
        );
      },
    );
  }
}
