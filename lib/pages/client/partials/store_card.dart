import 'package:flutter/material.dart';
import 'package:montana_mobile/models/store.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({
    Key key,
    @required this.store,
    @required this.index,
  }) : super(key: key);

  final Tienda store;
  final int index;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w900,
        );
    final subtitleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );
    final textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w400,
        );

    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${store.nombre} - ${store.local == null ? '' : store.local}",
                style: titleStyle),
            Text("Tienda No. $index", style: textStyle),
            const SizedBox(height: 10.0),
            Text("${store.lugar}", style: subtitleStyle),
            store.direccion == null
                ? Container()
                : Text("${store.direccion}", style: textStyle),
          ],
        ),
      ),
    );
  }
}
