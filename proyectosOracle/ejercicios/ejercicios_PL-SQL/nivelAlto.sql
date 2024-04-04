
-- Ejercicio 7 - Excepciones Personalizadas:
/*Crea una excepción personalizada llamada mi_excepcion y escribe un bloque anónimo PL/ que la levante y
maneje.*/
-- Crear excepción personalizada
CREATE OR REPLACE PROCEDURE pruebaExcepcion AS
    mi_excepcion EXCEPTION;
BEGIN
    -- Levantar la excepción personalizada
    RAISE mi_excepcion;
EXCEPTION
    -- Manejar la excepción personalizada
    WHEN mi_excepcion THEN
        DBMS_OUTPUT.PUT_LINE('Se ha levantado la excepción personalizada: mi_excepcion');
    -- Manejar cualquier otra excepción
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Se ha producido un error: ' || SQLERRM);
END pruebaExcepcion;
/

-- Bloque anónimo para manejar la excepción personalizada
BEGIN
    -- Intentar llamar al procedimiento que levanta la excepción personalizada
    pruebaExcepcion;
EXCEPTION
    -- Manejar cualquier otra excepción que pueda ocurrir
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Se ha producido un error en el bloque anónimo: ' || SQLERRM);
END;
/



/*División de números*/
CREATE OR REPLACE PROCEDURE division_procedure AS
    v_numero1 NUMBER := 10;
    v_numero2 NUMBER := 0;
    v_resultado NUMBER;
BEGIN
    -- Intentar dividir dos números
    v_resultado := v_numero1 / v_numero2;
    
    -- Mostrar el resultado si la división tiene éxito
    DBMS_OUTPUT.PUT_LINE('Resultado de la división: ' || v_resultado);

EXCEPTION
    -- Manejar la excepción de división por cero
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Error: División por cero.');
    
    -- Manejar cualquier otro error que pueda ocurrir
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/

-- Bloque anónimo que invoca el procedimiento
BEGIN
    division_procedure;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en el bloque anónimo: ' || SQLERRM);
END;
/

-- Ejercicio 8 - Procedimiento con Manejo de Excepciones:
/*Crea un procedimiento “obtener_info_empleado” PL/SQL que acepte un número de empleado como
parámetro y utilice un cursor para obtener información sobre ese empleado. Si el empleado no existe, levanta
una excepción personalizada.*/

-- Crear la excepción personalizada
CREATE OR REPLACE PROCEDURE excepcion_empleado_no_encontrado AS
    excepcion_empleado_no_encontrado EXCEPTION;
BEGIN
    -- Levantar la excepción personalizada
    RAISE excepcion_empleado_no_encontrado;
END excepcion_empleado_no_encontrado;
/

-- Crear el procedimiento obtener_info_empleado
CREATE OR REPLACE PROCEDURE obtener_info_empleado (
    numeroEmpleado IN NUMBER
)
AS
    nombreEmpleado VARCHAR2(50); /*Se puede poner esto para que coja el tipo de dato de la tabla misma --> nombreEmpleado empleados.nombre%TYPE;*/
    deptoEmpleado VARCHAR2(50); /*deptoEmpleado empleados.depto%TYPE;*/
    salarioEmpleado NUMBER(10, 2); /*salarioEmpleado empleados.salario%TYPE;*/
    
    excepcion_empleado_no_encontrado EXCEPTION;
    
BEGIN 
    FOR empleado_rec IN (SELECT nombre, depto, salario FROM empleados WHERE empleado_id = numeroEmpleado) 
    LOOP
        nombreEmpleado := empleado_rec.nombre;
        deptoEmpleado := empleado_rec.depto;
        salarioEmpleado := empleado_rec.salario;
    END LOOP;
    
    -- Si no se encuentra ningún empleado, levantar la excepción personalizada
    IF nombreEmpleado IS NULL THEN
        -- Levantar la excepción
        RAISE excepcion_empleado_no_encontrado;
    ELSE
        -- Mostrar la información del empleado
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || nombreEmpleado);
        DBMS_OUTPUT.PUT_LINE('Departamento: ' || deptoEmpleado);
        DBMS_OUTPUT.PUT_LINE('Salario: ' || salarioEmpleado);
    END IF;

EXCEPTION
  -- Manejar la excepción personalizada de empleado no encontrado
  WHEN excepcion_empleado_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('Error: El empleado con el ID ' || numeroEmpleado || ' no existe.');
  -- Manejar cualquier otra excepción
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END obtener_info_empleado;
/

