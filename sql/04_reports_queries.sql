
-- ######################################################################
-- # 9. CONSULTAS DE ANÁLISIS FINAL (Informes Directos para el Negocio)
-- ######################################################################

-- CONSULTA 9.1: CONTEO DE IPS POR ESTADO DE ALERTA (Métrica Principal de Riesgo)
SELECT 
    Estado_Habilitacion_Alerta,
    COUNT(id) AS Total_IPS_por_Estado,
    -- Calcula el porcentaje sobre el total de IPS de la tabla
    (COUNT(id) * 100.0 / (SELECT COUNT(id) FROM ips_col)) AS Porcentaje_del_Total 
FROM 
    vista_alertas_vigencia
GROUP BY 
    Estado_Habilitacion_Alerta
ORDER BY 
    Estado_Habilitacion_Alerta ASC;

-- CONSULTA 9.2: REPORTE OPERACIONAL DE IPS PRÓXIMAS A VENCER (90 DÍAS)
-- Este es el informe de prioridad para el equipo de auditoría.
SELECT 
    nombre_prestador,
    depa_nombre,
    muni_nombre,
    fecha_vencimiento,
    Dias_Para_Vencer
FROM 
    vista_alertas_vigencia
WHERE 
    Estado_Habilitacion_Alerta = '02 - PRÓXIMA A VENCER (90 días)'
ORDER BY 
    Dias_Para_Vencer ASC;
    
-- VALIDACIÓN: Muestra una vista general de las alertas
SELECT * FROM vista_alertas_vigencia LIMIT 10;
