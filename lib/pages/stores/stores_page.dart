import 'package:flutter/material.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/client/partials/store_card.dart';
import 'package:montana_mobile/providers/stores_provider.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';
import 'package:montana_mobile/widgets/search_box.dart';
import 'package:provider/provider.dart';

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
      final storesProvider = Provider.of<StoresProvider>(
        context,
        listen: false,
      );
      storesProvider.loadStores();
    }();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Colors.white,
        );
    final storesProvider = Provider.of<StoresProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const ScaffoldLogo(),
        actions: [
          TextButton(
            onPressed: null,
            child: Text('Listado de Tiendas', style: titleStyle),
            style: TextButton.styleFrom(primary: Colors.white),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: storesProvider.isLoading
          ? const LoadingContainer()
          : storesProvider.stores.length == 0
              ? EmptyMessage(
                  onPressed: () => storesProvider.loadStores(),
                  message: 'No hay tiendas encontradas.',
                )
              : RefreshIndicator(
                  onRefresh: () => storesProvider.loadStores(),
                  color: Theme.of(context).primaryColor,
                  child: _StoresContent(),
                ),
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
                  child: Text('No hay coincidencias.'),
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
    return Expanded(
      child: ListView.separated(
        itemCount: stores.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (_, int index) {
          return StoreCard(
            index: index + 1,
            store: stores[index],
          );
        },
        separatorBuilder: (_, int index) {
          return const SizedBox(height: 5.0);
        },
      ),
    );
  }
}
