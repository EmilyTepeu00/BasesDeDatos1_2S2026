-- Validación 1: "El empleado que atiende una venta debe pertenecer a la misma tienda en la que se registra la venta"

SELECT
    v.numero_venta,
    e.codigo_empleado,
    e.TIENDA_codigo_tienda AS tienda_del_empleado,
    v.TIENDA_codigo_tienda AS tienda_de_la_venta
FROM VENTA v
JOIN EMPLEADO e ON v.EMPLEADO_codigo_empleado = e.codigo_empleado
WHERE e.TIENDA_codigo_tienda <> v.TIENDA_codigo_tienda;