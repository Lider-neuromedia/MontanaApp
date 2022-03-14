import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/providers/validation_field.dart';
import 'package:montana_mobile/utils/preferences.dart';

class CartProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final List<PaymentMethod> paymentMethods = _paymentMethods;
  final List<SignMethod> signMethods = _signMethods;
  final _preferences = Preferences();

  ValidationField _notes = ValidationField();
  String get notes => _notes.value;
  String get notesError => _notes.error;

  set notes(String value) {
    final errorLength = ValidationField.validateLength(value, max: 120);

    if (errorLength != null) {
      _notes = ValidationField(error: errorLength);
    } else {
      _notes = ValidationField(value: value);
    }

    if (_notes.value != null && _notes.value.isNotEmpty) {
      _cart.notes = "${_notes.value}";
    } else {
      _cart.notes = null;
    }

    notifyListeners();
  }

  ValidationField _billingNotes = ValidationField();
  String get billingNotes => _billingNotes.value;
  String get billingNotesError => _billingNotes.error;

  set billingNotes(String value) {
    final errorLength = ValidationField.validateLength(value, max: 120);

    if (errorLength != null) {
      _billingNotes = ValidationField(error: errorLength);
    } else {
      _billingNotes = ValidationField(value: value);
    }

    if (_billingNotes.value != null && _billingNotes.value.isNotEmpty) {
      _cart.billingNotes = "${_billingNotes.value}";
    } else {
      _cart.billingNotes = null;
    }

    notifyListeners();
  }

  Cart _cart = Cart();
  Cart get cart => _cart;
  List<CartProduct> get products => _cart.products;

  int get catalogueId => _cart.catalogueId;

  set catalogueId(int value) {
    _cart.catalogueId = value;
    notifyListeners();
  }

  String get paymentMethod => _cart.paymentMethod;

  set paymentMethod(String value) {
    _cart.paymentMethod = value;
    notifyListeners();
  }

  String get signMethod => _cart.signMethod;

  set signMethod(String value) {
    _cart.signMethod = value;
    notifyListeners();
  }

  int get discount => _cart.discount;

  set discount(int value) {
    _cart.discount = value;
    notifyListeners();
  }

  int get clientId => _cart.clientId;

  set clientId(int value) {
    _cart.clientId = value;
    _cart.clean();
    notifyListeners();
  }

  String _getFileName(File file) {
    if (file == null) return null;
    List list = List.from(file.path.split("/").reversed);
    return list[0];
  }

  File get signPhoto => _cart.signPhoto;
  String get descriptionSignPhoto => _getFileName(_cart.signPhoto);

  set signPhoto(File value) {
    _cart.signPhoto = value;
    notifyListeners();
  }

  Uint8List get signData => _cart.signData;

  set signData(Uint8List value) {
    _cart.signData = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void removeProduct(Producto product, Tienda store) {
    _cart.removeProduct(product, store);
    notifyListeners();
  }

  void removeCompleteProduct(CartProduct cartProduct) {
    _cart.removeCompleteProduct(cartProduct);
    notifyListeners();
  }

  void addProduct(Producto product, Tienda store, int stock) {
    _cart.addProduct(product, store, stock);
    notifyListeners();
  }

  bool get canFinalize {
    if (_cart.products.length == 0) return false;
    if (_preferences.session.isVendedor && _cart.clientId == null) return false;
    return true;
  }

  bool get canSend {
    if (_isLoading) return false;
    if (!_cart.isValid) return false;
    return true;
  }

  void cleanCart() {
    _cart.cleanAll();
    notifyListeners();
  }

  Future<List<Tienda>> getClientStores(int clientId) async {
    final url = Uri.parse("$_url/tiendas-cliente/$clientId");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseTiendasFromJson(response.body);
  }

  Future<List<Tienda>> getClientStoresLocal(int clientId) async {
    final db = await DatabaseProvider.db.database;
    List<Map<String, Object>> list = await db.query(
      "stores",
      where: "cliente_id = ?",
      whereArgs: [clientId],
    );

    List<Tienda> stores = List<Tienda>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row["id_tiendas"] = row["id"];
      row["cliente"] =
          row["cliente"] != null ? jsonDecode(row["cliente"]) : null;
      row["vendedores"] =
          row["vendedores"] != null ? jsonDecode(row["vendedores"]) : null;
      return Tienda.fromJson(row);
    }));

    return stores;
  }

  Future<String> getOrderCode() async {
    final url = Uri.parse("$_url/generate-code");
    final response = await http.get(url, headers: _preferences.signedHeaders);
    final decodedResponse = json.decode(response.body);

    if (response.statusCode != 200) return "";
    return decodedResponse["code"];
  }

  Future<bool> createOrder(Cart cartCompleted,
      [bool isFromOffline = false]) async {
    final orderCode = await getOrderCode();
    final user = _preferences.session;

    if (orderCode.isEmpty) return false;

    final url = Uri.parse("$_url/pedidos");
    final request = http.MultipartRequest("POST", url);
    request.headers.addAll(_preferences.signedHeaders);

    if (cartCompleted.signMethod == SignMethod.FIRMA) {
      // Cargar firma.
      final fileFirma = http.MultipartFile.fromBytes(
        "firma",
        cartCompleted.signData,
        filename: "firma.png",
        contentType: MediaType("image", "image/png"),
      );
      request.files.add(fileFirma);
    }

    if (cartCompleted.signMethod == SignMethod.FOTO) {
      // Cargar foto.
      final mimeData = mime(cartCompleted.signPhoto.path).split("/");
      final fileSignPhoto = await http.MultipartFile.fromPath(
        "firma",
        cartCompleted.signPhoto.path,
        contentType: MediaType(mimeData[0], mimeData[1]),
      );
      request.files.add(fileSignPhoto);
    }

    if (user.isVendedor) {
      request.fields["cliente"] = "${cartCompleted.clientId}";
      request.fields["vendedor"] = "${user.id}";
      request.fields["descuento"] = "${cartCompleted.discount}";
    }
    if (user.isCliente) {
      final sellerId = await getSellerId();
      if (sellerId == null) return false;
      request.fields["cliente"] = "${user.id}";
      request.fields["vendedor"] = "$sellerId";
      request.fields["descuento"] = "0";
    }

    request.fields["codigo_pedido"] = "$orderCode";
    request.fields["total"] = "${cartCompleted.total.toInt()}";
    request.fields["metodo_pago"] = "${cartCompleted.paymentMethod}";
    request.fields["forma_firma"] = "${cartCompleted.signMethod}";

    if (cartCompleted.notes != null && cartCompleted.notes.isNotEmpty) {
      request.fields["notas"] = cartCompleted.notes;
    }
    if (cartCompleted.billingNotes != null &&
        cartCompleted.billingNotes.isNotEmpty) {
      request.fields["notas_facturacion"] = cartCompleted.billingNotes;
    }

    cartCompleted.products.asMap().forEach((int i, CartProduct product) {
      request.fields["productos[$i][producto_id]"] = "${product.productId}";
      product.stores.asMap().forEach((int j, CartStore store) {
        request.fields["productos[$i][tiendas][$j][id_tienda]"] =
            "${store.storeId}";
        request.fields["productos[$i][tiendas][$j][cantidad_producto]"] =
            "${store.quantity}";
      });
    });

    final responseStream = await request.send();
    final response = await http.Response.fromStream(responseStream);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> createOrderLocal(Cart cartCompleted) async {
    final response = await DatabaseProvider.db.saveRecord("offline_orders", {
      "content": jsonEncode(cartCompleted.toJson()),
    });
    return response != 0;
  }

  Future<List<Cart>> getOfflineOrders() async {
    final db = await DatabaseProvider.db.database;
    final records = await db.query("offline_orders");
    List<Cart> carts = [];

    if (records.isEmpty) return carts;

    for (final record in records) {
      carts.add(Cart.fromJson(jsonDecode(record["content"])));
    }

    return carts;
  }

  Future<void> deleteLocalOrder(int index) async {
    final db = await DatabaseProvider.db.database;
    final records = await db.query("offline_orders");

    for (int i = 0; i < records.length; i++) {
      if (i == index) {
        final cartId = records[i]["id"];
        await DatabaseProvider.db.deleteRecord("offline_orders", cartId);
        notifyListeners();
        break;
      }
    }
  }

  Future<void> syncOfflineOrdersInLocal() async {
    final db = await DatabaseProvider.db.database;
    final records = await db.query("offline_orders");

    if (records.isEmpty) return;

    for (final record in records) {
      final cartId = record["id"];
      final cart = Cart.fromJson(jsonDecode(record["content"]));
      final isSuccessResponse = await createOrder(cart, true);

      if (isSuccessResponse) {
        await DatabaseProvider.db.deleteRecord("offline_orders", cartId);
      }
    }
  }

  Future<int> getSellerId() async {
    final url = Uri.parse("$_url/vendedores-asignados");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;

    final decodedResponse = json.decode(response.body);
    return decodedResponse["id"];
  }
}

