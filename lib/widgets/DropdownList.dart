import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class DropdownList extends StatefulWidget {
  const DropdownList({
    Key key,
    @required this.onChanged,
    @required this.value,
    @required this.items,
  }) : super(key: key);

  final void Function(dynamic) onChanged;
  final dynamic value;
  final List<Map<String, dynamic>> items;

  @override
  _DropdownListState createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.w700,
        );
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: CustomTheme.greyColor,
        width: 1.0,
      ),
    );

    return DropdownButtonFormField(
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        border: border,
        enabledBorder: border,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 0.0,
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
      isExpanded: true,
      style: valueStyle,
      elevation: 16,
      iconSize: 24,
      value: widget.value,
      items: widget.items
          .map((item) => DropdownMenuItem<dynamic>(
                value: item['id'],
                child: Text(item['value']),
              ))
          .toList(),
    );
  }
}
