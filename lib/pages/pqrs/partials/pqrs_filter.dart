import 'package:flutter/material.dart';
import 'package:montana_mobile/providers/pqrs_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:provider/provider.dart';

class PqrsFilter extends StatefulWidget {
  @override
  _PqrsFilterState createState() => _PqrsFilterState();
}

class _PqrsFilterState extends State<PqrsFilter> {
  @override
  Widget build(BuildContext context) {
    final pqrsProvider = Provider.of<PqrsProvider>(context);
    final textStyle = Theme.of(context).textTheme.subtitle1;

    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Ordenar por:', style: textStyle),
          const SizedBox(width: 10.0),
          DropdownButton<String>(
            value: pqrsProvider.sortBy,
            icon: const Icon(Icons.keyboard_arrow_down),
            style: textStyle,
            elevation: 16,
            iconSize: 24,
            underline: Container(
              color: CustomTheme.greyColor,
              height: 2,
            ),
            onChanged: (String newValue) {
              setState(() => pqrsProvider.sortBy = newValue);
            },
            items: pqrsProvider.sortValues
                .map<DropdownMenuItem<String>>((SortValue value) {
              return DropdownMenuItem<String>(
                child: Text(value.value),
                value: value.id,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
