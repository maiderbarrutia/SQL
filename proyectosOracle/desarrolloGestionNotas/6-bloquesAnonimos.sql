DELETE FROM UFS
WHERE COD_ASIG = 'M05';
INSERT INTO UFS VALUES ('M05', 'UF1', 'Descripción UF1', 20, 0.3, 12, 6, 9, 7.8, 8.2, 'ORDINARIA', 8, 7.5, 'APROBADA');

-- 5.1.Crear un bloque anónimo que actualice la NOTA_MEDIA_UF de todas las UFS
DECLARE
    v_notaMedia NUMBER;
    
    CURSOR c_uf IS
        SELECT NOTA_MEDIA_UF
        FROM UFS
        FOR UPDATE OF NOTA_MEDIA_UF;
BEGIN
    FOR uf_rec IN c_uf
    LOOP
        v_notaMedia := uf_rec.NOTA_MEDIA_UF;

        UPDATE UFS
        SET
            NOTA_FINAL_UF = v_notaMedia * 0.4 + 0.6 * 7, -- Reemplazar 7 con el valor deseado para NOTA_EXAMEN
            STAT_UF = CASE
                          WHEN v_notaMedia >= 5 THEN 'APROBADA'
                          ELSE 'SUSPENDIDA'
                      END
        WHERE CURRENT OF c_uf;
    END LOOP;
END;
/

-----------------------------------------

DECLARE
    v_notaMedia NUMBER;
    
    CURSOR c_uf IS
        SELECT NOTA_MEDIA_UF, NOTA_EXAM
        FROM UFS
        FOR UPDATE OF NOTA_MEDIA_UF;
BEGIN
    FOR uf_rec IN c_uf
    LOOP
        v_notaMedia := uf_rec.NOTA_MEDIA_UF;

        UPDATE UFS
        SET
            NOTA_FINAL_UF = v_notaMedia * 0.4 + 0.6 * uf_rec.NOTA_EXAM,
            STAT_UF = CASE
                          WHEN v_notaMedia >= 5 THEN 'APROBADA'
                          ELSE 'SUSPENDIDA'
                      END
        WHERE CURRENT OF c_uf;
    END LOOP;
END;
/






-- 5.2.Crear un bloque anónimo que actualice NOTA_MEDIA_ASIG y APRO_UFS de todas las ASIGNATURAS


-- 5.3.Crear un bloque anónimo que calcule y muestre la nota media final del ciclo
DECLARE
    V_NOTA_MEDIA_CICLO NUMBER := 0;
    V_NUM_ASIG_FALTA NUMBER := 0;
    V_TOTAL_UFS NUMBER := 0;
BEGIN
    FOR asignatura_rec IN (SELECT NOTA_MEDIA_ASIG, NUM_UFS FROM ASIGNATURAS) LOOP
        IF asignatura_rec.NOTA_MEDIA_ASIG IS NOT NULL THEN
            V_NOTA_MEDIA_CICLO := V_NOTA_MEDIA_CICLO + (asignatura_rec.NOTA_MEDIA_ASIG * asignatura_rec.NUM_UFS);
            V_TOTAL_UFS := V_TOTAL_UFS + asignatura_rec.NUM_UFS;
        ELSE
            V_NUM_ASIG_FALTA := V_NUM_ASIG_FALTA + 1;
        END IF;
    END LOOP;

    -- Calcular la nota media del ciclo
    IF V_TOTAL_UFS > 0 THEN
        V_NOTA_MEDIA_CICLO := V_NOTA_MEDIA_CICLO / V_TOTAL_UFS;
    ELSE
        V_NOTA_MEDIA_CICLO := NULL; -- No hay UFS, por lo tanto, la nota media del ciclo no se puede calcular
    END IF;

    -- Mostrar el mensaje
    IF V_NOTA_MEDIA_CICLO IS NOT NULL THEN
        IF V_NUM_ASIG_FALTA = 0 THEN
            DBMS_OUTPUT.PUT_LINE('El ciclo se ha terminado con una nota media de aproximadamente: ' || V_NOTA_MEDIA_CICLO);
        ELSE
            DBMS_OUTPUT.PUT_LINE('A falta de ' || V_NUM_ASIG_FALTA || ' asignaturas por aprobar. La nota media del ciclo es de aproximadamente: ' || V_NOTA_MEDIA_CICLO);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se puede calcular la nota media del ciclo porque no hay unidades formativas.');
    END IF;
END;
/


