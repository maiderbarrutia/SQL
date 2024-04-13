CREATE OR REPLACE FUNCTION estado_moto (p_matricula IN VARCHAR2)
RETURN VARCHAR2 IS

 -- Variable para almacenar el estado de disponibilidad de la moto.
 v_disponible CHAR(2);

 -- Variable para almacenar el mensaje de retorno.
 v_estado VARCHAR2(20);

BEGIN

 -- Seleccionar el estado de disponibilidad de la moto basado en la matrícula.
 SELECT disponible INTO v_disponible
 FROM Motos_eco
 WHERE Matricula = p_matricula;

 -- Determinar el estado de la moto para el valor devuelto.
 IF v_disponible = 'SI' THEN
    v_estado := 'DISPONIBLE';
 ELSE
    v_estado := 'NO DISPONIBLE';
 END IF;
 
 -- Retornar el estado de la moto.
 RETURN v_estado;

EXCEPTION
 WHEN NO_DATA_FOUND THEN
  -- Si no se encuentra la matrícula, se maneja la excepción.
  RAISE_APPLICATION_ERROR(-20001, 'La Matricula: ' || p_matricula || ' no se encuentra.');

 WHEN OTHERS THEN
  -- Manejar cualquier otra excepción no capturada específicamente.
  RAISE_APPLICATION_ERROR(-20002, 'Error inesperado al buscar la matricula: ' || p_matricula);

END estado_moto;
/

