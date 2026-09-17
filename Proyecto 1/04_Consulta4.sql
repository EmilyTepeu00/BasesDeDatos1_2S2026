SET PAGESIZE 50000

-- Consulta 4: Desempeño de empleados
-- Muestra empleado, cargo, tienda, cantidad de ventas atendidas y total facturado, excluyendo ventas anuladas.

SELECT
    per.nombre || ' ' || per.apellido AS empleado,
    ca.nombre AS cargo,
    t.nombre AS tienda,
    COUNT(DISTINCT v.numero_venta) AS cantidad_ventas_atendidas,
    NVL(SUM(dv.subtotal), 0) AS total_facturado
FROM EMPLEADO e
JOIN PERSONA per ON e.PERSONA_codigo_persona = per.codigo_persona
JOIN CARGO ca ON e.CARGO_codigo_cargo = ca.codigo_cargo
JOIN TIENDA t ON e.TIENDA_codigo_tienda = t.codigo_tienda
LEFT JOIN VENTA v ON e.codigo_empleado = v.EMPLEADO_codigo_empleado
                 AND v.ESTADO_VENTA_codigo_estado <>
                     (SELECT codigo_estado FROM ESTADO_VENTA WHERE UPPER(nombre) = 'ANULADA')
LEFT JOIN DESGLOSE_VENTA dv ON v.numero_venta = dv.VENTA_numero_venta
GROUP BY per.nombre, per.apellido, ca.nombre, t.nombre
ORDER BY total_facturado DESC;