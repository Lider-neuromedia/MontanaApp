import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/session/reset_password_page.dart';
import 'package:montana_mobile/providers/password_provider.dart';
import 'package:montana_mobile/utils/utils.dart';

class PasswordPage extends StatelessWidget {
  static final String route = "password";

  final _emailController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Restablecer Contraseña"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _EmailInput(
              controller: _emailController,
            ),
            const SizedBox(height: 50.0),
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
            const SizedBox(height: 70.0),
            Text(
              "Si ya tiene el token para reiniciar su contraseña puede ir al formulario de reinicio de contraseña.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            _ResetFormButton()
          ],
        ),
      ),
    );
  }

  Future<void> _requestResetEmail(
      BuildContext context, PasswordProvider provider) async {
    provider.isLoading = true;
    bool success = await provider.requestResetEmail();
    provider.isLoading = false;

    if (success) {
      _emailController.clear();
      provider.email = "";

      showMessageDialog(
        context,
        "Listo",
        "Correo con token de reinicio de contraseña enviado.",
        onAccept: () {
          Navigator.of(context).pushNamed(ResetPasswordPage.route);
        },
      );
    } else {
      showMessageDialog(context, "Aviso", "Correo incorrecto.");
    }
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
      child: Text("Enviar Correo de Restauración"),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
    final passwordProvider = Provider.of<PasswordProvider>(context);

    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: InputDecoration(
        labelText: "E-mail",
        hintText: "example@mail.com",
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
      child: Text("Formulario de Reinicio"),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).textTheme.bodyText1.color,
        padding: const EdgeInsets.symmetric(
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
