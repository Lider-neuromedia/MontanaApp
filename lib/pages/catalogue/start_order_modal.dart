import 'package:flutter/material.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/providers/catalogues_provider.dart';
import 'package:montana_mobile/providers/clients_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/widgets/DropdownList.dart';
import 'package:provider/provider.dart';

class StartOrderModal extends StatefulWidget {
  const StartOrderModal({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  _StartOrderModalState createState() => _StartOrderModalState();
}

class _StartOrderModalState extends State<StartOrderModal> {
  ClientsProvider _clientsProvider;
  CataloguesProvider _cataloguesProvider;

  List<Cliente> _clients = [];
  List<Catalogo> _catalogues = [];
  bool _loading = false;

  @override
  void initState() {
    _clientsProvider = Provider.of<ClientsProvider>(
      context,
      listen: false,
    );
    _cataloguesProvider = Provider.of<CataloguesProvider>(
      context,
      listen: false,
    );
    _loadData();
    super.initState();
  }

  void _loadData() async {
    setState(() => _loading = true);

    final clients = await _clientsProvider.getClients();
    final catalogues = await _cataloguesProvider.getCatalogues();

    setState(() {
      _loading = false;
      _clients = clients;
      _catalogues = catalogues;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Container(
      height: size.height / 2,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Center(
        child: Container(
          width: size.width > 320.0 ? 320.0 : double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _TitleModal(title: 'Comienza tu pedido'),
              _FieldBox(
                children: [
                  _LabelField(label: 'CLIENTE'),
                  SizedBox(height: 10.0),
                  _loading
                      ? LoadingContainer()
                      : DropdownList(
                          onChanged: (dynamic value) {
                            cartProvider.clientId = value as int;
                          },
                          value: cartProvider.clientId,
                          items: _clients
                              .map<Map<String, dynamic>>((Cliente cliente) => {
                                    'id': cliente.id,
                                    'value': cliente.nombreCompleto,
                                  })
                              .toList(),
                        ),
                ],
              ),
              _FieldBox(
                children: [
                  _LabelField(label: 'CATALOGO'),
                  SizedBox(height: 10.0),
                  _loading
                      ? LoadingContainer()
                      : DropdownList(
                          onChanged: (dynamic value) {
                            cartProvider.catalogueId = value as int;
                          },
                          value: cartProvider.catalogueId,
                          items: _catalogues
                              .map<Map<String, dynamic>>((Catalogo cliente) => {
                                    'id': cliente.id,
                                    'value': cliente.titulo,
                                  })
                              .toList(),
                        ),
                ],
              ),
              _ContinueButton(
                icon: Icons.add,
                label: 'Continuar',
                onPressed: widget.onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleModal extends StatelessWidget {
  const _TitleModal({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline4.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.bold,
        );

    return Text(
      title,
      style: titleStyle,
      textAlign: TextAlign.center,
    );
  }
}

class _FieldBox extends StatelessWidget {
  const _FieldBox({
    Key key,
    @required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _LabelField extends StatelessWidget {
  const _LabelField({
    Key key,
    this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyText1.copyWith(
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
    final cartProvider = Provider.of<CartProvider>(context);

    return ElevatedButton(
      onPressed: cartProvider.clientId == null ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3.0,
                  color: CustomTheme.greyColor,
                  offset: Offset(2.0, 0.0),
                ),
              ],
            ),
            padding: EdgeInsets.all(15.0),
            child: Icon(icon, color: Colors.white),
          ),
          Text(label),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Icon(icon, color: Colors.transparent),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(
          left: 0.0,
          right: 10.0,
        ),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: Theme.of(context).primaryColor,
      ),
    );
  }
}
