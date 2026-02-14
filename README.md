# 🧠 MySQL IPS Colombia
### ETL Avanzado, Normalización Geográfica y Vistas Analíticas para BI

📊 Proyecto de ingeniería y análisis de datos basado en el **REPS (Registro Especial de Prestadores de Servicios de Salud)** de Colombia, orientado a la preparación de información confiable para **Business Intelligence** y **análisis territorial**.

Este repositorio implementa un **pipeline ETL completo en MySQL**, con foco en:

- limpieza estructural  
- estandarización de claves geográficas  
- control de calidad post-carga  
- construcción de vistas analíticas listas para consumo en **Power BI** u otras herramientas BI  

---

## 🎯 Objetivo del Proyecto

Diseñar una **base de datos relacional robusta** que transforme datos crudos del REPS en **métricas accionables**, permitiendo responder preguntas como:

- ¿Cuál es la cobertura real de IPS por municipio ajustada por población?  
- ¿Qué instituciones presentan alertas de vencimiento regulatorio?  
- ¿Cómo se distribuyen las IPS según su naturaleza jurídica y antigüedad?  
- ¿Dónde existen concentraciones o brechas de cobertura sanitaria?  

---

## 🧩 Alcance Técnico

- ✔️ Implementación de ETL 100% en SQL (MySQL 8+)  
- ✔️ Manejo de datos reales con inconsistencias (fechas, nulos, codificación)  
- ✔️ Normalización avanzada para JOINs geográficos confiables  
- ✔️ Modelado orientado a análisis, no solo almacenamiento  
- ✔️ Vistas diseñadas para reporting operativo y dashboards  

---

## 📂 Estructura de Archivos del Proyecto

A continuación se detalla la organización del repositorio, pensada para mantener un flujo claro y modular del proceso ETL y de análisis de datos.




📁 mysql-ips-colombia/

│

📂 sql/

│   ├──📄 01_create_schema.sql         # Creación del esquema y modelo base.

│   ├──📄 02_load_and_clean_data.sql   # Carga masiva + limpieza y tipado.

│   ├──📄 03_views_analytics.sql       # Vistas analíticas de negocio para consultas y dashboards.

│   └──📄 04_reports_queries.sql       # Consultas finales para reporting o análisis específicos.

│

📂 datos/

│   └── 📊 mi_data_ips.csv              # Dataset REPS utilizado para el análisis.

│

├── 📘 README.md                        # Documentación completa del proyecto.

└── 📜 LICENCIA                         # Licencia MIT para uso abierto.



---

## ⚙️ Tecnologías y Herramientas

- **MySQL 8.0+**  
- **MySQL Workbench / CLI MySQL**  
- **SQL estándar ANSI**  
- **ETL y limpieza de datos**  
- **Modelado de datos relacional**  
- **Optimización de consultas y creación de vistas**

---

## 🔄 Pipeline ETL Implementado

### ⚙️ Configuración del Entorno MySQL 🛠️

Para ejecutar la **carga masiva desde CSV** en tu entorno local, sigue estos pasos:
```sql
-- Habilita la carga de archivos locales
SET GLOBAL local_infile = 1;

-- Verifica configuración y versión del servidor
SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';
SELECT VERSION();
```

> ⚠️ **IMPORTANTE:** Esto es necesario únicamente en **entornos locales**.
> En servidores gestionados (RDS, hosting) puede no estar permitido
> y **no debe incluirse en los scripts ETL**.

---

### ✅ 1. Extracción y Carga Inicial

- Importación masiva desde CSV mediante `LOAD DATA INFILE`  
- Manejo explícito de:
  - valores vacíos  
  - guiones (`--`)  
  - errores de formato  

### ✅ 2. Transformación y Limpieza de Datos

- Conversión robusta de fechas en múltiples formatos  
- Normalización de tipos numéricos y campos nulos  
- Control de calidad post-carga (conteo y validación de campos críticos)  

### ✅ 3. Normalización Geográfica (Paso Crítico)

- Creación de claves de unión estandarizadas:
  - eliminación de tildes  
  - normalización a mayúsculas  
  - corrección de problemas de codificación  

Garantiza **JOINs consistentes** entre IPS y población.

### ✅ 4. Modelado Analítico (Vistas)

- 📌 Cobertura de IPS por 100.000 habitantes  
- 📌 Análisis de naturaleza jurídica y antigüedad institucional  
- 📌 Alertas de vencimiento para priorización de auditorías  

Vistas diseñadas para **consumo directo en Power BI** sin lógica adicional.

---

## 📊 Ejemplos de Métricas Generadas

- Cobertura sanitaria ajustada por población  
- Distribución público vs. privado  
- Antigüedad institucional (años)  
- Estados de habilitación:
  - Vigente  
  - Próxima a vencer (≤ 90 días)  
  - Vencida  

---

## 📈 Resultado del Proyecto

- ✔️ Dataset limpio, tipado y validado  
- ✔️ JOINs geográficos confiables  
- ✔️ Vistas listas para análisis inmediato  
- ✔️ Base escalable para análisis descriptivo o predictivo  
- ✔️ SQL reutilizable y documentado  

---

## 📍 Fuentes de Datos

- **REPS** – Registro Especial de Prestadores de Servicios de Salud  
- **DANE** – Proyecciones oficiales de población por departamento y municipio, utilizadas para el cálculo de métricas de cobertura  

---

## 🧠 Enfoque Profesional

Este proyecto refleja competencias en:

- Ingeniería de datos con SQL  
- ETL aplicado a datos reales  
- Pensamiento analítico orientado a negocio  
- Preparación de datos para Business Intelligence  
- Calidad, trazabilidad y consistencia de la información  

---

## 🧾 Licencia

Licencia **MIT** — uso libre con atribución.

---

## 👤 Autor

**Fabian Ramírez**  
📊 Data Analyst | SQL · Power BI · Python  
📍 Colombia  
🌐 GitHub: **Fabian-Ra**

> _“La calidad del análisis depende de la calidad del proceso que transforma los datos.”_
