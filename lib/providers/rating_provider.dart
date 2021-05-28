import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:montana_mobile/models/question.dart';
import 'package:montana_mobile/models/rating.dart';
import 'package:montana_mobile/models/session.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

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
    final session = _preferences.session as Session;
    if (_rating == null) return false;
    if (_rating.usuarios.indexOf(session.id) == -1) return false;
    return true;
  }

  Future<void> loadData(int catalogId, int productId) async {
    _isLoading = true;
    _valoracion = null;
    _rating = null;
    notifyListeners();

    final user = _preferences.session as Session;
    final questions = await getQuestions(catalogId);
    _rating = await getRatings(productId);

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

  Future<Rating> getRatings(int productId) async {
    final url = Uri.parse('$_url/getProductoValoraciones/$productId');
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return responseValoracionesFromJson(response.body);
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