class Cart {
  int clientId;
  String paymentMethod;
  String signMethod;
  int discount;
  List<CartProduct> products;
  Uint8List signData;
  File signPhoto;
  String signPhotoFilename;
  int catalogueId;
  String notes;
  String billingNotes;

  Cart() {
    paymentMethod = "contado";
    signMethod = "sign";
    discount = 0;
    products = [];
  }

  Cart.format({
    this.clientId,
    this.paymentMethod,
    this.signMethod,
    this.discount,
    this.products,
    this.signData,
    this.signPhoto,
    this.signPhotoFilename,
    this.catalogueId,
    this.notes,
    this.billingNotes,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    File signPhotoFile;

    if (json["sign_photo"] != null) {
      final decodedBytes = base64Decode(json["sign_photo"]);
      signPhotoFile = File(json["sign_photo_filename"]);
      signPhotoFile.writeAsBytesSync(decodedBytes);
    }

    return Cart.format(
      clientId: json["client_id"],
      paymentMethod: json["payment_method"],
      signMethod: json["sign_method"],
      discount: json["discount"],
      catalogueId: json["catalogue_id"],
      signData:
          json["sign_data"] != null ? base64Decode(json["sign_data"]) : null,
      signPhoto: signPhotoFile,
      signPhotoFilename: json["sign_photo_filename"],
      notes: json["notes"] ?? "",
      billingNotes: json["billing_notes"] ?? "",
      products: List<CartProduct>.from(
          json["products"].map((x) => CartProduct.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "payment_method": paymentMethod,
        "sign_method": signMethod,
        "discount": discount,
        "catalogue_id": catalogueId,
        "sign_data": signData != null ? base64Encode(signData) : null,
        "sign_photo": signPhoto != null
            ? base64Encode(signPhoto.readAsBytesSync())
            : null,
        "sign_photo_filename": signPhoto != null ? signPhoto.path : null,
        "notes": notes,
        "billing_notes": billingNotes,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };

  void cleanAll() {
    clientId = null;
    paymentMethod = "contado";
    signMethod = "firma";
    discount = 0;
    products = [];
    notes = null;
    billingNotes = null;
    signData = null;
    signPhoto = null;
  }

  void clean() {
    paymentMethod = "contado";
    signMethod = "firma";
    discount = 0;
    products = [];
    notes = null;
    billingNotes = null;
  }

  bool get isValid {
    final preferences = Preferences();

    if (preferences.session.isVendedor && clientId == null) return false;
    if (total == null) return false;
    if (discount == null) return false;
    if (paymentMethod == null) return false;
    if (paymentMethod.isEmpty) return false;
    if (signMethod == null) return false;
    if (signMethod.isEmpty == null) return false;
    if (total < 0) return false;
    if (discount < 0 || discount > 100) return false;
    if (products.length == 0) return false;
    if (signData == null && signPhoto == null) return false;
    return true;
  }

  double get total {
    double total = 0;
    products.forEach((x) => total += x.subtotal);
    return total;
  }

  int getProductStock(productId) {
    int i = products.indexWhere((x) => x.productId == productId);
    return i != -1 ? products[i].totalStock : 0;
  }

  int getProductStoreStock(productId, storeId) {
    int quantity = 0;
    int pIndex = products.indexWhere((x) => x.productId == productId);

    if (pIndex != -1) {
      int sIndex = products[pIndex].stores.indexWhere(
            (x) => x.storeId == storeId,
          );

      if (sIndex != -1) {
        quantity = products[pIndex].stores[sIndex].quantity;
      }
    }

    return quantity;
  }

  void removeCompleteProduct(CartProduct cartProduct) {
    int pIndex = products.indexWhere((CartProduct item) {
      return item.productId == cartProduct.productId;
    });

    // Si el producto no existe no se hace nada.
    if (pIndex == -1) {
      return;
    }

    products.removeAt(pIndex);
  }

  void removeProduct(Producto product, Tienda store) {
    int pIndex = products.indexWhere((CartProduct item) {
      return item.productId == product.id;
    });

    // Si el producto no existe no se hace nada.
    if (pIndex == -1) return;

    int sIndex = products[pIndex].stores.indexWhere((CartStore item) {
      return item.storeId == store.id;
    });

    // Si la tienda no existe no se hace nada.
    if (sIndex == -1) return;

    if (products[pIndex].stores[sIndex].quantity > 1) {
      // Si el stock es mayor a 1 solo se reduce el stock.
      products[pIndex].stores[sIndex].quantity--;
    } else {
      // Si el stock es igual a 1 se elimina la tienda.
      products[pIndex].stores.removeAt(sIndex);

      if (products[pIndex].stores.length == 0) {
        // Si no quedan tiendas, se borra el producto.
        products.removeAt(pIndex);
      }
    }
  }

  void addProduct(Producto product, Tienda store, int stock) {
    int pIndex = products.indexWhere((CartProduct item) {
      return item.productId == product.id;
    });

    if (pIndex == -1) {
      // Si el producto es nuevo.
      products.add(
        CartProduct(
          productId: product.id,
          product: product,
          stores: [
            CartStore(
              storeId: store.id,
              quantity: stock,
              store: store,
            ),
          ],
        ),
      );
    }

    if (pIndex != -1) {
      // Si el producto ya existe.
      int sIndex = products[pIndex].stores.indexWhere((CartStore item) {
        return item.storeId == store.id;
      });

      if (sIndex == -1) {
        // Si la tienda es nueva.
        products[pIndex].stores.add(
              CartStore(
                storeId: store.id,
                quantity: stock,
                store: store,
              ),
            );
      }
      if (sIndex != -1) {
        // Si la tienda ya existe.
        products[pIndex].stores[sIndex].quantity += stock;
      }
    }
  }
}

class CartProduct {
  int productId;
  Producto product;
  List<CartStore> stores;

  CartProduct({
    this.productId,
    this.stores,
    this.product,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        productId: json["product_id"],
        product: Producto.fromJson(json["product"]),
        stores: List<CartStore>.from(
            json["stores"].map((x) => CartStore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product": product.toJson(),
        "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
      };

  double get subtotal {
    int quantity = 0;
    stores.forEach((x) => quantity += x.quantity);
    return product.total * quantity;
  }

  int get totalStock {
    int quantity = 0;
    stores.forEach((x) => quantity += x.quantity);
    return quantity;
  }
}

class CartStore {
  int storeId;
  int quantity;
  Tienda store;

  CartStore({
    this.storeId,
    this.quantity,
    this.store,
  });

  factory CartStore.fromJson(Map<String, dynamic> json) => CartStore(
        storeId: json["store_id"],
        quantity: json["quantity"],
        store: Tienda.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "quantity": quantity,
        "store": store.toJson(),
      };
}

abstract class SwitchMethod {
  String id;
  String value;

  SwitchMethod(this.id, this.value);
}

class PaymentMethod extends SwitchMethod {
  static const CONTADO = "contado";
  static const CREDITO = "credito";

  String id;
  String value;

  PaymentMethod(this.id, this.value) : super(id, value);
}

final List<PaymentMethod> _paymentMethods = [
  PaymentMethod(PaymentMethod.CONTADO, "Contado"),
  PaymentMethod(PaymentMethod.CREDITO, "Crédito 45 días"),
];

class SignMethod extends SwitchMethod {
  static const FIRMA = "firma";
  static const FOTO = "foto";

  String id;
  String value;

  SignMethod(this.id, this.value) : super(id, value);
}

final List<SignMethod> _signMethods = [
  SignMethod(SignMethod.FIRMA, "Firma"),
  SignMethod(SignMethod.FOTO, "Foto"),
];
