import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/models/session.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/utils/preferences.dart';

class CartProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];

  Cart _cart = Cart();
  Cart get cart => _cart;
  List<CartProduct> get products => _cart.products;

  int _catalogueId;
  int get catalogueId => _catalogueId;

  set catalogueId(int value) {
    _catalogueId = value;
    notifyListeners();
  }

  int get clientId => _cart.clientId;

  set clientId(int value) {
    _cart.clientId = value;
    notifyListeners();
  }

  File _sign;
  File get sign => _sign;
  String get descriptionSign => _getFileName(_sign);

  set sign(File value) {
    _sign = value;
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

  void addProduct(Producto product, Tienda store, int stock) {
    _cart.addProduct(product, store, stock);
    notifyListeners();
  }

  bool get canSend {
    if (_isLoading) return false;
    if (!_cart.isValid) return false;
    if (_sign == null) return false;
    return true;
  }

  Future<List<Tienda>> getStores(int clientId) async {
    final preferences = Preferences();
    final url = Uri.parse('$_url/tiendas-cliente/$clientId');
    final response = await http.get(url, headers: preferences.signedHeaders);

    if (response.statusCode != 200) return [];
    return responseTiendasFromJson(response.body);
  }

  Future<bool> createOrder() async {
    final fileFirma = await http.MultipartFile.fromPath(
      'firma',
      sign.path,
      contentType: MediaType(
        mime(sign.path).split('/')[0],
        mime(sign.path).split('/')[1],
      ),
    );

    final preferences = Preferences();
    final user = preferences.session as Session;
    final url = Uri.parse('$_url/pedidos');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(preferences.signedHeaders);
    request.files.add(fileFirma);
    request.fields['cliente'] = "${_cart.clientId}";
    request.fields['vendedor'] = "${user.id}";
    request.fields['codigo_pedido'] = "${_cart.reference}";
    request.fields['descuento'] = "${_cart.discount}";
    request.fields['total_pedido'] = "${_cart.total}";
    request.fields['forma_pago'] = "${_cart.paymentMethod}";
    request.fields['productos'] = json.encode(
      List<dynamic>.from(_cart.products.map((x) => x.toJson())),
    );

    final responseStream = await request.send();
    final response = await http.Response.fromStream(responseStream);

    return response.statusCode == 200 || response.statusCode == 201;
  }

  String _getFileName(File file) {
    if (file == null) return null;
    List list = List.from(file.path.split('/').reversed);
    return list[0];
  }
}

class Cart {
  int clientId;
  String reference;
  String paymentMethod;
  int discount;
  List<CartProduct> products;

  Cart() {
    reference = '';
    paymentMethod = '';
    discount = 0;
    products = [];
  }

  bool get isValid {
    if (total == null) return false;
    if (total < 0) return false;
    if (discount == null) return false;
    if (discount < 0) return false;
    if (paymentMethod == null) return false;
    if (paymentMethod.isEmpty) return false;
    if (reference == null) return false;
    if (reference.isEmpty) return false;
    if (clientId == null) return false;
    if (products.length == 0) return false;
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

  void removeProduct(Producto product, Tienda store) {
    int pIndex = products.indexWhere((CartProduct item) {
      return item.productId == product.idProducto;
    });

    // Si el producto no existe no se hace nada.
    if (pIndex == -1) return;

    int sIndex = products[pIndex].stores.indexWhere((CartStore item) {
      return item.storeId == store.idTiendas;
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
      return item.productId == product.idProducto;
    });

    if (pIndex == -1) {
      // Si el producto es nuevo.
      products.add(
        CartProduct(
          product.idProducto,
          [CartStore(store.idTiendas, stock, store)],
          product,
        ),
      );
    }

    if (pIndex != -1) {
      // Si el producto ya existe.
      int sIndex = products[pIndex].stores.indexWhere((CartStore item) {
        return item.storeId == store.idTiendas;
      });

      if (sIndex == -1) {
        // Si la tienda es nueva.
        products[pIndex].stores.add(
              CartStore(store.idTiendas, stock, store),
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

  CartProduct(this.productId, this.stores, this.product);

  Map<String, dynamic> toJson() => {
        "id_producto": productId,
        "tiendas": List<dynamic>.from(
          stores.map((x) => x.toJson()),
        ),
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

  CartStore(this.storeId, this.quantity, this.store);

  Map<String, dynamic> toJson() => {
        "id_tienda": storeId,
        "cantidad": quantity,
      };
}
