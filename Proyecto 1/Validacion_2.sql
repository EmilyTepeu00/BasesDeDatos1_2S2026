-- Validación 2: "Las ventas en estado PAGADA deben tener pagos registrados cuya suma sea igual al total de la venta"

SELECT
    v.numero_venta,
    (SELECT SUM(dv.subtotal) FROM DESGLOSE_VENTA dv
        WHERE dv.VENTA_numero_venta = v.numero_venta) AS total_venta,
    NVL((SELECT SUM(pg.monto) FROM PAGO pg
        WHERE pg.VENTA_numero_venta = v.numero_venta), 0) AS total_pagado
FROM VENTA v
JOIN ESTADO_VENTA ev ON v.ESTADO_VENTA_codigo_estado = ev.codigo_estado
WHERE UPPER(ev.nombre) = 'PAGADA'
  AND (SELECT SUM(dv.subtotal) FROM DESGLOSE_VENTA dv
        WHERE dv.VENTA_numero_venta = v.numero_venta)
      <> NVL((SELECT SUM(pg.monto) FROM PAGO pg
        WHERE pg.VENTA_numero_venta = v.numero_venta), 0);