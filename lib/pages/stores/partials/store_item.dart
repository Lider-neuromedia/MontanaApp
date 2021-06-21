import 'package:flutter/material.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/providers/store_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:provider/provider.dart';

class StoreItem extends StatelessWidget {
  const StoreItem({
    Key key,
    this.store,
    this.index,
  }) : super(key: key);

  final Tienda store;
  final int index;

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final titleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: CustomTheme.mainColor,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Código: 00${index + 1}', style: titleStyle),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Lugar:'),
                  Text(store.lugar),
                ],
              ),
              const SizedBox(height: 5.0),
              store.local == null || store.local.isEmpty
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Locald:'),
                        Text(store.local),
                      ],
                    ),
            ],
          ),
          ElevatedButton(
            onPressed: () => storeProvider.removeStore(index),
            child: Icon(Icons.delete),
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
