-- Base de datos Comercial La Estrella — Proyecto Fase 2
-- Esquema traducido de Oracle (Fase 1) a T-SQL (SQL Server 2022)

IF DB_ID('ComercialLaEstrella') IS NULL
BEGIN
    CREATE DATABASE ComercialLaEstrella;
END
GO

USE ComercialLaEstrella;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- CATÁLOGOS BASE (sin dependencias)
CREATE TABLE PAIS (
    codigo_pais INT IDENTITY(1,1) PRIMARY KEY,
    nombre      VARCHAR(60) NOT NULL UNIQUE
);
GO

CREATE TABLE TIPO_TIENDA (
    codigo_tipo_tienda INT IDENTITY(1,1) PRIMARY KEY,
    nombre              VARCHAR(60) NOT NULL UNIQUE
);
GO

CREATE TABLE CARGO (
    codigo_cargo INT IDENTITY(1,1) PRIMARY KEY,
    nombre       VARCHAR(60) NOT NULL UNIQUE
);
GO

CREATE TABLE TIPO_IDENTIFICACION (
    codigo_tipo_identificacion INT IDENTITY(1,1) PRIMARY KEY,
    nombre                      VARCHAR(60) NOT NULL UNIQUE
);
GO

CREATE TABLE CATEGORIA (
    codigo_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre           VARCHAR(60) NOT NULL UNIQUE
);
GO

CREATE TABLE MARCA (
    codigo_marca INT IDENTITY(1,1) PRIMARY KEY,
    nombre       VARCHAR(60) NOT NULL UNIQUE
);
GO

CREATE TABLE ESTADO_VENTA (
    codigo_estado INT IDENTITY(1,1) PRIMARY KEY,
    nombre        VARCHAR(30) NOT NULL UNIQUE
);
GO

CREATE TABLE METODO_PAGO (
    codigo_metodo_pago INT IDENTITY(1,1) PRIMARY KEY,
    nombre              VARCHAR(30) NOT NULL UNIQUE
);
GO

-- DEPENDEN DE UN CATÁLOGO
CREATE TABLE DEPARTAMENTO (
    codigo_departamento INT IDENTITY(1,1) PRIMARY KEY,
    nombre               VARCHAR(60) NOT NULL,
    codigo_pais          INT NOT NULL,
    CONSTRAINT fk_depto_pais FOREIGN KEY (codigo_pais) REFERENCES PAIS(codigo_pais),
    CONSTRAINT uq_depto_nombre_pais UNIQUE (nombre, codigo_pais)
);
GO

CREATE TABLE MUNICIPIO (
    codigo_municipio     INT IDENTITY(1,1) PRIMARY KEY,
    nombre               VARCHAR(60) NOT NULL,
    codigo_departamento  INT NOT NULL,
    CONSTRAINT fk_muni_depto FOREIGN KEY (codigo_departamento) REFERENCES DEPARTAMENTO(codigo_departamento),
    CONSTRAINT uq_muni_nombre_depto UNIQUE (nombre, codigo_departamento)
);
GO

CREATE TABLE TIENDA (
    codigo_tienda       INT IDENTITY(1,1) PRIMARY KEY,
    nombre              VARCHAR(100) NOT NULL,
    direccion           VARCHAR(150) NOT NULL,
    telefono            VARCHAR(20) NOT NULL,
    codigo_municipio    INT NOT NULL,
    codigo_tipo_tienda  INT NOT NULL,
    CONSTRAINT fk_tienda_muni FOREIGN KEY (codigo_municipio) REFERENCES MUNICIPIO(codigo_municipio),
    CONSTRAINT fk_tienda_tipo FOREIGN KEY (codigo_tipo_tienda) REFERENCES TIPO_TIENDA(codigo_tipo_tienda)
);
GO

CREATE TABLE PERSONA (
    codigo_persona    INT IDENTITY(1,1) PRIMARY KEY,
    nombre            VARCHAR(100) NOT NULL,
    apellido          VARCHAR(100) NOT NULL,
    telefono          VARCHAR(20) NOT NULL,
    correo            VARCHAR(100) NULL,
    direccion         VARCHAR(150) NOT NULL,
    codigo_municipio  INT NOT NULL,
    CONSTRAINT fk_persona_muni FOREIGN KEY (codigo_municipio) REFERENCES MUNICIPIO(codigo_municipio)
);
CREATE UNIQUE INDEX uq_persona_correo ON PERSONA(correo) WHERE correo IS NOT NULL;
GO

CREATE TABLE PRODUCTO (
    codigo_producto   INT IDENTITY(1,1) PRIMARY KEY,
    nombre            VARCHAR(100) NOT NULL,
    descripcion       VARCHAR(255) NOT NULL,
    codigo_categoria  INT NOT NULL,
    codigo_marca      INT NOT NULL,
    CONSTRAINT fk_producto_cat FOREIGN KEY (codigo_categoria) REFERENCES CATEGORIA(codigo_categoria),
    CONSTRAINT fk_producto_marca FOREIGN KEY (codigo_marca) REFERENCES MARCA(codigo_marca)
);
GO

