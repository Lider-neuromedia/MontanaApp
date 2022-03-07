import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/client/partials/store_card.dart';
import 'package:montana_mobile/pages/stores/store_form_page.dart';
import 'package:montana_mobile/providers/stores_provider.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';
import 'package:montana_mobile/widgets/search_box.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({Key key}) : super(key: key);

  @override
  _StoresPageState createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);
      final storesProvider =
          Provider.of<StoresProvider>(context, listen: false);
      final connectionProvider =
          Provider.of<ConnectionProvider>(context, listen: false);
      storesProvider.loadStores(local: connectionProvider.isNotConnected);
    }();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Colors.white,
        );
    final storesProvider = Provider.of<StoresProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const ScaffoldLogo(),
        actions: [
          TextButton(
            onPressed: null,
            child: Text("Listado de Tiendas", style: titleStyle),
            style: TextButton.styleFrom(primary: Colors.white),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      floatingActionButton: _CreateStoreButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(StoreFormPage.route)
              .then((_) => storesProvider.loadStores(
                    local: connectionProvider.isNotConnected,
                  ));
        },
      ),
      body: storesProvider.isLoading
          ? const LoadingContainer()
          : storesProvider.stores.length == 0
              ? EmptyMessage(
                  onPressed: () => storesProvider.loadStores(
                    local: connectionProvider.isNotConnected,
                  ),
                  message: "No hay tiendas encontradas.",
                )
              : RefreshIndicator(
                  onRefresh: () => storesProvider.loadStores(
                    local: connectionProvider.isNotConnected,
                  ),
                  color: Theme.of(context).primaryColor,
                  child: _StoresContent(),
                ),
    );
  }
}

class _CreateStoreButton extends StatelessWidget {
  const _CreateStoreButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add),
      onPressed: onPressed,
    );
  }
}

class _StoresContent extends StatelessWidget {
  const _StoresContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storesProvider = Provider.of<StoresProvider>(context);

    return Column(
      children: [
        SearchBox(
          value: storesProvider.search,
          onChanged: (String value) {
            storesProvider.search = value;
          },
        ),
        storesProvider.isSearchActive
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("No hay coincidencias."),
                ),
              )
            : Container(),
        storesProvider.search.isEmpty
            ? _StoresListResults(stores: storesProvider.stores)
            : _StoresListResults(stores: storesProvider.searchStores),
      ],
    );
  }
}

class _StoresListResults extends StatelessWidget {
  const _StoresListResults({
    Key key,
    @required this.stores,
  }) : super(key: key);

  final List<Tienda> stores;

  @override
  Widget build(BuildContext context) {
    final storesProvider = Provider.of<StoresProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return Expanded(
      child: ListView.separated(
        itemCount: stores.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (_, int index) {
          final store = stores[index];

          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            key: ValueKey<int>(store.idTiendas),
            secondaryActions: <Widget>[
              IconSlideAction(
                color: CustomTheme.mainColor,
                icon: FontAwesome.pencil,
                onTap: () => Navigator.of(context)
                    .pushNamed(StoreFormPage.route, arguments: store)
                    .then((_) => storesProvider.loadStores(
                          local: connectionProvider.isNotConnected,
                        )),
              ),
              IconSlideAction(
                color: CustomTheme.mainColor,
                icon: FontAwesome5.trash_alt,
                onTap: () async {
                  final isSuccess = await storesProvider.makeDeleteStore(
                    store.idTiendas,
                    local: connectionProvider.isNotConnected,
                  );

                  if (!isSuccess) {
                    showMessageDialog(
                        context, "Aviso", "La tienda no pudo ser borrada.");
                  }
                },
              ),
            ],
            child: Container(
              width: double.infinity,
              child: StoreCard(
                index: index + 1,
                store: store,
              ),
            ),
          );
        },
        separatorBuilder: (_, int index) {
          return const SizedBox(height: 5.0);
        },
      ),
    );
  }
}
