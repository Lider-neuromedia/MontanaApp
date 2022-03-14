import 'dart:async';
import 'package:flutter/material.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/providers/client_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({Key key}) : super(key: key);

  @override
  _SyncPageState createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    final cartProvider = Provider.of<CartProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final canSyncNow = connectionProvider.isConnected &&
        !connectionProvider.isSyncing &&
        preferences.token != null &&
        preferences.canSync;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sincronización"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: canSyncNow
                  ? const Text("Sincronizar Ahora")
                  : const Text("No puede sincronizar ahora"),
              onPressed: canSyncNow
                  ? () => ConnectionProvider.syncDataNow(context)
                  : null,
              style: ElevatedButton.styleFrom(
                primary: CustomTheme.green2Color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Center(child: Text("Pedidos esperando sincronizar")),
            SizedBox(height: 10.0),
            connectionProvider.isSyncing
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const LoadingContainer(),
                          const SizedBox(height: 10.0),
                          const Center(
                            child: Text("Sincronización en proceso"),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            SizedBox(height: 10.0),
            FutureBuilder<List<Cart>>(
              initialData: [],
              future: cartProvider.getOfflineOrders(),
              builder: (ctx, AsyncSnapshot<List<Cart>> snapshot) {
                if (!snapshot.hasData) {
                  return const Expanded(
                    child: Center(
                      child: Text("No hay pedidos por sincronizar"),
                    ),
                  );
                }

                final carts = snapshot.data;

                return Expanded(
                  child: ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (_, int i) => _OrderItem(
                      cart: carts[i],
                      onDelete: connectionProvider.isSyncing
                          ? null
                          : () => cartProvider.deleteLocalOrder(i),
                    ),
                  ),
                );
              },
            ),
            _LastSyncTimer(
              onTime: () => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastSyncTimer extends StatefulWidget {
  const _LastSyncTimer({Key key, @required this.onTime}) : super(key: key);
  final Function onTime;

  @override
  State<_LastSyncTimer> createState() => __LastSyncTimerState();
}

class __LastSyncTimerState extends State<_LastSyncTimer> {
  final preferences = Preferences();
  int _timeToSync = 0;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(microseconds: 1000), (timer) {
      setState(() {
        _timeToSync =
            (DateTime.now().difference(preferences.lastSync).inSeconds - 60) *
                -1;

        if (_timeToSync == 0) {
          widget.onTime();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return connectionProvider.isSyncing || preferences.canSync
        ? Container()
        : Container(
            child: Center(
              child: Text("Puede sincronizar dentro de $_timeToSync segundos"),
            ),
          );
  }
}

class _OrderItem extends StatelessWidget {
  const _OrderItem({
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
            Text(
              "Cantidad de productos: ${cart.products.length}",
              style: textStyle2,
            ),
            const SizedBox(height: 5.0),
            Text(
              "Unidades en total: $units",
              style: textStyle2,
            ),
            const SizedBox(height: 5.0),
            Text(
              "Método de pago: ${cart.paymentMethod}",
              style: textStyle2,
            ),
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

class _ItemClientName extends StatefulWidget {
  const _ItemClientName(this.clientId, {Key key}) : super(key: key);

  final int clientId;

  @override
  __ItemClientNameState createState() => __ItemClientNameState();
}

class __ItemClientNameState extends State<_ItemClientName> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    TextStyle textStyle2 = textTheme.subtitle1;
    final clientProvider = Provider.of<ClientProvider>(context);

    return FutureBuilder<Usuario>(
      initialData: null,
      future: clientProvider.getClientLocal(widget.clientId),
      builder: (ctx, AsyncSnapshot<Usuario> snapshot) {
        if (!snapshot.hasData) {
          return Text(
            "Cliente ID: ${widget.clientId}",
            style: textStyle2,
          );
        }

        return Text(
          "Cliente: ${snapshot.data.nombreCompleto}",
          style: textStyle2,
        );
      },
    );
  }
}
