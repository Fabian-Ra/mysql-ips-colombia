-- ######################################################################
-- # 1. CONFIGURACIÓN INICIAL DEL ESQUEMA (BASE DE DATOS)
-- ######################################################################

-- Crea el esquema (base de datos) 'ips_colombia' si no existe.
-- Se utiliza la codificación 'utf8mb4' para asegurar el soporte completo de caracteres especiales
-- (tildes, Ñ, etc.) presentes en los datos geográficos de Colombia.
CREATE DATABASE IF NOT EXISTS ips_colombia
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

-- Selecciona el esquema recién creado para que las siguientes consultas
-- (CREATE TABLE, ALTER TABLE) se ejecuten dentro de este contexto.
USE ips_colombia;

-- ######################################################################
-- # 2. CREACIÓN DE LA TABLA PRINCIPAL DE IPS (Prestadores de Salud)
-- ######################################################################

-- Nota: Se asume que la carga inicial de datos (Importación CSV) se realiza después de crear esta estructura.

CREATE TABLE IF NOT EXISTS ips_col (
    -- Clave primaria auto-incremental. Identificador único de cada registro de IPS.
    id INT AUTO_INCREMENT PRIMARY KEY, 
    
    -- Columna clave para uniones geográficas.
    depa_nombre VARCHAR(150),
    muni_nombre VARCHAR(150),
    
    codigo_habilitacion VARCHAR(50),
    nombre_prestador VARCHAR(300),
    
    -- NITs, se manejan como VARCHAR para incluir ceros iniciales si los hay.
    nits_nit VARCHAR(30), 
    razon_social VARCHAR(300),
    
    -- Clasificación del prestador (tipo y nombre)
    clpr_codigo INT, 
    clpr_nombre VARCHAR(100),
    ese VARCHAR(20),
    
    direccion VARCHAR(400),
    telefono VARCHAR(80),
    email VARCHAR(300),
    nivel VARCHAR(20),
    caracter VARCHAR(100),
    habilitado VARCHAR(20),
    
    -- Fechas: Se usa DATE para calcular antigüedad y vigencia.
    fecha_radicacion DATE,
    fecha_vencimiento DATE,
    fecha_cierre DATE,
    
    dv INT,
    
    -- Naturaleza jurídica: Clave para la clasificación Público/Privado.
    clase_persona VARCHAR(80),
    naju_codigo INT,
    naju_nombre VARCHAR(80),
    
    numero_sede_principal INT,
    fecha_corte_REPS DATETIME -- Se usa DATETIME ya que puede incluir hora.
);
