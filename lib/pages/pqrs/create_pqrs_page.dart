import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class CreatePqrsPage extends StatelessWidget {
  static final String route = '/create-pqrs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PQRS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TitlePqrs(title: 'Nuevo PQRS'),
            SizedBox(height: 25.0),
            _LabelField(label: 'Tipo de PQRS'),
            SizedBox(height: 10.0),
            _DropdownType(),
            SizedBox(height: 20.0),
            _LabelField(label: 'Mensaje'),
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
            SizedBox(height: 40.0),
            Center(
              child: SizedBox(
                width: 160.0,
                child: _ContinueButton(
                  label: 'Enviar',
                  icon: Icons.arrow_forward,
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownType extends StatefulWidget {
  const _DropdownType({
    Key key,
  }) : super(key: key);

  @override
  __DropdownTypeState createState() => __DropdownTypeState();
}

class __DropdownTypeState extends State<_DropdownType> {
  String value = 'Queja por retrasos';
  List<String> values = ['Queja por retrasos'];

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.w700,
        );

    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: CustomTheme.greyColor,
        width: 2.0,
      ),
    );

    return DropdownButtonFormField(
      icon: const Icon(Icons.keyboard_arrow_down),
      isExpanded: true,
      style: valueStyle,
      elevation: 16,
      iconSize: 24,
      value: value,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 0.0,
        ),
        enabledBorder: border,
        border: border,
      ),
      onChanged: (String newValue) {
        setState(() => value = newValue);
      },
      items: values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          child: Text(value, style: Theme.of(context).textTheme.bodyText1),
          value: value,
        );
      }).toList(),
    );
  }
}

class _TitlePqrs extends StatelessWidget {
  const _TitlePqrs({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.headline4.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );
    return Text(
      title,
      textAlign: TextAlign.center,
      style: titleStyle,
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

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3.0,
                  color: Colors.red,
                  offset: Offset(2.0, 0.0),
                ),
              ],
            ),
            padding: EdgeInsets.all(5.0),
            child: Icon(icon, color: Colors.white),
          ),
          Text(label),
          Container(
            width: 30,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(icon, color: Colors.transparent),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(
          left: 0.0,
          right: 0.0,
        ),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: Theme.of(context).primaryColor,
      ),
    );
  }
}
