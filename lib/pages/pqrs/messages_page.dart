import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:montana_mobile/pages/pqrs/partials/message_card.dart';
import 'package:montana_mobile/pages/pqrs/pqrs_page.dart';
import 'package:montana_mobile/theme/theme.dart';

class MessagesPage extends StatelessWidget {
  static final String route = '/pqrs-messages';

  @override
  Widget build(BuildContext context) {
    PqrsTemporal pqrs = pqrsWithMessagesTest();
    List<int> users = [];

    pqrs.messages.forEach((message) => users.add(message.userId));
    users = users.toSet().toList();

    return Scaffold(
      backgroundColor: CustomTheme.grey3Color,
      appBar: AppBar(
        title: Text('PQRS'),
        actions: [
          IconButton(
            icon: Icon(WebSymbols.arrows_cw),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.separated(
            itemCount: pqrs.messages.length,
            padding: EdgeInsets.only(
              left: 10.0,
              top: 10.0,
              right: 10.0,
              bottom: 100.0,
            ),
            itemBuilder: (_, int index) {
              final message = pqrs.messages[index];
              return MessageCard(
                message: message,
                leftSide: users.indexOf(message.userId) % 2 == 0,
              );
            },
            separatorBuilder: (_, int index) {
              return SizedBox(height: 20.0);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _SendMessageForm(),
          ),
        ],
      ),
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
