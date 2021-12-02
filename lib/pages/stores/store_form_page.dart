import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/pages/catalogue/partials/action_button.dart';
import 'package:montana_mobile/pages/stores/partials/form_input.dart';
import 'package:montana_mobile/pages/stores/partials/store_item.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/store_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';

class StoreFormPage extends StatefulWidget {
  static final String route = '/store-form';

  const StoreFormPage({Key key}) : super(key: key);

  @override
  _StoreFormPageState createState() => _StoreFormPageState();
}

class _StoreFormPageState extends State<StoreFormPage> {
  TextEditingController _nombreController;
  TextEditingController _lugarController;
  TextEditingController _localController;
  TextEditingController _direccionController;
  TextEditingController _telefonoController;
  Tienda _store;

  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);
      _store = ModalRoute.of(context).settings.arguments as Tienda;

      final storeProvider = Provider.of<StoreProvider>(context, listen: false);
      storeProvider.initialize(store: _store);

      _nombreController = TextEditingController(text: storeProvider.nombre);
      _lugarController = TextEditingController(text: storeProvider.lugar);
      _localController = TextEditingController(text: storeProvider.local);
      _direccionController =
          TextEditingController(text: storeProvider.direccion);
      _telefonoController = TextEditingController(text: storeProvider.telefono);
    }();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _lugarController.dispose();
    _localController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_store == null ? 'Agregar Tienda' : 'Editar tienda'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(15.0),
              children: [
                const _ListAddedStores(),
                FormInput(
                  label: 'Nombre de la tienda',
                  controller: _nombreController,
                  error: storeProvider.nombreError,
                  onChanged: (String value) => storeProvider.nombre = value,
                ),
                const SizedBox(height: 15.0),
                FormInput(
                  label: 'Lugar',
                  controller: _lugarController,
                  error: storeProvider.lugarError,
                  onChanged: (String value) => storeProvider.lugar = value,
                ),
                const SizedBox(height: 15.0),
                FormInput(
                  label: 'Número del local',
                  controller: _localController,
                  error: storeProvider.localError,
                  onChanged: (String value) => storeProvider.local = value,
                ),
                const SizedBox(height: 15.0),
                FormInput(
                  label: 'Dirección',
                  controller: _direccionController,
                  error: storeProvider.direccionError,
                  onChanged: (String value) => storeProvider.direccion = value,
                ),
                const SizedBox(height: 15.0),
                FormInput(
                  label: 'Teléfono',
                  controller: _telefonoController,
                  error: storeProvider.telefonoError,
                  onChanged: (String value) => storeProvider.telefono = value,
                ),
                const SizedBox(height: 50.0),
                _store != null
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ActionButton(
                            label: storeProvider.stores.length == 0
                                ? "Agregar tienda"
                                : "Agregar otra tienda",
                            icon: Icons.add,
                            borderColor: CustomTheme.mainColor,
                            backgroundColor: Colors.white,
                            backgroundIconColor: CustomTheme.mainColor,
                            iconColor: Colors.white,
                            textColor: CustomTheme.mainColor,
                            onPressed: storeProvider.canAddStore
                                ? () => _addStore(storeProvider)
                                : null,
                          ),
                        ],
                      ),
              ],
            ),
          ),
          _FormActions(
            onSave: storeProvider.canSend
                ? () => _save(context, storeProvider, connectionProvider)
                : null,
          ),
        ],
      ),
    );
  }

  void _addStore(StoreProvider storeProvider) {
    storeProvider.addStore();
    _clear();
  }

  void _clear() {
    _nombreController.clear();
    _lugarController.clear();
    _localController.clear();
    _direccionController.clear();
    _telefonoController.clear();
  }

  Future<void> _save(
    BuildContext context,
    StoreProvider storeProvider,
    ConnectionProvider connectionProvider,
  ) async {
    final isUpdate = storeProvider.storeUpdate != null;
    final successMessage = isUpdate
        ? 'Tienda actualizada correctamente.'
        : 'Tienda(s) creada(s) correctamente.';
    final errorMessage = isUpdate
        ? 'No se actualizó la tienda.'
        : 'No se guardó la(s) tienda(s).';

    storeProvider.isLoading = true;
    bool success = false;

    if (connectionProvider.isNotConnected) {
      success = isUpdate
          ? await storeProvider.updateStore()
          : await storeProvider.saveStores();
    } else {
      success = isUpdate
          ? await storeProvider.updateStore()
          : await storeProvider.saveStores();
    }

    storeProvider.isLoading = false;

    if (success) {
      _clear();
      storeProvider.clear();

      showMessageDialog(
        context,
        'Listo',
        successMessage,
        onAccept: () => Navigator.pop(context),
      );
    } else {
      showMessageDialog(context, 'Aviso', errorMessage);
    }
  }
}

class _ListAddedStores extends StatelessWidget {
  const _ListAddedStores({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    int index = 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: storeProvider.stores.map((store) {
        return StoreItem(
          index: index++,
          store: store,
        );
      }).toList(),
    );
  }
}

class _FormActions extends StatelessWidget {
  const _FormActions({
    Key key,
    @required this.onSave,
  }) : super(key: key);

  final Function onSave;

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final countStores = storeProvider.stores.length;
    final hasStoresInList = countStores > 0;
    final isUpdate = storeProvider.storeUpdate != null;

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(10.0),
      child: storeProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  label: isUpdate
                      ? "Guardar"
                      : !hasStoresInList
                          ? "Guardar"
                          : "Guardar (${storeProvider.stores.length})",
                  icon: Icons.add,
                  borderColor: CustomTheme.mainColor,
                  backgroundColor: CustomTheme.mainColor,
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  onPressed: onSave,
                ),
                ActionButton(
                  label: "Cancelar",
                  icon: Icons.close,
                  borderColor: CustomTheme.redColor,
                  backgroundColor: Colors.white,
                  iconColor: CustomTheme.redColor,
                  textColor: CustomTheme.redColor,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
    );
  }
}
