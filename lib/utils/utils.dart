import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/pages/catalogue/add_product_modal.dart';
import 'package:montana_mobile/pages/catalogue/start_order_modal.dart';

bool isEmailValid(email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

String formatMoney(double value) {
  return '\$' + NumberFormat('###,###,##0', 'es').format(value);
}

String formatDate(DateTime date) {
  final String year = date.year.toString();
  final String month = date.month.toString().padLeft(2, '0');
  final String day = date.day.toString().padLeft(2, '0');
  return "$day / $month / $year";
}

Future<void> showMessageDialog(
    BuildContext context, String title, String message,
    {Function onAccept}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text("$message"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Aceptar"),
            onPressed: () {
              Navigator.of(context).pop();

              if (onAccept != null) {
                onAccept();
              }
            },
          ),
        ],
      );
    },
  );
}

Widget snackbar(String title, String body, {String label, Function action}) {
  return SnackBar(
    margin: const EdgeInsets.all(10.0),
    behavior: SnackBarBehavior.floating,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Text(body),
      ],
    ),
    action: action == null
        ? null
        : SnackBarAction(
            textColor: Colors.grey,
            label: label,
            onPressed: action,
          ),
  );
}

void openStartOrder(BuildContext context, {@required Function onContinue}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: const Radius.circular(30.0),
        topRight: const Radius.circular(30.0),
      ),
    ),
    builder: (_) {
      return StartOrderModal(
        showCatalogue: false,
        onPressed: () {
          Navigator.pop(context);
          onContinue();
        },
      );
    },
  );
}

void openAddProductModal(BuildContext context, Producto product) {
  showModalBottomSheet(
    context: context,
    enableDrag: false,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: const Radius.circular(30.0),
        topRight: const Radius.circular(30.0),
      ),
    ),
    builder: (_) => AddProductModal(product: product),
  );
}