-- SUBTIPOS DE PERSONA
CREATE TABLE EMPLEADO (
    codigo_empleado      INT IDENTITY(1,1) PRIMARY KEY,
    fecha_contratacion   DATE NOT NULL,
    codigo_tienda        INT NOT NULL,
    codigo_cargo         INT NOT NULL,
    codigo_persona       INT NOT NULL UNIQUE,
    CONSTRAINT fk_emp_tienda FOREIGN KEY (codigo_tienda) REFERENCES TIENDA(codigo_tienda),
    CONSTRAINT fk_emp_cargo FOREIGN KEY (codigo_cargo) REFERENCES CARGO(codigo_cargo),
    CONSTRAINT fk_emp_persona FOREIGN KEY (codigo_persona) REFERENCES PERSONA(codigo_persona)
);
GO

CREATE TABLE CLIENTE (
    codigo_cliente               INT IDENTITY(1,1) PRIMARY KEY,
    numero_identificacion        VARCHAR(20) NOT NULL,
    codigo_tipo_identificacion   INT NOT NULL,
    codigo_persona                INT NOT NULL UNIQUE,
    CONSTRAINT fk_cli_tipo_id FOREIGN KEY (codigo_tipo_identificacion) REFERENCES TIPO_IDENTIFICACION(codigo_tipo_identificacion),
    CONSTRAINT fk_cli_persona FOREIGN KEY (codigo_persona) REFERENCES PERSONA(codigo_persona),
    CONSTRAINT uq_cli_numid_tipo UNIQUE (numero_identificacion, codigo_tipo_identificacion)
);
GO

-- CATALOGO_PRODUCTO: resuelve N:M entre TIENDA y PRODUCTO
CREATE TABLE CATALOGO_PRODUCTO (
    codigo_tienda      INT NOT NULL,
    codigo_producto    INT NOT NULL,
    precio_vigente     DECIMAL(10,2) NOT NULL,
    existencia_actual  INT NOT NULL,
    PRIMARY KEY (codigo_tienda, codigo_producto),
    CONSTRAINT fk_catprod_tienda FOREIGN KEY (codigo_tienda) REFERENCES TIENDA(codigo_tienda),
    CONSTRAINT fk_catprod_producto FOREIGN KEY (codigo_producto) REFERENCES PRODUCTO(codigo_producto),
    CONSTRAINT ck_catprod_precio CHECK (precio_vigente > 0),
    CONSTRAINT ck_catprod_existencia CHECK (existencia_actual >= 0)
);
GO

-- VENTA
CREATE TABLE VENTA (
    numero_venta     INT IDENTITY(1,1) PRIMARY KEY,
    fecha            DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    codigo_estado    INT NOT NULL,
    codigo_cliente   INT NOT NULL,
    codigo_tienda    INT NOT NULL,
    codigo_empleado  INT NOT NULL,
    CONSTRAINT fk_venta_estado FOREIGN KEY (codigo_estado) REFERENCES ESTADO_VENTA(codigo_estado),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (codigo_cliente) REFERENCES CLIENTE(codigo_cliente),
    CONSTRAINT fk_venta_tienda FOREIGN KEY (codigo_tienda) REFERENCES TIENDA(codigo_tienda),
    CONSTRAINT fk_venta_empleado FOREIGN KEY (codigo_empleado) REFERENCES EMPLEADO(codigo_empleado)
);
GO

-- DESGLOSE_VENTA: resuelve N:M entre VENTA y PRODUCTO
CREATE TABLE DESGLOSE_VENTA (
    numero_venta      INT NOT NULL,
    codigo_producto   INT NOT NULL,
    cantidad          INT NOT NULL,
    precio_unitario   DECIMAL(10,2) NOT NULL,
    subtotal          DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (numero_venta, codigo_producto),
    CONSTRAINT fk_desg_venta FOREIGN KEY (numero_venta) REFERENCES VENTA(numero_venta),
    CONSTRAINT fk_desg_producto FOREIGN KEY (codigo_producto) REFERENCES PRODUCTO(codigo_producto),
    CONSTRAINT ck_desg_cantidad CHECK (cantidad > 0),
    CONSTRAINT ck_desg_preciou CHECK (precio_unitario > 0),
    CONSTRAINT ck_desg_subtotal CHECK (subtotal = cantidad * precio_unitario)
);
GO

-- PAGO
CREATE TABLE PAGO (
    codigo_pago          INT IDENTITY(1,1) PRIMARY KEY,
    monto                DECIMAL(10,2) NOT NULL,
    numero_venta         INT NOT NULL,
    codigo_metodo_pago   INT NOT NULL,
    CONSTRAINT fk_pago_venta FOREIGN KEY (numero_venta) REFERENCES VENTA(numero_venta),
    CONSTRAINT fk_pago_metodo FOREIGN KEY (codigo_metodo_pago) REFERENCES METODO_PAGO(codigo_metodo_pago),
    CONSTRAINT ck_pago_monto CHECK (monto > 0)
);
GO

