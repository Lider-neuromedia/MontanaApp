class Imagen {
  Imagen({
    this.idGaleriaProd,
    this.image,
    this.nameImg,
    this.destacada,
    this.producto,
    this.createdAt,
    this.updatedAt,
  });

  int idGaleriaProd;
  String image;
  String nameImg;
  int destacada;
  int producto;
  DateTime createdAt;
  DateTime updatedAt;

  factory Imagen.fromJson(Map<String, dynamic> json) => Imagen(
        idGaleriaProd: json["id_galeria_prod"],
        image: json["image"],
        nameImg: json["name_img"],
        destacada: json["destacada"],
        producto: json["producto"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_galeria_prod": idGaleriaProd,
        "image": image,
        "name_img": nameImg,
        "destacada": destacada,
        "producto": producto,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
