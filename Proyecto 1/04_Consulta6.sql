SET PAGESIZE 50000

-- Consulta 6: Facturación por categoría y marca
-- Muestra categoría, marca, unidades vendidas y total facturado, excluyendo ventas anuladas.

SELECT
    c.nombre  AS categoria,
    ma.nombre AS marca,
    SUM(dv.cantidad) AS unidades_vendidas,
    SUM(dv.subtotal) AS total_facturado
FROM CATEGORIA c
JOIN PRODUCTO p ON c.codigo_categoria = p.CATEGORIA_codigo_categoria
JOIN MARCA ma   ON p.MARCA_codigo_marca = ma.codigo_marca
JOIN DESGLOSE_VENTA dv ON p.codigo_producto = dv.PRODUCTO_codigo_producto
JOIN VENTA v ON dv.VENTA_numero_venta = v.numero_venta
JOIN ESTADO_VENTA ev ON v.ESTADO_VENTA_codigo_estado = ev.codigo_estado
WHERE UPPER(ev.nombre) <> 'ANULADA'
GROUP BY c.nombre, ma.nombre
ORDER BY total_facturado DESC;