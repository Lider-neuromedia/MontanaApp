import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:montana_mobile/theme/theme.dart';

class QuotaExpansionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ampliación de cupo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TitleQuota(title: 'Realiza tu Solicitud', size: 30.0),
              SizedBox(height: 30.0),
              _LabelField(label: 'CLIENTE'),
              SizedBox(height: 10.0),
              _DropdownType(),
              SizedBox(height: 20.0),
              _LabelField(label: 'Adjuntar documento de identidad'),
              SizedBox(height: 10.0),
              _FileButton(value: '', onTap: () => print('file 1')),
              SizedBox(height: 20.0),
              _LabelField(label: 'Adjuntar RUT'),
              SizedBox(height: 10.0),
              _FileButton(value: '', onTap: () => print('file 2')),
              SizedBox(height: 20.0),
              _LabelField(label: 'Adjuntar cámara de comercio'),
              SizedBox(height: 10.0),
              _FileButton(value: '', onTap: () => print('file 3')),
              SizedBox(height: 30.0),
              _TitleQuota(
                title:
                    'Por favor coloque el monto por el cual desea solicitar ampliación de cupo',
                size: 20.0,
              ),
              SizedBox(height: 30.0),
              _LabelField(label: 'Monto'),
              SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.number,
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
              SizedBox(height: 30.0),
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
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileButton extends StatelessWidget {
  const _FileButton({
    Key key,
    @required this.value,
    @required this.onTap,
  }) : super(key: key);
  final String value;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        onTap: onTap,
        child: Ink(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CustomTheme.greyColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                    ),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Text(value),
                ),
              ),
              Container(
                height: 50.0,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Icon(
                  FontAwesome5.file_image,
                  color: Colors.white,
                ),
              )
            ],
          ),
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
  String value = 'Noreña Loaiza William';
  List<String> values = ['Noreña Loaiza William'];

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.w700,
        );
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: CustomTheme.greyColor,
        width: 1.0,
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

class _TitleQuota extends StatelessWidget {
  const _TitleQuota({
    Key key,
    @required this.title,
    @required this.size,
  }) : super(key: key);

  final String title;
  final double size;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.headline4.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
          fontSize: size,
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
