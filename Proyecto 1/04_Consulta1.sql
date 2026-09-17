SET PAGESIZE 50000

-- Consulta 1: Ventas por tienda y ubicación
-- Muestra tienda, municipio, departamento, país, cantidad de ventas y total facturado, excluyendo las ventas anuladas.

SELECT
    t.nombre AS tienda,
    m.nombre AS municipio,
    dep.nombre AS departamento,
    pa.nombre AS pais,
    COUNT(DISTINCT v.numero_venta) AS cantidad_ventas,
    NVL(SUM(dv.subtotal), 0) AS total_facturado
FROM TIENDA t
JOIN MUNICIPIO m ON t.MUNICIPIO_codigo_municipio = m.codigo_municipio
JOIN DEPARTAMENTO dep ON m.DEP_codigo_departamento = dep.codigo_departamento
JOIN PAIS pa ON dep.PAIS_codigo_pais = pa.codigo_pais
LEFT JOIN VENTA v ON t.codigo_tienda = v.TIENDA_codigo_tienda
                  AND v.ESTADO_VENTA_codigo_estado <>
                         (SELECT codigo_estado FROM ESTADO_VENTA WHERE UPPER(nombre) = 'ANULADA')
LEFT JOIN DESGLOSE_VENTA dv ON v.numero_venta = dv.VENTA_numero_venta
GROUP BY t.nombre, m.nombre, dep.nombre, pa.nombre
ORDER BY total_facturado DESC;