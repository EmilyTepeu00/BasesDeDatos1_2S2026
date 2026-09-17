-- Generado por Oracle SQL Developer Data Modeler 24.3.1.347.1153
--   en:        2026-09-15 15:15:00 CST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE cargo (
    codigo_cargo NUMBER NOT NULL,
    nombre       VARCHAR2(60) NOT NULL
);

ALTER TABLE cargo ADD CONSTRAINT cargo_pk PRIMARY KEY ( codigo_cargo );

ALTER TABLE cargo ADD CONSTRAINT cargo_nombre_un UNIQUE ( nombre );

CREATE TABLE catalogo_producto (
    precio_vigente           NUMBER(10, 2) NOT NULL,
    existencia_actual        NUMBER(10) NOT NULL,
    tienda_codigo_tienda     NUMBER NOT NULL,
    producto_codigo_producto NUMBER NOT NULL
);

ALTER TABLE catalogo_producto ADD CONSTRAINT catalogo_producto_ck_1 CHECK ( precio_vigente > 0 );

ALTER TABLE catalogo_producto ADD CONSTRAINT catalogo_producto_ck_2 CHECK ( existencia_actual >= 0 );

ALTER TABLE catalogo_producto ADD CONSTRAINT catalogo_producto_pk PRIMARY KEY ( tienda_codigo_tienda,
                                                                                producto_codigo_producto );

CREATE TABLE categoria (
    codigo_categoria NUMBER NOT NULL,
    nombre           VARCHAR2(60) NOT NULL
);

ALTER TABLE categoria ADD CONSTRAINT categoria_pk PRIMARY KEY ( codigo_categoria );

ALTER TABLE categoria ADD CONSTRAINT categoria_nombre_un UNIQUE ( nombre );

CREATE TABLE cliente (
    codigo_cliente                 NUMBER NOT NULL,
    numero_identificacion          VARCHAR2(20) NOT NULL,
    tid_codigo_tipo_identificacion NUMBER NOT NULL,
    persona_codigo_persona         NUMBER NOT NULL
);

CREATE UNIQUE INDEX cliente__idx ON
    cliente (
        persona_codigo_persona
    ASC );

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY ( codigo_cliente );

ALTER TABLE cliente ADD CONSTRAINT cliente_numid_tipo_un UNIQUE ( numero_identificacion,
                                                                  tid_codigo_tipo_identificacion );

CREATE TABLE departamento (
    codigo_departamento NUMBER NOT NULL,
    nombre              VARCHAR2(60) NOT NULL,
    pais_codigo_pais    NUMBER NOT NULL
);

ALTER TABLE departamento ADD CONSTRAINT departamento_pk PRIMARY KEY ( codigo_departamento );

ALTER TABLE departamento ADD CONSTRAINT depto_nombre_pais_un UNIQUE ( nombre,
                                                                      pais_codigo_pais );

CREATE TABLE desglose_venta (
    cantidad                 NUMBER(10) NOT NULL,
    precio_unitario          NUMBER(10, 2) NOT NULL,
    subtotal                 NUMBER(10, 2) NOT NULL,
    venta_numero_venta       NUMBER NOT NULL,
    producto_codigo_producto NUMBER NOT NULL
);

ALTER TABLE desglose_venta ADD CONSTRAINT desglose_venta_ck_1 CHECK ( cantidad > 0 );

ALTER TABLE desglose_venta ADD CONSTRAINT desglose_venta_ck_2 CHECK ( precio_unitario > 0 );

ALTER TABLE desglose_venta
    ADD CONSTRAINT desglose_venta_ck_3 CHECK ( subtotal = cantidad * precio_unitario );

ALTER TABLE desglose_venta ADD CONSTRAINT desglose_venta_pk PRIMARY KEY ( venta_numero_venta,
                                                                          producto_codigo_producto );

CREATE TABLE empleado (
    codigo_empleado        NUMBER NOT NULL,
    fecha_contratacion     DATE NOT NULL,
    tienda_codigo_tienda   NUMBER NOT NULL,
    cargo_codigo_cargo     NUMBER NOT NULL,
    persona_codigo_persona NUMBER NOT NULL
);

CREATE UNIQUE INDEX empleado__idx ON
    empleado (
        persona_codigo_persona
    ASC );

ALTER TABLE empleado ADD CONSTRAINT empleado_pk PRIMARY KEY ( codigo_empleado );

CREATE TABLE estado_venta (
    codigo_estado NUMBER NOT NULL,
    nombre        VARCHAR2(30) NOT NULL
);

ALTER TABLE estado_venta ADD CONSTRAINT estado_venta_pk PRIMARY KEY ( codigo_estado );

ALTER TABLE estado_venta ADD CONSTRAINT estado_venta_nombre_un UNIQUE ( nombre );

