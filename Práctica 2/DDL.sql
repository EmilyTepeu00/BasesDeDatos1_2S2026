-- Generado por Oracle SQL Developer Data Modeler 24.3.1.347.1153
--   en:        2026-08-14 22:37:38 CST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE bitacora (
    id_bitacora              NUMBER NOT NULL,
    correlativo              NUMBER,
    fecha                    DATE,
    horas_trabajadas         NUMBER(5, 2),
    actividades              VARCHAR2(500),
    observaciones            VARCHAR2(500),
    validada                 CHAR(1),
    colocacion_id_colocacion NUMBER NOT NULL
);

ALTER TABLE bitacora ADD CONSTRAINT bitacora_pk PRIMARY KEY ( id_bitacora );

CREATE TABLE catedratico (
    id_catedratico         NUMBER NOT NULL,
    nombre                 VARCHAR2(100),
    identificacion         VARCHAR2(30),
    telefono               VARCHAR2(20),
    especialidad           VARCHAR2(100),
    instituto_id_instituto NUMBER NOT NULL
);

ALTER TABLE catedratico ADD CONSTRAINT catedratico_pk PRIMARY KEY ( id_catedratico );

CREATE TABLE colocacion (
    id_colocacion              NUMBER NOT NULL,
    fecha_inicio               DATE,
    fecha_final                DATE,
    estado                     VARCHAR2(20),
    estudiante_id_estudiante   NUMBER NOT NULL,
    plaza_id_plaza             NUMBER NOT NULL,
    catedratico_id_catedratico NUMBER NOT NULL
);

ALTER TABLE colocacion ADD CONSTRAINT colocacion_pk PRIMARY KEY ( id_colocacion );

CREATE TABLE contacto_empresarial (
    id_contacto        NUMBER NOT NULL,
    nombre             VARCHAR2(100),
    telefono           VARCHAR2(20),
    correo             VARCHAR2(100),
    empresa_id_empresa NUMBER NOT NULL
);

ALTER TABLE contacto_empresarial ADD CONSTRAINT contacto_empresarial_pk PRIMARY KEY ( id_contacto );

CREATE TABLE criterio_evaluacion (
    id_criterio     NUMBER NOT NULL,
    nombre_criterio VARCHAR2(100),
    descripcion     VARCHAR2(200)
);

ALTER TABLE criterio_evaluacion ADD CONSTRAINT criterio_evaluacion_pk PRIMARY KEY ( id_criterio );

CREATE TABLE detalle_evaluacion (
    puntuacion               NUMBER(1) NOT NULL,
    evaluacion_id_evaluacion NUMBER NOT NULL,
    id_criterio              NUMBER NOT NULL
);

ALTER TABLE detalle_evaluacion ADD CONSTRAINT detalle_evaluacion_pk PRIMARY KEY ( evaluacion_id_evaluacion,
                                                                                  id_criterio );

CREATE TABLE empresa (
    id_empresa       NUMBER NOT NULL,
    nombre           VARCHAR2(100),
    direccion        VARCHAR2(200),
    sector_economico VARCHAR2(20)
);

ALTER TABLE empresa ADD CONSTRAINT empresa_pk PRIMARY KEY ( id_empresa );

CREATE TABLE estudiante (
    id_estudiante          NUMBER NOT NULL,
    nombre_completo        VARCHAR2(150),
    carnet                 VARCHAR2(20),
    carrera_tecnica        VARCHAR2(100),
    direccion              VARCHAR2(200),
    telefono               VARCHAR2(20),
    fecha_nacimiento       DATE,
    genero                 VARCHAR2(15),
    departamento           VARCHAR2(50),
    municipio              VARCHAR2(50),
    es_primera_practica    CHAR(1),
    instituto_id_instituto NUMBER NOT NULL
);

ALTER TABLE estudiante ADD CONSTRAINT estudiante_pk PRIMARY KEY ( id_estudiante );

CREATE TABLE evaluacion (
    id_evaluacion              NUMBER NOT NULL,
    tipo_evaluacion            VARCHAR2(20),
    fecha_evaluacion           DATE,
    colocacion_id_colocacion   NUMBER NOT NULL,
    catedratico_id_catedratico NUMBER NOT NULL
);

