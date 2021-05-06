import 'package:flutter/material.dart';
import 'package:montana_mobile/theme/theme.dart';

class StartOrderModal extends StatelessWidget {
  const StartOrderModal({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 2,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Center(
        child: Container(
          width: size.width > 320.0 ? 320.0 : double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _TitleModal(title: 'Comienza tu pedido'),
              _FieldBox(
                children: [
                  _LabelField(label: 'CLIENTE'),
                  SizedBox(height: 10.0),
                  _DropdownList(
                    values: [
                      'Noreña Loaiza William',
                      'Otro Cliente',
                    ],
                  ),
                ],
              ),
              _FieldBox(
                children: [
                  _LabelField(label: 'CATALOGO'),
                  SizedBox(height: 10.0),
                  _DropdownList(
                    values: [
                      'Catalogo 1',
                      'Catalogo 2',
                      'Catalogo 3',
                    ],
                  ),
                ],
              ),
              _ContinueButton(
                icon: Icons.add,
                label: 'Continuar',
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleModal extends StatelessWidget {
  const _TitleModal({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline4.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.bold,
        );

    return Text(
      title,
      style: titleStyle,
      textAlign: TextAlign.center,
    );
  }
}

class _FieldBox extends StatelessWidget {
  const _FieldBox({
    Key key,
    @required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _LabelField extends StatelessWidget {
  const _LabelField({
    Key key,
    this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Theme.of(context).primaryColor,
        );
    return Text(label, style: labelStyle);
  }
}

class _DropdownList extends StatefulWidget {
  _DropdownList({
    Key key,
    this.values,
  }) : super(key: key);

  final List<String> values;

  @override
  __DropdownListState createState() => __DropdownListState();
}

class __DropdownListState extends State<_DropdownList> {
  String value;

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.w700,
        );
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: CustomTheme.greyColor,
        ),
      ),
      child: DropdownButton<String>(
        icon: const Icon(Icons.keyboard_arrow_down),
        underline: Container(height: 0),
        isExpanded: true,
        style: valueStyle,
        elevation: 16,
        iconSize: 24,
        value: value,
        onChanged: (String newValue) {
          setState(() => value = newValue);
        },
        items: widget.values.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            child: Text(value),
            value: value,
          );
        }).toList(),
      ),
    );
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
                  color: CustomTheme.greyColor,
                  offset: Offset(2.0, 0.0),
                ),
              ],
            ),
            padding: EdgeInsets.all(15.0),
            child: Icon(icon, color: Colors.white),
          ),
          Text(label),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Icon(icon, color: Colors.transparent),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(
          left: 0.0,
          right: 10.0,
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
