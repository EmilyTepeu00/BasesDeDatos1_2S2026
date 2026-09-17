SET PAGESIZE 50000

-- Consulta 3: Productos más vendidos
-- Muestra código, producto, categoría, marca, unidades vendidas y monto generado, excluyendo ventas anuladas.

SELECT
    p.codigo_producto,
    p.nombre AS producto,
    c.nombre AS categoria,
    ma.nombre AS marca,
    SUM(dv.cantidad) AS unidades_vendidas,
    SUM(dv.subtotal) AS monto_generado
FROM PRODUCTO p
JOIN CATEGORIA c ON p.CATEGORIA_codigo_categoria = c.codigo_categoria
JOIN MARCA ma ON p.MARCA_codigo_marca = ma.codigo_marca
JOIN DESGLOSE_VENTA dv ON p.codigo_producto = dv.PRODUCTO_codigo_producto
JOIN VENTA v ON dv.VENTA_numero_venta = v.numero_venta
JOIN ESTADO_VENTA ev ON v.ESTADO_VENTA_codigo_estado = ev.codigo_estado
WHERE UPPER(ev.nombre) <> 'ANULADA'
GROUP BY p.codigo_producto, p.nombre, c.nombre, ma.nombre
ORDER BY unidades_vendidas DESC;