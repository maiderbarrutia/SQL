CREATE OR REPLACE PROCEDURE Registrar_Devolucion(
    p_alquilerID IN Alquileres_eco.AlquilerID%TYPE,
    p_fechadev IN Alquileres_eco.FechaFin%TYPE
)
AS
    --Variables para obtener datos
    v_matricula_motos Motos_eco.Matricula%TYPE;
    v_modelo_motos Motos_eco.Modelo%TYPE;
    
    v_dniCliente_clientes Clientes_eco.Dni%TYPE;
    v_nombreCliente_clientes Clientes_eco.Nombre%TYPE;
    v_ecoPuntosCliente_clientes Clientes_eco.ecoPuntos%TYPE;
    
    --Variables para hacer cálculos
    v_diasAlquiler_Alquileres Alquileres_eco.DiasAlquiler%TYPE;
    v_precioAlquiler_Alquileres Alquileres_eco.PrecioAlquiler%TYPE;
    
    v_ecoPuntosGanados_clientes INTEGER;
    
    --Variable para excepción
    v_fechaInicial_Alquileres Alquileres_eco.FechaIni%TYPE;
    
    -- Declaramos la excepción 
    fecha_dev_anterior EXCEPTION;

BEGIN
    /*Calcular los días de alquiler e introducir el dato en la variable "v_diasAlquiler_Alquileres" 
    y para la excepción obtenemos tambien la fecha inicial y la añadimos a la variable "v_fechaInicial_Alquileres" */
    SELECT (p_fechadev - FechaIni), FechaIni INTO v_diasAlquiler_Alquileres, v_fechaInicial_Alquileres
    FROM Alquileres_eco
    WHERE AlquilerID = p_alquilerID;
 
    /*EXCEPCIÓN: Verificar si la fecha de devolución es anterior a la fecha de inicio de alquiler. 
    Si es anterior salta la exception "fecha_dev_anterior"*/
    IF p_fechadev < v_fechaInicial_Alquileres THEN
        RAISE fecha_dev_anterior;
    END IF;

    -- Calcular el precio total del alquiler e introducir el dato en la variable "v_precioAlquiler_Alquileres"
    SELECT (PrecioPorDia * v_diasAlquiler_Alquileres * (1 - Descuento)) INTO v_precioAlquiler_Alquileres
    FROM Motos_eco
    JOIN Alquileres_eco ON Motos_eco.Matricula = Alquileres_eco.Matricula
    WHERE Alquileres_eco.AlquilerID = p_alquilerID;

    /*Actualizar tabla Alquileres_eco con los nuevos valores de FechaFin, DiasAlquiler y PrecioAlquiler 
    e introducir esos valores en las variables correspondientes*/
    UPDATE Alquileres_eco
    SET FechaFin = p_fechadev,
        DiasAlquiler = v_diasAlquiler_Alquileres,
        PrecioAlquiler = v_precioAlquiler_Alquileres
    WHERE AlquilerID = p_alquilerID;

    -- Calcular ecoPuntos ganados por el alquiler
    v_ecoPuntosGanados_clientes := v_precioAlquiler_Alquileres / 10;

    -- Actualizar tabla Clientes_eco añadiendo los puntos correspondientes por el alquiler a lo que el cliente ya tenía
    UPDATE Clientes_eco
    SET ecoPuntos = ecoPuntos + v_ecoPuntosGanados_clientes
    WHERE Dni IN (SELECT Dni FROM Alquileres_eco WHERE AlquilerID = p_alquilerID);
    
    -- Obtener datos y meterlos en las variables creadas para luego mostrarlos en los mensajes
    SELECT Motos_eco.Matricula, Motos_eco.Modelo, Clientes_eco.Dni, 
    Clientes_eco.Nombre, Clientes_eco.ecoPuntos
    INTO v_matricula_motos, v_modelo_motos, v_dniCliente_clientes, 
    v_nombreCliente_clientes, v_ecoPuntosCliente_clientes
    FROM Alquileres_eco
    JOIN Motos_eco ON Alquileres_eco.Matricula = Motos_eco.Matricula
    JOIN Clientes_eco ON Alquileres_eco.Dni = Clientes_eco.Dni
    WHERE Alquileres_eco.AlquilerID = p_alquilerID;
   
    -- Actualizar tabla Motos_eco para poner que la moto está disponible
    UPDATE Motos_eco
    SET disponible = 'SI'
    WHERE Matricula = v_matricula_motos;
    
    -- Mostrar mensajes de confirmación para cada actualización
    DBMS_OUTPUT.PUT_LINE('La devolución del alquiler: ' || p_alquilerID || ' se ha realizado correctamente');
    DBMS_OUTPUT.PUT_LINE('La moto de matricula: ' || v_matricula_motos || ' y modelo ' || v_modelo_motos || ' ahora está disponible');
    DBMS_OUTPUT.PUT_LINE('El cliente con DNI: ' || v_dniCliente_clientes || ' y nombre: ' || v_nombreCliente_clientes || ' tiene un total de ' || v_ecoPuntosCliente_clientes || ' puntos');

EXCEPTION
    -- Salta el error en caso de que la id del alquiler de la moto no exista o no es encontrada
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, '¡El alquiler con ID ' || p_alquilerID || ' no encontrado!');
    -- Esto es lo que se muestra cuando salte el error en la condición empleada antes
    WHEN fecha_dev_anterior THEN
        RAISE_APPLICATION_ERROR(-20002, 'La devolución del Alquiler con ID: ' || p_alquilerID || ' tiene una fecha de devolución: ' || p_fechadev || ' anterior a la fecha de inicio de alquiler.');
    -- Manejar cualquier otra excepción no capturada específicamente
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error inesperado al registrar la devolución para el Alquiler con ID: ' || p_alquilerID);
END;
/