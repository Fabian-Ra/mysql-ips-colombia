
-- ######################################################################
-- # 6. VISTAS ANALÍTICAS (MÉTRICAS DE NEGOCIO PARA POWER BI)
-- ######################################################################

-- 6.1. VISTA: Densidad de Cobertura de IPS por 100K Habitantes

CREATE OR REPLACE VIEW vista_cobertura_ips AS
SELECT
    T1.depa_nombre AS Departamento, -- Nombre original con tildes (para la presentación)
    T1.muni_nombre AS Municipio,
    COUNT(T1.id) AS Total_IPS,
    T2.Poblacion,
    -- Métrica de alto valor: Calcula la cobertura por cada 100,000 habitantes.
    (COUNT(T1.id) * 100000.0 / T2.Poblacion) AS Cobertura_por_100k
FROM
    ips_col T1
JOIN
    tabla_poblacion T2
    -- JOIN exitoso gracias a las claves estandarizadas y limpias.
    ON T1.clave_ips_final = T2.clave_pob_final 
GROUP BY 
    T1.depa_nombre, T1.muni_nombre, T2.Poblacion
ORDER BY
    Cobertura_por_100k DESC;

-- Validación: Muestra un ejemplo de los municipios con mayor cobertura
SELECT * FROM vista_cobertura_ips LIMIT 10;



-- ######################################################################
-- # 7. VISTAS ANALÍTICAS (MÉTRICAS DE NEGOCIO PARA POWER BI)
-- ######################################################################

-- 7.1. VISTA: Análisis de Naturaleza Jurídica y Antigüedad

CREATE OR REPLACE VIEW vista_analisis_juridico_antiguedad AS
SELECT
    muni_nombre,
    depa_nombre,
    -- Columna clave para clasificar Público vs. Privado
    naju_nombre AS Naturaleza_Juridica, 
    -- Calcula la diferencia de días entre la fecha actual y la fecha de radicación
    DATEDIFF(CURDATE(), fecha_radicacion) AS Antiguedad_Dias, 
    -- Convierte la antigüedad a años (más útil para visualizaciones)
    ROUND(DATEDIFF(CURDATE(), fecha_radicacion) / 365.25, 1) AS Antiguedad_Anios,
    COUNT(id) AS Total_IPS_Tipo
FROM 
    ips_col
-- Agrupa por la naturaleza jurídica y fecha para contar las IPS de cada tipo y antigüedad
GROUP BY 
    muni_nombre, depa_nombre, naju_nombre, fecha_radicacion
ORDER BY
    Antiguedad_Anios DESC;

-- Validación: Muestra un ejemplo de las instituciones más antiguas.
SELECT * FROM vista_analisis_juridico_antiguedad LIMIT 10;



-- ######################################################################
-- # 8. VISTA: Alertas de Vigencia y Priorización de Auditoría
-- ######################################################################

CREATE OR REPLACE VIEW vista_alertas_vigencia AS
SELECT
    id,
    nombre_prestador,
    depa_nombre,
    muni_nombre,
    fecha_vencimiento,
    -- Calcula los días restantes (positivo) o días pasados (negativo) para el vencimiento
    DATEDIFF(fecha_vencimiento, CURDATE()) AS Dias_Para_Vencer,
    -- Clasifica la habilitación: Vencida, Próxima a vencer (90 días), o Vigente
    CASE
        WHEN DATEDIFF(fecha_vencimiento, CURDATE()) < 0 THEN '01 - VENCIDA'
        WHEN DATEDIFF(fecha_vencimiento, CURDATE()) <= 90 THEN '02 - PRÓXIMA A VENCER (90 días)'
        ELSE '03 - Vigente'
    END AS Estado_Habilitacion_Alerta
FROM 
    ips_col
ORDER BY 
    Dias_Para_Vencer ASC;
