import 'dart:io';
import 'package:flutter/material.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/pqrs/partials/dropdown_pqrs.dart';
import 'package:montana_mobile/pages/quota_expansion/partials/continue_button.dart';
import 'package:montana_mobile/pages/quota_expansion/partials/file_button.dart';
import 'package:montana_mobile/providers/clients_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/quota_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/utils/utils.dart';

class QuotaExpansionPage extends StatefulWidget {
  @override
  _QuotaExpansionPageState createState() => _QuotaExpansionPageState();
}

class _QuotaExpansionPageState extends State<QuotaExpansionPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);
      _loadData();
    }();
  }

  void _loadData() {
    final quotaProvider = Provider.of<QuotaProvider>(context, listen: false);
    final clientsProvider =
        Provider.of<ClientsProvider>(context, listen: false);
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    quotaProvider.clienteId = null;
    quotaProvider.monto = "0";
    quotaProvider.docIdentidad = null;
    quotaProvider.docRut = null;
    quotaProvider.docCamaraCom = null;
    quotaProvider.clientes = [];

    if (connectionProvider.isNotConnected) {
      clientsProvider.getSellerClientsLocal().then((clients) {
        quotaProvider.clientes = clients;
      });
    } else {
      clientsProvider.getSellerClients().then((clients) {
        quotaProvider.clientes = clients;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quotaProvider = Provider.of<QuotaProvider>(context);
    final preferences = Preferences();

    return Scaffold(
      appBar: AppBar(
        title: Text("Ampliaci??n de cupo"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const _TitleQuota(title: "Realiza tu Solicitud", size: 30.0),
          const SizedBox(height: 30.0),
          preferences.session.isCliente
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _LabelField(label: "CLIENTE"),
                    const SizedBox(height: 10.0),
                    _ClientsDropdown(),
                    const SizedBox(height: 20.0),
                  ],
                ),
          const _LabelField(label: "Adjuntar documento de identidad"),
          const SizedBox(height: 10.0),
          FileButton(
            value: quotaProvider.descriptionIdentidad,
            onSelected: (File file) {
              quotaProvider.docIdentidad = file;
            },
          ),
          const SizedBox(height: 20.0),
          const _LabelField(label: "Adjuntar RUT"),
          const SizedBox(height: 10.0),
          FileButton(
            value: quotaProvider.descriptionRut,
            onSelected: (File file) {
              quotaProvider.docRut = file;
            },
          ),
          const SizedBox(height: 20.0),
          const _LabelField(label: "Adjuntar c??mara de comercio"),
          const SizedBox(height: 10.0),
          FileButton(
            value: quotaProvider.descriptionCamaraCom,
            onSelected: (File file) {
              quotaProvider.docCamaraCom = file;
            },
          ),
          const SizedBox(height: 30.0),
          const _TitleQuota(
            title:
                "Por favor coloque el monto por el cual desea solicitar ampliaci??n de cupo",
            size: 20.0,
          ),
          const SizedBox(height: 30.0),
          const _LabelField(label: "Monto"),
          const SizedBox(height: 10.0),
          TextField(
            keyboardType: TextInputType.number,
            controller: quotaProvider.montoController,
            onChanged: (String value) {
              quotaProvider.monto = value;
            },
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.all(10.0),
              errorText: quotaProvider.montoError,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomTheme.greyColor,
                  width: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          _SubmitAction(),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}

class _SubmitAction extends StatelessWidget {
  final _preferences = Preferences();

  @override
  Widget build(BuildContext context) {
    final quotaProvider = Provider.of<QuotaProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    return quotaProvider.isLoading
        ? LoadingContainer()
        : Center(
            child: SizedBox(
              width: 160.0,
              child: ContinueButton(
                label: "Enviar",
                icon: Icons.arrow_forward,
                onPressed: quotaProvider.canSend
                    ? () => _createQuota(
                          context,
                          quotaProvider,
                          connectionProvider,
                        )
                    : null,
              ),
            ),
          );
  }

  Future<void> _createQuota(
    BuildContext context,
    QuotaProvider quotaProvider,
    ConnectionProvider connectionProvider,
  ) async {
    quotaProvider.isLoading = true;
    final user = _preferences.session;

    if (user.isCliente) {
      // TODO: getSellerId ya no es v??lido porque un cliente tiene varios vendedores.
      final sellerId = connectionProvider.isNotConnected
          ? await quotaProvider.getSellerIdLocal()
          : await quotaProvider.getSellerId();

      if (sellerId == null) {
        quotaProvider.isLoading = false;
        showMessageDialog(context, "Aviso", "Vendedor no asignado.");
        return;
      }

      quotaProvider.quota.vendedorId = sellerId;
      quotaProvider.quota.clienteId = user.id;
    } else {
      quotaProvider.quota.vendedorId = user.id;
      quotaProvider.quota.clienteId = quotaProvider.clienteId;
    }

    final success = connectionProvider.isNotConnected
        ? await quotaProvider.createQuotaExpansionLocal(quotaProvider.quota)
        : await quotaProvider.createQuotaExpansion(quotaProvider.quota);

    quotaProvider.isLoading = false;

    if (!success) {
      showMessageDialog(context, "Aviso", "No se pudieron guardar los datos.");
    } else {
      showMessageDialog(
        context,
        "Listo",
        connectionProvider.isNotConnected
            ? "Solicitud guardada localmente, cuando haya conexi??n se sincronizar??."
            : "Solicitud guardada correctamente.",
        onAccept: () {
          quotaProvider.montoController.text = "0";
          quotaProvider.monto = "0";
          quotaProvider.docIdentidad = null;
          quotaProvider.docRut = null;
          quotaProvider.docCamaraCom = null;
        },
      );
    }
  }
}

class _ClientsDropdown extends StatelessWidget {
  const _ClientsDropdown({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quotaProvider = Provider.of<QuotaProvider>(context);
    final dropdownStyle = Theme.of(context).textTheme.bodyText1;

    return quotaProvider.clientes.isEmpty
        ? Center(
            child: Text("Cargando listado de clientes"),
          )
        : DropdownPqrs(
            onChanged: (dynamic value) {
              quotaProvider.clienteId = value as int;
            },
            value: quotaProvider.clienteId,
            items: quotaProvider.clientes.map<DropdownMenuItem<int>>(
              (Usuario cliente) {
                return DropdownMenuItem<int>(
                  value: cliente.id,
                  child: Text(
                    cliente.nombreCompleto,
                    style: dropdownStyle,
                  ),
                );
              },
            ).toList(),
          );
  }
}

class _TitleQuota extends StatelessWidget {
  const _TitleQuota({
    Key key,
    @required this.title,
    @required this.size,
  }) : super(key: key);

  final String title;
  final double size;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline4.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
          fontSize: size,
        );

    return Text(
      title,
      textAlign: TextAlign.center,
      style: titleStyle,
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
