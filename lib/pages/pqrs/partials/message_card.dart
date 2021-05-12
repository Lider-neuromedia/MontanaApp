import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/pqrs/pqrs_page.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key key,
    this.message,
  }) : super(key: key);

  final PqrsMessageTemporal message;

  @override
  Widget build(BuildContext context) {
    // TODO: PENDIENTE.
    return Container(
      child: Text('mensaje'),
    );
  }
}
