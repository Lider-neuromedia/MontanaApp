class Product {
  Product({
    this.id,
    this.name,
    this.code,
    this.reference,
    this.stock,
    this.price,
    this.description,
    this.sku,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.discount,
    this.iva,
    this.catalogoId,
  });

  int id;
  String name;
  String code;
  String reference;
  int stock;
  double price;
  String description;
  String sku;
  double total;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  int discount;
  int iva;
  int catalogoId;
  Brand brand;
}

class Brand {
  Brand({
    this.id,
    this.name,
  });

  int id;
  String name;
}

List<Product> productsListTest() {
  List<Map<String, dynamic>> list = [
    {
      "id_producto": 22,
      "nombre": "Tenis Puma Hombre Moda BMW MMS Roma",
      "codigo": "01010386",
      "referencia": "ATH-30303",
      "stock": 87,
      "precio": 150000,
      "descripcion": "Tenis Puma Hombre Moda BMW MMS Roma",
      "sku": null,
      "total": 150000,
      "descuento": 0,
      "iva": 19,
      "catalogo": 3,
      "marca": 1,
      "created_at": "2020-10-27 03:08:49",
      "updated_at": "2021-04-27 14:23:12",
      "deleted_at": null,
      "image":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/ATH-30303/ATH-30303-0.png",
      "nombre_marca": "ATHLETIC"
    },
    {
      "id_producto": 30,
      "nombre": "Producto 3",
      "codigo": "001",
      "referencia": "001",
      "stock": 11,
      "precio": 1122,
      "descripcion": "123",
      "sku": null,
      "total": 1122,
      "descuento": 0,
      "iva": 19,
      "catalogo": 3,
      "marca": 1,
      "created_at": "2021-04-05 23:14:56",
      "updated_at": "2021-04-12 13:52:15",
      "deleted_at": null,
      "image":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/001/001-0.png",
      "nombre_marca": "ATHLETIC"
    },
    {
      "id_producto": 31,
      "nombre": "Producto 1",
      "codigo": "11023",
      "referencia": "002",
      "stock": 100,
      "precio": 100000,
      "descripcion": "Prueba",
      "sku": null,
      "total": 100000,
      "descuento": 0,
      "iva": 19,
      "catalogo": 3,
      "marca": 1,
      "created_at": "2021-04-06 23:03:45",
      "updated_at": "2021-04-06 23:03:45",
      "deleted_at": null,
      "image":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/002/002-0.jpeg",
      "nombre_marca": "ATHLETIC"
    },
    {
      "id_producto": 32,
      "nombre": "Producto 2",
      "codigo": "11023",
      "referencia": "002",
      "stock": 10000,
      "precio": 10000,
      "descripcion": "prueba 2",
      "sku": null,
      "total": 10000,
      "descuento": 0,
      "iva": 19,
      "catalogo": 3,
      "marca": 1,
      "created_at": "2021-04-06 23:06:37",
      "updated_at": "2021-04-06 23:06:37",
      "deleted_at": null,
      "image":
          "http://pruebasneuro.co/N-1010/montana_backend/public/storage/productos/3/002/002-0.jpeg",
      "nombre_marca": "ATHLETIC"
    }
  ];

  List<Product> listCatalogue = [];

  list.forEach((element) {
    var product = Product(
      id: int.parse(element['id_producto'].toString()),
      name: element['nombre'],
      code: element['codigo'],
      reference: element['referencia'],
      stock: int.parse(element['stock'].toString()),
      price: double.parse(element['precio'].toString()),
      description: element['descripcion'],
      sku: element['sku'],
      total: double.parse(element['total'].toString()),
      createdAt: DateTime.parse(element['created_at']),
      updatedAt: DateTime.parse(element['updated_at']),
      image: element['image'],
      discount: element['"descuento'] != null
          ? int.parse(element['"descuento'].toString())
          : null,
      iva: int.parse(element['iva'].toString()),
      catalogoId: int.parse(element['catalogo'].toString()),
    );
    product.brand = Brand(
      id: int.parse(element['marca'].toString()),
      name: element['nombre_marca'],
    );

    listCatalogue.add(product);
  });

  return listCatalogue;
}
