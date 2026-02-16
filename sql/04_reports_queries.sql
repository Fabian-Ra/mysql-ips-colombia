-- ======================================================================
-- Proyecto: mysql-ips-colombia
-- Archivo: 04_reports_queries.sql
-- Capa: BI / Analytics (Consultas ejecutivas)
-- Descripción: Consultas estratégicas y métricas ejecutivas basadas en
--              las vistas analíticas definidas previamente.
-- Orden de ejecución: 4 de 4
-- Dependencias:
--   - 01_create_schema.sql
--   - 02_load_and_clean_data.sql
--   - 03_views_analytics.sql
-- ======================================================================


-- ----------------------------------------------------------------------
-- 1. CONSULTA EJECUTIVA: TOP MUNICIPIOS POR COBERTURA DE IPS
-- ----------------------------------------------------------------------
-- Objetivo:
-- Identificar los municipios con mayor densidad de IPS
-- por cada 100.000 habitantes.

SELECT *
FROM vista_cobertura_ips
ORDER BY Cobertura_por_100k DESC
LIMIT 20;


-- ----------------------------------------------------------------------
-- 2. CONSULTA EJECUTIVA: IPS CON MAYOR RIESGO OPERATIVO
-- ----------------------------------------------------------------------
-- Objetivo:
-- Priorizar IPS vencidas o próximas a vencer
-- para seguimiento regulatorio.

SELECT *
FROM vista_alertas_vigencia
WHERE Estado_Habilitacion_Alerta IN
    ('01 - VENCIDA', '02 - PRÓXIMA A VENCER (90 días)')
ORDER BY Dias_Para_Vencer ASC;


-- ----------------------------------------------------------------------
-- 3. CONSULTA EJECUTIVA: DISTRIBUCIÓN POR NATURALEZA JURÍDICA
-- ----------------------------------------------------------------------
-- Objetivo:
-- Analizar la composición del sistema según naturaleza jurídica.

SELECT
    Naturaleza_Juridica,
    COUNT(*) AS Total_IPS
FROM vista_analisis_juridico_antiguedad
GROUP BY Naturaleza_Juridica
ORDER BY Total_IPS DESC;


-- ----------------------------------------------------------------------
-- 4. CONSULTA EJECUTIVA: DISTRIBUCIÓN DE IPS POR ESTADO DE HABILITACIÓN
-- ----------------------------------------------------------------------
-- Objetivo:
-- Proveer una métrica ejecutiva de riesgo operativo que muestre
-- la distribución porcentual de IPS según su estado actual.

SELECT 
    CASE 
        WHEN fecha_cierre IS NOT NULL THEN 'Cerrada'
        WHEN fecha_vencimiento < CURDATE() THEN 'Vencida'
        WHEN fecha_vencimiento >= CURDATE() THEN 'Vigente'
        ELSE 'Sin fecha definida'
    END AS Estado_Habilitacion_Alerta,
    COUNT(id) AS Total_IPS_por_Estado,
    ROUND((COUNT(id) * 100.0 / (SELECT COUNT(id) FROM ips_col)), 2) AS Porcentaje_del_Total
FROM 
    ips_col
GROUP BY 
    Estado_Habilitacion_Alerta
ORDER BY 
    Estado_Habilitacion_Alerta ASC;
