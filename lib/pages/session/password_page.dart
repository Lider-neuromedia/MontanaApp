import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/session/reset_password_page.dart';
import 'package:montana_mobile/providers/PasswordProvider.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatelessWidget {
  static final String route = 'password';

  final TextEditingController _emailController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    PasswordProvider passwordProvider = Provider.of<PasswordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _EmailInput(
              controller: _emailController,
            ),
            SizedBox(height: 50.0),
            passwordProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  )
                : _SubmitButton(
                    onPressed: !passwordProvider.canSend
                        ? null
                        : () => _requestResetEmail(context, passwordProvider),
                  ),
            SizedBox(height: 70.0),
            Text(
              'Si ya tiene el token para reiniciar su contraseña puede ir al formulario de reinicio de contraseña.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            _ResetFormButton()
          ],
        ),
      ),
    );
  }

  Future<void> _requestResetEmail(
      BuildContext context, PasswordProvider passwordProvider) async {
    passwordProvider.isLoading = true;
    bool success = await passwordProvider.requestResetEmail();
    passwordProvider.isLoading = false;

    if (success) {
      _emailController.clear();
      _showSuccesDialog(context, () {
        Navigator.of(context).pushNamed(ResetPasswordPage.route);
      });
    } else {
      _showWarningDialog(context);
    }
  }

  Future<void> _showSuccesDialog(
      BuildContext context, Function onAccept) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Listo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Correo con token de reinicio de contraseña enviado.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: onAccept,
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showWarningDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aviso'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Correo incorrecto.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Enviar Correo de Restauración'),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    PasswordProvider passwordProvider = Provider.of<PasswordProvider>(context);
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: InputDecoration(
        labelText: 'E-mail',
        hintText: 'example@mail.com',
        errorText: passwordProvider.emailError,
      ),
      onChanged: (String value) {
        passwordProvider.email = value;
      },
    );
  }
}

class _ResetFormButton extends StatelessWidget {
  const _ResetFormButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Formulario de Reinicio'),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).textTheme.bodyText1.color,
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(ResetPasswordPage.route);
      },
    );
  }
}
