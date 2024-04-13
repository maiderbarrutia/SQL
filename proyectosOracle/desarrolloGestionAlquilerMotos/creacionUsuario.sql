ALTER SESSION SET "_ORACLE_SCRIPT" = true;

SET SERVEROUTPUT ON;

--Creación de usuario con todos los privilegios
CREATE USER ecoMoto IDENTIFIED BY user123;

-- Da todos los privilegios al usuario creado
GRANT ALL PRIVILEGES TO ecoMoto;