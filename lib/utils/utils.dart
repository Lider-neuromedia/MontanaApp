import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        title: Text('Aviso'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text("$message"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("$title"),
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
