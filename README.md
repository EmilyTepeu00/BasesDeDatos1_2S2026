# Bases de Datos 1 - Segundo Semestre 2026

## Práctica 1: Sistema de gestión de Prácticas Profesionales Supervisadas (EPS)

Diseño de la base de datos con la que una Dirección Académica controla el programa de EPS de estudiantes de institutos técnicos en empresas afiliadas. El modelo cubre empresas, sectores, contactos empresariales, plazas, institutos, catedráticos supervisores, estudiantes, colocaciones, bitácoras diarias, evaluaciones (parcial y final) y criterios de evaluación.

**Qué se trabajó:**

- Modelo conceptual (entidad-relación), modelo lógico y modelo relacional.
- Normalización hasta la Tercera Forma Normal.
- Diccionario de datos y script DDL en Oracle.

## Práctica 2: Consultas avanzadas, agrupaciones y reportería (EPS)

Continuación de la práctica anterior. Se cargan los datos históricos (Excel/CSV) en el modelo respetando las llaves primarias y foráneas, y se construyen cinco reportes para una auditoría operativa.

**Qué se trabajó:**

- Importación de datos con SQL Developer, siguiendo un orden de carga que evita violaciones de integridad referencial.
- Cinco consultas con `JOIN` explícitos, `GROUP BY` y funciones de agregación:
  1. Directorio de estudiantes activos.
  2. Oferta de plazas por empresa.
  3. Carga de validación por contacto empresarial (julio a agosto de 2026).
  4. Estudiantes en repitencia.
  5. Auditoría de bitácoras de colocaciones activas.

## Proyecto 1: Diseño e implementación de una base de datos para el control de ventas

Base de datos relacional de Comercial La Estrella, una red de tiendas en varios países. Administra tiendas, empleados, clientes, productos, ventas y pagos, con su ubicación (país, departamento y municipio), catálogos (tipos de tienda, cargos, categorías, marcas, métodos de pago) y estados de venta.

**Qué se trabajó:**

- Modelos conceptual, lógico y relacional, con normalización hasta 3FN.
- Restricciones de integridad: llaves primarias y foráneas, `NOT NULL`, `UNIQUE` y `CHECK`.
- Script DDL, carga de datos desde Excel y manual técnico.
- 8 consultas de reportes (ventas por tienda y ubicación, por tipo de tienda, productos más vendidos, desempeño de empleados, clientes con mayor compra, facturación por categoría y marca, métodos de pago y ventas pendientes de pago) y dos consultas de validación.

## Proyecto 2: Backend y exposición de servicios para Comercial La Estrella

Migración del modelo del Proyecto 1 a Microsoft SQL Server 2022 en Docker, con un API REST en Node.js (Express) como única vía de acceso a los datos. Las reglas de negocio y los reportes viven en el motor de base de datos, y la API solo expone el CRUD y consulta las vistas.

**Qué incluye:**

- Infraestructura con `docker-compose`, que levanta SQL Server y ejecuta `init.sql` automáticamente (19 tablas, 3 vistas y 2 triggers).
- API REST con CRUD completo de las 19 tablas y carga masiva en transacción.
- Dos triggers: protección de inventario (`Insert_Detalle`) y cambio automático de la venta a PAGADA (`Insert_Pago`).
- Tres vistas analíticas: `Vista_Ventas_Ubicacion`, `Vista_Top_Productos` y `Vista_Saldos_Pendientes`.
- Colección de Postman con 245 pruebas, que incluye los escenarios de los triggers.

**Cómo ejecutarlo:** las instrucciones completas están en el [README del proyecto](Proyecto%202/README.md).

---

> **Nota:** Las dos prácticas trabajan sobre el mismo caso (EPS), y los dos proyectos sobre otro (Comercial La Estrella). Cada pareja va de menos a más: primero el modelo, después los datos, las consultas y la aplicación.
