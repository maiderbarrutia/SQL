ALTER SESSION SET "_ORACLE_SCRIPT" = true;

SET SERVEROUTPUT ON;

--Creación de usuario con todos los privilegios
CREATE USER userDesa IDENTIFIED BY user123;

-- Da todos los privilegios al usuario creado
GRANT ALL PRIVILEGES TO userDesa;

/*Esta sentencia otorga al usuario userDesa el privilegio de conectarse a la base de datos. 
Permite al usuario iniciar sesión en la base de datos, pero no le da acceso a ningún objeto 
dentro de la base de datos, como tablas o vistas. Es el permiso básico necesario para que un usuario 
pueda acceder a la base de datos.*/
/*GRANT CONNECT TO userDesa;*/

/*Esta sentencia otorga al usuario userDesa el privilegio de crear una sesión en la base de datos. 
Una sesión en Oracle se refiere al período de tiempo en el que un usuario está conectado a la base de datos 
y realiza operaciones. Con este privilegio, el usuario puede iniciar una sesión en la base de datos 
y realizar consultas y otras operaciones permitidas por los privilegios adicionales que se le otorguen.*/
/*GRANT CREATE SESSION TO userDesa;*/