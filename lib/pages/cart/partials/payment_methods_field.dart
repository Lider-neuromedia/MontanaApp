import 'package:flutter/material.dart';
import 'package:montana_mobile/providers/cart_provider.dart';
import 'package:montana_mobile/theme/theme.dart';

class SwitchMethodsField<T> extends StatelessWidget {
  const SwitchMethodsField({
    Key key,
    @required this.cartProvider,
    @required this.list,
    @required this.currentValue,
    @required this.onTap,
  }) : super(key: key);

  final CartProvider cartProvider;
  final List<SwitchMethod> list;
  final String currentValue;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final countMethods = cartProvider.paymentMethods.length;
    int index = -1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list.map<_MethodOption>((SwitchMethod method) {
        index++;
        return _MethodOption(
          onTap: () => onTap(method.id),
          label: method.value,
          selected: currentValue == method.id,
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
    @required this.label,
    @required this.selected,
    @required this.hasBorderLeft,
    @required this.hasBorderRight,
    @required this.onTap,
  }) : super(key: key);

  final String label;
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
                label,
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