ALTER TABLE evaluacion ADD CONSTRAINT evaluacion_pk PRIMARY KEY ( id_evaluacion );

CREATE TABLE instituto (
    id_instituto                NUMBER NOT NULL,
    nombre                      VARCHAR2(150),
    direccion                   VARCHAR2(200),
    codigo_autorizacion_mineduc VARCHAR2(50)
);

ALTER TABLE instituto ADD CONSTRAINT instituto_pk PRIMARY KEY ( id_instituto );

CREATE TABLE plaza (
    id_plaza             NUMBER NOT NULL,
    especialidad_tecnica VARCHAR2(100),
    empresa_id_empresa   NUMBER NOT NULL,
    id_contacto_plaza    NUMBER NOT NULL
);

ALTER TABLE plaza ADD CONSTRAINT plaza_pk PRIMARY KEY ( id_plaza );

ALTER TABLE bitacora
    ADD CONSTRAINT bitacora_colocacion_fk FOREIGN KEY ( colocacion_id_colocacion )
        REFERENCES colocacion ( id_colocacion );

ALTER TABLE catedratico
    ADD CONSTRAINT catedratico_instituto_fk FOREIGN KEY ( instituto_id_instituto )
        REFERENCES instituto ( id_instituto );

ALTER TABLE colocacion
    ADD CONSTRAINT colocacion_catedratico_fk FOREIGN KEY ( catedratico_id_catedratico )
        REFERENCES catedratico ( id_catedratico );

ALTER TABLE colocacion
    ADD CONSTRAINT colocacion_estudiante_fk FOREIGN KEY ( estudiante_id_estudiante )
        REFERENCES estudiante ( id_estudiante );

ALTER TABLE colocacion
    ADD CONSTRAINT colocacion_plaza_fk FOREIGN KEY ( plaza_id_plaza )
        REFERENCES plaza ( id_plaza );

ALTER TABLE contacto_empresarial
    ADD CONSTRAINT ce_empresa_fk FOREIGN KEY ( empresa_id_empresa )
        REFERENCES empresa ( id_empresa );
 
ALTER TABLE detalle_evaluacion
    ADD CONSTRAINT det_eval_criterio_fk FOREIGN KEY ( id_criterio )
        REFERENCES criterio_evaluacion ( id_criterio );

ALTER TABLE detalle_evaluacion
    ADD CONSTRAINT det_eval_evaluacion_fk FOREIGN KEY ( evaluacion_id_evaluacion )
        REFERENCES evaluacion ( id_evaluacion );

ALTER TABLE estudiante
    ADD CONSTRAINT estudiante_instituto_fk FOREIGN KEY ( instituto_id_instituto )
        REFERENCES instituto ( id_instituto );

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacion_catedratico_fk FOREIGN KEY ( catedratico_id_catedratico )
        REFERENCES catedratico ( id_catedratico );

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacion_colocacion_fk FOREIGN KEY ( colocacion_id_colocacion )
        REFERENCES colocacion ( id_colocacion );

ALTER TABLE plaza
    ADD CONSTRAINT plaza_contacto_empresarial_fk FOREIGN KEY ( id_contacto_plaza )
        REFERENCES contacto_empresarial ( id_contacto );

ALTER TABLE plaza
    ADD CONSTRAINT plaza_empresa_fk FOREIGN KEY ( empresa_id_empresa )
        REFERENCES empresa ( id_empresa );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             0
-- ALTER TABLE                             24
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
-- ERRORS                                   3
-- WARNINGS                                 0


-- PARA LA PRÁCTICA 2: Consultas Avanzadas, Agrupaciones

