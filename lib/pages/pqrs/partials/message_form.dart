import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/message.dart';
import 'package:montana_mobile/models/ticket.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/providers/message_provider.dart';
import 'package:montana_mobile/providers/pqrs_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/utils/utils.dart';

class MessageForm extends StatefulWidget {
  MessageForm({
    Key key,
    @required this.ticket,
  }) : super(key: key);

  final Ticket ticket;

  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _messageController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      final messageProvider = Provider.of<MessageProvider>(
        context,
        listen: false,
      );
      final preferences = Preferences();
      final user = preferences.session;

      messageProvider.pqrsId = widget.ticket.idPqrs;
      messageProvider.userId = user.id;
    }();
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final pqrsProvider = Provider.of<PqrsProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Escribe un mensaje",
              ),
              onChanged: (String value) {
                messageProvider.message = value;
              },
            ),
          ),
          messageProvider.isLoading
              ? LoadingContainer()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: CustomTheme.blue1Color,
                    shape: CircleBorder(),
                    padding: const EdgeInsets.all(14),
                  ),
                  child: const Icon(Linecons.paper_plane, size: 20.0),
                  onPressed: messageProvider.canSend
                      ? () => _createMessage(messageProvider, pqrsProvider)
                      : null,
                ),
        ],
      ),
    );
  }

  Future<void> _createMessage(MessageProvider mp, PqrsProvider pp) async {
    mp.isLoading = true;
    Mensaje mensaje = await mp.createMessage();
    mp.isLoading = false;

    if (mensaje == null) {
      showMessageDialog(context, "Aviso", "El mensaje no se pudo enviar.");
    } else {
      _messageController.clear();
      mp.message = "";
      pp.addCreatedMessage(mensaje);
    }
  }
}
