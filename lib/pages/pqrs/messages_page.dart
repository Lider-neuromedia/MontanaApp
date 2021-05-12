import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/pqrs/partials/message_card.dart';
import 'package:montana_mobile/pages/pqrs/pqrs_page.dart';
import 'package:montana_mobile/theme/theme.dart';

class MessagesPage extends StatelessWidget {
  static final String route = '/pqrs-messages';

  @override
  Widget build(BuildContext context) {
    PqrsTemporal pqrs = pqrsWithMessagesTest();

    return Scaffold(
      backgroundColor: CustomTheme.grey3Color,
      appBar: AppBar(
        title: Text('PQRS'),
      ),
      body: Stack(
        children: [
          ListView.separated(
            itemCount: pqrs.messages.length,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (_, int index) {
              return MessageCard(
                message: pqrs.messages[index],
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
        horizontal: 20.0,
        vertical: 15.0,
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
              padding: EdgeInsets.all(20),
            ),
            child: Icon(Icons.send),
            onPressed: () {},
          ),
          // ElevatedButton(
          //   onPressed: () {},
          //   child: Icon(Icons.send),
          //   style: ElevatedButton.styleFrom(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
          //     ),
          //   ),
          // ),
          // CircleAvatar(
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.send),
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}
