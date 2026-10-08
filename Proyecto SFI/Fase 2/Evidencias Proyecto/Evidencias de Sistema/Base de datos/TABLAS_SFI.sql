-- SFI - DDL de referencia para MySQL 8
-- Generado desde los modelos activos al 02-10-2026.
-- No contiene datos, contraseñas ni credenciales.
-- La forma oficial de construir la base sigue siendo: python manage.py migrate
-- Requiere que las tablas auth_group y auth_permission de Django ya existan.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS usuarios_usuario (
  id BIGINT NOT NULL AUTO_INCREMENT,
  password VARCHAR(128) NOT NULL,
  last_login DATETIME(6) NULL,
  is_superuser BOOLEAN NOT NULL DEFAULT FALSE,
  username VARCHAR(150) NOT NULL,
  first_name VARCHAR(150) NOT NULL DEFAULT '',
  last_name VARCHAR(150) NOT NULL DEFAULT '',
  email VARCHAR(254) NOT NULL,
  is_staff BOOLEAN NOT NULL DEFAULT FALSE,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  date_joined DATETIME(6) NOT NULL,
  rut VARCHAR(12) NOT NULL,
  telefono VARCHAR(15) NOT NULL,
  email_confirmado BOOLEAN NOT NULL DEFAULT FALSE,
  correo_activacion_enviado_en DATETIME(6) NULL,
  activacion_expira_en DATETIME(6) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuario_username (username),
  UNIQUE KEY uq_usuario_email (email),
  UNIQUE KEY uq_usuario_rut (rut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS usuarios_usuario_groups (
  id BIGINT NOT NULL AUTO_INCREMENT,
  usuario_id BIGINT NOT NULL,
  group_id INT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuario_grupo (usuario_id, group_id),
  CONSTRAINT fk_usuario_grupo_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios_usuario(id),
  CONSTRAINT fk_usuario_grupo_grupo FOREIGN KEY (group_id) REFERENCES auth_group(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS usuarios_usuario_user_permissions (
  id BIGINT NOT NULL AUTO_INCREMENT,
  usuario_id BIGINT NOT NULL,
  permission_id INT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuario_permiso (usuario_id, permission_id),
  CONSTRAINT fk_usuario_permiso_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios_usuario(id),
  CONSTRAINT fk_usuario_permiso_permiso FOREIGN KEY (permission_id) REFERENCES auth_permission(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS productos_proveedor (
  id BIGINT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(160) NOT NULL,
  nombre_contacto VARCHAR(160) NOT NULL DEFAULT '',
  email VARCHAR(254) NOT NULL,
  telefono VARCHAR(40) NOT NULL DEFAULT '',
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  creado_en DATETIME(6) NOT NULL,
  actualizado_en DATETIME(6) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_proveedor_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS productos_producto (
  id BIGINT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(200) NOT NULL,
  descripcion LONGTEXT NOT NULL,
  precio INT NOT NULL,
  imagen VARCHAR(255) NOT NULL,
  stock INT UNSIGNED NOT NULL DEFAULT 0,
  controla_vencimiento BOOLEAN NOT NULL DEFAULT FALSE,
  categoria VARCHAR(100) NOT NULL,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  marca VARCHAR(100) NOT NULL DEFAULT '',
  modelo VARCHAR(120) NOT NULL DEFAULT '',
  sku VARCHAR(50) NULL,
  color VARCHAR(80) NOT NULL DEFAULT '',
  color_hex VARCHAR(7) NOT NULL DEFAULT '',
  ambiente_uso VARCHAR(20) NOT NULL DEFAULT 'no_aplica',
  superficies_compatibles JSON NOT NULL,
  tipo_pintura VARCHAR(20) NOT NULL DEFAULT 'no_aplica',
  terminacion VARCHAR(20) NOT NULL DEFAULT 'no_aplica',
  propiedades_pintura JSON NOT NULL,
  preparaciones_recomendadas JSON NOT NULL,
  secado_tacto_horas DECIMAL(6,2) NULL,
  repintado_min_horas DECIMAL(6,2) NULL,
  repintado_max_horas DECIMAL(6,2) NULL,
  proveedor_id BIGINT NULL,
  stock_minimo INT UNSIGNED NOT NULL DEFAULT 5,
  unidad_venta VARCHAR(20) NOT NULL DEFAULT 'unidad',
  contenido DECIMAL(10,3) NULL,
  unidad_contenido VARCHAR(20) NOT NULL DEFAULT '',
  tipo_calculo VARCHAR(20) NOT NULL DEFAULT 'ninguno',
  rendimiento DECIMAL(10,3) NULL,
  unidad_rendimiento VARCHAR(30) NOT NULL DEFAULT '',
  capas_recomendadas SMALLINT UNSIGNED NULL,
  porcentaje_desperdicio DECIMAL(5,2) NOT NULL DEFAULT 10.00,
  uso_recomendado LONGTEXT NOT NULL,
  especificaciones JSON NOT NULL,
  informacion_tecnica_verificada BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (id),
  UNIQUE KEY uq_producto_sku (sku),
  KEY ix_producto_proveedor (proveedor_id),
  CONSTRAINT fk_producto_proveedor FOREIGN KEY (proveedor_id) REFERENCES productos_proveedor(id),
  CONSTRAINT ck_producto_precio CHECK (precio > 0),
  CONSTRAINT ck_producto_stock CHECK (stock >= 0),
  CONSTRAINT ck_producto_contenido CHECK (contenido IS NULL OR contenido > 0),
  CONSTRAINT ck_producto_rendimiento CHECK (rendimiento IS NULL OR rendimiento > 0),
  CONSTRAINT ck_producto_desperdicio CHECK (porcentaje_desperdicio BETWEEN 0 AND 50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS productos_historialprecio (
  id BIGINT NOT NULL AUTO_INCREMENT,
  producto_id BIGINT NOT NULL,
  precio_anterior INT NOT NULL,
  precio_nuevo INT NOT NULL,
  fecha DATETIME(6) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_historial_precio_producto FOREIGN KEY (producto_id) REFERENCES productos_producto(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS productos_solicitudreposicion (
  id BIGINT NOT NULL AUTO_INCREMENT,
  proveedor_id BIGINT NOT NULL,
  creada_por_id BIGINT NOT NULL,
  estado VARCHAR(20) NOT NULL,
  email_destino VARCHAR(254) NOT NULL,
  asunto VARCHAR(200) NOT NULL,
  observaciones LONGTEXT NOT NULL,
  error_envio LONGTEXT NOT NULL,
  creada_en DATETIME(6) NOT NULL,
  enviada_en DATETIME(6) NULL,
  recibida_en DATETIME(6) NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_solicitud_proveedor FOREIGN KEY (proveedor_id) REFERENCES productos_proveedor(id),
  CONSTRAINT fk_solicitud_usuario FOREIGN KEY (creada_por_id) REFERENCES usuarios_usuario(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS productos_detallesolicitudreposicion (
  id BIGINT NOT NULL AUTO_INCREMENT,
  solicitud_id BIGINT NOT NULL,
  producto_id BIGINT NOT NULL,
  cantidad_solicitada INT UNSIGNED NOT NULL,
  stock_al_solicitar INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_solicitud_producto (solicitud_id, producto_id),
  CONSTRAINT fk_detalle_solicitud FOREIGN KEY (solicitud_id) REFERENCES productos_solicitudreposicion(id),
  CONSTRAINT fk_detalle_solicitud_producto FOREIGN KEY (producto_id) REFERENCES productos_producto(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS productos_recepcionreposicion (
  id BIGINT NOT NULL AUTO_INCREMENT,
  solicitud_id BIGINT NOT NULL,
  recibida_por_id BIGINT NOT NULL,
  estado VARCHAR(20) NOT NULL,
  clave_idempotencia VARCHAR(100) NOT NULL,
  observaciones LONGTEXT NOT NULL,
  recibida_en DATETIME(6) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_recepcion_idempotencia (clave_idempotencia),
  CONSTRAINT fk_recepcion_solicitud FOREIGN KEY (solicitud_id) REFERENCES productos_solicitudreposicion(id),
  CONSTRAINT fk_recepcion_usuario FOREIGN KEY (recibida_por_id) REFERENCES usuarios_usuario(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS productos_detallerecepcionreposicion (
  id BIGINT NOT NULL AUTO_INCREMENT,
  recepcion_id BIGINT NOT NULL,
  detalle_solicitud_id BIGINT NOT NULL,
  cantidad_recibida INT UNSIGNED NOT NULL DEFAULT 0,
  resultado VARCHAR(20) NOT NULL,
  motivo LONGTEXT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_recepcion_detalle (recepcion_id, detalle_solicitud_id),
  CONSTRAINT fk_detalle_recepcion FOREIGN KEY (recepcion_id) REFERENCES productos_recepcionreposicion(id),
  CONSTRAINT fk_detalle_recepcion_solicitud FOREIGN KEY (detalle_solicitud_id) REFERENCES productos_detallesolicitudreposicion(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS carro_compras_venta (
  id BIGINT NOT NULL AUTO_INCREMENT,
  id_usuario_id BIGINT NOT NULL,
  fecha_compra DATETIME(6) NULL,
  total_venta INT NOT NULL,
  estado_venta VARCHAR(20) NOT NULL,
  webpay_transaction_id VARCHAR(100) NULL,
  webpay_payment_status VARCHAR(50) NULL,
  webpay_amount BIGINT UNSIGNED NULL,
  webpay_buy_order VARCHAR(26) NULL,
  webpay_session_id VARCHAR(61) NULL,
  ultimos_digitos VARCHAR(4) NULL,
  tipo_entrega VARCHAR(10) NOT NULL,
  direccion_despacho LONGTEXT NULL,
  estado_entrega VARCHAR(20) NOT NULL,
  eliminado BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (id),
  UNIQUE KEY uq_venta_transaction (webpay_transaction_id),
  UNIQUE KEY uq_venta_buy_order (webpay_buy_order),
  UNIQUE KEY uq_venta_session (webpay_session_id),
  CONSTRAINT fk_venta_usuario FOREIGN KEY (id_usuario_id) REFERENCES usuarios_usuario(id),
  CONSTRAINT ck_venta_total CHECK (total_venta >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS carro_compras_detalle (
  id BIGINT NOT NULL AUTO_INCREMENT,
  id_venta_id BIGINT NOT NULL,
  producto_id BIGINT NULL,
  cantidad_producto INT UNSIGNED NOT NULL,
  subtotal_venta INT NOT NULL,
  nombre_producto VARCHAR(200) NOT NULL,
  precio_unitario INT NOT NULL,
  imagen_producto VARCHAR(500) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_detalle_venta_producto (id_venta_id, producto_id),
  CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta_id) REFERENCES carro_compras_venta(id),
  CONSTRAINT fk_detalle_producto FOREIGN KEY (producto_id) REFERENCES productos_producto(id),
  CONSTRAINT ck_detalle_cantidad CHECK (cantidad_producto > 0),
  CONSTRAINT ck_detalle_precio CHECK (precio_unitario > 0),
  CONSTRAINT ck_detalle_subtotal CHECK (subtotal_venta >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS movimientos_movimientoinventario (
  id BIGINT NOT NULL AUTO_INCREMENT,
  producto_id BIGINT NULL,
  producto_id_original BIGINT UNSIGNED NOT NULL,
  producto_nombre VARCHAR(200) NOT NULL,
  producto_sku VARCHAR(50) NOT NULL,
  categoria VARCHAR(100) NOT NULL,
  marca VARCHAR(100) NOT NULL,
  modelo VARCHAR(120) NOT NULL,
  unidad_venta VARCHAR(20) NOT NULL,
  precio_unitario BIGINT UNSIGNED NOT NULL,
  proveedor_nombre VARCHAR(160) NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  estado VARCHAR(20) NOT NULL,
  origen VARCHAR(30) NOT NULL,
  cantidad_solicitada INT UNSIGNED NOT NULL,
  cantidad_movida INT UNSIGNED NOT NULL,
  cantidad_pendiente INT UNSIGNED NOT NULL,
  entrada INT UNSIGNED NOT NULL,
  salida INT UNSIGNED NOT NULL,
  stock_anterior INT UNSIGNED NULL,
  stock_resultante INT UNSIGNED NULL,
  referencia VARCHAR(120) NOT NULL,
  observacion LONGTEXT NOT NULL,
  cambios JSON NOT NULL,
  responsable_id BIGINT NULL,
  clave_idempotencia VARCHAR(150) NULL,
  creado_en DATETIME(6) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_movimiento_idempotencia (clave_idempotencia),
  KEY ix_movimiento_producto_fecha (producto_id_original, creado_en DESC),
  KEY ix_movimiento_origen_estado_fecha (origen, estado, creado_en DESC),
  CONSTRAINT fk_movimiento_producto FOREIGN KEY (producto_id) REFERENCES productos_producto(id),
  CONSTRAINT fk_movimiento_usuario FOREIGN KEY (responsable_id) REFERENCES usuarios_usuario(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS movimientos_loteinventario (
  id BIGINT NOT NULL AUTO_INCREMENT,
  producto_id BIGINT NOT NULL,
  lote VARCHAR(80) NOT NULL,
  cantidad_disponible INT UNSIGNED NOT NULL,
  fecha_ingreso DATE NOT NULL,
  fecha_vencimiento DATE NOT NULL,
  referencia VARCHAR(120) NOT NULL,
  creado_en DATETIME(6) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_lote_producto (producto_id, lote),
  CONSTRAINT fk_lote_producto FOREIGN KEY (producto_id) REFERENCES productos_producto(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maestros_especialidad (
  id BIGINT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  descripcion LONGTEXT NOT NULL,
  activa BOOLEAN NOT NULL DEFAULT TRUE,
  tipo_licencia VARCHAR(20) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_especialidad_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maestros_perfilmaestro (
  id BIGINT NOT NULL AUTO_INCREMENT,
  usuario_id BIGINT NOT NULL,
  foto VARCHAR(100) NULL,
  descripcion_profesional LONGTEXT NOT NULL,
  anos_experiencia SMALLINT UNSIGNED NOT NULL,
  region VARCHAR(2) NOT NULL,
  comuna VARCHAR(100) NOT NULL,
  zonas_trabajo LONGTEXT NOT NULL,
  disponible BOOLEAN NOT NULL DEFAULT TRUE,
  estado VARCHAR(12) NOT NULL,
  observacion_admin LONGTEXT NOT NULL,
  fecha_aprobacion DATETIME(6) NULL,
  creado_en DATETIME(6) NOT NULL,
  actualizado_en DATETIME(6) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_perfil_usuario (usuario_id),
  KEY ix_perfil_estado (estado),
  CONSTRAINT fk_perfil_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios_usuario(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maestros_perfilmaestro_especialidades (
  id BIGINT NOT NULL AUTO_INCREMENT,
  perfilmaestro_id BIGINT NOT NULL,
  especialidad_id BIGINT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_perfil_especialidad (perfilmaestro_id, especialidad_id),
  CONSTRAINT fk_pe_perfil FOREIGN KEY (perfilmaestro_id) REFERENCES maestros_perfilmaestro(id),
  CONSTRAINT fk_pe_especialidad FOREIGN KEY (especialidad_id) REFERENCES maestros_especialidad(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maestros_documentomaestro (
  id BIGINT NOT NULL AUTO_INCREMENT,
  perfil_id BIGINT NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  archivo VARCHAR(100) NOT NULL,
  estado_revision VARCHAR(12) NOT NULL,
  observacion_admin LONGTEXT NOT NULL,
  subido_en DATETIME(6) NOT NULL,
  actualizado_en DATETIME(6) NOT NULL,
  revisado_en DATETIME(6) NULL,
  revisado_por_id BIGINT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_documento_tipo (perfil_id, tipo),
  CONSTRAINT fk_documento_perfil FOREIGN KEY (perfil_id) REFERENCES maestros_perfilmaestro(id),
  CONSTRAINT fk_documento_revisor FOREIGN KEY (revisado_por_id) REFERENCES usuarios_usuario(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maestros_licenciamaestro (
  id BIGINT NOT NULL AUTO_INCREMENT,
  perfil_id BIGINT NOT NULL,
  tipo_licencia VARCHAR(20) NOT NULL,
  clase VARCHAR(1) NOT NULL,
  numero_licencia VARCHAR(100) NOT NULL,
  archivo VARCHAR(100) NOT NULL,
  estado_revision VARCHAR(12) NOT NULL,
  observacion_admin LONGTEXT NOT NULL,
  subido_en DATETIME(6) NOT NULL,
  actualizado_en DATETIME(6) NOT NULL,
  revisado_en DATETIME(6) NULL,
  revisado_por_id BIGINT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_licencia_tipo (perfil_id, tipo_licencia),
  CONSTRAINT fk_licencia_perfil FOREIGN KEY (perfil_id) REFERENCES maestros_perfilmaestro(id),
  CONSTRAINT fk_licencia_revisor FOREIGN KEY (revisado_por_id) REFERENCES usuarios_usuario(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maestros_apelacionmaestro (
  id BIGINT NOT NULL AUTO_INCREMENT,
  perfil_id BIGINT NOT NULL,
  mensaje LONGTEXT NOT NULL,
  estado VARCHAR(10) NOT NULL,
  enviada_en DATETIME(6) NOT NULL,
  resuelta_en DATETIME(6) NULL,
  revisada_por_id BIGINT NULL,
  observacion_admin LONGTEXT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_apelacion_perfil (perfil_id),
  CONSTRAINT fk_apelacion_perfil FOREIGN KEY (perfil_id) REFERENCES maestros_perfilmaestro(id),
  CONSTRAINT fk_apelacion_revisor FOREIGN KEY (revisada_por_id) REFERENCES usuarios_usuario(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maestros_observacionmaestro (
  id BIGINT NOT NULL AUTO_INCREMENT,
  perfil_id BIGINT NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  texto LONGTEXT NOT NULL,
  registrada_por_id BIGINT NULL,
  creada_en DATETIME(6) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_observacion_perfil FOREIGN KEY (perfil_id) REFERENCES maestros_perfilmaestro(id),
  CONSTRAINT fk_observacion_usuario FOREIGN KEY (registrada_por_id) REFERENCES usuarios_usuario(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maestros_trabajorealizado (
  id BIGINT NOT NULL AUTO_INCREMENT,
  maestro_id BIGINT NOT NULL,
  titulo VARCHAR(150) NOT NULL,
  descripcion LONGTEXT NOT NULL,
  comuna VARCHAR(100) NOT NULL,
  fecha DATE NULL,
  publicado BOOLEAN NOT NULL DEFAULT TRUE,
  creado_en DATETIME(6) NOT NULL,
  actualizado_en DATETIME(6) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_trabajo_maestro FOREIGN KEY (maestro_id) REFERENCES maestros_perfilmaestro(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maestros_trabajorealizado_especialidades (
  id BIGINT NOT NULL AUTO_INCREMENT,
  trabajorealizado_id BIGINT NOT NULL,
  especialidad_id BIGINT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_trabajo_especialidad (trabajorealizado_id, especialidad_id),
  CONSTRAINT fk_te_trabajo FOREIGN KEY (trabajorealizado_id) REFERENCES maestros_trabajorealizado(id),
  CONSTRAINT fk_te_especialidad FOREIGN KEY (especialidad_id) REFERENCES maestros_especialidad(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maestros_imagentrabajorealizado (
  id BIGINT NOT NULL AUTO_INCREMENT,
  trabajo_id BIGINT NOT NULL,
  imagen VARCHAR(100) NOT NULL,
  creada_en DATETIME(6) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_imagen_trabajo FOREIGN KEY (trabajo_id) REFERENCES maestros_trabajorealizado(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
