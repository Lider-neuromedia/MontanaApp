import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/models/dashboard_resume.dart';
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/models/question.dart';
import 'package:montana_mobile/models/rating.dart';
import 'package:montana_mobile/models/status.dart';
import 'package:montana_mobile/models/store.dart';

class DatabaseProvider {
  static Database _database;
  static final String _databaseName = 'montana.db';
  static final int _databaseVersion = 2;

  static final DatabaseProvider db = DatabaseProvider._();

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> dropDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    await deleteDatabase(path);
  }

  Future<void> cleanTables() async {
    final db = await database;
    await db.rawDelete("DELETE FROM dashboard_resume;");
    await db.rawDelete("DELETE FROM catalogues;");
    await db.rawDelete("DELETE FROM products;");
    await db.rawDelete("DELETE FROM clients;");
    await db.rawDelete("DELETE FROM stores;");
    await db.rawDelete("DELETE FROM ratings;");
    await db.rawDelete("DELETE FROM questions;");
    await db.rawDelete("DELETE FROM orders;");
    await db.rawDelete("DELETE FROM offline_orders;");
    await db.rawDelete("DELETE FROM images;");
  }

  Future<void> saveOrUpdateProducts(List<Producto> products,
      {bool isShowRoom = false}) async {
    for (final product in products) {
      await saveOrUpdateProduct(product, isShowRoom);
    }
  }

  Future<void> saveOrUpdateProduct(Producto product, bool isShowRoom) async {
    Map<String, dynamic> data = {
      'id': product.idProducto,
      'nombre': product.nombre,
      'codigo': product.codigo,
      'referencia': product.referencia,
      'stock': product.stock,
      'descripcion': product.descripcion,
      'sku': product.sku,
      'precio': product.precio,
      'total': product.total,
      'descuento': product.descuento,
      'iva': product.iva,
      'catalogo': product.catalogo,
      'marca': product.marcaId,
      'created_at': product.createdAt.toIso8601String(),
      'updated_at': product.updatedAt.toIso8601String(),
      'image': product.image,
      'nombre_marca': product.nombreMarca,
      'imagenes': jsonEncode(
          List<dynamic>.from(product.imagenes.map((x) => x.toJson()))),
      'tipo': isShowRoom ? 'show room' : '',
    };

    if (await existsRecordById('products', product.idProducto)) {
      await updateRecord('products', data, product.idProducto);
    } else {
      await saveRecord('products', data);
    }
  }

  Future<void> saveOrUpdateCatalogues(List<Catalogo> catalogues) async {
    for (final catalogue in catalogues) {
      Map<String, dynamic> data = {
        'id': catalogue.id,
        'estado': catalogue.estado,
        'tipo': catalogue.tipo,
        'imagen': catalogue.imagen,
        'titulo': catalogue.titulo,
        'cantidad': catalogue.cantidad,
        'descuento': catalogue.descuento,
        'etiqueta': catalogue.etiqueta,
        'created_at': catalogue.createdAt.toIso8601String(),
        'updated_at': catalogue.updatedAt.toIso8601String(),
      };

      if (await existsRecordById('catalogues', catalogue.id)) {
        await updateRecord('catalogues', data, catalogue.id);
      } else {
        await saveRecord('catalogues', data);
      }
    }
  }

  Future<void> saveOrUpdateClients(List<Cliente> clients) async {
    for (final client in clients) {
      await saveOrUpdateClient(client);
    }
  }

  Future<void> saveOrUpdateClient(Cliente client) async {
    Map<String, dynamic> data = {
      'id': client.id,
      'rol_id': client.rolId,
      'name': client.name,
      'apellidos': client.apellidos,
      'email': client.email,
      'tipo_identificacion': client.tipoIdentificacion,
      'dni': client.dni,
      'nit': client.nit,
      'id_vendedor_cliente': client.vendedorId,
      'user_data': jsonEncode(List<dynamic>.from(
        client.userData.map((x) => x.toJson()),
      )),
      'vendedor': jsonEncode(client.vendedor.toJson()),
      'tiendas': jsonEncode(List<dynamic>.from(
        client.tiendas.map((x) => x.toJson()),
      )),
      'pedidos': jsonEncode(List<dynamic>.from(
        client.pedidos.map((x) => x.toJson()),
      )),
    };

    if (await existsRecordById('clients', client.id)) {
      await updateRecord('clients', data, client.id);
    } else {
      await saveRecord('clients', data);
    }
  }

  Future<void> saveOrUpdateDashboardResume(DashboardResumen resume) async {
    const id = 1;

    Map<String, dynamic> data = {
      'id': id,
      'cantidad_clientes': resume.cantidadClientes,
      'cantidad_clientes_atendidos': resume.cantidadClientesAtendidos,
      'cantidad_tiendas': resume.cantidadTiendas,
      'cantidad_pqrs': resume.cantidadPqrs,
      'cantidad_pedidos': jsonEncode(resume.cantidadPedidos.toJson()),
    };

    if (await existsRecordById('dashboard_resume', id)) {
      await updateRecord('dashboard_resume', data, id);
    } else {
      await saveRecord('dashboard_resume', data);
    }
  }

  Future<void> saveOrUpdateRating(Rating rating) async {
    Map<String, dynamic> data = {
      'producto_id': rating.productoId,
      'cantidad_valoraciones': rating.cantidadValoraciones,
      'usuarios': jsonEncode(rating.usuarios),
      'valoraciones': jsonEncode(List<dynamic>.from(
        rating.valoraciones.map((x) => x.toJson()),
      ))
    };

    await saveRecord('ratings', data);
  }

  Future<void> saveOrUpdateQuestions(List<Pregunta> questions) async {
    for (final rating in questions) {
      Map<String, dynamic> data = {
        'id_form': rating.idForm,
        'catalogo': rating.catalogo,
        'id_pregunta': rating.idPregunta,
        'encuesta': rating.encuesta,
        'pregunta': rating.pregunta,
        'respuesta': rating.respuesta,
        'created_at': rating.createdAt.toIso8601String(),
        'updated_at': rating.updatedAt.toIso8601String(),
      };

      await saveRecord('questions', data);
    }
  }

  Future<void> saveOrUpdateStores(List<Tienda> stores) async {
    for (final store in stores) {
      await saveOrUpdateStore(store);
    }
  }

  Future<void> saveOrUpdateStore(Tienda store) async {
    Map<String, dynamic> data = {
      'id': store.idTiendas,
      'nombre': store.nombre,
      'lugar': store.lugar,
      'local': store.local,
      'direccion': store.direccion,
      'telefono': store.telefono,
      'created_at': store.createdAt.toIso8601String(),
      'updated_at': store.updatedAt.toIso8601String(),
      'cliente': store.cliente,
      'check_delete': 0,
    };

    if (await existsRecordById('stores', store.idTiendas)) {
      await updateRecord('stores', data, store.idTiendas);
    } else {
      await saveRecord('stores', data);
    }
  }

  Future<void> saveOrUpdateOrders(List<Pedido> orders) async {
    for (final order in orders) {
      await saveOrUpdateOrder(order);
    }
  }

  Future<void> saveOrUpdateOrder(Pedido order) async {
    Map<String, dynamic> data = {
      "id": order.idPedido,
      "fecha": order.fecha.toIso8601String(),
      "firma": order.firma,
      "codigo": order.codigo,
      "metodo_pago": order.metodoPago,
      "total": order.total,
      "sub_total": order.subTotal,
      "descuento": order.descuento,
      "notas": order.notas,
      "vendedor": order.vendedorId,
      "cliente": order.clienteId,
      "id_estado": order.idEstado,
      "estado": estadoValues.reverse[order.estado],
      "info_cliente": jsonEncode(order.cliente.toJson()),
      "name_vendedor": order.nameVendedor,
      "apellido_vendedor": order.apellidoVendedor,
      "name_cliente": order.nameCliente,
      "apellido_cliente": order.apellidoCliente,
      "productos": jsonEncode(
          List<dynamic>.from(order.productos.map((x) => x.toJson()))),
      "novedades": jsonEncode(
          List<dynamic>.from(order.novedades.map((x) => x.toJson()))),
      "created_at": order.createdAt.toIso8601String(),
      "updated_at": order.updatedAt.toIso8601String(),
    };

    if (await existsRecordById('orders', order.idPedido)) {
      await updateRecord('orders', data, order.idPedido);
    } else {
      await saveRecord('orders', data);
    }
  }

  Future<List<Producto>> getProducts() async {
    final list = await getRecords('products');
    final products = List<Producto>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row['id_producto'] = row['id'];
      row['imagenes'] = jsonDecode(row['imagenes']);
      return Producto.fromJson(row);
    }));
    return products;
  }

  Future<List<Map<String, Object>>> getRecords(String table,
      {bool withDeleted: true}) async {
    final db = await database;

    if (withDeleted) return await db.query(table);

    return await db.query(
      table,
      where: 'check_delete = ?',
      whereArgs: [0],
    );
  }

  Future<Map<String, Object>> getRecordById(String table, int id) async {
    final db = await database;
    final response = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return response.isEmpty ? null : response.first;
  }

  Future<bool> existsRecordById(String table, int id) async {
    final db = await database;
    final records = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return records.isNotEmpty;
  }

  Future<int> deleteRecord(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> saveRecord(String table, Map<String, Object> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<int> updateRecord(
      String table, Map<String, Object> data, int id) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> checkRecordToDelete(String table, int id) async {
    final db = await database;
    return await db.update(
      table,
      {'check_delete': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<MemoryImage> getImage(String path) async {
    final db = await database;
    final records =
        await db.query('images', where: 'url = ?', whereArgs: [path]);

    if (records.isEmpty) return null;
    return MemoryImage(base64Decode(records.first['image_file']));
  }

  Future<List<Map<String, Object>>> getImages() async {
    final db = await database;
    final records = await db.query('images');
    return records;
  }

  Future<void> saveImage(String path) async {
    final url = Uri.parse(path);
    final response = await http.get(url);

    if (response.statusCode != 200 && response.statusCode != 201) return;

    final imageBase64 = base64Encode(response.bodyBytes);
    final db = await database;
    final records =
        await db.query('images', where: 'url = ?', whereArgs: [path]);

    if (records.isEmpty) {
      await db.insert('images', {'url': path, 'image_file': imageBase64});
    } else {
      await db.update('images', {'image_file': imageBase64},
          where: 'url = ?', whereArgs: [path]);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE dashboard_resume(
            id INTEGER PRIMARY KEY,
            cantidad_clientes INTEGER,
            cantidad_clientes_atendidos INTEGER,
            cantidad_tiendas INTEGER,
            cantidad_pqrs INTEGER,
            cantidad_pedidos TEXT
          );''');
    await db.execute('''CREATE TABLE products(
            id INTEGER PRIMARY KEY,
            nombre TEXT,
            codigo TEXT,
            referencia TEXT,
            stock INTEGER,
            descripcion TEXT,
            sku TEXT,
            precio REAL,
            total REAL,
            descuento INTEGER,
            iva INTEGER,
            catalogo INTEGER,
            marca INTEGER,
            created_at TEXT,
            updated_at TEXT,
            image TEXT,
            nombre_marca TEXT,
            imagenes TEXT,
            tipo TEXT
          );''');
    await db.execute('''CREATE TABLE images(
            id INTEGER PRIMARY KEY,
            url TEXT,
            image_file TEXT
          );''');
    await db.execute('''CREATE TABLE catalogues(
            id INTEGER PRIMARY KEY,
            estado TEXT,
            tipo TEXT,
            imagen TEXT,
            titulo TEXT,
            cantidad INTEGER,
            descuento INTEGER,
            etiqueta TEXT,
            created_at TEXT,
            updated_at TEXT
          );''');
    await db.execute('''CREATE TABLE clients(
            id INTEGER PRIMARY KEY,
            rol_id INTEGER,
            name TEXT,
            apellidos TEXT,
            email TEXT,
            tipo_identificacion TEXT,
            dni TEXT,
            nit TEXT,
            id_vendedor_cliente INTEGER,
            user_data TEXT,
            vendedor TEXT,
            tiendas TEXT,
            pedidos TEXT
          );''');
    await db.execute('''CREATE TABLE stores(
            id INTEGER PRIMARY KEY,
            nombre TEXT,
            lugar TEXT,
            local TEXT,
            direccion TEXT,
            telefono TEXT,
            created_at TEXT,
            updated_at TEXT,
            cliente INTEGER,
            check_delete INTEGER
          );''');
    await db.execute('''CREATE TABLE ratings(
            id INTEGER PRIMARY KEY,
            producto_id TEXT,
            cantidad_valoraciones INTEGER,
            usuarios TEXT,
            valoraciones TEXT
          );''');
    await db.execute('''CREATE TABLE questions(
            id INTEGER PRIMARY KEY,
            id_form INTEGER,
            catalogo INTEGER,
            id_pregunta INTEGER,
            encuesta INTEGER,
            pregunta TEXT,
            respuesta INT,
            created_at TEXT,
            updated_at TEXT
          );''');
    await db.execute('''CREATE TABLE orders(
            id INTEGER PRIMARY KEY,
            fecha TEXT,
            firma TEXT,
            codigo TEXT,
            metodo_pago TEXT,
            total TEXT,
            sub_total TEXT,
            descuento INTEGER,
            notas TEXT,
            vendedor INTEGER,
            cliente INTEGER,
            id_estado INTEGER,
            estado TEXT,
            info_cliente TEXT,
            name_vendedor TEXT,
            apellido_vendedor TEXT,
            name_cliente TEXT,
            apellido_cliente TEXT,
            productos TEXT,
            novedades TEXT,
            created_at TEXT,
            updated_at TEXT
          );''');
    await db.execute('''CREATE TABLE offline_orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT
          );''');
  }
}
