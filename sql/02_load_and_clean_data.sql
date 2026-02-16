-- ======================================================================
-- Proyecto: mysql-ips-colombia
-- Archivo: 02_load_and_clean_data.sql
-- Capa: ETL (Carga y limpieza de datos)
-- Descripción: Carga de datasets CSV, tipado de datos, limpieza de nulos
--              y estandarización de claves para análisis posterior.
-- Orden de ejecución: 2 de 4
-- ======================================================================

USE ips_colombia;

-- ----------------------------------------------------------------------
-- 1. CARGA Y LIMPIEZA DEL DATASET IPS (REPS)
-- ----------------------------------------------------------------------
-- Nota técnica:
-- Los archivos CSV deben ubicarse en el directorio permitido por la
-- variable MySQL `secure_file_priv`
-- (ejemplo: C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/)

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/mi_data_ips.csv'
INTO TABLE ips_col
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    depa_nombre,
    muni_nombre,
    codigo_habilitacion,
    nombre_prestador,
    nits_nit,
    razon_social,
    @clpr_codigo,
    clpr_nombre,
    ese,
    direccion,
    telefono,
    email,
    nivel,
    caracter,
    habilitado,
    @fecha_radicacion,
    @fecha_vencimiento,
    @fecha_cierre,
    @dv,
    clase_persona,
    @naju_codigo,
    naju_nombre,
    @numero_sede_principal,
    @fecha_corte_REPS
)
SET
    clpr_codigo = IF(@clpr_codigo IN ('', '--'), NULL, @clpr_codigo),

    fecha_radicacion = IF(@fecha_radicacion IN ('', '--'), NULL,
        CASE
            WHEN LENGTH(@fecha_radicacion) = 10 THEN STR_TO_DATE(@fecha_radicacion, '%Y-%m-%d')
            WHEN LENGTH(@fecha_radicacion) = 8 THEN STR_TO_DATE(@fecha_radicacion, '%Y%m%d')
            ELSE NULL
        END
    ),

    fecha_vencimiento = IF(@fecha_vencimiento IN ('', '--'), NULL,
        CASE
            WHEN LENGTH(@fecha_vencimiento) = 10 THEN STR_TO_DATE(@fecha_vencimiento, '%Y-%m-%d')
            WHEN LENGTH(@fecha_vencimiento) = 8 THEN STR_TO_DATE(@fecha_vencimiento, '%Y%m%d')
            ELSE NULL
        END
    ),

    fecha_cierre = IF(@fecha_cierre IN ('', '--'), NULL,
        CASE
            WHEN LENGTH(@fecha_cierre) = 10 THEN STR_TO_DATE(@fecha_cierre, '%Y-%m-%d')
            WHEN LENGTH(@fecha_cierre) = 8 THEN STR_TO_DATE(@fecha_cierre, '%Y%m%d')
            ELSE NULL
        END
    ),

    fecha_corte_REPS = IF(@fecha_corte_REPS IN ('', '--'), NULL,
        STR_TO_DATE(@fecha_corte_REPS, '%Y-%m-%d %H:%i:%s')
    ),

    numero_sede_principal = IF(@numero_sede_principal IN ('', '--'), NULL, @numero_sede_principal),
    dv = IF(@dv IN ('', '--'), NULL, @dv),
    naju_codigo = IF(@naju_codigo IN ('', '--'), NULL, @naju_codigo);

-- ----------------------------------------------------------------------
-- 2. CONTROL DE CALIDAD POST-CARGA (IPS)
-- ----------------------------------------------------------------------

SELECT
    COUNT(*) AS total_filas,
    COUNT(fecha_radicacion) AS fecha_radicacion_no_nulos,
    COUNT(fecha_vencimiento) AS fecha_vencimiento_no_nulos,
    COUNT(fecha_cierre) AS fecha_cierre_no_nulos,
    COUNT(clpr_codigo) AS clpr_codigo_no_nulos,
    COUNT(naju_codigo) AS naju_codigo_no_nulos
FROM ips_col;

-- ----------------------------------------------------------------------
-- 3. CARGA DEL DATASET DE POBLACIÓN (DANE)
-- ----------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS tabla_poblacion (
    DPNOM VARCHAR(150),
    DPMP VARCHAR(150),
    Poblacion BIGINT,
    clave_union VARCHAR(300)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/poblacion_dane_final.csv'
INTO TABLE tabla_poblacion
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    DPNOM,
    DPMP,
    Poblacion,
    clave_union
);

-- ----------------------------------------------------------------------
-- 4. ESTANDARIZACIÓN DE CLAVES GEOGRÁFICAS
-- ----------------------------------------------------------------------

ALTER TABLE ips_col
ADD COLUMN IF NOT EXISTS clave_ips_final VARCHAR(150);

UPDATE ips_col
SET clave_ips_final =
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            UPPER(CONCAT(TRIM(depa_nombre), '_', TRIM(muni_nombre))),
                            'Á','A'),
                        'É','E'),
                    'Í','I'),
                'Ó','O'),
            'Ú','U'),
        ' ','_');

ALTER TABLE tabla_poblacion
ADD COLUMN IF NOT EXISTS clave_pob_final VARCHAR(150);

UPDATE tabla_poblacion
SET clave_pob_final =
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            UPPER(CONCAT(TRIM(DPNOM), '_', TRIM(DPMP))),
                            'Á','A'),
                        'É','E'),
                    'Í','I'),
                'Ó','O'),
            'Ú','U'),
        ' ','_');
