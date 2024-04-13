CALL Registrar_Devolucion(1, TO_DATE('2024-04-15', 'YYYY-MM-DD'));

CALL Registrar_Devolucion(2, TO_DATE('2023-04-05', 'YYYY-MM-DD'));

CALL Registrar_Devolucion(3, TO_DATE('2024-04-07', 'YYYY-MM-DD'));



INSERT INTO Alquileres_eco (dni, Matricula, FechaIni, Descuento)

VALUES ('12345678A', 'Moto006', TO_DATE('2024-04-05', 'YYYY-MM-DD'), 0.5);



INSERT INTO Alquileres_eco (dni, Matricula, FechaIni, Descuento)

VALUES ('34567890C', 'Moto008', TO_DATE('2024-04-05', 'YYYY-MM-DD'), 0.2);



CALL Registrar_Devolucion(6, TO_DATE('2024-04-11', 'YYYY-MM-DD'));