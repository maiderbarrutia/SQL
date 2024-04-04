
--EJERCICIO 2: Procedimiento

/*Crear un procedimiento que a partir de un código asignatura pasado por parámetro nos devuelva 
el número de UFS aprobadas y la nota media de la asignatura si están todas aprobadas*/
CREATE OR REPLACE PROCEDURE P_CALCULAR_NOTA_MEDIA_ASIG (
    VIN_COD_ASIG IN VARCHAR, /* Codigo de la asignatura */
    VOUT_APRO_UFS OUT NUMBER, /* UFS aprobadas */
    VOUT_NOTA_MEDIA_ASIG OUT NUMBER /* Nota media asignatura */
)
IS
    totalUFS NUMBER := 0;
    numeroUfsAprobadas NUMBER := 0;
    notaMediaAsignatura NUMBER := NULL;
    notaTotal NUMBER := 0;
BEGIN
    -- Contar el número total de UFS
    SELECT COUNT(*) INTO totalUFS
    FROM UFS
    WHERE COD_ASIG = VIN_COD_ASIG;
    
    DBMS_OUTPUT.PUT_LINE('Total UFS: ' || totalUFS);

    -- Calcular la nota media de la asignatura si todas las UFS están aprobadas
    IF totalUFS > 0 THEN /*Solo hace esto si el total de UFS es mayor a 0. Si hay UFS entonces...*/
    
        /*Recorre un cursor llamado ufs_cursor. El cursor es una estructura que almacena el resultado de una consulta SQL. 
        Aquí, el cursor almacena la NOTA_FINAL_UF y PONDERA_UF de las UFs relacionadas con la asignatura especificada 
        por VIN_COD_ASIG.  un cursor es un conjunto de registros devuelto por una instrucción SQL. Es una especie de forech*/
        FOR ufs_cursor IN (SELECT NOTA_FINAL_UF, PONDERA_UF
                    FROM UFS
                    WHERE COD_ASIG = VIN_COD_ASIG) 
                    
        LOOP /*Es el equivalente en programación de la apertura de llaves {*/
        
            /*Si la UF está aprobada, osea, en la nota final hay más de un 5 se calcula*/
            IF ufs_cursor.NOTA_FINAL_UF >= 5 THEN
                notaTotal := notaTotal + (ufs_cursor.NOTA_FINAL_UF * ufs_cursor.PONDERA_UF);
                /*Nota final ponderada = (Nota MAT * Ponderación MAT) + (Nota CIE * Ponderación CIE) + (Nota LIT * Ponderación LIT)
                     = (8.5 * 0.40) + (7.2 * 0.30) + (9.0 * 0.30)
                     = 3.4 + 2.16 + 2.7
                     = 8.26*/   
                 DBMS_OUTPUT.PUT_LINE('Nota UF: ' || notaTotal);
                numeroUfsAprobadas := numeroUfsAprobadas + 1;
            END IF;
            
        END LOOP;
    
                     
        -- Asignar el numeroUfsAprobadas al parámetro VOUT_APRO_UFS
        VOUT_APRO_UFS := numeroUfsAprobadas;

        -- Calcular la nota media si todas las UFS están aprobadas
        IF numeroUfsAprobadas = totalUFS THEN
            notaMediaAsignatura := notaTotal;
        END IF;
    END IF;

    -- Asignar el resultado a las variables de salida
    VOUT_NOTA_MEDIA_ASIG := notaMediaAsignatura;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        VOUT_APRO_UFS := NULL;
        VOUT_NOTA_MEDIA_ASIG := NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

DECLARE
    ufsAprobadas NUMBER;
    notaMediaAsignatura NUMBER;
BEGIN
    -- Llamada al procedimiento para calcular la nota media de la asignatura
    P_CALCULAR_NOTA_MEDIA_ASIG('M03B', ufsAprobadas, notaMediaAsignatura);
    
    -- Mostrar número de UFS aprobadas
    DBMS_OUTPUT.PUT_LINE('Número de UFS aprobadas: ' || ufsAprobadas);
    
    -- Mostrar nota media de la asignatura solo si están todas aprobadas sino sale un mensaje de no se puede calcular
    IF notaMediaAsignatura IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Nota media de la asignatura: No se puede calcular debido a que hay UFS no aprobadas.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nota media de la asignatura: ' || notaMediaAsignatura);
    END IF;
END;
/