-- Eliminar las tablas de la práctica 1
DROP TABLE bitacora CASCADE CONSTRAINTS PURGE;
DROP TABLE detalle_evaluacion CASCADE CONSTRAINTS PURGE;
DROP TABLE evaluacion CASCADE CONSTRAINTS PURGE;
DROP TABLE colocacion CASCADE CONSTRAINTS PURGE;
DROP TABLE plaza CASCADE CONSTRAINTS PURGE;
DROP TABLE estudiante CASCADE CONSTRAINTS PURGE;
DROP TABLE catedratico CASCADE CONSTRAINTS PURGE;
DROP TABLE contacto_empresarial CASCADE CONSTRAINTS PURGE;
DROP TABLE empresa CASCADE CONSTRAINTS PURGE;
DROP TABLE instituto CASCADE CONSTRAINTS PURGE;
DROP TABLE criterio_evaluacion CASCADE CONSTRAINTS PURGE;

-- CATÁLOGOS NUEVOS (sin dependencias)
CREATE TABLE SECTOR_ECONOMICO (
    ID_SECTOR NUMBER NOT NULL,
    NOMBRE    VARCHAR2(50) NOT NULL
);
ALTER TABLE SECTOR_ECONOMICO ADD CONSTRAINT sector_pk PRIMARY KEY (ID_SECTOR);

CREATE TABLE DEPARTAMENTO (
    ID_DEPARTAMENTO NUMBER NOT NULL,
    NOMBRE           VARCHAR2(50) NOT NULL
);
ALTER TABLE DEPARTAMENTO ADD CONSTRAINT depto_pk PRIMARY KEY (ID_DEPARTAMENTO);

CREATE TABLE ESTADO_COLOCACION (
    ID_ESTADO NUMBER NOT NULL,
    NOMBRE    VARCHAR2(30) NOT NULL
);
ALTER TABLE ESTADO_COLOCACION ADD CONSTRAINT estado_pk PRIMARY KEY (ID_ESTADO);

CREATE TABLE TIPO_EVALUACION (
    ID_TIPO_EVALUACION NUMBER NOT NULL,
    NOMBRE              VARCHAR2(30) NOT NULL
);
ALTER TABLE TIPO_EVALUACION ADD CONSTRAINT tipo_eval_pk PRIMARY KEY (ID_TIPO_EVALUACION);

CREATE TABLE CRITERIO (
    ID_CRITERIO NUMBER NOT NULL,
    NOMBRE      VARCHAR2(100) NOT NULL
);
ALTER TABLE CRITERIO ADD CONSTRAINT criterio_pk PRIMARY KEY (ID_CRITERIO);

CREATE TABLE INSTITUTO (
    ID_INSTITUTO        NUMBER NOT NULL,
    NOMBRE              VARCHAR2(150) NOT NULL,
    DIRECCION           VARCHAR2(200) NOT NULL,
    CODIGO_AUTORIZACION VARCHAR2(50) NOT NULL
);
ALTER TABLE INSTITUTO ADD CONSTRAINT instituto_pk PRIMARY KEY (ID_INSTITUTO);

-- DEPENDEN DE UN CATÁLOGO
CREATE TABLE MUNICIPIO (
    ID_MUNICIPIO     NUMBER NOT NULL,
    NOMBRE           VARCHAR2(50) NOT NULL,
    ID_DEPARTAMENTO  NUMBER NOT NULL
);
ALTER TABLE MUNICIPIO ADD CONSTRAINT municipio_pk PRIMARY KEY (ID_MUNICIPIO);
ALTER TABLE MUNICIPIO ADD CONSTRAINT muni_depto_fk FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO (ID_DEPARTAMENTO);

CREATE TABLE EMPRESA (
    ID_EMPRESA NUMBER NOT NULL,
    NOMBRE     VARCHAR2(100) NOT NULL,
    DIRECCION  VARCHAR2(200) NOT NULL,
    ID_SECTOR  NUMBER NOT NULL
);
ALTER TABLE EMPRESA ADD CONSTRAINT empresa_pk PRIMARY KEY (ID_EMPRESA);
ALTER TABLE EMPRESA ADD CONSTRAINT empresa_sector_fk FOREIGN KEY (ID_SECTOR) REFERENCES SECTOR_ECONOMICO (ID_SECTOR);

