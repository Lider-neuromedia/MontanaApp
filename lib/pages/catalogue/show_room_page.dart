import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/catalogue/partials/product_item.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/show_room_provider.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

class ShowRoomPage extends StatefulWidget {
  @override
  _ShowRoomPageState createState() => _ShowRoomPageState();
}

class _ShowRoomPageState extends State<ShowRoomPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      final showRoomProvider =
          Provider.of<ShowRoomProvider>(context, listen: false);
      final connectionProvider =
          Provider.of<ConnectionProvider>(context, listen: false);

      showRoomProvider.loadShowRoomProducts(
        local: connectionProvider.isNotConnected,
      );
    }();
  }

  @override
  Widget build(BuildContext context) {
    final showRoomProvider = Provider.of<ShowRoomProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const ScaffoldLogo(),
        actions: [
          const CartIcon(),
        ],
      ),
      backgroundColor: const Color.fromRGBO(45, 45, 45, 1.0),
      body: showRoomProvider.isLoading
          ? const LoadingContainer()
          : showRoomProvider.products.length == 0
              ? EmptyMessage(
                  message: "No hay productos disponibles en ShowRoom.",
                  onPressed: () => showRoomProvider.loadShowRoomProducts(
                    local: connectionProvider.isNotConnected,
                  ),
                )
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  child: _ProductsList(products: showRoomProvider.products),
                  onRefresh: () => showRoomProvider.loadShowRoomProducts(
                    local: connectionProvider.isNotConnected,
                  ),
                ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList({
    Key key,
    @required this.products,
  }) : super(key: key);

  final List<Producto> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      separatorBuilder: (_, i) => const SizedBox(height: 30.0),
      itemCount: products.length,
      itemBuilder: (_, i) {
        if (i == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              BannerShowRoom(),
              ProductItem(
                product: products[i],
                isShowRoom: true,
              ),
            ],
          );
        }
        return ProductItem(
          product: products[i],
          isShowRoom: true,
        );
      },
    );
  }
}

class BannerShowRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Image(
        image: const AssetImage("assets/images/show_room.png"),
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }
}