CREATE TABLE marca (
    codigo_marca NUMBER NOT NULL,
    nombre       VARCHAR2(60) NOT NULL
);

ALTER TABLE marca ADD CONSTRAINT marca_pk PRIMARY KEY ( codigo_marca );

ALTER TABLE marca ADD CONSTRAINT marca_nombre_un UNIQUE ( nombre );

CREATE TABLE metodo_pago (
    codigo_metodo_pago NUMBER NOT NULL,
    nombre             VARCHAR2(30) NOT NULL
);

ALTER TABLE metodo_pago ADD CONSTRAINT metodo_pago_pk PRIMARY KEY ( codigo_metodo_pago );

ALTER TABLE metodo_pago ADD CONSTRAINT metodo_pago_nombre_un UNIQUE ( nombre );

CREATE TABLE municipio (
    codigo_municipio        NUMBER NOT NULL,
    nombre                  VARCHAR2(60) NOT NULL,
    dep_codigo_departamento NUMBER NOT NULL
);

ALTER TABLE municipio ADD CONSTRAINT municipio_pk PRIMARY KEY ( codigo_municipio );

ALTER TABLE municipio ADD CONSTRAINT muni_nombre_depto_un UNIQUE ( nombre,
                                                                   dep_codigo_departamento );

CREATE TABLE pago (
    codigo_pago                    NUMBER NOT NULL,
    monto                          NUMBER(10, 2) NOT NULL,
    venta_numero_venta             NUMBER NOT NULL,
    metodo_pago_codigo_metodo_pago NUMBER NOT NULL
);

ALTER TABLE pago ADD CONSTRAINT pago_ck_1 CHECK ( monto > 0 );

ALTER TABLE pago ADD CONSTRAINT pago_pk PRIMARY KEY ( codigo_pago );

CREATE TABLE pais (
    codigo_pais NUMBER NOT NULL,
    nombre      VARCHAR2(60) NOT NULL
);

ALTER TABLE pais ADD CONSTRAINT pais_pk PRIMARY KEY ( codigo_pais );

ALTER TABLE pais ADD CONSTRAINT pais_nombre_un UNIQUE ( nombre );

CREATE TABLE persona (
    codigo_persona             NUMBER NOT NULL,
    nombre                     VARCHAR2(100) NOT NULL,
    apellido                   VARCHAR2(100) NOT NULL,
    telefono                   VARCHAR2(20) NOT NULL,
    correo                     VARCHAR2(100),
    direccion                  VARCHAR2(150) NOT NULL,
    municipio_codigo_municipio NUMBER NOT NULL
);

ALTER TABLE persona ADD CONSTRAINT persona_pk PRIMARY KEY ( codigo_persona );

ALTER TABLE persona ADD CONSTRAINT persona_correo_un UNIQUE ( correo );

CREATE TABLE producto (
    codigo_producto            NUMBER NOT NULL,
    nombre                     VARCHAR2(100) NOT NULL,
    descripcion                VARCHAR2(255) NOT NULL,
    categoria_codigo_categoria NUMBER NOT NULL,
    marca_codigo_marca         NUMBER NOT NULL
);

ALTER TABLE producto ADD CONSTRAINT producto_pk PRIMARY KEY ( codigo_producto );

CREATE TABLE tienda (
    codigo_tienda                  NUMBER NOT NULL,
    nombre                         VARCHAR2(100) NOT NULL,
    direccion                      VARCHAR2(150) NOT NULL,
    telefono                       VARCHAR2(20) NOT NULL,
    municipio_codigo_municipio     NUMBER NOT NULL,
    tipo_tienda_codigo_tipo_tienda NUMBER NOT NULL
);

ALTER TABLE tienda ADD CONSTRAINT tienda_pk PRIMARY KEY ( codigo_tienda );

CREATE TABLE tipo_identificacion (
    codigo_tipo_identificacion NUMBER NOT NULL,
    nombre                     VARCHAR2(60) NOT NULL
);

ALTER TABLE tipo_identificacion ADD CONSTRAINT tipo_identificacion_pk PRIMARY KEY ( codigo_tipo_identificacion );

ALTER TABLE tipo_identificacion ADD CONSTRAINT tipo_identificacion_nombre_un UNIQUE ( nombre );

CREATE TABLE tipo_tienda (
    codigo_tipo_tienda NUMBER NOT NULL,
    nombre             VARCHAR2(60) NOT NULL
);

ALTER TABLE tipo_tienda ADD CONSTRAINT tipo_tienda_pk PRIMARY KEY ( codigo_tipo_tienda );

ALTER TABLE tipo_tienda ADD CONSTRAINT tipo_tienda_nombre_un UNIQUE ( nombre );

