import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/home_page.dart';
import 'package:montana_mobile/pages/session/password_page.dart';
import 'package:montana_mobile/providers/LoginProvider.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static final String route = 'login';

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: 0.0,
              top: mediaSize.height * 0.2 * -1,
              child: backgroundBox(context, mediaSize),
            ),
            Positioned(
              left: mediaSize.width / 4,
              top: mediaSize.height * 0.18,
              child: backgroundLogo(mediaSize),
            ),
            Center(
              child: LoginCard(),
            )
          ],
        ),
      ),
    );
  }

  Widget backgroundLogo(Size mediaSize) {
    return Image(
      image: AssetImage("assets/images/logo.png"),
      fit: BoxFit.contain,
      width: mediaSize.width / 2,
    );
  }

  Widget backgroundBox(BuildContext context, Size mediaSize) {
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

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  LoginProvider _loginProvider;
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    _loginProvider = Provider.of<LoginProvider>(context);

    return Container(
      margin: EdgeInsets.only(top: mediaSize.height * 0.15),
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
              Center(
                child: Text(
                  'Iniciar Sesión',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(height: 30.0),
              emailInput(),
              SizedBox(height: 30.0),
              passwordInput(),
              forgetPasswordButton(context),
              SizedBox(height: 30.0),
              submitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget forgetPasswordButton(BuildContext context) {
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

  Widget emailInput() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Usuario',
        hintText: 'example@mail.com',
      ),
      onChanged: (String value) {
        _loginProvider.email = value;
      },
    );
  }

  Widget passwordInput() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Contraseña',
      ),
      onChanged: (String value) {
        _loginProvider.password = value;
      },
    );
  }

  Widget submitButton(BuildContext context) {
    return ElevatedButton(
      child: Text(_loginProvider.isLoading ? 'Cargando...' : 'Iniciar Sesión'),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 20.0),
      ),
      onPressed:
          _loginProvider.isLoginDataValid && _loginProvider.isLoading == false
              ? login
              : null,
    );
  }

  Future<void> login() async {
    await _loginProvider.login();
    final preferences = Preferences();

    if (preferences.token != null) {
      _emailController.text = '';
      _passwordController.text = '';
      _loginProvider.email = '';
      _loginProvider.password = '';
      Navigator.of(context).pushReplacementNamed(HomePage.route);
    } else {
      print('bad');
    }
  }
}
