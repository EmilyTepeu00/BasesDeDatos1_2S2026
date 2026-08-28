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
