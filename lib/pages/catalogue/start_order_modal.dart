import 'package:flutter/material.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/providers/catalogues_provider.dart';
import 'package:montana_mobile/providers/clients_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/widgets/DropdownList.dart';

class StartOrderModal extends StatefulWidget {
  const StartOrderModal({
    Key key,
    @required this.onPressed,
    @required this.showCatalogue,
  }) : super(key: key);

  final Function onPressed;
  final bool showCatalogue;

  @override
  _StartOrderModalState createState() => _StartOrderModalState();
}

class _StartOrderModalState extends State<StartOrderModal> {
  List<Usuario> _clients = [];
  List<Catalogo> _catalogues = [];
  bool _loading = false;

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);

      final clientsProvider =
          Provider.of<ClientsProvider>(context, listen: false);
      final cataloguesProvider =
          Provider.of<CataloguesProvider>(context, listen: false);
      final connectionProvider =
          Provider.of<ConnectionProvider>(context, listen: false);

      setState(() => _loading = true);

      final clients = connectionProvider.isNotConnected
          ? await clientsProvider.getSellerClientsLocal()
          : await clientsProvider.getSellerClients();
      final catalogues = connectionProvider.isNotConnected
          ? await cataloguesProvider.getCataloguesLocal()
          : await cataloguesProvider.getCatalogues();

      setState(() {
        _loading = false;
        _clients = clients;
        _catalogues = catalogues;
      });
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context);

    return Container(
      height: size.height / 2,
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          topRight: const Radius.circular(30.0),
        ),
      ),
      child: Center(
        child: Container(
          width: size.width > 320.0 ? 320.0 : double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _TitleModal(title: "Comienza tu pedido"),
              _FieldBox(
                children: [
                  _LabelField(label: "CLIENTE"),
                  const SizedBox(height: 10.0),
                  _loading
                      ? LoadingContainer()
                      : DropdownList(
                          onChanged: (dynamic value) {
                            cartProvider.clientId = value as int;
                          },
                          value: cartProvider.clientId,
                          items: _clients
                              .map<Map<String, dynamic>>((Usuario cliente) => {
                                    "id": cliente.id,
                                    "value": cliente.nombreCompleto,
                                  })
                              .toList(),
                        ),
                ],
              ),
              !widget.showCatalogue
                  ? Container()
                  : _FieldBox(
                      children: [
                        _LabelField(label: "CATALOGO"),
                        const SizedBox(height: 10.0),
                        _loading
                            ? LoadingContainer()
                            : DropdownList(
                                onChanged: (dynamic value) {
                                  cartProvider.catalogueId = value as int;
                                },
                                value: cartProvider.catalogueId,
                                items: _catalogues
                                    .map<Map<String, dynamic>>(
                                      (Catalogo cliente) => {
                                        "id": cliente.id,
                                        "value": cliente.titulo,
                                      },
                                    )
                                    .toList(),
                              ),
                      ],
                    ),
              _ContinueButton(
                icon: Icons.add,
                label: "Continuar",
                onPressed:
                    cartProvider.clientId == null ? null : widget.onPressed,
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
    @required this.title,
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
    @required this.label,
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
    final isBlocked = onPressed == null;

    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Icon(icon, color: Colors.white),
            decoration: BoxDecoration(
              color: isBlocked ? Colors.grey : Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: CustomTheme.greyColor,
                  offset: Offset(2.0, 0.0),
                  blurRadius: 3.0,
                ),
              ],
            ),
          ),
          Text(label),
          Container(
            child: Icon(icon, color: Colors.transparent),
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: const EdgeInsets.only(right: 10.0, left: 0.0),
        side: BorderSide(
          color: isBlocked ? Colors.grey : Theme.of(context).primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
