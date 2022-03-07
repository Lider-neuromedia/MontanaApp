import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/order_product.dart';
import 'package:montana_mobile/providers/orders_provider.dart';
import 'package:montana_mobile/theme/theme.dart';

class ProductsTable extends StatefulWidget {
  ProductsTable({
    Key key,
    @required this.products,
  }) : super(key: key);

  final List<PedidoProducto> products;

  @override
  _ProductsTableState createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsTable> {
  bool referenceDesc = true;
  bool placeDesc = true;

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final List<TableRow> rows = [];

    rows.add(TableRow(
      children: [
        _HeaderField(
          onTap: () {
            referenceDesc = !referenceDesc;
            ordersProvider.sortOrderProductsBy("reference", referenceDesc);
          },
          label: "Referencia",
        ),
        _HeaderField(
          onTap: () {
            placeDesc = !placeDesc;
            ordersProvider.sortOrderProductsBy("place", placeDesc);
          },
          label: "Tienda",
        ),
      ],
    ));

    widget.products.asMap().forEach((int index, PedidoProducto product) {
      rows.add(TableRow(
        children: [
          _TableField(field: product.referencia, index: index),
          _TableField(field: product.lugar, index: index),
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
    @required this.onTap,
  }) : super(key: key);

  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.w700,
        );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label, style: textStyle),
            Icon(
              Icons.unfold_more,
              color: CustomTheme.textColor1,
            ),
          ],
        ),
      ),
    );
  }
}
