import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:montana_mobile/models/ticket.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/pqrs/partials/message_card.dart';
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
    Ticket ticket = ModalRoute.of(context).settings.arguments as Ticket;
    PqrsProvider pqrsProvider =
        Provider.of<PqrsProvider>(context, listen: false);
    pqrsProvider.loadTicket(ticket.idPqrs);
  }

  @override
  Widget build(BuildContext context) {
    PqrsProvider pqrsProvider = Provider.of<PqrsProvider>(context);
    Ticket ticket = ModalRoute.of(context).settings.arguments as Ticket;

    return Scaffold(
      backgroundColor: CustomTheme.grey3Color,
      appBar: AppBar(
        title: Text('PQRS'),
      ),
      body: pqrsProvider.isLoadingTicket
          ? const LoadingContainer()
          : pqrsProvider.ticket == null
              ? EmptyMessage(
                  onPressed: () => pqrsProvider.loadTicket(ticket.idPqrs),
                  message: 'No hay información disponible.',
                )
              : Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => pqrsProvider.loadTicket(ticket.idPqrs),
                        color: Theme.of(context).primaryColor,
                        child: _MessagesList(
                            messages: pqrsProvider.ticket.mensajes),
                      ),
                    ),
                    _SendMessageForm(),
                  ],
                ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  const _MessagesList({
    Key key,
    @required this.messages,
  }) : super(key: key);

  final List<Mensaje> messages;

  @override
  Widget build(BuildContext context) {
    List<int> users = messages != null
        ? messages.map<int>((message) => message.idUsuario).toSet().toList()
        : [];

    return ListView.separated(
      reverse: true,
      itemCount: messages.length,
      padding: EdgeInsets.all(10.0),
      itemBuilder: (_, int index) {
        final message = messages[index];
        return MessageCard(
          message: message,
          leftSide: users.indexOf(message.idUsuario) % 2 == 0,
        );
      },
      separatorBuilder: (_, int index) {
        return SizedBox(height: 20.0);
      },
    );
  }
}

class _SendMessageForm extends StatelessWidget {
  const _SendMessageForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Escribe un mensaje',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: CustomTheme.blue1Color,
              shape: CircleBorder(),
              padding: EdgeInsets.all(14),
            ),
            child: Icon(Linecons.paper_plane, size: 20.0),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
