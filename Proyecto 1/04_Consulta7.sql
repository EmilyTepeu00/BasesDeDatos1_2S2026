SET PAGESIZE 50000

-- Consulta 7: Uso de métodos de pago
-- Muestra método de pago, cantidad de pagos y monto total recibido.
-- No se excluyen anuladas porque los pagos ya reflejan transacciones reales efectuadas.

SELECT
    mp.nombre AS metodo_pago,
    COUNT(pg.codigo_pago) AS cantidad_pagos,
    NVL(SUM(pg.monto), 0) AS monto_total_recibido
FROM METODO_PAGO mp
LEFT JOIN PAGO pg ON mp.codigo_metodo_pago = pg.METODO_PAGO_codigo_metodo_pago
GROUP BY mp.nombre
ORDER BY monto_total_recibido DESC;