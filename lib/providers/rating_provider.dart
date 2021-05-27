import 'package:flutter/material.dart';
import 'package:montana_mobile/models/question.dart';
import 'package:montana_mobile/utils/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class RatingProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Pregunta> _questions = [];
  List<Pregunta> get questions => _questions;

  void applyAnswer(int questionId, int rate) {
    int index = _questions.indexWhere(
      (question) => question.idPregunta == questionId,
    );
    if (index == -1) return;
    _questions[index].respuesta = rate;
    notifyListeners();
  }

  bool get canSend {
    bool valid = true;

    _questions.forEach((question) {
      if (question.respuesta < 1 || question.respuesta > 5) {
        valid = false;
      }
    });

    return valid;
  }

  Future<void> loadQuestions(int catalogId) async {
    _isLoading = true;
    _questions = [];
    notifyListeners();
    _questions = await getQuestions(catalogId);
    _isLoading = false;
    notifyListeners();
  }

  Future<List<Pregunta>> getQuestions(int catalogId) async {
    final preferences = Preferences();
    final url = Uri.parse('$_url/getPreguntas/$catalogId');
    final response = await http.get(url, headers: preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return reponsePreguntasFromJson(response.body).preguntas;
  }
}

class Valoracion {
  int preguntaId;
  int valoracion;
}
