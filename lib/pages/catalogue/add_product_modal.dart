import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/action_button.dart';
import 'package:montana_mobile/theme/theme.dart';

class AddProductModal extends StatelessWidget {
  final List<StoreStockTemporal> stores = [
    StoreStockTemporal(1, 'CC Único', 'L 204', 102),
    StoreStockTemporal(2, 'San Andresito', 'L 118', 102),
    StoreStockTemporal(3, 'CC Unicentro', 'L 204', 102),
    StoreStockTemporal(4, 'Granada', 'Calle 4 No. 6 - 89', 102),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<Widget> list = [
      _LabelField(label: 'REFERENCIA'),
      SizedBox(height: 5.0),
      _BoxField(
        child: _ValueField(
          value: 'KLI-39823098209',
        ),
      ),
      SizedBox(height: 20.0),
      _LabelField(label: 'TIENDAS'),
    ];

    stores.asMap().forEach((int index, storeStock) {
      list.add(SizedBox(height: 15.0));
      list.add(_BoxField(
        child: _ProductStoreStock(
          storeStock: storeStock,
        ),
      ));
    });

    list.add(SizedBox(height: 25.0));

    return Container(
      height: size.height * 0.85,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: list,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  label: "Añadir al pedido",
                  icon: Icons.add,
                  borderColor: CustomTheme.green2Color,
                  backgroundColor: CustomTheme.green2Color,
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ActionButton(
                  label: "Cancelar",
                  icon: Icons.close,
                  borderColor: CustomTheme.redColor,
                  backgroundColor: Colors.grey[200],
                  iconColor: CustomTheme.redColor,
                  textColor: CustomTheme.redColor,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StoreStockTemporal {
  StoreStockTemporal(this.id, this.place, this.local, this.stock);

  int id;
  String place;
  String local;
  int stock;
}

class _ProductStoreStock extends StatelessWidget {
  const _ProductStoreStock({
    Key key,
    this.storeStock,
  }) : super(key: key);

  final StoreStockTemporal storeStock;

  @override
  Widget build(BuildContext context) {
    final regularStyle = Theme.of(context).textTheme.bodyText1;
    final boldStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.bold,
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(storeStock.place, style: boldStyle),
            Text(storeStock.local, style: regularStyle),
          ],
        ),
        Expanded(child: Container()),
        ElevatedButton(
          child: Icon(Icons.remove, size: 20.0),
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(3.0),
            minimumSize: Size(0, 0),
          ),
          onPressed: () {},
        ),
        _BoxField(
          child: Text(
            storeStock.stock.toString(),
            style: regularStyle,
          ),
        ),
        ElevatedButton(
          child: Icon(Icons.add, size: 20.0),
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(3.0),
            minimumSize: Size(0, 0),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _LabelField extends StatelessWidget {
  const _LabelField({
    Key key,
    @required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Theme.of(context).primaryColor,
        );
    return Text(label, style: labelStyle);
  }
}

class _ValueField extends StatelessWidget {
  const _ValueField({
    Key key,
    @required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.textColor1,
        );
    return Text(value, style: valueStyle);
  }
}

class _BoxField extends StatelessWidget {
  const _BoxField({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: CustomTheme.greyColor,
          width: 1.0,
        ),
      ),
    );
  }
}