CREATE TABLE CATEDRATICO (
    ID_CATEDRATICO NUMBER NOT NULL,
    IDENTIFICACION VARCHAR2(30) NOT NULL,
    NOMBRE         VARCHAR2(100) NOT NULL,
    TELEFONO       VARCHAR2(20) NOT NULL,
    ESPECIALIDAD   VARCHAR2(100) NOT NULL,
    ID_INSTITUTO   NUMBER NOT NULL
);
ALTER TABLE CATEDRATICO ADD CONSTRAINT catedratico_pk PRIMARY KEY (ID_CATEDRATICO);
ALTER TABLE CATEDRATICO ADD CONSTRAINT catedra_inst_fk FOREIGN KEY (ID_INSTITUTO) REFERENCES INSTITUTO (ID_INSTITUTO);

-- DEPENDEN DE EMPRESA
CREATE TABLE CONTACTO_EMPRESARIAL (
    ID_CONTACTO NUMBER NOT NULL,
    NOMBRE      VARCHAR2(100) NOT NULL,
    TELEFONO    VARCHAR2(20) NOT NULL,
    CORREO      VARCHAR2(100) NOT NULL,
    ID_EMPRESA  NUMBER NOT NULL
);
ALTER TABLE CONTACTO_EMPRESARIAL ADD CONSTRAINT contacto_pk PRIMARY KEY (ID_CONTACTO);
ALTER TABLE CONTACTO_EMPRESARIAL ADD CONSTRAINT contacto_empresa_fk FOREIGN KEY (ID_EMPRESA) REFERENCES EMPRESA (ID_EMPRESA);

CREATE TABLE PLAZA (
    ID_PLAZA             NUMBER NOT NULL,
    ESPECIALIDAD_TECNICA VARCHAR2(100) NOT NULL,
    ID_EMPRESA           NUMBER NOT NULL,
    ID_CONTACTO          NUMBER NOT NULL
);
ALTER TABLE PLAZA ADD CONSTRAINT plaza_pk PRIMARY KEY (ID_PLAZA);
ALTER TABLE PLAZA ADD CONSTRAINT plaza_empresa_fk FOREIGN KEY (ID_EMPRESA) REFERENCES EMPRESA (ID_EMPRESA);
ALTER TABLE PLAZA ADD CONSTRAINT plaza_contacto_fk FOREIGN KEY (ID_CONTACTO) REFERENCES CONTACTO_EMPRESARIAL (ID_CONTACTO);

-- ESTUDIANTE (carné como llave primaria)
CREATE TABLE ESTUDIANTE (
    CARNE            VARCHAR2(20) NOT NULL,
    NOMBRE_COMPLETO  VARCHAR2(150) NOT NULL,
    CARRERA_TECNICA  VARCHAR2(100) NOT NULL,
    DIRECCION        VARCHAR2(200) NOT NULL,
    TELEFONO         VARCHAR2(20) NOT NULL,
    FECHA_NACIMIENTO DATE NOT NULL,
    GENERO           CHAR(1) NOT NULL,
    ES_REPITENCIA    NUMBER(1) NOT NULL,
    ID_MUNICIPIO     NUMBER NOT NULL,
    ID_INSTITUTO     NUMBER NOT NULL
);
ALTER TABLE ESTUDIANTE ADD CONSTRAINT estudiante_pk PRIMARY KEY (CARNE);
ALTER TABLE ESTUDIANTE ADD CONSTRAINT estud_muni_fk FOREIGN KEY (ID_MUNICIPIO) REFERENCES MUNICIPIO (ID_MUNICIPIO);
ALTER TABLE ESTUDIANTE ADD CONSTRAINT estud_inst_fk FOREIGN KEY (ID_INSTITUTO) REFERENCES INSTITUTO (ID_INSTITUTO);

