/*actualizar el alquiler cuando se realiza la devolución de una moto 
al llegar un cliente, con la moto a devolverla en la oficina.*/

CREATE OR REPLACE PROCEDURE Registrar_Devolucion (
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
    v_descuento_Alquileres Alquileres_eco.Descuento%TYPE;
    v_precioPorDia_Motos Motos_eco.PrecioPorDia%TYPE;
    v_fechaInicial_Alquileres Alquileres_eco.FechaIni%TYPE;
    
    v_ecoPuntosGanados_clientes INTEGER;
    
    
    
BEGIN
    -- Establecer los ecoPuntos del cliente a 0 antes de procesar
   /*UPDATE Clientes_eco
    SET ecoPuntos = 0
    WHERE Dni IN (SELECT Dni FROM Alquileres_eco WHERE AlquilerID = p_alquilerID);*/

    -- Obtener datos para luego mostrarlos
    SELECT Matricula, Modelo, precioPorDia
    INTO v_matricula_motos, v_modelo_motos, v_precioPorDia_Motos
    FROM Motos_eco 
    WHERE Matricula = (SELECT Matricula FROM Alquileres_eco WHERE AlquilerID = p_alquilerID);
    
    SELECT Dni, Nombre, ecoPuntos
    INTO v_dniCliente_clientes, v_nombreCliente_clientes, v_ecoPuntosCliente_clientes
    FROM Clientes_eco 
    WHERE Dni IN (SELECT Dni FROM Alquileres_eco WHERE AlquilerID = p_alquilerID);

    -- Obtener datos para hacer operaciones
    SELECT FechaIni, Descuento 
    INTO v_fechaInicial_Alquileres, v_descuento_Alquileres
    FROM Alquileres_eco
    WHERE AlquilerID = p_alquilerID;
    
    -- Calcular los días de alquiler
    v_diasAlquiler_Alquileres := p_fechadev - v_fechaInicial_Alquileres;
    
    -- Calcular el precio total del alquiler
    v_precioAlquiler_Alquileres := (v_precioPorDia_Motos * v_diasAlquiler_Alquileres) - (v_precioPorDia_Motos * v_diasAlquiler_Alquileres * v_descuento_Alquileres);

    -- Obtener el precio total del alquiler
    /*SELECT PrecioAlquiler
    INTO v_precioAlquiler_Alquileres
    FROM Motos_eco 
    JOIN Alquileres_eco ON Motos_eco.Matricula = Alquileres_eco.Matricula
    WHERE AlquilerID = p_alquilerID;*/

    -- Actualizar tabla Alquileres_eco
    UPDATE Alquileres_eco
    SET FechaFin = p_fechadev,
        DiasAlquiler = v_diasAlquiler_Alquileres,
        PrecioAlquiler = v_precioAlquiler_Alquileres
    WHERE AlquilerID = p_alquilerID;
    
    -- Actualizar tabla Alquileres_eco
    /*UPDATE Alquileres_eco
    SET FechaFin = p_fechadev,
        DiasAlquiler = ROUND(p_fechadev - FechaIni),
        PrecioAlquiler = ROUND((SELECT PrecioPorDia FROM Motos_eco WHERE Matricula = (SELECT Matricula FROM Alquileres_eco WHERE AlquilerID = p_alquilerID)) * ROUND(p_fechadev - FechaIni) * (1 - (SELECT Descuento FROM Alquileres_eco WHERE AlquilerID = p_alquilerID)), 2)
    WHERE AlquilerID = p_alquilerID;*/
    
   
    
    -- Actualizar tabla Motos_eco
    UPDATE Motos_eco
    SET disponible = 'SI'
    WHERE Matricula = v_matricula_motos;

    -- Calcular ecoPuntos ganados por el alquiler (Si 1€ = 10puntos, x€ del alquiler = xpuntos)
    v_ecoPuntosGanados_clientes := v_precioAlquiler_Alquileres / 10;

    -- Actualizar tabla Clientes_eco
    UPDATE Clientes_eco
    SET ecoPuntos = ecoPuntos + v_ecoPuntosGanados_clientes
    WHERE Dni IN (SELECT Dni FROM Alquileres_eco WHERE AlquilerID = p_alquilerID);

     --Obtener el precio del alquiler (ESTO SOLO ES PARA OBTENER LOS DATOS Y VER SI FUNCIONA)
    /*SELECT PrecioAlquiler, DiasAlquiler 
    INTO v_precioAlquiler_Alquileres, v_diasAlquiler_Alquileres
    FROM Alquileres_eco 
    WHERE AlquilerID = p_alquilerID;
    DBMS_OUTPUT.PUT_LINE('Dias alquiler: ' || v_diasAlquiler_Alquileres);
    DBMS_OUTPUT.PUT_LINE('Precio alquiler: ' || v_precioAlquiler_Alquileres);*/

    -- Confirmar devolución y mostrar mensajes
    DBMS_OUTPUT.PUT_LINE('La devolución del alquiler: ' || p_alquilerID || ' se ha realizado correctamente');
    DBMS_OUTPUT.PUT_LINE('La moto de matricula: ' || v_matricula_motos || ' y modelo ' || v_modelo_motos || ' ahora está disponible');
    DBMS_OUTPUT.PUT_LINE('El cliente con DNI: ' || v_dniCliente_clientes || ' y nombre: ' || v_nombreCliente_clientes || ' tiene un total de ' || v_ecoPuntosCliente_clientes || ' puntos');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('El alquiler con ID ' || p_alquilerID || ' no existe.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/






-- COMPROBAR QUE FUNCIONA
DECLARE
    v_alquilerID NUMBER := 5; -- ID de alquiler específico
    v_fechadev DATE := TO_DATE('2024-04-10', 'YYYY-MM-DD');
BEGIN
    Registrar_Devolucion(v_alquilerID, v_fechadev);
  
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

