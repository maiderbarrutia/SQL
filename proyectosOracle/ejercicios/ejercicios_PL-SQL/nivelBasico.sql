
-- Ejercicio 1 - Bloque Anónimo Simple:

/*Escribe un bloque anónimo PL/ que declare una variable y la inicialice con un valor. 
Luego, muestra el valor de la variable.*/
DECLARE
    valor INTEGER;
BEGIN
    valor := 589;
    
    DBMS_OUTPUT.PUT_LINE('Este es el valor: ' || valor);
    
END;
/

/* Encontrar cuantos empleados hay en la tabla */
DECLARE
    numeroEmpleados NUMBER;
BEGIN
    SELECT COUNT(*) INTO numeroEmpleados FROM empleados;
    
    DBMS_OUTPUT.PUT_LINE('Nombre empleados: ' || numeroEmpleados);
    
END;
/

-- Ejercicio 2 - Operadores Aritméticos:
/*Escribe un bloque anónimo PL/ que use operadores aritméticos para realizar una serie de cálculos simples
(suma, resta, multiplicación y división) e imprima los resultados*/
DECLARE
    resultadoSuma NUMBER;
    resultadoResta NUMBER;
    resultadoMultiplicacion NUMBER;
    resultadoDivision NUMBER;
    num1 NUMBER;
    num2 NUMBER;
BEGIN
    num1 := 5;
    num2 := 3;
    resultadoSuma := num1 + num2;
    resultadoResta := num1 - num2;
    resultadoMultiplicacion := num1 * num2;
    resultadoDivision := num1 / num2;
    
    DBMS_OUTPUT.PUT_LINE('Resultado suma: ' || resultadoSuma);
    DBMS_OUTPUT.PUT_LINE('Resultado resta: ' || resultadoResta);
    DBMS_OUTPUT.PUT_LINE('Resultado multiplicación: ' || resultadoMultiplicacion);
    DBMS_OUTPUT.PUT_LINE('Resultado división: ' || resultadoDivision);
    
END;
/

-- Ejercicio 3 - Condicionales IF:
/*Escribe un bloque anónimo PL/ que utilice una declaración condicional IF para determinar si un número es
positivo, negativo o cero y mostrar un mensaje en consecuencia.*/
DECLARE
    num NUMBER := 7;
BEGIN
    IF num>0 THEN
        dbms_output.put_line(num || ' es un número POSITIVO');
    ELSIF num<0 THEN
        dbms_output.put_line(num || ' es un número NEGATIVO');
    ELSIF num=0 THEN
        dbms_output.put_line('El número tiene un valor de 0');
    ELSE
        dbms_output.put_line('El número no existe');
    END IF;
END;
/



