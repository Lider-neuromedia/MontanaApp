import 'dart:async';
import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/sync/sync_order_item.dart';
import 'package:montana_mobile/pages/sync/sync_quota_item.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/quota_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/preferences.dart';
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
    final quotaProvider = Provider.of<QuotaProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    final canSyncNow = connectionProvider.isConnected &&
        !connectionProvider.isSyncing &&
        preferences.token != null &&
        preferences.canSync;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sincronización"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LastSyncTimer(onTime: () => setState(() {})),
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
              const SizedBox(height: 15.0),
              connectionProvider.isSyncing
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const LoadingContainer(),
                          const SizedBox(height: 10.0),
                          const Center(child: Text("Sincronizando...")),
                        ],
                      ),
                    )
                  : Container(),
              const SizedBox(height: 10.0),
              const Center(child: Text("Pedidos por sincronizar")),
              const SizedBox(height: 10.0),
              FutureBuilder<List<Cart>>(
                initialData: [],
                future: cartProvider.getOfflineOrders(),
                builder: (_, AsyncSnapshot<List<Cart>> snapshot) {
                  final isEmpty = snapshot.hasData && snapshot.data.isEmpty;
                  return !snapshot.hasData || isEmpty
                      ? const Center(child: Text("0"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, int i) => SyncOrderItem(
                            cart: snapshot.data[i],
                            onDelete: connectionProvider.isNotSyncing
                                ? () => cartProvider.deleteLocalOrder(i)
                                : null,
                          ),
                        );
                },
              ),
              const SizedBox(height: 15.0),
              const Center(child: Text("Ampliación de cupos por sincronizar")),
              const SizedBox(height: 10.0),
              FutureBuilder<List<QuotaRequest>>(
                initialData: [],
                future: quotaProvider.getOfflineQuotas(),
                builder: (_, AsyncSnapshot<List<QuotaRequest>> snapshot) {
                  final isEmpty = snapshot.hasData && snapshot.data.isEmpty;
                  return !snapshot.hasData || isEmpty
                      ? const Center(child: Text("0"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, int i) => SyncQuotaItem(
                            quota: snapshot.data[i],
                            onDelete: connectionProvider.isNotSyncing
                                ? () => quotaProvider.deleteLocalQuota(i)
                                : null,
                          ),
                        );
                },
              ),
            ],
          ),
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
  int _toSync = 0; // Segundos para sincronizar
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(microseconds: 1000), (timer) {
      setState(() {
        final now = DateTime.now();
        _toSync = (now.difference(preferences.lastSync).inSeconds - 60) * -1;

        if (_toSync == 0) {
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
    final message = "Puede sincronizar dentro de $_toSync segundos";
    return connectionProvider.isSyncing || preferences.canSync
        ? Container()
        : Container(
            child: Center(
              child: Text(message),
            ),
          );
  }
}
