import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  static final String route = 'reset_password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reiniciar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            tokenInput(),
            SizedBox(height: 30.0),
            emailInput(),
            SizedBox(height: 30.0),
            passwordInput('Contraseña'),
            SizedBox(height: 30.0),
            passwordInput('Confirmar Contraseña'),
            SizedBox(height: 30.0),
            submitButton(context),
          ],
        ),
      ),
    );
  }

  Widget tokenInput() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Token de Reinicio',
        hintText: '3x4mp13',
      ),
      onChanged: (String value) {},
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

  Widget passwordInput(String label) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: (String value) {},
    );
  }

  Widget submitButton(BuildContext context) {
    return ElevatedButton(
      child: Text('Reiniciar Contraseña'),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      ),
      onPressed: () {},
    );
  }
}
