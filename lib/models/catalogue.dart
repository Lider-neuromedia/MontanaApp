class Catalogue {
  Catalogue({
    this.id,
    this.title,
    this.image,
    this.quantity,
    this.discount,
    this.type,
  });

  int id;
  String title;
  String image;
  int quantity;
  int discount;
  String type;

  String get typeFormatted {
    String temp = type.toLowerCase().trim();
    String firstLetter = temp.substring(0, 1).toUpperCase();
    String word = firstLetter + temp.substring(1, temp.length);
    return word;
  }
}

List<Catalogue> catalogueListTest() {
  List<Map<String, dynamic>> list = [
    {
      "id_catalogo": 14,
      "estado": "privado",
      "tipo": "general",
      "imagen":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/catalogos/14.png",
      "titulo": "prueba",
      "cantidad": 0,
      "descuento": null,
    },
    {
      "id_catalogo": 15,
      "estado": "privado",
      "tipo": "general",
      "imagen":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/catalogos/15.png",
      "titulo": "Deportivo",
      "cantidad": 0,
      "descuento": null,
    },
    {
      "id_catalogo": 16,
      "estado": "privado",
      "tipo": "general",
      "imagen":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/catalogos/16.png",
      "titulo": "prueba",
      "cantidad": 0,
      "descuento": null,
    },
    {
      "id_catalogo": 17,
      "estado": "privado",
      "tipo": "general",
      "imagen":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/catalogos/17.png",
      "titulo": "prueba",
      "cantidad": 0,
      "descuento": null,
    },
    {
      "id_catalogo": 22,
      "estado": "privado",
      "tipo": "general",
      "imagen":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/catalogos/22.png",
      "titulo": "Clasico 2020",
      "cantidad": 0,
      "descuento": null,
    },
    {
      "id_catalogo": 23,
      "estado": "privado",
      "tipo": "general",
      "imagen":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/catalogos/23.png",
      "titulo": "Catalogo especial",
      "cantidad": 0,
      "descuento": null,
    },
    {
      "id_catalogo": 24,
      "estado": "privado",
      "tipo": "general",
      "imagen":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/catalogos/24.png",
      "titulo": "Prueba",
      "cantidad": 0,
      "descuento": null,
    },
    {
      "id_catalogo": 25,
      "estado": "privado",
      "tipo": "show room",
      "imagen":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/catalogos/25.png",
      "titulo": "Clasico 2021",
      "cantidad": 0,
      "descuento": null,
    },
    {
      "id_catalogo": 81,
      "estado": "activo",
      "tipo": "general",
      "imagen":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/catalogos/81.jpg",
      "titulo": "Prueba 3",
      "cantidad": 2,
      "descuento": 4,
    }
  ];

  List<Catalogue> listCatalogue = [];

  list.forEach((element) {
    listCatalogue.add(Catalogue(
      id: element['id_catalogo'],
      title: element['titulo'],
      image: element['imagen'],
      quantity: element['cantidad'],
      discount: element['descuento'],
      type: element['tipo'],
    ));
  });

  return listCatalogue;
}
