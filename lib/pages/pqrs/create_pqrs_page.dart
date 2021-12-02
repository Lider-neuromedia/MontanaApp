import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/pqrs/partials/dropdown_pqrs.dart';
import 'package:montana_mobile/providers/clients_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/pqrs_provider.dart';
import 'package:montana_mobile/providers/pqrs_ticket_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/utils/utils.dart';

class CreatePqrsPage extends StatefulWidget {
  static final String route = '/create-pqrs';

  @override
  _CreatePqrsPageState createState() => _CreatePqrsPageState();
}

class _CreatePqrsPageState extends State<CreatePqrsPage> {
  final _messageController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      final pqrsTicketProvider =
          Provider.of<PqrsTicketProvider>(context, listen: false);
      final clientsProvider =
          Provider.of<ClientsProvider>(context, listen: false);
      final connectionProvider =
          Provider.of<ConnectionProvider>(context, listen: false);

      pqrsTicketProvider.clientes = [];

      if (connectionProvider.isNotConnected) {
        clientsProvider.getSellerClientsLocal().then((clients) {
          pqrsTicketProvider.clientes = clients;
        });
      } else {
        clientsProvider.getSellerClients().then((clients) {
          pqrsTicketProvider.clientes = clients;
        });
      }

      pqrsTicketProvider.message = '';
      pqrsTicketProvider.clienteId = null;
      pqrsTicketProvider.pqrsType = null;
    }();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pqrsTicketProvider = Provider.of<PqrsTicketProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final preferences = Preferences();
    final isCliente = preferences.session.isCliente;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PQRS'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const _TitlePqrs(title: 'Nuevo PQRS'),
          const SizedBox(height: 25.0),
          const _LabelField(label: 'Tipo de PQRS'),
          const SizedBox(height: 10.0),
          DropdownPqrs(
            onChanged: (dynamic value) {
              pqrsTicketProvider.pqrsType = value as String;
            },
            value: pqrsTicketProvider.pqrsType,
            items: pqrsTicketProvider.pqrsTypes.map<DropdownMenuItem<String>>(
              (PqrsType value) {
                return DropdownMenuItem<String>(
                  value: value.id,
                  child: Text(
                    value.value,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 25.0),
          isCliente
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _LabelField(label: 'Cliente'),
                    const SizedBox(height: 10.0),
                    DropdownPqrs(
                      onChanged: (dynamic value) {
                        pqrsTicketProvider.clienteId = value as int;
                      },
                      value: pqrsTicketProvider.clienteId,
                      items: pqrsTicketProvider.clientes
                          .map<DropdownMenuItem<int>>(
                        (Cliente client) {
                          return DropdownMenuItem<int>(
                            value: client.id,
                            child: Text(
                              client.nombreCompleto,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
          const _LabelField(label: 'Mensaje'),
          const SizedBox(height: 10.0),
          TextField(
            maxLines: 5,
            controller: _messageController,
            onChanged: (String value) {
              pqrsTicketProvider.message = value;
            },
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomTheme.greyColor,
                  width: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          pqrsTicketProvider.isLoading
              ? LoadingContainer()
              : Center(
                  child: SizedBox(
                    width: 160.0,
                    child: _ContinueButton(
                      label: 'Enviar',
                      icon: Icons.arrow_forward,
                      onPressed: pqrsTicketProvider.canSend
                          ? () => _createMessage(
                                context,
                                pqrsTicketProvider,
                                connectionProvider,
                              )
                          : null,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _createMessage(
    BuildContext context,
    PqrsTicketProvider pqrsTicketProvider,
    ConnectionProvider connectionProvider,
  ) async {
    pqrsTicketProvider.isLoading = true;
    bool success = await pqrsTicketProvider.createPqrs(
      local: connectionProvider.isNotConnected,
    );
    pqrsTicketProvider.isLoading = false;

    if (!success) {
      showMessageDialog(
        context,
        'Aviso',
        'No se pudo registrar el PQRS',
      );
    } else {
      showMessageDialog(
        context,
        'Listo',
        'PQRS creado correctamente.',
        onAccept: () {
          _messageController.clear();
          pqrsTicketProvider.message = '';
          Navigator.pop(context);

          final pqrsProvider = Provider.of<PqrsProvider>(
            context,
            listen: false,
          );
          pqrsProvider.sortBy = SortValue.RECENT_FIRST;
          pqrsProvider.loadTickets(
            local: connectionProvider.isNotConnected,
          );
        },
      );
    }
  }
}

class _TitlePqrs extends StatelessWidget {
  const _TitlePqrs({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline4.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );

    return Text(
      title,
      style: titleStyle,
      textAlign: TextAlign.center,
    );
  }
}

class _LabelField extends StatelessWidget {
  const _LabelField({
    Key key,
    @required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          color: Theme.of(context).primaryColor,
        );

    return Text(label, style: labelStyle);
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isBlocked = onPressed == null;

    final shadow = [
      BoxShadow(
        blurRadius: 3.0,
        color: Colors.red,
        offset: Offset(2.0, 0.0),
      ),
    ];

    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isBlocked ? Colors.grey : Theme.of(context).primaryColor,
              boxShadow: isBlocked ? [] : shadow,
            ),
            padding: const EdgeInsets.all(5.0),
            child: Icon(icon, color: Colors.white),
          ),
          Text(label),
          Container(
            width: 30,
            child: Icon(icon, color: Colors.transparent),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
        primary: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        side: BorderSide(
          color: isBlocked ? Colors.grey : Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
