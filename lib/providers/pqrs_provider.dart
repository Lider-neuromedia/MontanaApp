import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/message.dart';
import 'package:montana_mobile/models/ticket.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:montana_mobile/utils/utils.dart';

class PqrsProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final List<SortValue> sortValues = _sortValues;
  final _preferences = Preferences();

  String _sortBy;
  String get sortBy => _sortBy;

  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

  Ticket _ticket;
  Ticket get ticket => _ticket;

  bool _isLoadingTickets = false;
  bool get isLoadingTickets => _isLoadingTickets;

  set isLoadingTickets(bool value) {
    _isLoadingTickets = value;
    notifyListeners();
  }

  bool _isLoadingTicket = false;
  bool get isLoadingTicket => _isLoadingTicket;

  set isLoadingTicket(bool value) {
    _isLoadingTicket = value;
    notifyListeners();
  }

  bool _isLoadingMessages = false;
  bool get isLoadingMessages => _isLoadingMessages;

  set isLoadingMessages(bool value) {
    _isLoadingMessages = value;
    notifyListeners();
  }

  bool _isLoadingMessage = false;
  bool get isLoadingMessage => _isLoadingMessage;

  set isLoadingMessage(bool value) {
    _isLoadingMessage = value;
    notifyListeners();
  }

  set sortBy(String value) {
    _sortBy = value;
    _sortTickets();
    notifyListeners();
  }

  void _sortTickets() {
    _tickets.sort((Ticket ticket, Ticket previus) {
      if (_sortBy == SortValue.RECENT_FIRST) {
        return ticket.fechaRegistro.compareTo(previus.fechaRegistro) * -1;
      }
      if (_sortBy == SortValue.LAST_FIRST) {
        return ticket.fechaRegistro.compareTo(previus.fechaRegistro);
      }
      if (_sortBy == SortValue.STATUS) {
        return ticket.estado.compareTo(previus.estado);
      }
      if (_sortBy == SortValue.STATUS_REVERSE) {
        return ticket.estado.compareTo(previus.estado) * -1;
      }
      return 0;
    });
  }

  String _search = "";
  String get search => _search;
  bool get isSearchActive => _search.isNotEmpty && searchTickets.length == 0;

  set search(String value) {
    _search = value.toLowerCase();
    notifyListeners();
  }

  List<Ticket> get searchTickets {
    return _tickets.where((ticket) {
      bool match = false;
      String nombreCliente = "${ticket.clienteNombre.toLowerCase()}";
      String nombreVendedor = "${ticket.vendedorNombre.toLowerCase()}";
      String codigo = "${ticket.codigo}";
      String estado = "${ticket.estado}";
      String fechaRegistro = "${formatDate(ticket.fechaRegistro)}";
      String idPqrs = "${ticket.idPqrs}";

      if (nombreCliente.indexOf(_search) != -1 ||
          nombreVendedor.indexOf(_search) != -1 ||
          codigo.indexOf(_search) != -1 ||
          estado.indexOf(_search) != -1 ||
          fechaRegistro.indexOf(_search) != -1 ||
          idPqrs.indexOf(_search) != -1) {
        match = true;
      }

      return match;
    }).toList();
  }

  Future<void> addCreatedMessage(Mensaje mensaje) async {
    _isLoadingTicket = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 100));

    _ticket.mensajes.add(mensaje);
    _ticket.mensajes.sort((Mensaje mensaje, Mensaje previus) {
      return mensaje.createdAt.compareTo(previus.createdAt) * -1;
    });

    _isLoadingTicket = false;
    notifyListeners();
  }

  Future<void> loadTickets({@required bool local}) async {
    _tickets = [];
    _sortBy = SortValue.RECENT_FIRST;
    _isLoadingTickets = true;
    notifyListeners();

    _tickets = local ? await getTicketsLocal() : await getTickets();

    _sortTickets();
    _isLoadingTickets = false;
    notifyListeners();
  }

  Future<void> loadTicket(int id, {@required bool local}) async {
    _ticket = null;
    _isLoadingTicket = true;
    notifyListeners();

    _ticket = local
        ? await getTicketWithMessagesLocal(id)
        : await getTicketWithMessages(id);

    _ticket.mensajes.sort((Mensaje mensaje, Mensaje previus) {
      return mensaje.createdAt.compareTo(previus.createdAt) * -1;
    });

    _isLoadingTicket = false;
    notifyListeners();
  }

  Future<List<Ticket>> getTickets() async {
    final url = Uri.parse("$_url/pqrs");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseTicketsFromJson(response.body).tickets;
  }

  Future<List<Ticket>> getTicketsLocal() async {
    // TODO: No implementado y no es necesario, el id se genera en el backend.
    return [];
  }

  Future<Ticket> getTicketWithMessages(int id) async {
    final url = Uri.parse("$_url/pqrs/$id");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseTicketFromJson(response.body).ticket;
  }

  Future<Ticket> getTicketWithMessagesLocal(int id) async {
    // TODO: No implementado porque se ocultaron todas las opciones de pqrs.
    return null;
  }
}

class SortValue {
  static const RECENT_FIRST = "1";
  static const LAST_FIRST = "2";
  static const STATUS = "3";
  static const STATUS_REVERSE = "4";

  String id;
  String value;

  SortValue(this.id, this.value);
}

final List<SortValue> _sortValues = [
  SortValue(SortValue.RECENT_FIRST, "M??s recientes"),
  SortValue(SortValue.LAST_FIRST, "M??s antiguos"),
  SortValue(SortValue.STATUS, "Abiertos primero"),
  SortValue(SortValue.STATUS_REVERSE, "Cerrados primero"),
];
