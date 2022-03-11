import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/utils/preferences.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token;

  static Future<void> initializeApp() async {
    // TODO: Inicialización de Firebase deshabilitada porque no se va a usar.
    // await Firebase.initializeApp();
    // token = await FirebaseMessaging.instance.getToken();

    // FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    // FirebaseMessaging.onMessage.listen(_onMessageHandler);
    // FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // final preferences = Preferences();

    // if (preferences.token != null) {
    //   await PushNotificationService.saveDeviceToken();
    // }
  }

  // static Future<void> _onBackgroundHandler(RemoteMessage message) async {
  //   _messageStreamController.add(message);
  // }

  // static Future<void> _onMessageHandler(RemoteMessage message) async {
  //   _messageStreamController.add(message);
  // }

  // static Future<void> _onMessageOpenApp(RemoteMessage message) async {
  //   _messageStreamController.add(message);
  // }

  static StreamController<RemoteMessage> _messageStreamController =
      new StreamController.broadcast();
  static Stream<RemoteMessage> get messageStream =>
      _messageStreamController.stream;

  static closeStream() {
    _messageStreamController.close();
  }

  static Future<bool> saveDeviceToken() async {
    final preferences = Preferences();
    final backendUrl = dotenv.env["API_URL"];
    final url = Uri.parse("$backendUrl/devices");

    final Map<String, String> data = {
      "device_token": token,
    };

    if (token == null) return false;
    if (token.isEmpty) return false;

    try {
      final response = await http.post(
        url,
        headers: preferences.signedHeaders,
        body: json.encode(data),
      );
      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }
}
