import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class PaymentMethodsField extends StatelessWidget {
  final List<String> paymentMethods = ['Contado', 'Crédito 45 días'];
  String selected = 'Contado';

  @override
  Widget build(BuildContext context) {
    paymentMethods.asMap().forEach((key, value) {});
    List<Widget> methodsOptions = [];

    paymentMethods.asMap().forEach(
      (int index, String method) {
        methodsOptions.add(_MethodOption(
          method: method,
          selected: selected == method,
          hasBorderLeft: index == 0,
          hasBorderRight: index == paymentMethods.length - 1,
        ));
      },
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: methodsOptions,
    );
  }
}

class _MethodOption extends StatelessWidget {
  const _MethodOption({
    Key key,
    @required this.method,
    @required this.selected,
    @required this.hasBorderLeft,
    @required this.hasBorderRight,
  }) : super(key: key);

  final String method;
  final bool selected;
  final bool hasBorderLeft;
  final bool hasBorderRight;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline6.copyWith(
          fontWeight: FontWeight.w700,
          color: selected
              ? Colors.white
              : Theme.of(context).textTheme.bodyText1.color,
        );

    var borderRadius;

    if (hasBorderLeft) {
      borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(10.0),
        topLeft: Radius.circular(10.0),
      );
    }

    if (hasBorderRight) {
      borderRadius = BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      );
    }
    // TODO: en proceso.
    return Expanded(
      child: Container(
        // decoration: BoxDecoration(
        //   color: selected ? CustomTheme.mainDarkColor : CustomTheme.textColor2,
        //   borderRadius: borderRadius,
        // ),
        child: Material(
          child: InkWell(
            splashColor: selected
                ? Theme.of(context).primaryColor.withOpacity(0.5)
                : CustomTheme.greyColor.withOpacity(0.5),
            borderRadius: borderRadius,
            onTap: () => print(method),
            child: Ink(
              color: selected
                  ? Theme.of(context).primaryColor
                  : CustomTheme.greyColor,
              child: Container(
                margin: EdgeInsets.only(bottom: 3.0),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  // color: selected
                  //     ? Theme.of(context).primaryColor
                  //     : CustomTheme.greyColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: Text(
                  method,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
