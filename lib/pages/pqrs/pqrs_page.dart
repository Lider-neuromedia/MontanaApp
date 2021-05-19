import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/pqrs/create_pqrs_page.dart';
import 'package:montana_mobile/pages/pqrs/partials/pqrs_card.dart';
import 'package:montana_mobile/pages/pqrs/partials/pqrs_filter.dart';
import 'package:montana_mobile/pages/pqrs/partials/search_box.dart';
import 'package:montana_mobile/providers/pqrs_provider.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';
import 'package:provider/provider.dart';

class PqrsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PqrsProvider pqrsProvider = Provider.of<PqrsProvider>(context);
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Colors.white,
        );

    return Scaffold(
      appBar: AppBar(
        title: ScaffoldLogo(),
        actions: [
          TextButton(
            onPressed: null,
            child: Text('Listado de PQRS', style: titleStyle),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
          SizedBox(width: 10.0),
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(CreatePqrsPage.route);
        },
      ),
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

class _PqrsContent extends StatelessWidget {
  const _PqrsContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PqrsProvider pqrsProvider = Provider.of<PqrsProvider>(context);
    return Column(
      children: [
        SearchBox(),
        PqrsFilter(),
        Expanded(
          child: ListView.separated(
            itemCount: pqrsProvider.tickets.length,
            padding: EdgeInsets.only(top: 15.0, bottom: 100.0),
            itemBuilder: (_, int index) {
              return PqrsCard(ticket: pqrsProvider.tickets[index]);
            },
            separatorBuilder: (_, int index) {
              return SizedBox(height: 20.0);
            },
          ),
        ),
      ],
    );
  }
}
