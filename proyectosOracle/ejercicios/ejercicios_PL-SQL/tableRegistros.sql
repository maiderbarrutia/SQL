
SET SERVEROUTPUT ON;

-- Ejercicio 0 – Crear tabla empleados y añadir registros
CREATE TABLE empleados (
    empleado_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    depto VARCHAR2(50),
    salario NUMBER(10, 2)
);

-- Insertar los registros:
INSERT INTO empleados VALUES (1, 'Empleado1', 'DepartamentoA', 1000);
INSERT INTO empleados VALUES (2, 'Empleado2', 'DepartamentoB', 2992.50);
INSERT INTO empleados VALUES (3, 'Empleado3', 'DepartamentoA', 1500.55);
INSERT INTO empleados VALUES (4, 'Empleado4', 'DepartamentoA', 1500.75);

