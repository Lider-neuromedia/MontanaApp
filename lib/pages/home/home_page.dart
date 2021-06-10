import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/providers/pqrs_provider.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:montana_mobile/models/session.dart';
import 'package:montana_mobile/pages/session/login_page.dart';
import 'package:montana_mobile/providers/session_provider.dart';
import 'package:montana_mobile/services/push_notification_service.dart';
import 'package:montana_mobile/pages/home/partials/bottom_drawer.dart';
import 'package:montana_mobile/pages/home/partials/navigation_bar.dart';
import 'package:montana_mobile/pages/home/partials/pages.dart';
import 'package:montana_mobile/providers/navigation_provider.dart';

class HomePage extends StatefulWidget {
  static final String route = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    PushNotificationService.messageStream.listen((message) {
      final _navigationProvider = Provider.of<NavigationProvider>(
        context,
        listen: false,
      );

      if (message.data['type'] == 'pqrs-message') {
        final isCurrentRoute = ModalRoute.of(context).isCurrent;

        if (isCurrentRoute) {
          ScaffoldMessenger.of(context).showSnackBar(snackbar(
            message.notification.title,
            message.notification.body,
            label: 'Aceptar',
            action: () {},
          ));
        }

        if (isCurrentRoute && _navigationProvider.currentPage == 5) {
          final pqrsProvider = Provider.of<PqrsProvider>(
            context,
            listen: false,
          );
          pqrsProvider.loadTickets();
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      () async {
        final isValid = await SessionProvider().isUserSessionValid();

        if (!isValid) {
          Navigator.of(context).pushReplacementNamed(LoginPage.route);
        }
      }();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Pages(rol: Session.rolSeller),
          BottomDrawer(rol: Session.rolSeller),
        ],
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }
}
