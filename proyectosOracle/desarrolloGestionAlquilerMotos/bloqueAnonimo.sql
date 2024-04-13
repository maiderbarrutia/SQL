SET SERVEROUTPUT ON;

DECLARE
    -- Variables para almacenar los resultados de la función
    v_resultado VARCHAR2(100);
    v_matricula VARCHAR2(20) := 'Moto009';
    v_precio  NUMBER;

BEGIN
    -- Llamada a la función con una matrícula existente
    v_resultado := estado_moto(v_matricula);
    
    SELECT preciopordia
    INTO v_precio
    FROM motos_eco
    WHERE matricula = v_matricula;

  dbms_output.put_line('La moto con matricula '|| v_matricula || ' esta '
 || v_resultado || ' y tiene un precio de ' || v_precio || ' € por día.');

EXCEPTION
    WHEN OTHERS THEN
    -- Manejo de cualquier error inesperado
    dbms_output.put_line('Error inesperado: ' || sqlerrm);
END;