-- COLOCACION
CREATE TABLE COLOCACION (
    ID_COLOCACION       NUMBER NOT NULL,
    FECHA_INICIO        DATE NOT NULL,
    FECHA_FINALIZACION  DATE,
    ID_ESTUDIANTE       VARCHAR2(20) NOT NULL,
    ID_PLAZA            NUMBER NOT NULL,
    ID_CATEDRATICO      NUMBER NOT NULL,
    ID_ESTADO           NUMBER NOT NULL
);
ALTER TABLE COLOCACION ADD CONSTRAINT colocacion_pk PRIMARY KEY (ID_COLOCACION);
ALTER TABLE COLOCACION ADD CONSTRAINT coloc_estud_fk FOREIGN KEY (ID_ESTUDIANTE) REFERENCES ESTUDIANTE (CARNE);
ALTER TABLE COLOCACION ADD CONSTRAINT coloc_plaza_fk FOREIGN KEY (ID_PLAZA) REFERENCES PLAZA (ID_PLAZA);
ALTER TABLE COLOCACION ADD CONSTRAINT coloc_catedra_fk FOREIGN KEY (ID_CATEDRATICO) REFERENCES CATEDRATICO (ID_CATEDRATICO);
ALTER TABLE COLOCACION ADD CONSTRAINT coloc_estado_fk FOREIGN KEY (ID_ESTADO) REFERENCES ESTADO_COLOCACION (ID_ESTADO);

-- BITACORA
CREATE TABLE BITACORA (
    ID_BITACORA             NUMBER NOT NULL,
    CORRELATIVO_MENSUAL     NUMBER NOT NULL,
    FECHA                   DATE NOT NULL,
    HORAS_TRABAJADAS        NUMBER(5,2) NOT NULL,
    ACTIVIDADES_REALIZADAS  VARCHAR2(500) NOT NULL,
    OBSERVACIONES           VARCHAR2(500),
    ID_COLOCACION           NUMBER NOT NULL,
    ID_CONTACTO_VALIDADOR   NUMBER NOT NULL
);
ALTER TABLE BITACORA ADD CONSTRAINT bitacora_pk PRIMARY KEY (ID_BITACORA);
ALTER TABLE BITACORA ADD CONSTRAINT bita_coloc_fk FOREIGN KEY (ID_COLOCACION) REFERENCES COLOCACION (ID_COLOCACION);
ALTER TABLE BITACORA ADD CONSTRAINT bita_contacto_fk FOREIGN KEY (ID_CONTACTO_VALIDADOR) REFERENCES CONTACTO_EMPRESARIAL (ID_CONTACTO);

-- EVALUACION
CREATE TABLE EVALUACION (
    ID_EVALUACION       NUMBER NOT NULL,
    FECHA_EVALUACION    DATE NOT NULL,
    ID_COLOCACION       NUMBER NOT NULL,
    ID_CATEDRATICO      NUMBER NOT NULL,
    ID_TIPO_EVALUACION  NUMBER NOT NULL
);
ALTER TABLE EVALUACION ADD CONSTRAINT evaluacion_pk PRIMARY KEY (ID_EVALUACION);
ALTER TABLE EVALUACION ADD CONSTRAINT eval_coloc_fk FOREIGN KEY (ID_COLOCACION) REFERENCES COLOCACION (ID_COLOCACION);
ALTER TABLE EVALUACION ADD CONSTRAINT eval_catedra_fk FOREIGN KEY (ID_CATEDRATICO) REFERENCES CATEDRATICO (ID_CATEDRATICO);
ALTER TABLE EVALUACION ADD CONSTRAINT eval_tipo_fk FOREIGN KEY (ID_TIPO_EVALUACION) REFERENCES TIPO_EVALUACION (ID_TIPO_EVALUACION);

-- DETALLE_EVALUACION (PK compuesta)
CREATE TABLE DETALLE_EVALUACION (
    ID_EVALUACION NUMBER NOT NULL,
    ID_CRITERIO   NUMBER NOT NULL,
    PUNTUACION    NUMBER(1) NOT NULL
);
ALTER TABLE DETALLE_EVALUACION ADD CONSTRAINT detalle_pk PRIMARY KEY (ID_EVALUACION, ID_CRITERIO);
ALTER TABLE DETALLE_EVALUACION ADD CONSTRAINT det_eval_fk FOREIGN KEY (ID_EVALUACION) REFERENCES EVALUACION (ID_EVALUACION);
ALTER TABLE DETALLE_EVALUACION ADD CONSTRAINT det_criterio_fk FOREIGN KEY (ID_CRITERIO) REFERENCES CRITERIO (ID_CRITERIO);