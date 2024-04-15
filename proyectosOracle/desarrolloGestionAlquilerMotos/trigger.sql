CREATE OR REPLACE TRIGGER verificar_alquiler 
BEFORE INSERT ON Alquileres_eco 
FOR EACH ROW

DECLARE
 -- Variable para almacenar el estado de disponibilidad de la moto.
 v_disponible CHAR(2);
 v_matricula VARCHAR(20);
 e_moto_no_disponible EXCEPTION;

BEGIN
 -- Buscar el estado de disponibilidad de la moto que se quiere alquilar.
 v_matricula := :NEW.Matricula;

 -- Buscar el estado de disponibilidad de la moto que se quiere alquilar.
 SELECT disponible INTO v_disponible
 FROM Motos_eco
 WHERE Matricula = v_matricula;

 -- Verificar si la moto está disponible.
 IF v_disponible = 'NO' THEN

      -- Si la moto no está disponible, lanzar una excepción.
      RAISE e_moto_no_disponible;

 END IF;

EXCEPTION

 WHEN NO_DATA_FOUND THEN
  -- Manejar el caso en que la matrícula de la moto no existe en la tabla Motos_eco.
  RAISE_APPLICATION_ERROR(-20001, 'La moto con matrícula ' || v_matricula || ' no existe en la base de datos.');

  WHEN e_moto_no_disponible THEN
  -- Lanzar un error indicando que la moto no está disponible para alquiler.
  RAISE_APPLICATION_ERROR(-20002, 'La moto con matrícula ' || v_matricula|| ' no está disponible para alquiler.');

END;