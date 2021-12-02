import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                  onPressed: () => showRoomProvider.loadShowRoomProducts(
                    local: connectionProvider.isNotConnected,
                  ),
                  message: 'No hay productos disponibles en ShowRoom.',
                )
              : RefreshIndicator(
                  onRefresh: () => showRoomProvider.loadShowRoomProducts(
                    local: connectionProvider.isNotConnected,
                  ),
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
    final showRoomProvider = Provider.of<ShowRoomProvider>(context);

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: showRoomProvider.products.length,
      itemBuilder: (_, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              BannerShowRoom(),
              ProductItem(
                product: showRoomProvider.products[index],
                isShowRoom: true,
              ),
            ],
          );
        }
        return ProductItem(
          product: showRoomProvider.products[index],
          isShowRoom: true,
        );
      },
      separatorBuilder: (_, index) {
        return const SizedBox(height: 30.0);
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
