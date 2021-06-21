import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/providers/validation_field.dart';
import 'package:montana_mobile/utils/preferences.dart';

class StoreProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  final _preferences = Preferences();

  void clear() {
    _stores = [];
    _nombre = ValidationField();
    _lugar = ValidationField();
    _local = ValidationField();
    _direccion = ValidationField();
    _telefono = ValidationField();
    notifyListeners();
  }

  List<Tienda> _stores = [];
  List<Tienda> get stores => _stores;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  ValidationField _nombre = ValidationField();
  String get nombre => _nombre.value;
  String get nombreError => _nombre.error;

  set nombre(String value) {
    final errorLength = ValidationField.validateLength(value, max: 45);

    if (errorLength != null) {
      _nombre = ValidationField(error: errorLength);
    } else {
      _nombre = ValidationField(value: value);
    }

    notifyListeners();
  }

  ValidationField _lugar = ValidationField();
  String get lugar => _lugar.value;
  String get lugarError => _lugar.error;

  set lugar(String value) {
    final errorLength = ValidationField.validateLength(value, max: 45);

    if (errorLength != null) {
      _lugar = ValidationField(error: errorLength);
    } else {
      _lugar = ValidationField(value: value);
    }

    notifyListeners();
  }

  ValidationField _local = ValidationField();
  String get local => _local.value;
  String get localError => _local.error;

  set local(String value) {
    final errorLength = ValidationField.validateLength(value, max: 20);

    if (errorLength != null) {
      _local = ValidationField(error: errorLength);
    } else {
      _local = ValidationField(value: value);
    }

    notifyListeners();
  }

  ValidationField _direccion = ValidationField();
  String get direccion => _direccion.value;
  String get direccionError => _direccion.error;

  set direccion(String value) {
    final errorLength = ValidationField.validateLength(value, max: 50);

    if (errorLength != null) {
      _direccion = ValidationField(error: errorLength);
    } else {
      _direccion = ValidationField(value: value);
    }

    notifyListeners();
  }

  ValidationField _telefono = ValidationField();
  String get telefono => _telefono.value;
  String get telefonoError => _telefono.error;

  set telefono(String value) {
    final errorLength = ValidationField.validateLength(value, max: 20);

    if (errorLength != null) {
      _telefono = ValidationField(error: errorLength);
    } else {
      _telefono = ValidationField(value: value);
    }

    notifyListeners();
  }

  void addStore() {
    final store = Tienda(
      nombre: _nombre.value,
      lugar: _lugar.value,
      local: _local.value,
      direccion: _direccion.value,
      telefono: _telefono.value,
    );

    _stores.add(store);

    _nombre = ValidationField();
    _lugar = ValidationField();
    _local = ValidationField();
    _direccion = ValidationField();
    _telefono = ValidationField();

    notifyListeners();
  }

  void removeStore(index) {
    stores.removeAt(index);
    notifyListeners();
  }

  bool get canAddStore {
    if (_nombre.isEmptyOrHasError()) return false;
    if (_lugar.isEmptyOrHasError()) return false;
    if (_local.hasError()) return false;
    if (_direccion.hasError()) return false;
    if (_telefono.hasError()) return false;
    return true;
  }

  bool get canSend {
    if (_isLoading) return false;
    if (_stores.length == 0) return false;

    return true;
  }

  Future<bool> saveStores() async {
    final url = Uri.parse('$_url/tiendas');
    final Map<String, dynamic> data = {
      'cliente': _preferences.session.id,
      'tiendas': _stores
          .map<Map<String, dynamic>>(
            (store) => store.createStoreToJson(),
          )
          .toList(),
    };

    final response = await http.post(
      url,
      headers: _preferences.signedHeaders,
      body: json.encode(data),
    );

    print(response.body);

    return response.statusCode == 200;
  }
}
