import 'dart:convert';

ResponseProductos responseProductosFromJson(String str) =>
    ResponseProductos.fromJson(json.decode(str));

String responseProductosToJson(ResponseProductos data) =>
    json.encode(data.toJson());

class ResponseProductos {
  ResponseProductos({
    this.response,
    this.message,
    this.status,
    this.productos,
    this.showRoom,
  });

  String response;
  String message;
  int status;
  List<Producto> productos;
  bool showRoom;

  factory ResponseProductos.fromJson(Map<String, dynamic> json) =>
      ResponseProductos(
        response: json["response"],
        message: json["message"],
        status: json["status"],
        productos: List<Producto>.from(
            json["productos"].map((x) => Producto.fromJson(x))),
        showRoom: json["show_room"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "status": status,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
        "show_room": showRoom,
      };
}

class Producto {
  Producto({
    this.idProducto,
    this.nombre,
    this.codigo,
    this.referencia,
    this.stock,
    this.precio,
    this.descripcion,
    this.sku,
    this.total,
    this.descuento,
    this.iva,
    this.catalogo,
    this.marca,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.image,
    this.nombreMarca,
  });

  int idProducto;
  String nombre;
  String codigo;
  String referencia;
  int stock;
  double precio;
  String descripcion;
  dynamic sku;
  double total;
  int descuento;
  int iva;
  int catalogo;
  int marca;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String image;
  String nombreMarca;
  List<Imagen> imagenes;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        idProducto: json["id_producto"],
        nombre: json["nombre"],
        codigo: json["codigo"],
        referencia: json["referencia"],
        stock: json["stock"],
        precio: double.parse(json["precio"].toString()),
        descripcion: json["descripcion"],
        sku: json["sku"],
        total: double.parse(json["total"].toString()),
        descuento: json["descuento"],
        iva: json["iva"],
        catalogo: json["catalogo"],
        marca: json["marca"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        image: json["image"],
        nombreMarca: json["nombre_marca"],
      );

