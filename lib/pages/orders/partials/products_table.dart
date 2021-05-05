import 'package:flutter/material.dart';
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/theme/theme.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({
    Key key,
    @required this.products,
  }) : super(key: key);

  final List<OrderProduct> products;

  @override
  Widget build(BuildContext context) {
    List<TableRow> rows = [];

    rows.add(TableRow(
      children: [
        _HeaderField(label: "Referencia"),
        _HeaderField(label: "Tienda"),
      ],
    ));

    products.asMap().forEach((int index, OrderProduct product) {
      rows.add(TableRow(
        children: [
          _TableField(field: product.reference, index: index),
          _TableField(field: product.place, index: index),
        ],
      ));
    });

    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: CustomTheme.greyColor,
          width: 1.0,
        ),
      ),
      children: rows,
    );
  }
}

class _TableField extends StatelessWidget {
  const _TableField({
    Key key,
    @required this.field,
    @required this.index,
  }) : super(key: key);

  final String field;
  final int index;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.textColor1,
        );
    return Container(
      color: index % 2 == 0 ? Colors.grey[100] : Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 30.0,
      ),
      child: Row(
        children: [
          Text(field, style: textStyle),
        ],
      ),
    );
  }
}

class _HeaderField extends StatelessWidget {
  const _HeaderField({
    Key key,
    @required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w700,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: textStyle),
          _TableHeaderIcon(),
        ],
      ),
    );
  }
}

class _TableHeaderIcon extends StatelessWidget {
  const _TableHeaderIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.0,
      child: Stack(
        children: [
          Icon(
            Icons.keyboard_arrow_up,
            size: 18.0,
            color: CustomTheme.textColor1,
          ),
          Align(
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 18.0,
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}
