-- ======================================================================
-- Proyecto: mysql-ips-colombia
-- Archivo: 04_reports_queries.sql
-- Capa: BI / Analytics (Vistas y consultas de negocio)
-- Descripción: Creación de vistas analíticas y consultas ejecutivas
--              para consumo en Power BI y análisis estratégico del
--              sistema de IPS en Colombia.
-- Orden de ejecución: 4 de 4
-- Dependencias:
--   - 01_create_schema.sql
--   - 02_load_and_clean_data.sql
--   - 03_views_analytics.sql
-- ======================================================================


-- ----------------------------------------------------------------------
-- 1. VISTA ANALÍTICA: COBERTURA DE IPS POR CADA 100.000 HABITANTES
-- ----------------------------------------------------------------------
-- Objetivo:
-- Medir la densidad de IPS a nivel municipal, normalizada por población,
-- permitiendo comparaciones justas entre territorios.

CREATE OR REPLACE VIEW vista_cobertura_ips AS
SELECT
    T1.depa_nombre AS Departamento,     -- Nombre original (con tildes) para visualización
    T1.muni_nombre AS Municipio,
    COUNT(T1.id) AS Total_IPS,
    T2.Poblacion,
    -- Métrica clave: cobertura de IPS por cada 100.000 habitantes
    (COUNT(T1.id) * 100000.0 / T2.Poblacion) AS Cobertura_por_100k
FROM
    ips_col T1
JOIN
    tabla_poblacion T2
    -- Unión basada en claves geográficas estandarizadas (ETL previo)
    ON T1.clave_ips_final = T2.clave_pob_final
GROUP BY
    T1.depa_nombre,
    T1.muni_nombre,
    T2.Poblacion
ORDER BY
    Cobertura_por_100k DESC;

-- Validación rápida
SELECT * FROM vista_cobertura_ips LIMIT 10;


-- ----------------------------------------------------------------------
-- 2. VISTA ANALÍTICA: NATURALEZA JURÍDICA Y ANTIGÜEDAD OPERATIVA
-- ----------------------------------------------------------------------
-- Objetivo:
-- Analizar la distribución de IPS según su naturaleza jurídica
-- (pública / privada) y su antigüedad operativa.

CREATE OR REPLACE VIEW vista_analisis_juridico_antiguedad AS
SELECT
    depa_nombre,
    muni_nombre,
    naju_nombre AS Naturaleza_Juridica,
    -- Antigüedad calculada desde la fecha de radicación
    DATEDIFF(CURDATE(), fecha_radicacion) AS Antiguedad_Dias,
    -- Conversión a años para análisis ejecutivo
    ROUND(DATEDIFF(CURDATE(), fecha_radicacion) / 365.25, 1) AS Antiguedad_Anios,
    COUNT(id) AS Total_IPS_Tipo
FROM
    ips_col
GROUP BY
    depa_nombre,
    muni_nombre,
    naju_nombre,
    fecha_radicacion
ORDER BY
    Antiguedad_Anios DESC;

-- Validación rápida
SELECT * FROM vista_analisis_juridico_antiguedad LIMIT 10;


-- ----------------------------------------------------------------------
-- 3. VISTA ANALÍTICA: ALERTAS DE VIGENCIA Y PRIORIZACIÓN OPERATIVA
-- ----------------------------------------------------------------------
-- Objetivo:
-- Identificar IPS con habilitación vencida o próxima a vencer,
-- facilitando procesos de auditoría, control y seguimiento.

CREATE OR REPLACE VIEW vista_alertas_vigencia AS
SELECT
    id,
    nombre_prestador,
    depa_nombre,
    muni_nombre,
    fecha_vencimiento,
    -- Días restantes (positivo) o vencidos (negativo)
    DATEDIFF(fecha_vencimiento, CURDATE()) AS Dias_Para_Vencer,
    -- Clasificación operacional del estado de habilitación
    CASE
        WHEN DATEDIFF(fecha_vencimiento, CURDATE()) < 0 THEN '01 - VENCIDA'
        WHEN DATEDIFF(fecha_vencimiento, CURDATE()) <= 90 THEN '02 - PRÓXIMA A VENCER (90 días)'
        ELSE '03 - VIGENTE'
    END AS Estado_Habilitacion_Alerta
FROM
    ips_col
ORDER BY
    Dias_Para_Vencer ASC;

-- Validación rápida
SELECT * FROM vista_alertas_vigencia LIMIT 10;


-- ----------------------------------------------------------------------
-- 4. CONSULTA EJECUTIVA: DISTRIBUCIÓN DE IPS POR ESTADO DE HABILITACIÓN
-- ----------------------------------------------------------------------
-- Objetivo:
-- Proveer una métrica ejecutiva de riesgo operativo que muestre
-- la distribución porcentual de IPS según su estado actual
-- (Cerrada, Vencida, Vigente).

-- CONSULTA 4.1: CONTEO Y PORCENTAJE DE IPS POR ESTADO DE ALERTA
SELECT 
    CASE 
        WHEN fecha_cierre IS NOT NULL THEN 'Cerrada'
        WHEN fecha_vencimiento < CURDATE() THEN 'Vencida'
        WHEN fecha_vencimiento >= CURDATE() THEN 'Vigente'
        ELSE 'Sin fecha definida'
    END AS Estado_Habilitacion_Alerta,
    COUNT(id) AS Total_IPS_por_Estado,
    -- Porcentaje sobre el total de IPS (métrica ejecutiva)
    ROUND((COUNT(id) * 100.0 / (SELECT COUNT(id) FROM ips_col)), 2) AS Porcentaje_del_Total
FROM 
    ips_col
GROUP BY 
    Estado_Habilitacion_Alerta
ORDER BY 
    Estado_Habilitacion_Alerta ASC;
