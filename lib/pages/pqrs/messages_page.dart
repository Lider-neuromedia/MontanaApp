import 'package:flutter/material.dart';
import 'package:montana_mobile/models/ticket.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/pqrs/partials/message_card.dart';
import 'package:montana_mobile/pages/pqrs/partials/message_form.dart';
import 'package:montana_mobile/providers/pqrs_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  static final String route = '/pqrs-messages';

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);
      _loadData(context);
    }();
  }

  void _loadData(BuildContext context) {
    final ticket = ModalRoute.of(context).settings.arguments as Ticket;
    final pqrsProvider = Provider.of<PqrsProvider>(context, listen: false);
    pqrsProvider.loadTicket(ticket.idPqrs);
  }

  @override
  Widget build(BuildContext context) {
    final ticket = ModalRoute.of(context).settings.arguments as Ticket;
    final pqrsProvider = Provider.of<PqrsProvider>(context);

    return Scaffold(
      backgroundColor: CustomTheme.grey3Color,
      appBar: AppBar(
        title: Text('PQRS'),
      ),
      body: Column(
        children: [
          Expanded(
            child: pqrsProvider.isLoadingTicket
                ? const LoadingContainer()
                : pqrsProvider.ticket == null
                    ? EmptyMessage(
                        onPressed: () => pqrsProvider.loadTicket(ticket.idPqrs),
                        message: 'No hay información.',
                      )
                    : RefreshIndicator(
                        onRefresh: () => pqrsProvider.loadTicket(ticket.idPqrs),
                        color: Theme.of(context).primaryColor,
                        child: _MessagesList(),
                      ),
          ),
          MessageForm(ticket: ticket),
        ],
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  const _MessagesList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pqrsProvider = Provider.of<PqrsProvider>(context);
    List<int> users = pqrsProvider.ticket.mensajes == null
        ? []
        : pqrsProvider.ticket.mensajes
            .map<int>((message) => message.idUsuario)
            .toSet()
            .toList();

    return ListView.separated(
      reverse: true,
      itemCount: pqrsProvider.ticket.mensajes.length,
      padding: EdgeInsets.all(10.0),
      itemBuilder: (_, int index) {
        final message = pqrsProvider.ticket.mensajes[index];
        return MessageCard(
          message: message,
          leftSide: users.indexOf(message.idUsuario) % 2 != 0,
        );
      },
      separatorBuilder: (_, int index) {
        return SizedBox(height: 20.0);
      },
    );
  }
}
