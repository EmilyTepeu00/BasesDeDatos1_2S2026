const express = require('express');
const crudFactory = require('../utils/crudFactory');
const { getPool } = require('../config/db');

const router = express.Router();

const tablasSimples = [
    { path: '/paises', table: 'PAIS', pk: 'codigo_pais' },
    { path: '/departamentos', table: 'DEPARTAMENTO', pk: 'codigo_departamento' },
    { path: '/municipios', table: 'MUNICIPIO', pk: 'codigo_municipio' },
    { path: '/tipos-tienda', table: 'TIPO_TIENDA', pk: 'codigo_tipo_tienda' },
    { path: '/cargos', table: 'CARGO', pk: 'codigo_cargo' },
    { path: '/tipos-identificacion', table: 'TIPO_IDENTIFICACION', pk: 'codigo_tipo_identificacion' },
    { path: '/categorias', table: 'CATEGORIA', pk: 'codigo_categoria' },
    { path: '/marcas', table: 'MARCA', pk: 'codigo_marca' },
    { path: '/estados-venta', table: 'ESTADO_VENTA', pk: 'codigo_estado' },
    { path: '/metodos-pago', table: 'METODO_PAGO', pk: 'codigo_metodo_pago' },
    { path: '/tiendas', table: 'TIENDA', pk: 'codigo_tienda' },
    { path: '/personas', table: 'PERSONA', pk: 'codigo_persona' },
    { path: '/productos', table: 'PRODUCTO', pk: 'codigo_producto' },
    { path: '/empleados', table: 'EMPLEADO', pk: 'codigo_empleado' },
    { path: '/clientes', table: 'CLIENTE', pk: 'codigo_cliente' },
    { path: '/catalogo-producto', table: 'CATALOGO_PRODUCTO', pk: ['codigo_tienda', 'codigo_producto'] }
];

tablasSimples.forEach(({ path, table, pk }) => {
    const subRouter = express.Router();
    crudFactory(subRouter, { table, pk });
    router.use(path, subRouter);
});

const ventaSelect = `SELECT v.numero_venta, v.fecha, v.codigo_estado, e.nombre AS estado,
    v.codigo_cliente, v.codigo_tienda, v.codigo_empleado,
    ISNULL((SELECT SUM(d.subtotal) FROM DESGLOSE_VENTA d WHERE d.numero_venta = v.numero_venta), 0) AS total_venta,
    ISNULL((SELECT SUM(p.monto) FROM PAGO p WHERE p.numero_venta = v.numero_venta), 0) AS total_pagado
    FROM VENTA v JOIN ESTADO_VENTA e ON e.codigo_estado = v.codigo_estado`;

const ventasRouter = express.Router();

ventasRouter.get('/', async (req, res) => {
    try {
        const pool = await getPool();
        const result = await pool.request().query(ventaSelect + ' ORDER BY v.numero_venta');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

ventasRouter.get('/:id', async (req, res) => {
    try {
        const pool = await getPool();
        const result = await pool.request()
            .input('id', req.params.id)
            .query(ventaSelect + ' WHERE v.numero_venta = @id');
        if (result.recordset.length === 0) {
            return res.status(404).json({ error: 'VENTA no encontrado' });
        }
        res.json(result.recordset[0]);
    } catch (err) {
        res.status(err.number === 245 ? 400 : 500).json({ error: err.message });
    }
});

crudFactory(ventasRouter, { table: 'VENTA', pk: 'numero_venta' });
router.use('/ventas', ventasRouter);

const pagosRouter = express.Router();
crudFactory(pagosRouter, { table: 'PAGO', pk: 'codigo_pago', insertTrigger: true });
router.use('/pagos', pagosRouter);

const detalleVentaRouter = express.Router();

detalleVentaRouter.post('/', async (req, res) => {
    try {
        const check = await crudFactory.validateBody('DESGLOSE_VENTA', req.body);
        if (check.error) return res.status(400).json({ error: check.error });
        if (req.body.numero_venta === undefined || req.body.codigo_producto === undefined) {
            return res.status(400).json({ error: 'numero_venta y codigo_producto son obligatorios' });
        }
        const pool = await getPool();
        const request = pool.request();
        const columns = check.keys;
        columns.forEach(col => request.input(col, req.body[col]));
        const colList = columns.join(', ');
        const paramList = columns.map(c => '@' + c).join(', ');
        const query = `INSERT INTO DESGLOSE_VENTA (${colList}) VALUES (${paramList});
                       SELECT * FROM DESGLOSE_VENTA WHERE numero_venta = @numero_venta AND codigo_producto = @codigo_producto`;
        const result = await request.query(query);
        res.status(201).json(result.recordset[0]);
    } catch (err) {
        const sinStock = err.number === 50001 ||
            /Existencia insuficiente|transaction ended in the trigger/i.test(err.message || '');
        if (sinStock) {
            return res.status(400).json({ error: 'Stock insuficiente' });
        }
        res.status(400).json({ error: err.message });
    }
});

crudFactory(detalleVentaRouter, { table: 'DESGLOSE_VENTA', pk: ['numero_venta', 'codigo_producto'], insertTrigger: true });
router.use('/detalles-venta', detalleVentaRouter);

const vistas = [
    { path: '/vista-ventas-ubicacion', view: 'Vista_Ventas_Ubicacion' },
    { path: '/vista-top-productos', view: 'Vista_Top_Productos' },
    { path: '/vista-saldos-pendientes', view: 'Vista_Saldos_Pendientes' }
];

vistas.forEach(({ path, view }) => {
    router.get(path, async (req, res) => {
        try {
            const pool = await getPool();
            const result = await pool.request().query(`SELECT * FROM ${view}`);
            res.json(result.recordset);
        } catch (err) {
            res.status(500).json({ error: err.message });
        }
    });
});

module.exports = router;
