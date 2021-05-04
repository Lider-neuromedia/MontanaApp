import 'package:intl/intl.dart';

bool isEmailValid(email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

String formatMoney(double value) {
  return '\$' + NumberFormat('###,###,##0', 'es').format(value);
}
