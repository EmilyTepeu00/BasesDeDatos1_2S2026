SET PAGESIZE 50000

-- Consulta 5: Clientes con mayor compra
-- Muestra cliente, municipio de residencia, cantidad de ventas pagadas y monto total comprado. Solo ventas pagadas.

SELECT
    per.nombre || ' ' || per.apellido AS cliente,
    m.nombre AS municipio_residencia,
    COUNT(DISTINCT v.numero_venta) AS cantidad_ventas_pagadas,
    SUM(dv.subtotal) AS monto_total_comprado
FROM CLIENTE cl
JOIN PERSONA per ON cl.PERSONA_codigo_persona = per.codigo_persona
JOIN MUNICIPIO m ON per.MUNICIPIO_codigo_municipio = m.codigo_municipio
JOIN VENTA v ON cl.codigo_cliente = v.CLIENTE_codigo_cliente
JOIN ESTADO_VENTA ev ON v.ESTADO_VENTA_codigo_estado = ev.codigo_estado
JOIN DESGLOSE_VENTA dv ON v.numero_venta = dv.VENTA_numero_venta
WHERE UPPER(ev.nombre) = 'PAGADA'
GROUP BY per.nombre, per.apellido, m.nombre
ORDER BY monto_total_comprado DESC;