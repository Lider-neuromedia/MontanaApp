import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/catalogue/partials/product_item.dart';
import 'package:montana_mobile/providers/products_provider.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';
import 'package:provider/provider.dart';

class ShowRoomPage extends StatelessWidget {
  static final String route = 'show-room';

  @override
  Widget build(BuildContext context) {
    final ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: ScaffoldLogo(),
        actions: [
          CartIcon(),
        ],
      ),
      backgroundColor: Color.fromRGBO(45, 45, 45, 1.0),
      body: productsProvider.isLoadingShowRoom
          ? const LoadingContainer()
          : productsProvider.showRoomProducts.length == 0
              ? EmptyMessage(
                  onPressed: () => productsProvider.loadShowRoomProducts(),
                  message: 'No hay productos disponibles en ShowRoom.',
                )
              : RefreshIndicator(
                  onRefresh: () => productsProvider.loadShowRoomProducts(),
                  color: Theme.of(context).primaryColor,
                  child: _ProductsList(),
                ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context);

    return ListView.separated(
      padding: EdgeInsets.all(20.0),
      itemCount: productsProvider.showRoomProducts.length,
      itemBuilder: (_, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              BannerShowRoom(),
              ProductItem(
                product: productsProvider.showRoomProducts[index],
                isShowRoom: true,
              ),
            ],
          );
        }
        return ProductItem(
          product: productsProvider.showRoomProducts[index],
          isShowRoom: true,
        );
      },
      separatorBuilder: (_, index) {
        return SizedBox(height: 30.0);
      },
    );
  }
}

class BannerShowRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Image(
        image: AssetImage("assets/images/show_room.png"),
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }
}
