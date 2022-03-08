import 'package:flutter/material.dart';
import 'package:montana_mobile/models/product.dart';
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
  static final String route = "catalogue-products";

  @override
  _CatalogueProductsPageState createState() => _CatalogueProductsPageState();
}

class _CatalogueProductsPageState extends State<CatalogueProductsPage> {
  ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;

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

    productsProvider.loadProducts(
      catalogue.id,
      local: connectionProvider.isNotConnected,
      refresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as ProductsScreenArguments;
    final catalogue = args.catalogue;
    final productsProvider = Provider.of<ProductsProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final products = productsProvider.products;
    final loadFromLocal = connectionProvider.isNotConnected;

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!productsProvider.isLoading &&
            productsProvider.pagination.isEndNotReached()) {
          productsProvider.loadProducts(catalogue.id, local: loadFromLocal);
        }
      }

      if (_scrollController.position.pixels > 1000 && !_showScrollButton) {
        setState(() => _showScrollButton = true);
      }
      if (_scrollController.position.pixels <= 1000 && _showScrollButton) {
        setState(() => _showScrollButton = false);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(catalogue.titulo),
        elevation: 0.0,
        actions: [const CartIcon()],
      ),
      floatingActionButton: _showScrollButton
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.arrow_upward),
              mini: true,
              onPressed: () => _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
              ),
            )
          : null,
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () => productsProvider.loadProducts(
          catalogue.id,
          refresh: true,
          local: loadFromLocal,
        ),
        child: Column(
          children: [
            SearchBox(
              value: productsProvider.search,
              onChanged: (String value) {
                if (value != productsProvider.search) {
                  productsProvider.search = value;

                  if (!productsProvider.isLoading) {}
                  productsProvider.loadProducts(
                    catalogue.id,
                    refresh: true,
                    local: loadFromLocal,
                  );
                }
              },
            ),
            products.isEmpty && productsProvider.search.isNotEmpty
                ? _EmptySearchMessage()
                : Container(),
            !productsProvider.isLoading &&
                    productsProvider.search.isEmpty &&
                    products.isEmpty
                ? EmptyMessage(
                    message: "No hay productos disponibles en este catálogo.",
                    onPressed: () => productsProvider.loadProducts(
                      catalogue.id,
                      refresh: true,
                      local: loadFromLocal,
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20.0),
                      itemCount: products.length,
                      separatorBuilder: (_, i) => const SizedBox(height: 30.0),
                      itemBuilder: (_, i) => ProductItem(
                        product: products[i],
                        isShowRoom: false,
                      ),
                    ),
                  ),
            productsProvider.isLoading && products.isNotEmpty
                ? _BottomLoading()
                : Container()
          ],
        ),
      ),
    );
  }
}

class _EmptySearchMessage extends StatelessWidget {
  const _EmptySearchMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        child: Text("No hay coincidencias."),
        padding: EdgeInsets.symmetric(vertical: 10.0),
      ),
    );
  }
}

class _BottomLoading extends StatelessWidget {
  const _BottomLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 6.0),
        ],
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: LoadingContainer(),
        ),
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
