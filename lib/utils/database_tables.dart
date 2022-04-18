class DatabaseTables {
  static const String dashboardResume = '''CREATE TABLE dashboard_resume(
      id INTEGER PRIMARY KEY,
      cantidad_clientes INTEGER,
      cantidad_clientes_atendidos INTEGER,
      cantidad_tiendas INTEGER,
      cantidad_pqrs INTEGER,
      cantidad_pedidos TEXT
    );''';

  static const String clientsResume = '''CREATE TABLE clients_resume(
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER,
    cupo_preaprobado INTEGER,
    cupo_disponible INTEGER,
    saldo_total_deuda INTEGER,
    saldo_mora INTEGER
  );''';

  static const String sellersResume = '''CREATE TABLE sellers_resume(
    id INTEGER PRIMARY KEY,
    vendedor_id INTEGER,
    comisiones_perdidas INTEGER,
    comisiones_proximas_perder INTEGER,
    comisiones_ganadas INTEGER
  );''';

  static const String products = '''CREATE TABLE products(
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
  );''';

  static const String images = '''CREATE TABLE images(
    id INTEGER PRIMARY KEY,
    url TEXT,
    image_file TEXT
  );''';

  static const String catalogues = '''CREATE TABLE catalogues(
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
  );''';

  static const String clients = '''CREATE TABLE clients(
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
  );''';

  static const String stores = '''CREATE TABLE stores(
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
  );''';

  static const String ratings = '''CREATE TABLE ratings(
    id INTEGER PRIMARY KEY,
    producto_id TEXT,
    cantidad_valoraciones INTEGER,
    usuarios TEXT,
    valoraciones TEXT
  );''';

  static const String questions = '''CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    id_form INTEGER,
    catalogo INTEGER,
    id_pregunta INTEGER,
    encuesta INTEGER,
    pregunta TEXT,
    respuesta INT,
    created_at TEXT,
    updated_at TEXT
  );''';

  static const String orders = '''CREATE TABLE orders(
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
  );''';

  static const String offlineOrders = '''CREATE TABLE offline_orders(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT
  );''';

  static const String offlineQuotas = '''CREATE TABLE offline_quotas(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT
  );''';
}
