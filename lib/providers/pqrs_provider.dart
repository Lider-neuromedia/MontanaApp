import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/ticket.dart';
import 'package:montana_mobile/utils/preferences.dart';

class PqrsProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];

  PqrsProvider() {
    loadTickets();
  }

  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

  bool _isLoadingTickets = false;
  bool _isLoadingTicket = false;
  bool _isLoadingMessages = false;
  bool _isLoadingMessage = false;
  bool get isLoadingTickets => _isLoadingTickets;
  bool get isLoadingTicket => _isLoadingTicket;
  bool get isLoadingMessages => _isLoadingMessages;
  bool get isLoadingMessage => _isLoadingMessage;

  set isLoadingTickets(bool value) {
    _isLoadingTickets = value;
    notifyListeners();
  }

  set isLoadingMessages(bool value) {
    _isLoadingMessages = value;
    notifyListeners();
  }

  set isLoadingTicket(bool value) {
    _isLoadingTicket = value;
    notifyListeners();
  }

  set isLoadingMessage(bool value) {
    _isLoadingMessage = value;
    notifyListeners();
  }

  Future<void> loadTickets() async {
    _tickets = [];
    _isLoadingTickets = true;
    notifyListeners();
    _tickets = await getTickets();
    _isLoadingTickets = false;
    notifyListeners();
  }

  Future<List<Ticket>> getTickets() async {
    final preferences = Preferences();
    final url = Uri.parse('$_url/pqrs');
    final response = await http.get(url, headers: preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseTicketsFromJson(response.body).tickets;
  }
}