  Map<String, dynamic> toJson() => {
        "id_producto": idProducto,
        "nombre": nombre,
        "codigo": codigo,
        "referencia": referencia,
        "stock": stock,
        "precio": precio,
        "descripcion": descripcion,
        "sku": sku,
        "total": total,
        "descuento": descuento,
        "iva": iva,
        "catalogo": catalogo,
        "marca": marca,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "image": image,
        "nombre_marca": nombreMarca,
      };
}

class Imagen {
  String image;
}

// class Product {
//   Product({
//     this.id,
//     this.name,
//     this.code,
//     this.reference,
//     this.stock,
//     this.price,
//     this.description,
//     this.sku,
//     this.total,
//     this.createdAt,
//     this.updatedAt,
//     this.image,
//     this.discount,
//     this.iva,
//     this.catalogoId,
//   });

//   int id;
//   String name;
//   String code;
//   String reference;
//   int stock;
//   double price;
//   String description;
//   String sku;
//   double total;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String image;
//   int discount;
//   int iva;
//   int catalogoId;
//   Brand brand;
//   List<ProductImage> images;
// }

// class Brand {
//   Brand({
//     this.id,
//     this.name,
//   });

//   int id;
//   String name;
// }

// class ProductImage {
//   int id;
//   String image;
//   String imageName;
//   bool featured;
//   int productId;
//   DateTime createdAt;
//   DateTime updatedAt;

//   ProductImage({
//     this.id,
//     this.image,
//     this.imageName,
//     this.featured,
//     this.productId,
//     this.createdAt,
//     this.updatedAt,
//   });
// }

// Product productTest() {
//   Map<String, dynamic> data = _productDataTest();

//   Product product = Product(
//     id: data["id_producto"],
//     name: data["nombre"],
//     code: data["codigo"],
//     reference: data["referencia"],
//     stock: data["stock"],
//     price: double.parse(data["precio"].toString()),
//     total: double.parse(data["total"].toString()),
//     description: data["descripcion"],
//     sku: data["sku"],
//     createdAt: DateTime.parse(data["created_at"]),
//     updatedAt: DateTime.parse(data["updated_at"]),
//     image: data["destacada"],
//     discount: data["descuento"],
//     iva: data["iva"],
//     catalogoId: data["catalogo"],
//   );

//   product.brand = Brand(
//     id: data["id_marca"],
//     name: data["nombre_marca"],
//   );

//   product.images = [];

//   (data["imagenes"] as List).forEach((image) {
//     product.images.add(
//       ProductImage(
//         id: image["id_galeria_prod"],
//         image: image["image"],
//         imageName: image["name_img"],
//         featured: image["destacada"] == 1,
//         productId: image["producto"],
//         createdAt: DateTime.parse(image["created_at"]),
//         updatedAt: DateTime.parse(image["updated_at"]),
//       ),
//     );
//   });

//   return product;
// }

// List<Product> productsListTest() {
//   List<Map<String, dynamic>> list = productsListDataTest();
//   List<Product> listCatalogue = [];

//   list.forEach((element) {
//     var product = Product(
//       id: int.parse(element['id_producto'].toString()),
//       name: element['nombre'],
//       code: element['codigo'],
//       reference: element['referencia'],
//       stock: int.parse(element['stock'].toString()),
//       price: double.parse(element['precio'].toString()),
//       description: element['descripcion'],
//       sku: element['sku'],
//       total: double.parse(element['total'].toString()),
//       createdAt: DateTime.parse(element['created_at']),
//       updatedAt: DateTime.parse(element['updated_at']),
//       image: element['image'],
//       discount: element['"descuento'] != null
//           ? int.parse(element['"descuento'].toString())
//           : null,
//       iva: int.parse(element['iva'].toString()),
//       catalogoId: int.parse(element['catalogo'].toString()),
//     );
//     product.brand = Brand(
//       id: int.parse(element['marca'].toString()),
//       name: element['nombre_marca'],
//     );

//     listCatalogue.add(product);
//   });

//   return listCatalogue;
// }

// Map<String, dynamic> _productDataTest() {
//   return {
//     "id_producto": 22,
//     "nombre": "Tenis Puma Hombre Moda BMW MMS Roma",
//     "codigo": "01010386",
//     "referencia": "ATH-30303",
//     "stock": 74,
//     "precio": 150000,
//     "descripcion": "Tenis Puma Hombre Moda BMW MMS Roma",
//     "sku": null,
//     "total": 150000,
//     "descuento": 0,
//     "iva": 19,
//     "catalogo": 3,
//     "marca": 1,
//     "created_at": "2020-10-27 03:08:49",
//     "updated_at": "2021-05-07 17:12:10",
//     "deleted_at": null,
//     "id_marca": 1,
//     "nombre_marca": "ATHLETIC",
//     "destacada":
//         "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/ATH-30303/ATH-30303-0.png",
//     "imagenes": [
//       {
//         "id_galeria_prod": 24,
//         "image":
//             "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/ATH-30303/ATH-30303-0.png",
//         "name_img": "ATH-30303-0",
//         "destacada": 1,
//         "producto": 22,
//         "created_at": "2020-10-27 03:08:49",
//         "updated_at": "2020-10-27 03:08:49"
//       },
//       {
//         "id_galeria_prod": 25,
//         "image":
//             "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/ATH-30303/ATH-30303-1.png",
//         "name_img": "ATH-30303-1",
//         "destacada": 0,
//         "producto": 22,
//         "created_at": "2020-10-27 03:08:49",
//         "updated_at": "2020-10-27 03:08:49"
//       },
//       {
//         "id_galeria_prod": 29,
//         "image":
//             "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/ATH-30303/ATH-30303-2.png",
//         "name_img": "ATH-30303-2",
//         "destacada": 0,
//         "producto": 22,
//         "created_at": "2020-10-27 03:30:00",
//         "updated_at": "2020-10-27 03:30:00"
//       },
//       {
//         "id_galeria_prod": 29,
//         "image":
//             "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/ATH-30303/ATH-30303-2.png",
//         "name_img": "ATH-30303-2",
//         "destacada": 0,
//         "producto": 22,
//         "created_at": "2020-10-27 03:30:00",
//         "updated_at": "2020-10-27 03:30:00"
//       },
//       {
//         "id_galeria_prod": 29,
//         "image":
//             "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/ATH-30303/ATH-30303-2.png",
//         "name_img": "ATH-30303-2",
//         "destacada": 0,
//         "producto": 22,
//         "created_at": "2020-10-27 03:30:00",
//         "updated_at": "2020-10-27 03:30:00"
//       }
//     ]
//   };
// }

// List<Map<String, dynamic>> productsListDataTest() {
//   return [
//     {
//       "id_producto": 22,
//       "nombre": "Tenis Puma Hombre Moda BMW MMS Roma",
//       "codigo": "01010386",
//       "referencia": "ATH-30303",
//       "stock": 87,
//       "precio": 150000,
//       "descripcion": "Tenis Puma Hombre Moda BMW MMS Roma",
//       "sku": null,
//       "total": 150000,
//       "descuento": 5,
//       "iva": 19,
//       "catalogo": 3,
//       "marca": 1,
//       "created_at": "2020-10-27 03:08:49",
//       "updated_at": "2021-04-27 14:23:12",
//       "deleted_at": null,
//       "image":
//           "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/ATH-30303/ATH-30303-0.png",
//       "nombre_marca": "ATHLETIC"
//     },
//     {
//       "id_producto": 30,
//       "nombre": "Producto 3",
//       "codigo": "001",
//       "referencia": "001",
//       "stock": 11,
//       "precio": 1122,
//       "descripcion": "123",
//       "sku": null,
//       "total": 1122,
//       "descuento": 0,
//       "iva": 19,
//       "catalogo": 3,
//       "marca": 1,
//       "created_at": "2021-04-05 23:14:56",
//       "updated_at": "2021-04-12 13:52:15",
//       "deleted_at": null,
//       "image":
//           "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/001/001-0.png",
//       "nombre_marca": "ATHLETIC"
//     },
//     {
//       "id_producto": 31,
//       "nombre": "Producto 1",
//       "codigo": "11023",
//       "referencia": "002",
//       "stock": 100,
//       "precio": 100000,
//       "descripcion": "Prueba",
//       "sku": null,
//       "total": 100000,
//       "descuento": 0,
//       "iva": 19,
//       "catalogo": 3,
//       "marca": 1,
//       "created_at": "2021-04-06 23:03:45",
//       "updated_at": "2021-04-06 23:03:45",
//       "deleted_at": null,
//       "image":
//           "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/002/002-0.jpeg",
//       "nombre_marca": "ATHLETIC"
//     },
//     {
//       "id_producto": 32,
//       "nombre": "Producto 2",
//       "codigo": "11023",
//       "referencia": "002",
//       "stock": 10000,
//       "precio": 10000,
//       "descripcion": "prueba 2",
//       "sku": null,
//       "total": 10000,
//       "descuento": 0,
//       "iva": 19,
//       "catalogo": 3,
//       "marca": 1,
//       "created_at": "2021-04-06 23:06:37",
//       "updated_at": "2021-04-06 23:06:37",
//       "deleted_at": null,
//       "image":
//           "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/002/002-0.jpeg",
//       "nombre_marca": "ATHLETIC"
//     }
//   ];
// }
