import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class FormInput extends StatelessWidget {
  const FormInput({
    Key key,
    @required this.controller,
    @required this.onChanged,
    @required this.error,
    this.label,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String) onChanged;
  final String label;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelField(label: label),
        const SizedBox(height: 5.0),
        TextField(
          keyboardType: TextInputType.text,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: const EdgeInsets.all(10.0),
            errorText: error,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomTheme.greyColor,
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
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
