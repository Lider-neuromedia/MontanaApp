import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/pqrs/create_pqrs_page.dart';
import 'package:montana_mobile/pages/pqrs/partials/pqrs_card.dart';
import 'package:montana_mobile/pages/pqrs/partials/pqrs_filter.dart';
import 'package:montana_mobile/providers/pqrs_provider.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';
import 'package:montana_mobile/widgets/search_box.dart';
import 'package:provider/provider.dart';

class PqrsPage extends StatefulWidget {
  @override
  _PqrsPageState createState() => _PqrsPageState();
}

class _PqrsPageState extends State<PqrsPage> {
  @override
  void initState() {
    super.initState();
    () async {
      await Future.delayed(Duration.zero);

      final pqrsProvider = Provider.of<PqrsProvider>(context, listen: false);
      pqrsProvider.loadTickets();
    }();
  }

  @override
  Widget build(BuildContext context) {
    final pqrsProvider = Provider.of<PqrsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const ScaffoldLogo(),
        actions: [
          const _PageTitle(),
          const SizedBox(width: 10.0),
        ],
      ),
      floatingActionButton: _CreatePqrsButton(),
      body: pqrsProvider.isLoadingTickets
          ? const LoadingContainer()
          : pqrsProvider.tickets.length == 0
              ? EmptyMessage(
                  onPressed: () => pqrsProvider.loadTickets(),
                  message: 'No hay PQRS.',
                )
              : RefreshIndicator(
                  onRefresh: () => pqrsProvider.loadTickets(),
                  color: Theme.of(context).primaryColor,
                  child: _PqrsContent(),
                ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Colors.white,
        );

    return TextButton(
      onPressed: null,
      child: Text('Listado de PQRS', style: titleStyle),
      style: TextButton.styleFrom(
        primary: Colors.white,
      ),
    );
  }
}

class _CreatePqrsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(CreatePqrsPage.route);
      },
    );
  }
}

class _PqrsContent extends StatelessWidget {
  const _PqrsContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pqrsProvider = Provider.of<PqrsProvider>(context);
    final tickets = pqrsProvider.search.isEmpty
        ? pqrsProvider.tickets
        : pqrsProvider.searchTickets;

    return Column(
      children: [
        SearchBox(
          value: pqrsProvider.search,
          onChanged: (String value) {
            pqrsProvider.search = value;
          },
        ),
        PqrsFilter(),
        pqrsProvider.isSearchActive
            ? const Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('No hay coincidencias.'),
                ),
              )
            : Container(),
        Expanded(
          child: ListView.separated(
            itemCount: tickets.length,
            padding: const EdgeInsets.only(top: 15.0, bottom: 100.0),
            itemBuilder: (_, int index) {
              return PqrsCard(ticket: tickets[index]);
            },
            separatorBuilder: (_, int index) {
              return const SizedBox(height: 20.0);
            },
          ),
        ),
      ],
    );
  }
}
