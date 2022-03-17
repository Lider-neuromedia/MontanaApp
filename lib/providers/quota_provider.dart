import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/providers/validation_field.dart';
import 'package:montana_mobile/utils/preferences.dart';

class QuotaProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  QuotaRequest _quota = QuotaRequest();
  QuotaRequest get quota => _quota;

  File get docIdentidad => _quota.docIdentidad;
  String get descriptionIdentidad => _getFileName(_quota.docIdentidad);

  set docIdentidad(File value) {
    _quota.docIdentidad = value;
    notifyListeners();
  }

  File get docRut => _quota.docRut;
  String get descriptionRut => _getFileName(_quota.docRut);

  set docRut(File value) {
    _quota.docRut = value;
    notifyListeners();
  }

  File get docCamaraCom => _quota.docCamaraCom;
  String get descriptionCamaraCom => _getFileName(_quota.docCamaraCom);

  set docCamaraCom(File value) {
    _quota.docCamaraCom = value;
    notifyListeners();
  }

  int get clienteId => _quota.clienteId;

  set clienteId(int value) {
    _quota.clienteId = value;
    notifyListeners();
  }

  ValidationField _monto = ValidationField();
  String get monto => _monto.value;
  String get montoError => _monto.error;
  TextEditingController _montoController = TextEditingController(text: "0");
  TextEditingController get montoController => _montoController;

  set monto(String value) {
    final errorInteger = ValidationField.validateInteger(value);
    final errorIntRange = ValidationField.validateIntRange(value, min: 0);
    _quota.monto = null;

    if (errorInteger != null) {
      _monto = ValidationField(error: errorInteger);
    } else if (errorIntRange != null) {
      _monto = ValidationField(error: errorIntRange);
    } else {
      _monto = ValidationField(value: value);
      _quota.monto = "${_monto.value}";
    }

    notifyListeners();
  }

  List<Usuario> _clientes = [];
  List<Usuario> get clientes => _clientes;

  set clientes(List<Usuario> list) {
    _clientes = list;
    notifyListeners();
  }

  String _getFileName(File file) {
    if (file == null) return null;
    List list = List.from(file.path.split("/").reversed);
    return list[0];
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get canSend {
    if (_isLoading) return false;
    if (_monto.isEmptyOrHasError()) return false;
    if (_preferences.session.isVendedor && clienteId == null) return false;

    if (_quota.monto == null) return false;
    if (_quota.docIdentidad == null) return false;
    if (_quota.docRut == null) return false;
    if (_quota.docCamaraCom == null) return false;
    return true;
  }

  Future<bool> createQuotaExpansion(QuotaRequest pQuota) async {
    final fileDocIdentidad = await http.MultipartFile.fromPath(
      "doc_identidad",
      pQuota.docIdentidad.path,
      contentType: MediaType(
        mime(pQuota.docIdentidad.path).split("/")[0],
        mime(pQuota.docIdentidad.path).split("/")[1],
      ),
    );
    final fileDocRut = await http.MultipartFile.fromPath(
      "doc_rut",
      pQuota.docRut.path,
      contentType: MediaType(
        mime(pQuota.docRut.path).split("/")[0],
        mime(pQuota.docRut.path).split("/")[1],
      ),
    );
    final fileDocCamaraCom = await http.MultipartFile.fromPath(
      "doc_camara_com",
      pQuota.docCamaraCom.path,
      contentType: MediaType(
        mime(pQuota.docCamaraCom.path).split("/")[0],
        mime(pQuota.docCamaraCom.path).split("/")[1],
      ),
    );

    final url = Uri.parse("$_url/ampliacion-cupo");
    final request = http.MultipartRequest("POST", url);
    request.headers.addAll(_preferences.signedHeaders);

    request.fields["vendedor"] = "${pQuota.vendedorId}";
    request.fields["cliente"] = "${pQuota.clienteId}";
    request.fields["monto"] = pQuota.monto;
    request.files.add(fileDocIdentidad);
    request.files.add(fileDocRut);
    request.files.add(fileDocCamaraCom);

    final responseStream = await request.send();
    final response = await http.Response.fromStream(responseStream);

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> createQuotaExpansionLocal(QuotaRequest quota) async {
    final response = await DatabaseProvider.db.saveRecord("offline_quotas", {
      "content": jsonEncode(quota.toJson()),
    });
    return response != 0;
  }

  Future<void> syncOfflineQuotasInLocal() async {
    final db = await DatabaseProvider.db.database;
    final records = await db.query("offline_quotas");

    if (records.isEmpty) return;

    for (final record in records) {
      final quotaId = record["id"];
      final quota = QuotaRequest.fromJson(jsonDecode(record["content"]));
      final isSuccessResponse = await createQuotaExpansion(quota);

      if (isSuccessResponse) {
        await DatabaseProvider.db.deleteRecord("offline_quotas", quotaId);
      }
    }
  }

  Future<void> deleteLocalQuota(int index) async {
    final db = await DatabaseProvider.db.database;
    final records = await db.query("offline_quotas");

    for (int i = 0; i < records.length; i++) {
      if (i == index) {
        final cartId = records[i]["id"];
        await DatabaseProvider.db.deleteRecord("offline_quotas", cartId);
        notifyListeners();
        break;
      }
    }
  }

  Future<List<QuotaRequest>> getOfflineQuotas() async {
    final db = await DatabaseProvider.db.database;
    final records = await db.query("offline_quotas");
    List<QuotaRequest> quotas = [];

    if (records.isEmpty) return quotas;

    for (final record in records) {
      quotas.add(QuotaRequest.fromJson(jsonDecode(record["content"])));
    }
    return quotas;
  }

  Future<int> getSellerId() async {
    final url = Uri.parse("$_url/vendedores-asignados");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;

    final decodedResponse = json.decode(response.body);
    return decodedResponse["id"];
  }

  Future<int> getSellerIdLocal() async {
    // TODO
    return null;
  }
}

class QuotaRequest {
  File docIdentidad;
  String docIdentidadFilename;
  File docRut;
  String docRutFilename;
  File docCamaraCom;
  String docCamaraComFilename;
  String monto;
  int clienteId;
  int vendedorId;

  QuotaRequest() {
    monto = "";
    clienteId = null;
    vendedorId = null;
  }

  QuotaRequest.format({
    this.docIdentidad,
    this.docRut,
    this.docCamaraCom,
    this.docIdentidadFilename,
    this.docRutFilename,
    this.docCamaraComFilename,
    this.monto,
    this.clienteId,
    this.vendedorId,
  });

  factory QuotaRequest.fromJson(Map<String, dynamic> json) {
    File docIdentidadFile;
    File docRutFile;
    File docCamaraComFile;

    if (json["doc_identidad"] != null) {
      final decodedBytes = base64Decode(json["doc_identidad"]);
      docIdentidadFile = File(json["doc_identidad_filename"]);
      docIdentidadFile.writeAsBytesSync(decodedBytes);
    }
    if (json["doc_rut"] != null) {
      final decodedBytes = base64Decode(json["doc_rut"]);
      docRutFile = File(json["doc_rut_filename"]);
      docRutFile.writeAsBytesSync(decodedBytes);
    }
    if (json["doc_camara_com"] != null) {
      final decodedBytes = base64Decode(json["doc_camara_com"]);
      docCamaraComFile = File(json["doc_camara_com_filename"]);
      docCamaraComFile.writeAsBytesSync(decodedBytes);
    }

    return QuotaRequest.format(
      docIdentidad: docIdentidadFile,
      docRut: docRutFile,
      docCamaraCom: docCamaraComFile,
      docIdentidadFilename: json["doc_identidad_filename"],
      docRutFilename: json["doc_rut_filename"],
      docCamaraComFilename: json["doc_camara_com_filename"],
      monto: json["monto"],
      clienteId: json["cliente_id"],
      vendedorId: json["vendedor_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "doc_identidad": docIdentidad != null
            ? base64Encode(docIdentidad.readAsBytesSync())
            : null,
        "doc_rut":
            docRut != null ? base64Encode(docRut.readAsBytesSync()) : null,
        "doc_camara_com": docCamaraCom != null
            ? base64Encode(docCamaraCom.readAsBytesSync())
            : null,
        "doc_identidad_filename":
            docIdentidad != null ? docIdentidad.path : null,
        "doc_rut_filename": docRut != null ? docRut.path : null,
        "doc_camara_com_filename":
            docCamaraCom != null ? docCamaraCom.path : null,
        "monto": monto,
        "cliente_id": clienteId,
        "vendedor_id": vendedorId,
      };
}
