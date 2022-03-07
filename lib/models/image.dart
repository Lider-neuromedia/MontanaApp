class Imagen {
  Imagen({
    this.id,
    this.image,
    this.nameImg,
    this.destacada,
    this.producto,
  });

  int id;
  String image;
  String nameImg;
  int destacada;
  int producto;

  factory Imagen.fromJson(Map<String, dynamic> json) => Imagen(
        id: json["id"],
        image: json["image"],
        nameImg: json["name_img"],
        destacada: json["destacada"],
        producto: json["producto"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name_img": nameImg,
        "destacada": destacada,
        "producto": producto,
      };
}
