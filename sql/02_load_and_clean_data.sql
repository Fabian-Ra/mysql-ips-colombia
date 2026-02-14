
USE ips_colombia;

-- ######################################################################
-- # 3. CARGA DE DATOS Y LIMPIEZA DE TIPOS (ETL de Fechas y Nulos)
-- ######################################################################

-- Carga el archivo CSV en la tabla ips_col. 
-- NOTA: Se asume que el archivo 'mi_data_ips.csv' se encuentra en el directorio seguro de MySQL (secure_file_priv).

LOAD DATA LOCAL INFILE 'mi_data_ips.csv'
INTO TABLE ips_col
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'        -- Delimitador común en archivos del REPS
ENCLOSED BY '"'                 -- Maneja celdas con comas internas
LINES TERMINATED BY '\n'
IGNORE 1 ROWS                   -- Ignora la fila de encabezados
(
    depa_nombre, 
    muni_nombre, 
    codigo_habilitacion, 
    nombre_prestador, 
    nits_nit, 
    razon_social, 
    @clpr_codigo,                -- Se usa variable para transformar el valor
    clpr_nombre, 
    ese, 
    direccion, 
    telefono, 
    email, 
    nivel, 
    caracter, 
    habilitado, 
    @fecha_radicacion,           -- Se usa variable para transformar el formato de fecha
    @fecha_vencimiento,          -- Se usa variable para transformar el formato de fecha
    @fecha_cierre,               -- Se usa variable para transformar el formato de fecha
    @dv,                         -- Se usa variable para manejar nulos
    clase_persona, 
    @naju_codigo,                -- Se usa variable para manejar nulos
    naju_nombre, 
    @numero_sede_principal,       -- Se usa variable para manejar nulos
    @fecha_corte_REPS            -- Se usa variable para transformar el formato de fecha y hora
)
SET
    -- Lógica de limpieza: Convierte valores vacíos ('') o guiones ('--') a NULL en campos numéricos (código de prestador).
    clpr_codigo = IF(@clpr_codigo IN ('', '--'), NULL, @clpr_codigo),
    
    -- Transformación compleja de fechas: Maneja múltiples formatos de fecha (YYYY-MM-DD o YYYYMMDD)
    -- y convierte los valores vacíos a NULL.
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
    
    -- Manejo del formato DATETIME para la fecha de corte REPS.
    fecha_corte_REPS = IF(@fecha_corte_REPS IN ('', '--'), NULL, STR_TO_DATE(@fecha_corte_REPS, '%Y-%m-%d %H:%i:%s')),
    
    -- Conversión a NULL para el resto de campos numéricos (Sede, DV, Código de Naturaleza Jurídica).
    numero_sede_principal = IF(@numero_sede_principal IN ('', '--'), NULL, @numero_sede_principal),
    dv = IF(@dv IN ('', '--'), NULL, @dv),
    naju_codigo = IF(@naju_codigo IN ('', '--'), NULL, @naju_codigo);
    
    


-- ######################################################################
-- # 4. CONTROL DE CALIDAD POST-CARGA (VALIDACIÓN DE NULOS)
-- ######################################################################

-- Verifica que el número total de filas cargadas coincida con el CSV original.
-- Confirma que los campos que fueron transformados (Fechas, Códigos) no contengan errores
-- y que los valores vacíos se hayan convertido correctamente a NULL, como se especificó en el SET de la carga.
SELECT 
    COUNT(*) AS total_filas,
    COUNT(fecha_radicacion) AS fecha_radicacion_no_nulos,
    COUNT(fecha_vencimiento) AS fecha_vencimiento_no_nulos,
    COUNT(fecha_cierre) AS fecha_cierre_no_nulos,
    COUNT(clpr_codigo) AS clpr_codigo_no_nulos,
    COUNT(naju_codigo) AS naju_codigo_no_nulos
FROM 
    ips_col;
    



-- ######################################################################
-- # 5. LIMPIEZA Y ESTANDARIZACIÓN DE CLAVES GEOGRÁFICAS (ETL FINAL)
-- ######################################################################

-- Este paso es CRUCIAL para garantizar un JOIN exitoso, ya que las claves originales
-- fallan debido a inconsistencias de acentos, mayúsculas y caracteres especiales.

-- 5.1. Estandarización de la Tabla IPS (ips_col)

-- 1. Añade la columna final para la clave de unión estandarizada.
ALTER TABLE ips_col
ADD COLUMN clave_ips_final VARCHAR(150);

-- 2. Limpieza de tildes y formateo:
-- Crea la clave uniendo Departamento y Municipio, lo convierte a MAYÚSCULAS,
-- e implementa la función REPLACE anidada para eliminar todas las tildes (Á, É, Í, Ó, Ú).
UPDATE ips_col
SET clave_ips_final = 
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        UPPER(CONCAT(depa_nombre, '_', muni_nombre)),
                        'Á', 'A'),
                    'É', 'E'),
                'Í', 'I'),
            'Ó', 'O'),
        'Ú', 'U');
        
        




-- 5.2. Estandarización de la Tabla de Población (tabla_poblacion)

-- 1. Añade la columna final para la clave de unión estandarizada.
ALTER TABLE tabla_poblacion
ADD COLUMN clave_pob_final VARCHAR(150);

-- 2. Limpieza de caracteres mal codificados y formateo:
-- Limpia la CLAVE_UNION (que tenía errores de codificación del CSV),
-- convierte a mayúsculas y elimina los caracteres especiales y tildes.
UPDATE tabla_poblacion
SET clave_pob_final = 
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        UPPER(clave_union), 
                        'Á', 'A'),  -- Reemplazo de tildes (por si pasaron la importación)
                    'É', 'E'),
                'Í', 'I'),
            'Ó', 'O'),
        'Ú', 'U');
        
-- NOTA CRÍTICA: Dependiendo del error de codificación del CSV, podría ser necesario 
-- reemplazar los caracteres mal formados ('ÃÁ', 'ÃÍ') por su letra simple ('A', 'I').
-- El REPLACE('Á', 'A') es suficiente en la mayoría de los casos.
