--Borrar las tablas y la vista
/*DROP TABLE ASIGNATURAS;
DROP TABLE UFS;
DROP VIEW EXPEDIENTE;*/

--DEFINICIÓN DE LA TABLA

-- Creación de la tabla ASIGNATURAS
CREATE TABLE ASIGNATURAS (
    COD_ASIG VARCHAR2(10) PRIMARY KEY,
    ABV_ASIG VARCHAR2(20),
    DES_ASIG VARCHAR2(100),
    SEMES NUMBER,
    HORAS NUMBER,
    PRECIO NUMBER,
    NUM_UFS NUMBER
);

-- Creación de la tabla UFS
CREATE TABLE UFS (
    COD_ASIG VARCHAR2(10),
    COD_UF VARCHAR2(10),
    DES_UF VARCHAR2(100),
    NUM_HORAS NUMBER,
    PONDERA_UF NUMBER,
    TOT_PACS_UF NUMBER,
    MIN_PACS_ENT NUMBER,
    NUM_PACS_ENT NUMBER,
    NOTA_MEDIA_PACS NUMBER,
    NOTA_EXAM NUMBER,
    CONV_EXAM VARCHAR2(20),
    PRIMARY KEY (COD_ASIG, COD_UF),
    FOREIGN KEY (COD_ASIG) REFERENCES ASIGNATURAS(COD_ASIG)
);

--EJERCICIO 1: Repaso SQL (Tablas y vistas)

-- 1.1. Añadir campos a las tablas ASIGNATURAS y UFS
-- Añadir campos a la tabla ASIGNATURAS
ALTER TABLE ASIGNATURAS
ADD (NOM_PROFE VARCHAR2(50),
     APRO_UFS NUMBER(10),
     NOTA_MEDIA_ASIG NUMBER(4,2));

-- Añadir campos a la tabla UFS
ALTER TABLE UFS
ADD (NOTA_MEDIA_UF NUMBER(4,2),
     NOTA_FINAL_UF NUMBER(10),
     STAT_UF VARCHAR2(10));
     
-- Insertar datos en la tabla ASIGNATURAS
INSERT INTO ASIGNATURAS VALUES ('M02B', 'Base de datos B', 'Lenguaje SQL: DCL y extensión procedimental', 1, 82, 199, 2, 'Emilio Saurina', 2, 8.5);
INSERT INTO ASIGNATURAS VALUES ('M03B', 'Programación B', 'Programación orientada a objetos', 1, 77, 199, 3, 'Fernando Méndez', 3, 7.8);
INSERT INTO ASIGNATURAS VALUES ('M05', 'Entornos desarrollo', 'Desarrollo de software', 1, 66, 99, 3, 'Armando Cea', 2, 0);

-- Insertar datos en la tabla UFS
INSERT INTO UFS VALUES ('M02B', 'UF3', 'Descripción UF3', 66, 0.7, 9, 8, 9, 7.5, 8.0, 'ORDINARIA', 7.5, 8.0, 'APROBADA');
INSERT INTO UFS VALUES ('M02B', 'UF4', 'Descripción UF4', 16, 0.3, 5, 4, 5, 7.2, 7.8, 'ORDINARIA', 7.2, 7.8, 'APROBADA');

INSERT INTO UFS VALUES ('M03B', 'UF4', 'Descripción UF4', 28, 0.4, 6, 5, 5, 9.3, 10, 'ORDINARIA', 7.2, 10, 'APROBADA');
INSERT INTO UFS VALUES ('M03B', 'UF5', 'Descripción UF5', 28, 0.4, 6, 5, 5, 6.8, 10, 'ORDINARIA', 7.2, 8, 'APROBADA');
INSERT INTO UFS VALUES ('M03B', 'UF6', 'Descripción UF6', 21, 0.2, 6, 5, 5, 7.7, 10, 'ORDINARIA', 7.2, 9.3, 'APROBADA');

INSERT INTO UFS VALUES ('M05', 'UF1', 'Descripción UF1', 20, 0.3, 12, 6, 9, 7.8, 8.2, 'EXTRAORDINARIA', 0, 0, 'SUSPENDIDA');
INSERT INTO UFS VALUES ('M05', 'UF2', 'Descripción UF2', 20, 0.3, 6, 5, 5, 7.7, 10, 'ORDINARIA', 7.2, 9.3, 'APROBADA');
INSERT INTO UFS VALUES ('M05', 'UF3', 'Descripción UF3', 26, 0.4, 6, 5, 5, 7.7, 10, 'ORDINARIA', 7.2, 9.3, 'APROBADA');

--1.2 Crear una vista llamada "EXPEDIENTE"
CREATE OR REPLACE VIEW EXPEDIENTE AS
SELECT 
    ASIGNATURAS.ABV_ASIG,
    ASIGNATURAS.DES_ASIG,
    ROUND(UFS.NUM_PACS_ENT / UFS.TOT_PACS_UF * 100, 2) AS PORC_PACS_ENTRE,
    UFS.NOTA_MEDIA_PACS,
    UFS.NOTA_EXAM,
    UFS.CONV_EXAM,
    UFS.NOTA_MEDIA_UF,
    UFS.NOTA_FINAL_UF,
    UFS.STAT_UF 
FROM 
    ASIGNATURAS
INNER JOIN 
    UFS 
ON 
    ASIGNATURAS.COD_ASIG = UFS.COD_ASIG;
/    

--1.3. Actualizar registros de la tabla ASIGNATURAS
UPDATE ASIGNATURAS
SET NOM_PROFE = 'Emilio Saurina'
WHERE COD_ASIG IN ('ICB0102A', 'ICB0102B');

--Mostrar todos los datos de la vista
SELECT * FROM EXPEDIENTE;

--Borrar todos los datos de la tabla ASIGNATURAS
/*DELETE FROM ASIGNATURAS;*/