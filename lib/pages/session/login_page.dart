import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/home/home_page.dart';
import 'package:montana_mobile/pages/session/password_page.dart';
import 'package:montana_mobile/providers/login_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static final String route = 'login';

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0.0,
            top: mediaSize.height * 0.2 * -1,
            child: _BackgroundBox(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BackgroundLogo(),
              SizedBox(height: 30.0),
              LoginCard(),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackgroundBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.skewY(0.15),
      child: Container(
        color: Theme.of(context).primaryColor,
        height: mediaSize.height * 0.70,
        width: mediaSize.width,
      ),
    );
  }
}

class _BackgroundLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return Image(
      image: AssetImage("assets/images/logo.png"),
      fit: BoxFit.contain,
      width: mediaSize.width / 2,
    );
  }
}

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  LoginProvider _loginProvider;
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    _loginProvider = Provider.of<LoginProvider>(context);

    return Container(
      width: mediaSize.width > 400 ? 400 : mediaSize.width,
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 30.0,
            bottom: 30.0,
            right: 30.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LoginTitle(),
              SizedBox(height: 30.0),
              _EmailInput(controller: _emailController),
              SizedBox(height: 30.0),
              _PasswordInput(controller: _passwordController),
              _ForgetPasswordButton(),
              SizedBox(height: 30.0),
              _loginProvider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    )
                  : _SubmitLoginButton(
                      label: 'Iniciar Sesión',
                      onPressed: !_loginProvider.canSend
                          ? null
                          : () => _login(context),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    _loginProvider.isLoading = true;
    await _loginProvider.login();
    _loginProvider.isLoading = false;

    final preferences = Preferences();

    if (preferences.token != null) {
      _emailController.clear();
      _passwordController.clear();
      Navigator.of(context).pushReplacementNamed(HomePage.route);
    } else {
      _showWarningDialog(context);
    }
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
                Text('Usuario y contraseña incorrectos.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class _SubmitLoginButton extends StatelessWidget {
  const _SubmitLoginButton({
    Key key,
    @required this.onPressed,
    @required this.label,
  }) : super(key: key);

  final String label;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 20.0),
      ),
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
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        errorText: loginProvider.passwordError,
      ),
      onChanged: (String value) {
        loginProvider.password = value;
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
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Usuario',
        hintText: 'example@mail.com',
        errorText: loginProvider.emailError,
      ),
      onChanged: (String value) {
        loginProvider.email = value;
      },
    );
  }
}

class _ForgetPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: Text('Olvidé mi contraseña'),
            onPressed: () {
              Navigator.of(context).pushNamed(PasswordPage.route);
            },
          )
        ],
      ),
    );
  }
}

class _LoginTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Iniciar Sesión',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
