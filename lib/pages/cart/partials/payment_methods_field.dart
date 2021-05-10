import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class PaymentMethodsField extends StatelessWidget {
  final List<String> paymentMethods = ['Contado', 'Crédito 45 días'];

  @override
  Widget build(BuildContext context) {
    paymentMethods.asMap().forEach((key, value) {});
    List<Widget> methodsOptions = [];
    String selected = 'Contado';

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
  _MethodOption({
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

  final borderLeft = BorderRadius.only(
    bottomLeft: Radius.circular(10.0),
    topLeft: Radius.circular(10.0),
  );
  final borderRight = BorderRadius.only(
    bottomRight: Radius.circular(10.0),
    topRight: Radius.circular(10.0),
  );

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
      borderRadius = borderLeft;
    }
    if (hasBorderRight) {
      borderRadius = borderRight;
    }

    Color normalColor =
        selected ? Theme.of(context).primaryColor : CustomTheme.greyColor;
    Color darkColor =
        selected ? CustomTheme.mainDarkColor : CustomTheme.textColor1;

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(bottom: 3.0),
        decoration: BoxDecoration(
          color: darkColor,
          borderRadius: borderRadius,
        ),
        child: Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: () => print(method),
            borderRadius: borderRadius,
            child: Ink(
              padding: EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: normalColor,
              ),
              child: Text(
                method,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
