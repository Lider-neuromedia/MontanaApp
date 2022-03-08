import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';
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
    final showRoomProvider =
        Provider.of<ShowRoomProvider>(context, listen: false);
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    showRoomProvider.loadShowRoomProducts(
      local: connectionProvider.isNotConnected,
      refresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final showRoomProvider = Provider.of<ShowRoomProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final products = showRoomProvider.products;
    final loadFromLocal = connectionProvider.isNotConnected;

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!showRoomProvider.isLoading &&
            showRoomProvider.pagination.isEndNotReached()) {
          showRoomProvider.loadShowRoomProducts(local: loadFromLocal);
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
        title: const ScaffoldLogo(),
        actions: [const CartIcon()],
      ),
      backgroundColor: const Color.fromRGBO(45, 45, 45, 1.0),
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
        onRefresh: () => showRoomProvider.loadShowRoomProducts(
          refresh: true,
          local: loadFromLocal,
        ),
        child: Column(
          children: [
            !showRoomProvider.isLoading && products.isEmpty
                ? EmptyMessage(
                    message: "No hay productos disponibles.",
                    hasBgDark: true,
                    onPressed: () => showRoomProvider.loadShowRoomProducts(
                      refresh: true,
                      local: loadFromLocal,
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20.0),
                      separatorBuilder: (_, i) => const SizedBox(height: 30.0),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _BannerShowRoom(),
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
                    ),
                  ),
            showRoomProvider.isLoading && products.isNotEmpty
                ? const _BottomLoading()
                : Container()
          ],
        ),
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
        color: const Color.fromRGBO(45, 45, 45, 1.0),
        boxShadow: [
          BoxShadow(color: CustomTheme.goldColor, blurRadius: 6.0),
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

class _BannerShowRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: const Image(
        image: AssetImage("assets/images/show_room.png"),
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }
}
