import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/add_product_modal.dart';
import 'package:montana_mobile/pages/client/partials/store_card.dart';
import 'package:montana_mobile/pages/dashboard/partials/buyer_card.dart';
import 'package:montana_mobile/pages/dashboard/partials/card_data.dart';
import 'package:montana_mobile/theme/theme.dart';

class ClientPage extends StatelessWidget {
  static final String route = 'client-detail';

  @override
  Widget build(BuildContext context) {
    List<StoreStockTemporal> stores = storesListTest();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cliente'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.only(bottom: 30.0),
        itemCount: stores.length,
        itemBuilder: (_, int index) {
          if (index == 0) {
            return ClientData(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 0.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30.0),
                    _StoresTitle(),
                    SizedBox(height: 20.0),
                    StoreCard(
                      store: stores[index],
                      index: index + 1,
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 0.0,
            ),
            child: StoreCard(
              store: stores[index],
              index: index + 1,
            ),
          );
        },
        separatorBuilder: (_, int index) {
          return SizedBox(height: 20.0);
        },
      ),
    );
  }
}

class _StoresTitle extends StatelessWidget {
  const _StoresTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tiendas',
        style: Theme.of(context).textTheme.headline6.copyWith(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class ClientData extends StatelessWidget {
  const ClientData({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20.0),
        BuyerCard(),
        _CardDataList(
          children: [
            CardData(
              title: 'Cupo preaprobado',
              value: '\$4.300.400',
              icon: Icons.sentiment_neutral_rounded,
              color: CustomTheme.yellowColor,
              isMain: false,
            ),
            CardData(
              title: 'Cupo disponible',
              value: '\$3.500.400',
              icon: Icons.sentiment_very_satisfied,
              color: CustomTheme.greenColor,
              isMain: false,
            ),
          ],
        ),
        _CardDataList(
          children: [
            CardData(
              title: 'Saldo total deuda',
              value: '\$4.300.400',
              icon: Icons.error_outline,
              color: CustomTheme.purpleColor,
              isMain: false,
            ),
            CardData(
              title: 'Saldo en mora',
              value: '\$3.500.400',
              icon: Icons.sentiment_dissatisfied_rounded,
              color: CustomTheme.redColor,
              isMain: false,
            ),
          ],
        ),
        child,
      ],
    );
  }
}

class _CardDataList extends StatelessWidget {
  const _CardDataList({
    Key key,
    this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    children.asMap().forEach((index, item) {
      items.add(Expanded(child: item));
      if (index < children.length - 1) {
        items.add(SizedBox(width: 15.0));
      }
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }
}
