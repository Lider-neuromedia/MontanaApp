import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:montana_mobile/pages/cart/partials/payment_methods_field.dart';
import 'package:montana_mobile/pages/catalogue/partials/action_button.dart';
import 'package:montana_mobile/theme/theme.dart';

class CheckoutModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          _CheckoutForm(),
          _CheckoutActions(),
        ],
      ),
    );
  }
}

class _CheckoutForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TitleCheckout(),
              SizedBox(height: 10.0),
              _LabelField(label: 'Forma de pago'),
              SizedBox(height: 5.0),
              PaymentMethodsField(),
              SizedBox(height: 15.0),
              _LabelField(label: 'Descuento asignado'),
              SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: CustomTheme.greyColor,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              _LabelField(label: 'Notas adicionales'),
              SizedBox(height: 10.0),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: CustomTheme.greyColor,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleCheckout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline4.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );

    return Text(
      'Método de Pago',
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ActionButton(
            label: "Finalizar pedido",
            icon: Icons.add,
            borderColor: CustomTheme.green2Color,
            backgroundColor: CustomTheme.green2Color,
            iconColor: Colors.white,
            textColor: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          ActionButton(
            label: "Cancelar",
            icon: Icons.close,
            borderColor: CustomTheme.redColor,
            backgroundColor: Colors.grey[200],
            iconColor: CustomTheme.redColor,
            textColor: CustomTheme.redColor,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