-- Ejecutar el procedimiento
DECLARE
    numEmpleado NUMBER := 6;
BEGIN
    obtener_info_empleado(numEmpleado);
END;
/

-- Ejercicio 9 - Función con Excepción Personalizada y Cursor:
/*Crea una función PL/SQL “salario_empleado”que acepte un número de empleado como parámetro y devuelva
el salario de ese empleado. Si el empleado no existe, levanta una excepción personalizada.*/
CREATE OR REPLACE PROCEDURE excepcion_empleado_no_encontrado AS
    excepcion_empleado_no_encontrado EXCEPTION;
BEGIN
    -- Levantar la excepción personalizada
    RAISE excepcion_empleado_no_encontrado;
END excepcion_empleado_no_encontrado;
/


CREATE OR REPLACE FUNCTION salario_empleado (
    numeroEmpleado IN NUMBER
) RETURN NUMBER
IS
    salarioEmpleado NUMBER(10, 2) := NULL; -- Cambiamos el valor predeterminado a NULL
    
    excepcion_empleado_no_encontrado EXCEPTION;
BEGIN
    FOR empleado_rec IN (SELECT salario FROM empleados WHERE empleado_id = numeroEmpleado) 
    LOOP
        salarioEmpleado := empleado_rec.salario;
    END LOOP;
    
    -- Si no se encuentra ningún empleado, levantar la excepción personalizada
    IF salarioEmpleado IS NULL THEN
        -- Levantar la excepción
        RAISE excepcion_empleado_no_encontrado;
    ELSE
        -- Mostrar la información del empleado
        RETURN salarioEmpleado;
    END IF;

EXCEPTION
    -- Manejar la excepción personalizada de empleado no encontrado
    WHEN excepcion_empleado_no_encontrado THEN
        DBMS_OUTPUT.PUT_LINE('Error: El empleado con el ID ' || numeroEmpleado || ' no existe.');
        RETURN NULL; -- Devolvemos NULL en caso de excepción
    -- Manejar cualquier otra excepción
    WHEN OTHERS THEN
        -- Manejo de excepciones: mostrar un mensaje de error en la salida estándar
        DBMS_OUTPUT.PUT_LINE('Error al calcular el salario del empleado');
        RETURN NULL;
END;
/

-- Ejecutar la función
DECLARE
    numEmpleado NUMBER := 6;
    salarioEmpleado NUMBER;
BEGIN
    
    -- Llamar a la función con los datos recuperados
    salarioEmpleado := salario_empleado(numEmpleado);
    
    -- Mostrar el resultado
    IF salarioEmpleado >= 0 THEN
        DBMS_OUTPUT.PUT_LINE('El salario del empleado seleccionado es: ' || salarioEmpleado);
    END IF;
END;
/


-- Ejercicio 10 - Trigger:
/* Un trigger es un tipo especial de procedimiento almacenado en una base de datos que se activa automáticamente 
("dispara" o "trigger") en respuesta a ciertos eventos o acciones realizadas en la base de datos. 
Estos eventos pueden incluir inserciones, actualizaciones o eliminaciones de filas en una tabla, 
o incluso eventos de nivel de esquema, como la creación o eliminación de tablas. */

/*Este trigger se activará antes de insertar un nuevo registro en la tabla empleados 
y mostrará un mensaje en la salida estándar indicando los valores que se están insertando.*/
CREATE OR REPLACE TRIGGER before_insert_empleado_trigger
BEFORE INSERT ON empleados /*se activara antes de insertar un nuevo registro en la tabla empleados*/
FOR EACH ROW /*Se activará una vez por cada fila que se esté insertando en la tabla*/
BEGIN
    -- Mostrar un mensaje con el valor que se está insertando (mediante :NEW, accedera al valor del nuevo registro que se está insertando)
    DBMS_OUTPUT.PUT_LINE('Insertando nuevo registro con empleado_id: ' || :NEW.empleado_id || ', nombre: ' || :NEW.nombre || ', departamento: ' || :NEW.depto || ', salario: ' || :NEW.salario);
END;
/

-- Insertar un nuevo registro en la tabla empleados
INSERT INTO empleados VALUES (5, 'NuevoEmpleado', 'DepartamentoC', 70000);

-- Consultar los registros de la tabla empleados para ver el mensaje del trigger
SELECT * FROM empleados;

-- Borrar un registro específico
DELETE FROM empleados WHERE empleado_id = 5;








