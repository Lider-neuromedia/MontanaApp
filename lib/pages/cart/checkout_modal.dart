import 'dart:io';
import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/quota_expansion/partials/file_button.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/cart/partials/current_sign.dart';
import 'package:montana_mobile/pages/cart/partials/payment_methods_field.dart';
import 'package:montana_mobile/pages/cart/partials/sign_box.dart';
import 'package:montana_mobile/pages/catalogue/partials/action_button.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';

class CheckoutModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          topRight: const Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          _CheckoutForm(),
          cartProvider.isLoading
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LoadingContainer(),
                )
              : _CheckoutActions(
                  onFinish: cartProvider.canSend
                      ? () => finishOrder(
                            context,
                            cartProvider,
                            connectionProvider,
                          )
                      : null,
                ),
        ],
      ),
    );
  }

  Future<void> finishOrder(
    BuildContext context,
    CartProvider cartProvider,
    ConnectionProvider connectionProvider,
  ) async {
    cartProvider.isLoading = true;

    final success = connectionProvider.isNotConnected
        ? await cartProvider.createOrderLocal(cartProvider.cart)
        : await cartProvider.createOrder(cartProvider.cart);

    cartProvider.isLoading = false;

    if (success) {
      cartProvider.clientId = null;
      cartProvider.catalogueId = null;
      cartProvider.notes = "";
      cartProvider.billingNotes = "";
      cartProvider.signData = null;
      cartProvider.cart.clean();

      showMessageDialog(
        context,
        "Listo",
        connectionProvider.isNotConnected
            ? "Pedido guardado localmente y se sincronizar?? cuando haya conexi??n."
            : "Pedido creado correctamente.",
        onAccept: () {
          final navigationProvider =
              Provider.of<NavigationProvider>(context, listen: false);
          navigationProvider.currentPage = 0;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    } else {
      showMessageDialog(context, "Aviso", "Datos de pedido incorrectos.");
    }
  }
}

class _CheckoutForm extends StatefulWidget {
  const _CheckoutForm({Key key}) : super(key: key);

  @override
  __CheckoutFormState createState() => __CheckoutFormState();
}

class __CheckoutFormState extends State<_CheckoutForm> {
  TextEditingController _notesController;
  TextEditingController _billingNotesController;

  @override
  void initState() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    super.initState();
    _notesController = TextEditingController(text: cartProvider.notes);
    _billingNotesController =
        TextEditingController(text: cartProvider.billingNotes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _billingNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final discountList = Iterable<int>.generate(100).toList();
    // final preferences = Preferences();
    final cartProvider = Provider.of<CartProvider>(context);
    final counterTheme = Theme.of(context).textTheme.bodyText1.copyWith(
          color: CustomTheme.mainColor,
        );

    const minSpace = const SizedBox(height: 10.0);
    const maxSpace = const SizedBox(height: 15.0);
    // final canSelectDiscount = !preferences.session.isCliente;

    final signLabel = cartProvider.signMethods
        .firstWhere((x) => x.id == cartProvider.signMethod)
        .value;

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _TitleCheckout(label: "M??todo de Pago"),
          const SizedBox(height: 20.0),
          const _LabelField(label: "Forma de pago"),
          minSpace,
          SwitchMethodsField<PaymentMethod>(
            cartProvider: cartProvider,
            list: cartProvider.paymentMethods,
            currentValue: cartProvider.paymentMethod,
            onTap: (String value) {
              cartProvider.paymentMethod = value;
            },
          ),
          maxSpace,
          // !canSelectDiscount
          //     ? Container()
          //     : Column(
          //         crossAxisAlignment: CrossAxisAlignment.stretch,
          //         children: [
          //           const _LabelField(label: "Descuento asignado"),
          //           minSpace,
          //           DropdownList(
          //             onChanged: (dynamic value) {
          //               cartProvider.discount = value as int;
          //             },
          //             value: cartProvider.discount,
          //             items: discountList
          //                 .map<Map<String, dynamic>>(
          //                   (int discount) => {
          //                     "id": discount,
          //                     "value": "$discount%",
          //                   },
          //                 )
          //                 .toList(),
          //           ),
          //           maxSpace,
          //         ],
          //       ),
          const _LabelField(label: "Notas de descuento"),
          minSpace,
          TextField(
            controller: _notesController,
            maxLines: 4,
            maxLength: 120,
            buildCounter: (_,
                {int currentLength, int maxLength, bool isFocused}) {
              return Text(
                "$currentLength/$maxLength",
                style: counterTheme,
              );
            },
            onChanged: (String value) {
              cartProvider.notes = value;
            },
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.all(10.0),
              errorText: cartProvider.notesError,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomTheme.greyColor,
                  width: 1.0,
                ),
              ),
            ),
          ),
          minSpace,
          const _LabelField(label: "Notas de facturaci??n"),
          minSpace,
          TextField(
            controller: _billingNotesController,
            maxLines: 4,
            maxLength: 120,
            buildCounter: (_,
                {int currentLength, int maxLength, bool isFocused}) {
              return Text(
                "$currentLength/$maxLength",
                style: counterTheme,
              );
            },
            onChanged: (String value) {
              cartProvider.billingNotes = value;
            },
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.all(10.0),
              errorText: cartProvider.billingNotesError,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomTheme.greyColor,
                  width: 1.0,
                ),
              ),
            ),
          ),
          maxSpace,
          const _LabelField(label: "??Como quiere firmar?"),
          minSpace,
          SwitchMethodsField<SignMethod>(
            cartProvider: cartProvider,
            list: cartProvider.signMethods,
            currentValue: cartProvider.signMethod,
            onTap: (String value) {
              cartProvider.signMethod = value;
            },
          ),
          maxSpace,
          _LabelField(label: signLabel),
          minSpace,
          cartProvider.signMethod == SignMethod.FIRMA
              ? cartProvider.signData != null
                  ? CurrentSign(
                      signData: cartProvider.signData,
                      onDeleteSign: () => cartProvider.signData = null,
                    )
                  : SignBox()
              : FileButton(
                  value: cartProvider.descriptionSignPhoto,
                  onSelected: (File file) {
                    cartProvider.signPhoto = file;
                  },
                ),
          const SizedBox(height: 100.0),
        ],
      ),
    );
  }
}

class _TitleCheckout extends StatelessWidget {
  const _TitleCheckout({
    Key key,
    @required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline4.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );

    return Text(
      label,
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

class _CheckoutActions extends StatelessWidget {
  const _CheckoutActions({
    Key key,
    @required this.onFinish,
  }) : super(key: key);

  final Function onFinish;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ActionButton(
            label: "Volver",
            icon: Icons.arrow_back,
            borderColor: CustomTheme.redColor,
            backgroundColor: Colors.grey[200],
            iconColor: CustomTheme.redColor,
            textColor: CustomTheme.redColor,
            onPressed: () => Navigator.pop(context),
          ),
          ActionButton(
            label: "Finalizar pedido",
            icon: Icons.check,
            borderColor: CustomTheme.green2Color,
            backgroundColor: CustomTheme.green2Color,
            iconColor: Colors.white,
            textColor: Colors.white,
            onPressed: onFinish,
          ),
        ],
      ),
    );
  }
}
