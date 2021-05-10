import 'package:flutter/material.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/pages/catalogue/partials/product_item.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';

class ShowRoomPage extends StatelessWidget {
  static final String route = 'show-room';
  @override
  Widget build(BuildContext context) {
    List<Product> products = productsListTest();

    return Scaffold(
      appBar: AppBar(
        title: ScaffoldLogo(),
        actions: [
          CartIcon(),
        ],
      ),
      backgroundColor: Color.fromRGBO(45, 45, 45, 1.0),
      body: ListView.separated(
        padding: EdgeInsets.all(20.0),
        itemCount: products.length,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                BannerShowRoom(),
                ProductItem(
                  product: products[index],
                  isShowRoom: true,
                ),
              ],
            );
          }
          return ProductItem(
            product: products[index],
            isShowRoom: true,
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 30.0);
        },
      ),
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
