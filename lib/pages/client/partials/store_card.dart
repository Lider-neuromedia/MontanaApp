import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/add_product_modal.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({
    Key key,
    @required this.store,
    @required this.index,
  }) : super(key: key);

  final StoreStockTemporal store;
  final int index;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w900,
        );
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w400,
        );

    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${store.place} - ${store.local}", style: titleStyle),
            Text("Tienda No. $index", style: textStyle),
            SizedBox(height: 10.0),
            Text("${store.city} ${store.department}", style: textStyle),
            Text(store.address, style: textStyle),
          ],
        ),
      ),
    );
  }
}