PRINT 'Esquema de 19 tablas creado correctamente';
GO

-- Vistas

CREATE VIEW Vista_Ventas_Ubicacion AS
SELECT
    t.nombre AS tienda,
    m.nombre AS municipio,
    dep.nombre AS departamento,
    pa.nombre AS pais,
    COUNT(DISTINCT v.numero_venta) AS cantidad_ventas,
    ISNULL(SUM(dv.subtotal), 0) AS total_facturado
FROM TIENDA t
JOIN MUNICIPIO m ON t.codigo_municipio = m.codigo_municipio
JOIN DEPARTAMENTO dep ON m.codigo_departamento = dep.codigo_departamento
JOIN PAIS pa ON dep.codigo_pais = pa.codigo_pais
LEFT JOIN VENTA v ON t.codigo_tienda = v.codigo_tienda
    AND v.codigo_estado <> (SELECT codigo_estado FROM ESTADO_VENTA WHERE nombre = 'ANULADA')
LEFT JOIN DESGLOSE_VENTA dv ON v.numero_venta = dv.numero_venta
GROUP BY t.nombre, m.nombre, dep.nombre, pa.nombre;
GO

CREATE VIEW Vista_Top_Productos AS
SELECT
    p.codigo_producto,
    p.nombre AS producto,
    c.nombre AS categoria,
    ma.nombre AS marca,
    SUM(dv.cantidad) AS unidades_vendidas,
    SUM(dv.subtotal) AS monto_generado
FROM PRODUCTO p
JOIN CATEGORIA c ON p.codigo_categoria = c.codigo_categoria
JOIN MARCA ma ON p.codigo_marca = ma.codigo_marca
JOIN DESGLOSE_VENTA dv ON p.codigo_producto = dv.codigo_producto
JOIN VENTA v ON dv.numero_venta = v.numero_venta
JOIN ESTADO_VENTA ev ON v.codigo_estado = ev.codigo_estado
WHERE ev.nombre <> 'ANULADA'
GROUP BY p.codigo_producto, p.nombre, c.nombre, ma.nombre;
GO

CREATE VIEW Vista_Saldos_Pendientes AS
SELECT
    v.numero_venta,
    (SELECT SUM(d.subtotal) FROM DESGLOSE_VENTA d WHERE d.numero_venta = v.numero_venta) AS total_venta,
    ISNULL((SELECT SUM(p.monto) FROM PAGO p WHERE p.numero_venta = v.numero_venta), 0) AS total_pagado,
    (SELECT SUM(d.subtotal) FROM DESGLOSE_VENTA d WHERE d.numero_venta = v.numero_venta)
    - ISNULL((SELECT SUM(p.monto) FROM PAGO p WHERE p.numero_venta = v.numero_venta), 0) AS diferencia_pendiente
FROM VENTA v
JOIN ESTADO_VENTA ev ON v.codigo_estado = ev.codigo_estado
WHERE ev.nombre = 'REGISTRADA';
GO

-- Trigger: valida existencia y descuenta inventario al insertar un detalle de venta
CREATE TRIGGER trg_Insert_Detalle ON DESGLOSE_VENTA
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN VENTA v ON v.numero_venta = i.numero_venta
        LEFT JOIN CATALOGO_PRODUCTO cp ON cp.codigo_tienda = v.codigo_tienda AND cp.codigo_producto = i.codigo_producto
        WHERE ISNULL(cp.existencia_actual, 0) < i.cantidad
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'Existencia insuficiente para completar la venta.', 1;
        RETURN;
    END

    UPDATE cp
    SET cp.existencia_actual = cp.existencia_actual - i.cantidad
    FROM CATALOGO_PRODUCTO cp
    JOIN inserted i ON cp.codigo_producto = i.codigo_producto
    JOIN VENTA v ON v.numero_venta = i.numero_venta AND cp.codigo_tienda = v.codigo_tienda;
END
GO

-- Trigger: marca una venta como Pagada cuando la suma de sus pagos cubre el total
CREATE TRIGGER trg_Insert_Pago ON PAGO
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE v
    SET v.codigo_estado = (SELECT codigo_estado FROM ESTADO_VENTA WHERE nombre = 'PAGADA')
    FROM VENTA v
    WHERE v.numero_venta IN (SELECT numero_venta FROM inserted)
      AND v.codigo_estado = (SELECT codigo_estado FROM ESTADO_VENTA WHERE nombre = 'REGISTRADA')
      AND ISNULL((SELECT SUM(d.subtotal) FROM DESGLOSE_VENTA d WHERE d.numero_venta = v.numero_venta), 0) > 0
      AND ISNULL((SELECT SUM(p.monto) FROM PAGO p WHERE p.numero_venta = v.numero_venta), 0)
          >= ISNULL((SELECT SUM(d.subtotal) FROM DESGLOSE_VENTA d WHERE d.numero_venta = v.numero_venta), 0);
END
GO

PRINT 'Vistas y triggers creados correctamente';
GO