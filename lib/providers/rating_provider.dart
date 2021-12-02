import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:montana_mobile/models/question.dart';
import 'package:montana_mobile/models/rating.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/question_rating.dart' as vp;

class RatingProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  final _preferences = Preferences();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingSend = false;
  bool get isLoadingSend => _isLoadingSend;

  set isLoadingSend(bool value) {
    _isLoadingSend = value;
    notifyListeners();
  }

  void applyAnswer(int questionId, int rate) {
    int index = _valoracion.preguntas.indexWhere(
      (x) => x.pregunta == questionId,
    );

    if (index == -1) return;

    _valoracion.preguntas[index].respuesta = rate;
    notifyListeners();
  }

  bool get canSend {
    if (_valoracion == null) return false;
    if (_valoracion.preguntas.length == 0) return false;
    if (!_valoracion.hasAllAnswered) return false;
    return true;
  }

  Valoracion _valoracion;
  Valoracion get valoracion => _valoracion;
  List<ValoracionPregunta> get preguntas {
    return _valoracion != null ? _valoracion.preguntas : [];
  }

  Rating _rating;
  Rating get rating => _rating;

  bool get isRatingCompleted {
    final session = _preferences.session;
    if (_rating == null) return false;
    if (_rating.usuarios.indexOf(session.id) == -1) return false;
    return true;
  }

  Future<void> loadData(int catalogId, int productId,
      {@required bool local}) async {
    _isLoading = true;
    _valoracion = null;
    _rating = null;
    notifyListeners();

    final user = _preferences.session;
    final questions = local
        ? await getQuestionsLocal(catalogId)
        : await getQuestions(catalogId);
    _rating =
        local ? await getRatingsLocal(productId) : await getRatings(productId);

    _valoracion = Valoracion(
      user.id,
      productId,
      questions
          .map<ValoracionPregunta>(
              (x) => ValoracionPregunta(x.idPregunta, 0, x))
          .toList(),
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Pregunta>> getQuestions(int catalogId) async {
    final url = Uri.parse('$_url/getPreguntas/$catalogId');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return reponsePreguntasFromJson(response.body).preguntas;
  }

  Future<List<Pregunta>> getQuestionsLocal(int catalogueId) async {
    final db = await DatabaseProvider.db.database;
    List<Map<String, Object>> list = await db.query(
      'questions',
      where: 'catalogo = ?',
      whereArgs: [catalogueId],
    );
    return List<Pregunta>.from(list.map((x) => Pregunta.fromJson(x)));
  }

  Future<Rating> getRatings(int productId) async {
    final url = Uri.parse('$_url/getProductoValoraciones/$productId');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseValoracionesFromJson(response.body);
  }

  Future<Rating> getRatingsLocal(int productId) async {
    final db = await DatabaseProvider.db.database;
    final response = await db.query(
      'ratings',
      where: 'producto_id = ?',
      whereArgs: [productId],
    );

    if (response.length == 0) {
      return Rating(
        productoId: productId.toString(),
        cantidadValoraciones: 0,
        usuarios: [],
        valoraciones: [],
      );
    }

    Map<String, Object> record = response.first;
    Map<String, Object> recordTemp = Map<String, Object>.of(record);

    final usuarios = jsonDecode(recordTemp['usuarios']);
    final valoraciones = jsonDecode(recordTemp["valoraciones"]);

    recordTemp['usuarios'] = List<int>.from(usuarios.map((x) => x));
    recordTemp['valoraciones'] = List<vp.ValoracionPregunta>.from(
      valoraciones.map((x) => vp.ValoracionPregunta.fromJson(x)),
    );

    return Rating.fromJson(recordTemp);
  }

  Future<bool> saveRating() async {
    final url = Uri.parse('$_url/storeRespuestas');
    final response = await http.post(
      url,
      headers: _preferences.signedHeaders,
      body: json.encode(valoracion.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}

class Valoracion {
  int usuario;
  int producto;
  List<ValoracionPregunta> preguntas;

  Valoracion(this.usuario, this.producto, this.preguntas);

  Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "producto": producto,
        "preguntas": List<dynamic>.from(preguntas.map((x) => x.toJson())),
      };

  bool get hasAllAnswered {
    bool valid = true;
    preguntas.forEach((pregunta) {
      if (pregunta.respuesta < 1 || pregunta.respuesta > 5) {
        valid = false;
      }
    });
    return valid;
  }
}

class ValoracionPregunta {
  int pregunta;
  int respuesta;
  Pregunta question;

  ValoracionPregunta(this.pregunta, this.respuesta, this.question);

  Map<String, dynamic> toJson() => {
        "pregunta": pregunta,
        "respuesta": respuesta,
      };
}
