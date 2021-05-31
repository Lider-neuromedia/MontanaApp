import 'package:flutter/material.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:provider/provider.dart';

class PaymentMethodsField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final countMethods = cartProvider.paymentMethods.length;
    int index = -1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: cartProvider.paymentMethods
          .map<_MethodOption>((PaymentMethod method) {
        index++;
        final bool isSelected = cartProvider.paymentMethod == method.id;

        return _MethodOption(
          onTap: () => cartProvider.paymentMethod = method.id,
          method: method,
          selected: isSelected,
          hasBorderRight: index == countMethods - 1,
          hasBorderLeft: index == 0,
        );
      }).toList(),
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
    @required this.onTap,
  }) : super(key: key);

  final PaymentMethod method;
  final bool selected;
  final bool hasBorderLeft;
  final bool hasBorderRight;
  final Function onTap;

  final borderLeft = const BorderRadius.only(
    bottomLeft: const Radius.circular(10.0),
    topLeft: const Radius.circular(10.0),
  );
  final borderRight = const BorderRadius.only(
    bottomRight: const Radius.circular(10.0),
    topRight: const Radius.circular(10.0),
  );

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline6.copyWith(
          fontWeight: FontWeight.w700,
          color: selected
              ? Colors.white
              : Theme.of(context).textTheme.bodyText1.color,
        );

    BorderRadius borderRadius;

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
        padding: const EdgeInsets.only(bottom: 3.0),
        decoration: BoxDecoration(
          color: darkColor,
          borderRadius: borderRadius,
        ),
        child: Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: Ink(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: normalColor,
              ),
              child: Text(
                method.value,
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
