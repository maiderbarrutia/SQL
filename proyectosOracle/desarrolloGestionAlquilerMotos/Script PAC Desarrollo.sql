-- Crear Tabla clientes_eco
CREATE TABLE Clientes_eco (
    Dni VARCHAR2(9) PRIMARY KEY,
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    Email VARCHAR2(100),
    Telefono VARCHAR2(20),
    ecoPuntos INTEGER DEFAULT 0
);

-- Crear Tabla motos_eco
CREATE TABLE Motos_eco (
    Matricula VARCHAR2(20) PRIMARY KEY,
    Modelo VARCHAR2(50),
    Color VARCHAR2(30),
    PrecioPorDia NUMBER,
    disponible CHAR(2) DEFAULT ('SI') CHECK (disponible IN ('SI', 'NO'))
);

-- Crear una secuencia para n�meros autom�ticos de alquiler
CREATE SEQUENCE seq_alquiler_id START WITH 1 INCREMENT BY 1;

-- Crear Tabla alquileres_eco
CREATE TABLE Alquileres_eco (
    AlquilerID NUMBER DEFAULT seq_alquiler_id.nextval  PRIMARY KEY,
    dni VARCHAR2(20),
    Matricula VARCHAR2(20),
    FechaIni DATE,
    FechaFin DATE,
    Descuento NUMBER,
    DiasAlquiler INTEGER,
    PrecioAlquiler NUMBER,
    FOREIGN KEY (dni) REFERENCES Clientes_eco(Dni),
    FOREIGN KEY (Matricula) REFERENCES Motos_eco(Matricula)
);


INSERT INTO Clientes_eco (Dni, Nombre, Apellido, Email, Telefono) VALUES ('12345678A', 'Juan', 'Pérez', 'juan.perez@email.com', '600100200');
INSERT INTO Clientes_eco (Dni, Nombre, Apellido, Email, Telefono) VALUES ('23456789B', 'María', 'López', 'maria.lopez@email.com', '610200300');
INSERT INTO Clientes_eco (Dni, Nombre, Apellido, Email, Telefono) VALUES ('34567890C', 'Carlos', 'García', 'carlos.garcia@email.com', '620300400');
INSERT INTO Clientes_eco (Dni, Nombre, Apellido, Email, Telefono) VALUES ('45678901D', 'Ana', 'Martínez', 'ana.martinez@email.com', '630400500');
INSERT INTO Clientes_eco (Dni, Nombre, Apellido, Email, Telefono) VALUES ('56789012E', 'Luis', 'Hernández', 'luis.hernandez@email.com', '640500600');
INSERT INTO Clientes_eco (Dni, Nombre, Apellido, Email, Telefono) VALUES ('67890123F', 'Lucía', 'Gómez', 'lucia.gomez@email.com', '650600700');
INSERT INTO Clientes_eco (Dni, Nombre, Apellido, Email, Telefono) VALUES ('78901234G', 'Antonio', 'Navarro', 'antonio.navarro@email.com', '660700800');
INSERT INTO Clientes_eco (Dni, Nombre, Apellido, Email, Telefono) VALUES ('89012345H', 'Sofía', 'Ruiz', 'sofia.ruiz@email.com', '670800900');
INSERT INTO Clientes_eco (Dni, Nombre, Apellido, Email, Telefono) VALUES ('90123456I', 'David', 'Díaz', 'david.diaz@email.com', '680900100');
INSERT INTO Clientes_eco (Dni, Nombre, Apellido, Email, Telefono) VALUES ('01234567J', 'Elena', 'Morales', 'elena.morales@email.com', '690001002');

INSERT INTO Motos_eco (Matricula, Modelo, Color, PrecioPorDia) VALUES ('Moto001', 'Honda CB500F', 'Negro', 15);
INSERT INTO Motos_eco (Matricula, Modelo, Color, PrecioPorDia) VALUES ('Moto002', 'Yamaha YZF-R3', 'Azul', 20);
INSERT INTO Motos_eco (Matricula, Modelo, Color, PrecioPorDia) VALUES ('Moto003', 'Kawasaki Ninja 400', 'Verde', 25);
INSERT INTO Motos_eco (Matricula, Modelo, Color, PrecioPorDia) VALUES ('Moto004', 'Suzuki GSX-S750', 'Blanco', 30);
INSERT INTO Motos_eco (Matricula, Modelo, Color, PrecioPorDia) VALUES ('Moto005', 'Ducati Monster 797', 'Rojo', 35);
INSERT INTO Motos_eco (Matricula, Modelo, Color, PrecioPorDia) VALUES ('Moto006', 'BMW G310R', 'Gris', 40);
INSERT INTO Motos_eco (Matricula, Modelo, Color, PrecioPorDia) VALUES ('Moto007', 'Triumph Street Triple', 'Amarillo', 45);
INSERT INTO Motos_eco (Matricula, Modelo, Color, PrecioPorDia) VALUES ('Moto008', 'KTM 390 Duke', 'Naranja', 50);
INSERT INTO Motos_eco (Matricula, Modelo, Color, PrecioPorDia) VALUES ('Moto009', 'Aprilia Tuono 125', 'Plata', 55);
INSERT INTO Motos_eco (Matricula, Modelo, Color, PrecioPorDia) VALUES ('Moto010', 'MV Agusta Brutale 800', 'Oro', 60);

/*TRIGGER que actualiza autom�ticamente el estado de la moto a 'NO' en la tabla Motos_eco cuando se inserta un nuevo alquiler en la tabla Alquileres_eco*/
CREATE OR REPLACE TRIGGER TRG_ACTUALIZAR_ESTADO_MOTO
AFTER INSERT ON Alquileres_eco
FOR EACH ROW
BEGIN
  -- Actualizar el estado de la moto a 'NO' cuando se inserta un nuevo alquiler.
  UPDATE Motos_eco
  SET disponible = 'NO'
  WHERE Matricula = :NEW.Matricula;

END TRG_ACTUALIZAR_ESTADO_MOTO;
/

-- Insertar nuevos Alquileres
INSERT INTO Alquileres_eco (dni, Matricula, FechaIni, Descuento) VALUES ('12345678A', 'Moto001', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 0.1);
INSERT INTO Alquileres_eco (dni, Matricula, FechaIni, Descuento) VALUES ('23456789B', 'Moto002', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 0.05);
INSERT INTO Alquileres_eco (dni, Matricula, FechaIni, Descuento) VALUES ('34567890C', 'Moto006', TO_DATE('2024-04-03', 'YYYY-MM-DD'), 0.15);
INSERT INTO Alquileres_eco (dni, Matricula, FechaIni, Descuento) VALUES ('45678901D', 'Moto008', TO_DATE('2024-04-04', 'YYYY-MM-DD'), 0.2);
INSERT INTO Alquileres_eco (dni, Matricula, FechaIni, Descuento) VALUES ('56789012E', 'Moto010', TO_DATE('2024-04-05', 'YYYY-MM-DD'), 0);