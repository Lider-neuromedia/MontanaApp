import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/session/reset_password_page.dart';

class PasswordPage extends StatelessWidget {
  static final String route = 'password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            emailInput(),
            SizedBox(height: 50.0),
            submitButton(context),
            SizedBox(height: 70.0),
            Text(
              'Si ya tiene el token para reiniciar su contraseña puede ir al formulario de reinicio de contraseña.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            resetFormButton(context)
          ],
        ),
      ),
    );
  }

  ElevatedButton resetFormButton(BuildContext context) {
    return ElevatedButton(
      child: Text('Formulario de Reinicio'),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).textTheme.bodyText1.color,
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(ResetPasswordPage.route);
      },
    );
  }

  Widget emailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'E-mail',
        hintText: 'example@mail.com',
      ),
      onChanged: (String value) {},
    );
  }

  Widget submitButton(BuildContext context) {
    return ElevatedButton(
      child: Text('Enviar Correo de Restauración'),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      ),
      onPressed: () {},
    );
  }
}
