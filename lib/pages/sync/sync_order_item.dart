import 'package:flutter/material.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/providers/client_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class SyncOrderItem extends StatelessWidget {
  const SyncOrderItem({
    Key key,
    @required this.cart,
    @required this.onDelete,
  }) : super(key: key);

  final Cart cart;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    TextStyle textStyle2 = textTheme.subtitle1;
    TextStyle textStyle3 = textTheme.subtitle1.copyWith(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w700,
    );

    final total = cart.products
        .map((x) => x.product.precio * x.totalStock)
        .reduce((a, b) => a + b);

    final units =
        cart.products.map((x) => x.totalStock).reduce((a, b) => a + b);

    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total: ${formatMoney(total)}", style: textStyle3),
            const SizedBox(height: 5.0),
            Text("# de productos: ${cart.products.length}", style: textStyle2),
            const SizedBox(height: 5.0),
            Text("Unidades en total: $units", style: textStyle2),
            const SizedBox(height: 5.0),
            Text("Método de pago: ${cart.paymentMethod}", style: textStyle2),
            const SizedBox(height: 5.0),
            _ItemClientName(cart.clientId),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: const Text("Eliminar"),
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    primary: CustomTheme.mainColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 3.0,
                      horizontal: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemClientName extends StatelessWidget {
  const _ItemClientName(this.clientId, {Key key}) : super(key: key);

  final int clientId;

  @override
  Widget build(BuildContext context) {
    final textStyle2 = Theme.of(context).textTheme.subtitle1;
    final clientProvider = Provider.of<ClientProvider>(context);

    return FutureBuilder<Usuario>(
      initialData: null,
      future: clientProvider.getClientLocal(clientId),
      builder: (ctx, AsyncSnapshot<Usuario> snapshot) {
        final name = !snapshot.hasData
            ? "Cliente ID: $clientId"
            : "Cliente: ${snapshot.data.nombreCompleto}";
        return Text(name, style: textStyle2);
      },
    );
  }
}
