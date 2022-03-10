class Imagen {
  Imagen({
    this.id,
    this.image,
    this.nombre,
    this.destacada,
    this.productoId,
  });

  int id;
  String image;
  String nombre;
  int destacada;
  int productoId;

  factory Imagen.fromJson(Map<String, dynamic> json) => Imagen(
        id: json["id"],
        image: json["image"],
        nombre: json["name_img"],
        destacada: json["destacada"],
        productoId: json["producto"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name_img": nombre,
        "destacada": destacada,
        "producto": productoId,
      };
}
