
-- Ejercicio 4 - Bucle FOR:

/*Escribe un bloque anónimo PL/ que use un bucle FOR para mostrar los números del 1 al 10.*/
DECLARE
    valor INTEGER;
BEGIN
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('Número ' || i );
    END LOOP;   
END;
/

-- Ejercicio 5 - Procedimiento Simple:
/*Crea un procedimiento PL/ que acepte dos números como parámetros y devuelva la suma de esos números.*/
CREATE OR REPLACE PROCEDURE sumaNumeros(num1 NUMBER, num2 NUMBER) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Este es el total de la suma de números: ' || (num1 + num2));
END sumaNumeros;
/

DECLARE
    num1 NUMBER := 5;
    num2 NUMBER := 2;
BEGIN
       sumaNumeros(num1, num2);
END;
/

-- Ejercicio 6 - Cursor Simple:
/*Escribe un bloque anónimo PL/ que utilice un cursor para recorrer una tabla y mostrar los nombres de los
empleados.*/

--Cursor implicito
BEGIN
    FOR listaNombreEmpleados IN (SELECT nombre FROM empleados) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Nombre empleado: ' || listaNombreEmpleados.nombre);
    END LOOP;  
END;
/

--Cursor explicito
DECLARE
  -- Declaración del cursor explícito
  CURSOR listaNombreEmpleados IS
    SELECT nombre
    FROM empleados;
  
  -- Variable para almacenar el nombre del empleado
  nombre empleados.nombre%TYPE;
BEGIN
  -- Abre el cursor explícito
  OPEN listaNombreEmpleados;
  
  -- Recorrer el cursor
    LOOP
        -- Obtener el nombre del empleado
        FETCH listaNombreEmpleados INTO nombre;
        
        -- Salir del bucle cuando no hay más filas
        EXIT WHEN listaNombreEmpleados%NOTFOUND;

        -- Mostrar el nombre del empleado
        DBMS_OUTPUT.PUT_LINE('Nombre empleado: ' || nombre);
    END LOOP;
    
    -- Cerrar el cursor
    CLOSE listaNombreEmpleados;
END;

/


