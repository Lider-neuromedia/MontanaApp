import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/catalogue/partials/product_item.dart';
import 'package:montana_mobile/providers/show_room_provider.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';
import 'package:provider/provider.dart';

class ShowRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ShowRoomProvider showRoomProvider =
        Provider.of<ShowRoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: ScaffoldLogo(),
        actions: [
          CartIcon(),
        ],
      ),
      backgroundColor: Color.fromRGBO(45, 45, 45, 1.0),
      body: showRoomProvider.isLoading
          ? const LoadingContainer()
          : showRoomProvider.products.length == 0
              ? EmptyMessage(
                  onPressed: () => showRoomProvider.loadShowRoomProducts(),
                  message: 'No hay productos disponibles en ShowRoom.',
                )
              : RefreshIndicator(
                  onRefresh: () => showRoomProvider.loadShowRoomProducts(),
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
    final ShowRoomProvider showRoomProvider =
        Provider.of<ShowRoomProvider>(context);

    return ListView.separated(
      padding: EdgeInsets.all(20.0),
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
