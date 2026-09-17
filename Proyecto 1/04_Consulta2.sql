SET PAGESIZE 50000

-- Consulta 2: Ventas por tipo de tienda
-- Muestra tipo de tienda, cantidad de tiendas de ese tipo, cantidad de ventas y monto facturado, excluyendo ventas anuladas.

SELECT
    tt.nombre AS tipo_tienda,
    COUNT(DISTINCT t.codigo_tienda) AS cantidad_tiendas,
    COUNT(DISTINCT v.numero_venta) AS cantidad_ventas,
    NVL(SUM(dv.subtotal), 0) AS monto_facturado
FROM TIPO_TIENDA tt
JOIN TIENDA t ON tt.codigo_tipo_tienda = t.TIPO_TIENDA_codigo_tipo_tienda
LEFT JOIN VENTA v ON t.codigo_tienda = v.TIENDA_codigo_tienda
                 AND v.ESTADO_VENTA_codigo_estado <>
                     (SELECT codigo_estado FROM ESTADO_VENTA WHERE UPPER(nombre) = 'ANULADA')
LEFT JOIN DESGLOSE_VENTA dv ON v.numero_venta = dv.VENTA_numero_venta
GROUP BY tt.nombre
ORDER BY monto_facturado DESC;