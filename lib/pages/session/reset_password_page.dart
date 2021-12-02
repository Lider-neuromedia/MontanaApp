import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/session/login_page.dart';
import 'package:montana_mobile/providers/reset_password_provider.dart';
import 'package:montana_mobile/utils/utils.dart';

class ResetPasswordPage extends StatelessWidget {
  static final String route = 'reset_password';

  final _tokenController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _passwordConfirmationController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final resetPasswordProvider = Provider.of<ResetPasswordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reiniciar Contraseña'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _TokenInput(controller: _tokenController),
          const SizedBox(height: 30.0),
          _EmailInput(controller: _emailController),
          const SizedBox(height: 30.0),
          _PasswordInput(controller: _passwordController),
          const SizedBox(height: 30.0),
          _PasswordConfirmationInput(
              controller: _passwordConfirmationController),
          const SizedBox(height: 30.0),
          resetPasswordProvider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                )
              : _SubmitButton(
                  onPressed: !resetPasswordProvider.canSend
                      ? null
                      : () => _resetPassword(context, resetPasswordProvider),
                ),
        ],
      ),
    );
  }

  Future<void> _resetPassword(
      BuildContext context, ResetPasswordProvider provider) async {
    provider.isLoading = true;
    bool success = await provider.resetPassword();
    provider.isLoading = false;

    if (success) {
      _tokenController.clear();
      _emailController.clear();
      _passwordController.clear();
      _passwordConfirmationController.clear();

      provider.token = '';
      provider.email = '';
      provider.password = '';
      provider.passwordConfirmation = '';

      showMessageDialog(
        context,
        'Listo',
        'Contraseña actualizada correctamente, ahora puede iniciar sesión.',
        onAccept: () {
          Navigator.of(context).pushReplacementNamed(LoginPage.route);
        },
      );
    } else {
      showMessageDialog(context, 'Aviso', 'Datos de reinicio incorrectos.');
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
      child: Text('Reiniciar Contraseña'),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 12.0,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final resetPasswordProvider = Provider.of<ResetPasswordProvider>(context);

    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        errorText: resetPasswordProvider.passwordError,
      ),
      onChanged: (String value) {
        resetPasswordProvider.password = value;
      },
    );
  }
}

class _PasswordConfirmationInput extends StatelessWidget {
  const _PasswordConfirmationInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final resetPasswordProvider = Provider.of<ResetPasswordProvider>(context);

    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirmar Contraseña',
        errorText: resetPasswordProvider.passwordConfirmationError,
      ),
      onChanged: (String value) {
        resetPasswordProvider.passwordConfirmation = value;
      },
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
    final resetPasswordProvider = Provider.of<ResetPasswordProvider>(context);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'E-mail',
        hintText: 'example@mail.com',
        errorText: resetPasswordProvider.emailError,
      ),
      onChanged: (String value) {
        resetPasswordProvider.email = value;
      },
    );
  }
}

class _TokenInput extends StatelessWidget {
  const _TokenInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final resetPasswordProvider = Provider.of<ResetPasswordProvider>(context);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Token de Reinicio',
        hintText: '3x4mp13',
        errorText: resetPasswordProvider.tokenError,
      ),
      onChanged: (String value) {
        resetPasswordProvider.token = value;
      },
    );
  }
}