CREATE TABLE venta (
    numero_venta               NUMBER NOT NULL,
    fecha                      DATE NOT NULL,
    estado_venta_codigo_estado NUMBER NOT NULL,
    cliente_codigo_cliente     NUMBER NOT NULL,
    tienda_codigo_tienda       NUMBER NOT NULL,
    empleado_codigo_empleado   NUMBER NOT NULL
);

ALTER TABLE venta ADD CONSTRAINT venta_pk PRIMARY KEY ( numero_venta );

ALTER TABLE catalogo_producto
    ADD CONSTRAINT catalogo_producto_producto_fk FOREIGN KEY ( producto_codigo_producto )
        REFERENCES producto ( codigo_producto );

ALTER TABLE catalogo_producto
    ADD CONSTRAINT catalogo_producto_tienda_fk FOREIGN KEY ( tienda_codigo_tienda )
        REFERENCES tienda ( codigo_tienda );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_persona_fk FOREIGN KEY ( persona_codigo_persona )
        REFERENCES persona ( codigo_persona );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_tipo_identificacion_fk FOREIGN KEY ( tid_codigo_tipo_identificacion )
        REFERENCES tipo_identificacion ( codigo_tipo_identificacion );

ALTER TABLE departamento
    ADD CONSTRAINT departamento_pais_fk FOREIGN KEY ( pais_codigo_pais )
        REFERENCES pais ( codigo_pais );

ALTER TABLE desglose_venta
    ADD CONSTRAINT desglose_venta_producto_fk FOREIGN KEY ( producto_codigo_producto )
        REFERENCES producto ( codigo_producto );

ALTER TABLE desglose_venta
    ADD CONSTRAINT desglose_venta_venta_fk FOREIGN KEY ( venta_numero_venta )
        REFERENCES venta ( numero_venta );

ALTER TABLE empleado
    ADD CONSTRAINT empleado_cargo_fk FOREIGN KEY ( cargo_codigo_cargo )
        REFERENCES cargo ( codigo_cargo );

ALTER TABLE empleado
    ADD CONSTRAINT empleado_persona_fk FOREIGN KEY ( persona_codigo_persona )
        REFERENCES persona ( codigo_persona );

ALTER TABLE empleado
    ADD CONSTRAINT empleado_tienda_fk FOREIGN KEY ( tienda_codigo_tienda )
        REFERENCES tienda ( codigo_tienda );

ALTER TABLE municipio
    ADD CONSTRAINT municipio_departamento_fk FOREIGN KEY ( dep_codigo_departamento )
        REFERENCES departamento ( codigo_departamento );

ALTER TABLE pago
    ADD CONSTRAINT pago_metodo_pago_fk FOREIGN KEY ( metodo_pago_codigo_metodo_pago )
        REFERENCES metodo_pago ( codigo_metodo_pago );

ALTER TABLE pago
    ADD CONSTRAINT pago_venta_fk FOREIGN KEY ( venta_numero_venta )
        REFERENCES venta ( numero_venta );

ALTER TABLE persona
    ADD CONSTRAINT persona_municipio_fk FOREIGN KEY ( municipio_codigo_municipio )
        REFERENCES municipio ( codigo_municipio );

ALTER TABLE producto
    ADD CONSTRAINT producto_categoria_fk FOREIGN KEY ( categoria_codigo_categoria )
        REFERENCES categoria ( codigo_categoria );

ALTER TABLE producto
    ADD CONSTRAINT producto_marca_fk FOREIGN KEY ( marca_codigo_marca )
        REFERENCES marca ( codigo_marca );

ALTER TABLE tienda
    ADD CONSTRAINT tienda_municipio_fk FOREIGN KEY ( municipio_codigo_municipio )
        REFERENCES municipio ( codigo_municipio );

ALTER TABLE tienda
    ADD CONSTRAINT tienda_tipo_tienda_fk FOREIGN KEY ( tipo_tienda_codigo_tipo_tienda )
        REFERENCES tipo_tienda ( codigo_tipo_tienda );

ALTER TABLE venta
    ADD CONSTRAINT venta_cliente_fk FOREIGN KEY ( cliente_codigo_cliente )
        REFERENCES cliente ( codigo_cliente );

ALTER TABLE venta
    ADD CONSTRAINT venta_empleado_fk FOREIGN KEY ( empleado_codigo_empleado )
        REFERENCES empleado ( codigo_empleado );

ALTER TABLE venta
    ADD CONSTRAINT venta_estado_venta_fk FOREIGN KEY ( estado_venta_codigo_estado )
        REFERENCES estado_venta ( codigo_estado );

ALTER TABLE venta
    ADD CONSTRAINT venta_tienda_fk FOREIGN KEY ( tienda_codigo_tienda )
        REFERENCES tienda ( codigo_tienda );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            19
-- CREATE INDEX                             2
-- ALTER TABLE                             59
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
