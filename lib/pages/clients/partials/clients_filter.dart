import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class ClientsFilter extends StatefulWidget {
  @override
  _ClientsFilterState createState() => _ClientsFilterState();
}

class _ClientsFilterState extends State<ClientsFilter> {
  String dropdownValue = "Más recientes";
  final List<String> values = ["Más recientes"];

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.subtitle1;

    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Ordenar por:", style: textStyle),
          const SizedBox(width: 10.0),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            elevation: 16,
            style: textStyle,
            underline: Container(
              height: 2,
              color: CustomTheme.greyColor,
            ),
            onChanged: (String newValue) {
              setState(() => dropdownValue = newValue);
            },
            items: values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
