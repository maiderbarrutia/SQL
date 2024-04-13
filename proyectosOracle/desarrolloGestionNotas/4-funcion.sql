--3. Funcion
CREATE OR REPLACE FUNCTION F_NOTA_MEDIA_UF (
    VIN_CONV_EXAM IN VARCHAR2,
    VIN_NUM_PACS_ENT IN NUMBER,
    VIN_MIN_PACS_ENT IN NUMBER,
    VIN_NOTA_MEDIA_PACS IN NUMBER,
    VIN_NOTA_EXAM IN NUMBER
)
RETURN NUMBER
IS
    v_notaMediaUF NUMBER;
BEGIN
    IF VIN_CONV_EXAM = 'EXTRAORDINARIA' THEN
        -- La nota media es igual a la nota de examen
        v_notaMediaUF := VIN_NOTA_EXAM;
    ELSIF VIN_CONV_EXAM = 'ORDINARIA' THEN
        -- Si el número de pacs entregadas es menor que el mínimo de pacs a entregar
        -- o la nota de examen es menor a 4.75
        -- o la nota media de PACs es menor a 7 y la nota de examen entre 4.75 y 4.89
        IF VIN_NUM_PACS_ENT < VIN_MIN_PACS_ENT OR VIN_NOTA_EXAM < 4.75 OR
           (VIN_NOTA_MEDIA_PACS < 7 AND VIN_NOTA_EXAM >= 4.75 AND VIN_NOTA_EXAM <= 4.89) THEN
            v_notaMediaUF := VIN_NOTA_MEDIA_PACS * 0.4;
        ELSE
            -- En otro caso, la nota media es calculada como 0.4 * nota media de pacs + 0.6 * nota de examen
            v_notaMediaUF := VIN_NOTA_MEDIA_PACS * 0.4 + VIN_NOTA_EXAM * 0.6;
        END IF;
    ELSIF VIN_CONV_EXAM = 'PROYECTO' THEN
        -- Si la convocatoria es "PROYECTO", la nota media es igual a la nota de examen (proyecto)
        v_notaMediaUF := VIN_NOTA_EXAM;
    ELSE
        -- Si la convocatoria no es reconocida, se devuelve NULL
        v_notaMediaUF := NULL;
    END IF;

    -- Devolver la nota media de la UF
    RETURN v_notaMediaUF;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de excepciones: mostrar un mensaje de error en la salida estándar
        DBMS_OUTPUT.PUT_LINE('Error al calcular la nota media de la UF.');
        RETURN NULL;
        
END;
/

DECLARE
    -- Variables para almacenar los datos recuperados de la tabla UFS
    convocatoriaExamen VARCHAR2(20);
    numPacsEntregadas NUMBER;
    minPacsEntregar NUMBER;
    notaMediaPacs NUMBER;
    notaExamen NUMBER;
    -- Variable para almacenar el resultado de la función
    notaFinal NUMBER;
BEGIN
    -- Seleccionar los datos de la tabla UFS para la asignatura M02B y UF3
    SELECT CONV_EXAM, NUM_PACS_ENT, MIN_PACS_ENT, NOTA_MEDIA_PACS, NOTA_EXAM
    INTO convocatoriaExamen, numPacsEntregadas, minPacsEntregar, notaMediaPacs, notaExamen
    FROM UFS
    WHERE COD_ASIG = 'M05' AND COD_UF = 'UF2';

    -- Llamar a la función con los datos recuperados
    notaFinal := F_NOTA_MEDIA_UF(convocatoriaExamen, numPacsEntregadas, minPacsEntregar, notaMediaPacs, notaExamen);
    
    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('La nota media de la UF es: ' || notaFinal);
END;
/


