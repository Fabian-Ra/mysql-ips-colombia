-- ======================================================================
-- Proyecto: mysql-ips-colombia
-- Archivo: 01_create_schema.sql
-- Capa: DDL (Definición del esquema)
-- Descripción: Creación de la base de datos y de la tabla principal
--              para el registro de IPS en Colombia.
-- Orden de ejecución: 1 de 4
-- ======================================================================

-- ----------------------------------------------------------------------
-- 1. REINICIO Y CREACIÓN DE LA BASE DE DATOS
-- ----------------------------------------------------------------------

-- Se elimina la base de datos si existe para garantizar una ejecución
-- completamente reproducible del proyecto desde cero.
DROP DATABASE IF EXISTS ips_colombia;

-- Creación de la base de datos con codificación utf8mb4 para asegurar
-- soporte completo de caracteres especiales (tildes, ñ, etc.).
CREATE DATABASE ips_colombia
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

-- Selección del esquema de trabajo.
USE ips_colombia;

-- ----------------------------------------------------------------------
-- 2. TABLA PRINCIPAL: REGISTRO DE IPS
-- ----------------------------------------------------------------------

CREATE TABLE ips_col (
    
    -- Clave primaria auto-incremental.
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Información geográfica.
    depa_nombre VARCHAR(150),
    muni_nombre VARCHAR(150),
    
    -- Identificación del prestador.
    codigo_habilitacion VARCHAR(50),
    nombre_prestador VARCHAR(300),
    nits_nit VARCHAR(30),      -- Se maneja como VARCHAR para conservar ceros iniciales.
    razon_social VARCHAR(300),
    
    -- Clasificación del prestador.
    clpr_codigo INT,
    clpr_nombre VARCHAR(100),
    ese VARCHAR(20),
    
    -- Información de contacto.
    direccion VARCHAR(400),
    telefono VARCHAR(80),
    email VARCHAR(300),
    
    -- Características operativas.
    nivel VARCHAR(20),
    caracter VARCHAR(100),
    habilitado VARCHAR(20),
    
    -- Fechas relevantes del registro.
    fecha_radicacion DATE,
    fecha_vencimiento DATE,
    fecha_cierre DATE,
    
    dv INT,
    
    -- Naturaleza jurídica.
    clase_persona VARCHAR(80),
    naju_codigo INT,
    naju_nombre VARCHAR(80),
    
    numero_sede_principal INT,
    
    -- Fecha de corte del registro REPS.
    fecha_corte_REPS DATETIME
);

