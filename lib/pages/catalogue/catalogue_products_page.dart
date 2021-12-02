import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/catalogue/partials/product_item.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/widgets/search_box.dart';
import 'package:montana_mobile/providers/products_provider.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';

class CatalogueProductsPage extends StatefulWidget {
  static final String route = 'catalogue-products';

  @override
  _CatalogueProductsPageState createState() => _CatalogueProductsPageState();
}

class _CatalogueProductsPageState extends State<CatalogueProductsPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);
      _loadData(context);
    }();
  }

  void _loadData(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as ProductsScreenArguments;
    final catalogue = args.catalogue;
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    productsProvider.loadProducts(catalogue.id,
        local: connectionProvider.isNotConnected);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as ProductsScreenArguments;
    final catalogue = args.catalogue;
    final productsProvider = Provider.of<ProductsProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(catalogue.titulo),
        elevation: 0.0,
        actions: [
          const CartIcon(),
        ],
      ),
      body: productsProvider.isLoadingProducts
          ? const LoadingContainer()
          : productsProvider.products.length == 0
              ? EmptyMessage(
                  onPressed: () => productsProvider.loadProducts(
                    catalogue.id,
                    local: connectionProvider.isNotConnected,
                  ),
                  message: 'No hay productos disponibles en este catálogo.',
                )
              : RefreshIndicator(
                  onRefresh: () => productsProvider.loadProducts(
                    catalogue.id,
                    local: connectionProvider.isNotConnected,
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      SearchBox(
                        value: productsProvider.search,
                        onChanged: (String value) {
                          productsProvider.search = value;
                        },
                      ),
                      productsProvider.isSearchActive
                          ? Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text('No hay coincidencias.'),
                              ),
                            )
                          : Container(),
                      Expanded(child: _ProductsList()),
                    ],
                  ),
                ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.search.isEmpty
        ? productsProvider.products
        : productsProvider.searchProducts;

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: products.length,
      itemBuilder: (_, index) {
        return ProductItem(
          product: products[index],
          isShowRoom: false,
        );
      },
      separatorBuilder: (_, index) {
        return const SizedBox(height: 30.0);
      },
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
