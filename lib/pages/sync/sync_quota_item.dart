import 'package:flutter/material.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/providers/client_provider.dart';
import 'package:montana_mobile/providers/quota_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class SyncQuotaItem extends StatelessWidget {
  const SyncQuotaItem({
    Key key,
    @required this.quota,
    @required this.onDelete,
  }) : super(key: key);

  final QuotaRequest quota;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle3 = textTheme.subtitle1.copyWith(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w700,
    );

    final monto = formatMoney(double.parse(quota.monto));

    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Monto: $monto", style: textStyle3),
            const SizedBox(height: 5.0),
            _ItemClientName(quota.clienteId),
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
