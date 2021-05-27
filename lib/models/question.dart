import 'dart:convert';

ReponsePreguntas reponsePreguntasFromJson(String str) =>
    ReponsePreguntas.fromJson(json.decode(str));

String reponsePreguntasToJson(ReponsePreguntas data) =>
    json.encode(data.toJson());

class ReponsePreguntas {
  ReponsePreguntas({
    this.response,
    this.status,
    this.preguntas,
    this.respuestaUsuario,
  });

  String response;
  int status;
  List<Pregunta> preguntas;
  bool respuestaUsuario;

  factory ReponsePreguntas.fromJson(Map<String, dynamic> json) =>
      ReponsePreguntas(
        response: json["response"],
        status: json["status"],
        preguntas: List<Pregunta>.from(
            json["preguntas"].map((x) => Pregunta.fromJson(x))),
        respuestaUsuario: json["respuesta_usuario"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "preguntas": List<dynamic>.from(preguntas.map((x) => x.toJson())),
        "respuesta_usuario": respuestaUsuario,
      };
}

class Pregunta {
  Pregunta({
    this.idForm,
    this.catalogo,
    this.idPregunta,
    this.encuesta,
    this.pregunta,
    this.createdAt,
    this.updatedAt,
    this.respuesta,
  });

  int idForm;
  int catalogo;
  int idPregunta;
  int encuesta;
  String pregunta;
  DateTime createdAt;
  DateTime updatedAt;
  int respuesta;

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
        idForm: json["id_form"],
        catalogo: json["catalogo"],
        idPregunta: json["id_pregunta"],
        encuesta: json["encuesta"],
        pregunta: json["pregunta"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        respuesta: json["respuesta"],
      );

  Map<String, dynamic> toJson() => {
        "id_form": idForm,
        "catalogo": catalogo,
        "id_pregunta": idPregunta,
        "encuesta": encuesta,
        "pregunta": pregunta,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "respuesta": respuesta,
      };
}
