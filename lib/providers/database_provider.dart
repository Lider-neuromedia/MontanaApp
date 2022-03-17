import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:montana_mobile/models/client_wallet_resume.dart';
import 'package:montana_mobile/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/models/dashboard_resume.dart';
import 'package:montana_mobile/models/order.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/models/question.dart';
import 'package:montana_mobile/models/rating.dart';
import 'package:montana_mobile/models/store.dart';

class DatabaseProvider {
  static Database _database;
  static final String _databaseName = "montana.db";
  static final int _databaseVersion = 3;

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
    await db.rawDelete("DELETE FROM images;");
  }

  /// --------------------------------------------------------------------------
  /// RESUMENES
  /// --------------------------------------------------------------------------

  Future<void> saveOrUpdateResumeClientWallets(
      List<ResumenCarteraCliente> wallets) async {
    for (final wallet in wallets) {
      await saveOrUpdateResumeClientWallet(wallet);
    }
  }

  Future<void> saveOrUpdateResumeClientWallet(
      ResumenCarteraCliente wallet) async {
    Map<String, dynamic> data = wallet.toJson();
    data['id'] = wallet.clienteId;

    if (await existsRecordById("clients_resume", wallet.clienteId)) {
      await updateRecord("clients_resume", data, wallet.clienteId);
    } else {
      await saveRecord("clients_resume", data);
    }
  }

  /// --------------------------------------------------------------------------
  /// PRODUCTOS
  /// --------------------------------------------------------------------------

  Future<List<Producto>> getProducts() async {
    final list = await getRecords("products");
    final products = List<Producto>.from(list.map((x) {
      Map<String, Object> row = Map<String, Object>.of(x);
      row["id_producto"] = row["id"];
      row["imagenes"] = jsonDecode(row["imagenes"]);
      row["marca"] = row["marca"] != null ? jsonDecode(row["marca"]) : null;
      return Producto.fromJson(row);
    }));
    return products;
  }

  Future<void> saveOrUpdateProducts(
      List<Producto> products, List<int> showRoomCataloguesIds) async {
    for (final product in products) {
      bool isShowRoom = showRoomCataloguesIds.contains(product.catalogoId);
      await saveOrUpdateProduct(product, isShowRoom);
    }
  }

  Future<void> saveOrUpdateProduct(Producto product, bool isShowRoom) async {
    Map<String, dynamic> data = {
      "id": product.id,
      "nombre": product.nombre,
      "codigo": product.codigo,
      "referencia": product.referencia,
      "stock": product.stock,
      "precio": product.precio,
      "descripcion": product.descripcion,
      "sku": product.sku,
      "total": product.total,
      "descuento": product.descuento,
      "iva": product.iva,
      "catalogo": product.catalogoId,
      "image": product.image,
      "imagenes": product.imagenes.isNotEmpty
          ? jsonEncode(List<dynamic>.from(
              product.imagenes.map((x) => x.toJson()),
            ))
          : jsonEncode([]),
      "marca_id": product.marcaId,
      "marca":
          product.marca != null ? jsonEncode(product.marca.toJson()) : null,
      "created_at": product.createdAt.toIso8601String(),
      "updated_at": product.updatedAt.toIso8601String(),
      "tipo": isShowRoom ? "show room" : "",
    };

    if (await existsRecordById("products", product.id)) {
      await updateRecord("products", data, product.id);
    } else {
      await saveRecord("products", data);
    }
  }

  /// --------------------------------------------------------------------------
  /// CATÁLOGOS
  /// --------------------------------------------------------------------------

  Future<void> saveOrUpdateCatalogues(List<Catalogo> catalogues) async {
    for (final catalogue in catalogues) {
      Map<String, dynamic> data = {
        "id": catalogue.id,
        "estado": catalogue.estado,
        "tipo": catalogue.tipo,
        "imagen": catalogue.imagen,
        "titulo": catalogue.titulo,
        "cantidad": catalogue.cantidad,
        "descuento": catalogue.descuento,
        "etiqueta": catalogue.etiqueta,
        "created_at": catalogue.createdAt.toIso8601String(),
        "updated_at": catalogue.updatedAt.toIso8601String(),
      };

      if (await existsRecordById("catalogues", catalogue.id)) {
        await updateRecord("catalogues", data, catalogue.id);
      } else {
        await saveRecord("catalogues", data);
      }
    }
  }

  /// --------------------------------------------------------------------------
  /// CLIENTES
  /// --------------------------------------------------------------------------

  Future<void> saveOrUpdateClients(List<Usuario> clients) async {
    for (final client in clients) {
      await saveOrUpdateClient(client);
    }
  }

  Future<void> saveOrUpdateClient(Usuario client) async {
    Map<String, dynamic> data = {
      "id": client.id,
      "name": client.name,
      "apellidos": client.apellidos,
      "email": client.email,
      "tipo_identificacion": client.tipoIdentificacion,
      "dni": client.dni,
      "rol_id": client.rolId,
      "datos": client.datos.isNotEmpty
          ? jsonEncode(List<dynamic>.from(
              client.datos.map((x) => x.toJson()),
            ))
          : jsonEncode([]),
      "created_at": client.createdAt.toIso8601String(),
      "updated_at": client.updatedAt.toIso8601String(),
    };

    if (await existsRecordById("clients", client.id)) {
      await updateRecord("clients", data, client.id);
    } else {
      await saveRecord("clients", data);
    }
  }

  /// --------------------------------------------------------------------------
  /// RESUME
  /// --------------------------------------------------------------------------

  Future<void> saveOrUpdateDashboardResume(DashboardResumen resume) async {
    const id = 1;

    Map<String, dynamic> data = {
      "id": id,
      "cantidad_clientes": resume.cantidadClientes,
      "cantidad_clientes_atendidos": resume.cantidadClientesAtendidos,
      "cantidad_tiendas": resume.cantidadTiendas,
      "cantidad_pqrs": resume.cantidadPqrs,
      "cantidad_pedidos": jsonEncode(resume.cantidadPedidos.toJson()),
    };

    if (await existsRecordById("dashboard_resume", id)) {
      await updateRecord("dashboard_resume", data, id);
    } else {
      await saveRecord("dashboard_resume", data);
    }
  }

  /// --------------------------------------------------------------------------
  /// RATING
  /// --------------------------------------------------------------------------

  Future<void> saveOrUpdateRating(Rating rating) async {
    Map<String, dynamic> data = {
      "producto_id": rating.productoId,
      "cantidad_valoraciones": rating.cantidadValoraciones,
      "usuarios": rating.usuarios.isNotEmpty
          ? jsonEncode(rating.usuarios)
          : jsonEncode([]),
      "valoraciones": rating.valoraciones.isNotEmpty
          ? jsonEncode(List<dynamic>.from(
              rating.valoraciones.map((x) => x.toJson()),
            ))
          : jsonEncode([])
    };

    await saveRecord("ratings", data);
  }

  /// --------------------------------------------------------------------------
  /// PREGUNTAS
  /// --------------------------------------------------------------------------

  Future<void> saveOrUpdateQuestions(List<Pregunta> questions) async {
    for (final rating in questions) {
      Map<String, dynamic> data = {
        "id_form": rating.idForm,
        "catalogo": rating.catalogo,
        "id_pregunta": rating.idPregunta,
        "encuesta": rating.encuesta,
        "pregunta": rating.pregunta,
        "respuesta": rating.respuesta,
        "created_at": rating.createdAt.toIso8601String(),
        "updated_at": rating.updatedAt.toIso8601String(),
      };

      await saveRecord("questions", data);
    }
  }

  /// --------------------------------------------------------------------------
  /// TIENDAS
  /// --------------------------------------------------------------------------

  Future<void> saveOrUpdateStores(List<Tienda> stores) async {
    for (final store in stores) {
      await saveOrUpdateStore(store);
    }
  }

  Future<void> saveOrUpdateStore(Tienda store) async {
    Map<String, dynamic> data = {
      "id": store.id,
      "nombre": store.nombre,
      "lugar": store.lugar,
      "local": store.local,
      "direccion": store.direccion,
      "telefono": store.telefono,
      "sucursal": store.sucursal,
      "fecha_ingreso": store.fechaIngreso.toIso8601String(),
      "fecha_ultima_compra": store.fechaUltimaCompra.toIso8601String(),
      "cupo": store.cupo,
      "ciudad_codigo": store.ciudadCodigo,
      "zona": store.zona,
      "bloqueado": store.bloqueado,
      "bloqueado_fecha": store.bloqueadoFecha != null
          ? store.bloqueadoFecha.toIso8601String()
          : null,
      "nombre_representante": store.nombreRepresentante,
      "plazo": store.plazo,
      "escala_factura": store.escalaFactura,
      "observaciones": store.observaciones,
      "cliente_id": store.clienteId,
      "cliente":
          store.cliente != null ? jsonEncode(store.cliente.toJson()) : null,
      "vendedores": store.vendedores.isNotEmpty
          ? jsonEncode(List<dynamic>.from(
              store.vendedores.map((x) => x.toJson()),
            ))
          : jsonEncode([]),
      "created_at": store.createdAt.toIso8601String(),
      "updated_at": store.updatedAt.toIso8601String(),
      "check_delete": 0,
    };

    if (await existsRecordById("stores", store.id)) {
      await updateRecord("stores", data, store.id);
    } else {
      await saveRecord("stores", data);
    }
  }

  /// --------------------------------------------------------------------------
  /// ORDENES
  /// --------------------------------------------------------------------------

  Future<void> saveOrUpdateOrders(List<Pedido> orders) async {
    for (final order in orders) {
      await saveOrUpdateOrder(order);
    }
  }

  Future<void> saveOrUpdateOrder(Pedido order) async {
    Map<String, dynamic> data = {
      "id": order.id,
      "fecha": order.fecha.toIso8601String(),
      "codigo": order.codigo,
      "total": order.total,
      "firma": order.firma,
      "vendedor":
          order.vendedor != null ? jsonEncode(order.vendedor.toJson()) : null,
      "cliente":
          order.cliente != null ? jsonEncode(order.cliente.toJson()) : null,
      "estado": order.estado != null ? jsonEncode(order.estado.toJson()) : null,
      "estado_id": order.estadoId,
      "vendedor_id": order.vendedorId,
      "cliente_id": order.clienteId,
      "metodo_pago": order.metodoPago,
      "sub_total": order.subTotal,
      "notas": order.notas,
      "notas_facturacion": order.notasFacturacion,
      "detalles": order.detalles.isNotEmpty
          ? jsonEncode(List<dynamic>.from(
              order.detalles.map((x) => x.toJson()),
            ))
          : jsonEncode([]),
      "novedades": order.novedades.isNotEmpty
          ? jsonEncode(List<dynamic>.from(
              order.novedades.map((x) => x.toJson()),
            ))
          : jsonEncode([]),
    };

    if (await existsRecordById("orders", order.id)) {
      await updateRecord("orders", data, order.id);
    } else {
      await saveRecord("orders", data);
    }
  }

  /// --------------------------------------------------------------------------
  /// CONSULTAS SQL
  /// --------------------------------------------------------------------------

  Future<List<Map<String, Object>>> getRecords(String table,
      {bool withDeleted: true}) async {
    final db = await database;

    if (withDeleted) return await db.query(table);

    return await db.query(
      table,
      where: "check_delete = ?",
      whereArgs: [0],
    );
  }

  Future<Map<String, Object>> getRecordById(String table, int id) async {
    final db = await database;
    final response = await db.query(table, where: "id = ?", whereArgs: [id]);
    return response.isEmpty ? null : response.first;
  }

  Future<bool> existsRecordById(String table, int id) async {
    final db = await database;
    final records = await db.query(table, where: "id = ?", whereArgs: [id]);
    return records.isNotEmpty;
  }

  Future<int> deleteRecord(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  Future<int> saveRecord(String table, Map<String, Object> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<int> updateRecord(
      String table, Map<String, Object> data, int id) async {
    final db = await database;
    return await db.update(table, data, where: "id = ?", whereArgs: [id]);
  }

  Future<int> checkRecordToDelete(String table, int id) async {
    final db = await database;
    return await db.update(
      table,
      {"check_delete": 1},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<MemoryImage> getImage(String path) async {
    final db = await database;
    final records =
        await db.query("images", where: "url = ?", whereArgs: [path]);

    if (records.isEmpty) return null;
    return MemoryImage(base64Decode(records.first["image_file"]));
  }

  Future<List<Map<String, Object>>> getImages() async {
    final db = await database;
    final records = await db.query("images");
    return records;
  }

  Future<void> saveImage(String path) async {
    if (path == null || path.isEmpty) return;

    final url = Uri.parse(path);
    final response = await http.get(url);

    if (response.statusCode != 200 && response.statusCode != 201) return;

    final imageBase64 = base64Encode(response.bodyBytes);
    final db = await database;
    final records =
        await db.query("images", where: "url = ?", whereArgs: [path]);

    if (records.isEmpty) {
      await db.insert("images", {"url": path, "image_file": imageBase64});
    } else {
      await db.update("images", {"image_file": imageBase64},
          where: "url = ?", whereArgs: [path]);
    }
  }

  /// --------------------------------------------------------------------------
  /// TABLAS
  /// --------------------------------------------------------------------------

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE dashboard_resume(
            id INTEGER PRIMARY KEY,
            cantidad_clientes INTEGER,
            cantidad_clientes_atendidos INTEGER,
            cantidad_tiendas INTEGER,
            cantidad_pqrs INTEGER,
            cantidad_pedidos TEXT
          );''');
    await db.execute('''CREATE TABLE clients_resume(
            id INTEGER PRIMARY KEY,
            cliente_id INTEGER,
            cupo_preaprobado INTEGER,
            cupo_disponible INTEGER,
            saldo_total_deuda INTEGER,
            saldo_mora INTEGER
          );''');
    await db.execute('''CREATE TABLE products(
            id INTEGER PRIMARY KEY,
            nombre TEXT,
            codigo TEXT,
            referencia TEXT,
            stock INTEGER,
            precio REAL,
            descripcion TEXT,
            sku TEXT,
            total REAL,
            descuento INTEGER,
            iva INTEGER,
            catalogo INTEGER,
            image TEXT,
            imagenes TEXT,
            marca_id INTEGER,
            marca TEXT,
            created_at TEXT,
            updated_at TEXT,
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
            name TEXT,
            apellidos TEXT,
            email TEXT,
            tipo_identificacion TEXT,
            dni TEXT,
            rol_id INTEGER,
            datos TEXT,
            created_at TEXT,
            updated_at TEXT
          );''');

    await db.execute('''CREATE TABLE stores(
            id INTEGER PRIMARY KEY,
            nombre TEXT,
            lugar TEXT,
            local TEXT,
            direccion TEXT,
            telefono TEXT,
            sucursal TEXT,
            fecha_ingreso TEXT,
            fecha_ultima_compra TEXT,
            cupo INTEGER,
            ciudad_codigo TEXT,
            zona TEXT,
            bloqueado TEXT,
            bloqueado_fecha TEXT,
            nombre_representante TEXT,
            plazo INTEGER,
            escala_factura TEXT,
            observaciones TEXT,
            cliente_id INTEGER,
            cliente TEXT,
            vendedores TEXT,
            created_at TEXT,
            updated_at TEXT,
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
            codigo TEXT,
            total REAL,
            firma TEXT,
            vendedor TEXT,
            cliente TEXT,
            estado TEXT,
            estado_id INTEGER,
            vendedor_id INTEGER,
            cliente_id INTEGER,
            metodo_pago TEXT,
            sub_total REAL,
            notas TEXT,
            notas_facturacion TEXT,
            detalles TEXT,
            novedades TEXT
          );''');
    await db.execute('''CREATE TABLE offline_orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT
          );''');
    await db.execute('''CREATE TABLE offline_quotas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT
          );''');
  }
}
