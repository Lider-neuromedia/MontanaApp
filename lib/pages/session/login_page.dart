import 'package:flutter/material.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/pages/home/home_page.dart';
import 'package:montana_mobile/pages/session/password_page.dart';
import 'package:montana_mobile/providers/login_provider.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/utils/utils.dart';

class LoginPage extends StatelessWidget {
  static final String route = "login";

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: mediaSize.height * 0.2 * -1,
            child: _BackgroundBox(),
            right: 0.0,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    const _BackgroundLogo(),
                    const SizedBox(height: 30.0),
                    LoginCard(),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

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
  const _BackgroundLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: const AssetImage("assets/images/logo.png"),
      fit: BoxFit.contain,
      width: 200.0,
    );
  }
}

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _emailController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  LoginProvider _loginProvider;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    _loginProvider = Provider.of<LoginProvider>(context);

    return Container(
      width: mediaSize.width > 400 ? 400 : mediaSize.width,
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
              const _LoginTitle(),
              const SizedBox(height: 30.0),
              _EmailInput(controller: _emailController),
              const SizedBox(height: 30.0),
              _PasswordInput(controller: _passwordController),
              _ForgetPasswordButton(),
              const SizedBox(height: 30.0),
              _loginProvider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    )
                  : _SubmitLoginButton(
                      label: "Iniciar Sesi??n",
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
    final preferences = Preferences();
    await _loginProvider.login();
    _loginProvider.isLoading = false;

    if (preferences.token == null) {
      showMessageDialog(context, "Aviso", "Usuario y contrase??a incorrectos.");
      return;
    }

    _emailController.clear();
    _passwordController.clear();
    _loginProvider.email = "";
    _loginProvider.password = "";

    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.currentPage = 0;
    Navigator.of(context).pushReplacementNamed(HomePage.route);

    ConnectionProvider.syncDataNow(context);
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
        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
    final loginProvider = Provider.of<LoginProvider>(context);

    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Contrase??a",
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
    final loginProvider = Provider.of<LoginProvider>(context);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Usuario",
        hintText: "example@mail.com",
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
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: Text("Olvid?? mi contrase??a"),
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
  const _LoginTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Iniciar Sesi??n",
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
