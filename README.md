# 🧠 MySQL IPS Colombia — ETL Pipeline & Data Analysis

### 📊 Proyecto de análisis y modelado de datos REPS (Registro Especial de Prestadores de Servicios de Salud) en Colombia.

Este proyecto implementa un **pipeline ETL (Extract, Transform, Load)** completo en **MySQL**, diseñado para procesar, limpiar y estructurar la información de **IPS (Instituciones Prestadoras de Servicios de Salud)** registrada en el **REPS** del Ministerio de Salud de Colombia.  

El objetivo es transformar los datos crudos en **vistas analíticas listas para dashboards** y exploración de datos en herramientas como **Power BI, Tableau o Python**.

---

## 🚀 Objetivos del Proyecto

- Automatizar la **carga y limpieza** de datos del REPS en MySQL.  
- Estandarizar columnas, tipos de datos y valores inconsistentes.  
- Implementar un flujo ETL modular con consultas SQL claras y comentadas.  
- Generar **vistas analíticas optimizadas** para visualización y reporting.  
- Proveer una base sólida para análisis geográficos y estadísticos de las IPS en Colombia.

---

## 🧩 Estructura del Repositorio

mysql-ips-colombia/
│
├── 📂 sql_scripts/
│ ├── etl_pipeline.sql # Flujo ETL completo: carga, transformación y carga final.
│ ├── data_cleaning.sql # Limpieza de datos: normalización, eliminación de duplicados y validaciones.
│ ├── analysis_views.sql # Creación de vistas analíticas finales para dashboards.
│
├── 📄 README.md # Documentación completa del proyecto.
└── 📄 LICENSE # Licencia MIT para uso abierto.


---

## ⚙️ Tecnologías y Herramientas

- **MySQL 8.0+**
- **Workbench**
- **SQL estándar ANSI**
- **ETL y Data Cleaning**
- **Modelado de datos**
- **Creación de vistas analíticas**
- **Optimización de consultas**

---

## 🧰 Funcionalidades Principales

✅ **Carga inicial (Extract):**
- Importa el dataset REPS (.csv o .xlsx) a tablas temporales.  
- Verifica integridad de columnas y formatos.

✅ **Transformación (Transform):**
- Limpieza de datos: eliminación de duplicados, nulos, y errores de codificación.  
- Homogeneización de nombres de municipios y departamentos.  
- Conversión de tipos de datos y normalización de valores.  

✅ **Carga final (Load):**
- Inserción en tablas definitivas optimizadas.  
- Creación de vistas analíticas agregadas:  
  - IPS por departamento y tipo.  
  - Tendencias de habilitación.  
  - Cobertura nacional por servicio.

✅ **Consultas analíticas listas para dashboards.**

---

## 🧪 Ejemplo de Consulta

```sql
-- Cantidad de IPS por departamento y tipo
SELECT 
    departamento,
    tipo_entidad,
    COUNT(*) AS total_ips
FROM 
    vista_ips_analitica
GROUP BY 
    departamento, tipo_entidad
ORDER BY 
    total_ips DESC;

📈 Resultados Esperados

Dataset limpio y estructurado en base MySQL.

Vistas analíticas para visualización inmediata.

Flujo ETL reproducible, escalable y fácil de mantener.

Base sólida para analítica descriptiva o predictiva.

🧠 Aprendizajes y Enfoque Técnico

Este proyecto demuestra competencias en:

Modelado de datos relacional.

Diseño y optimización de consultas SQL.

Procesos ETL aplicados a entornos reales.

Pensamiento analítico orientado a la calidad de datos.

Preparación de información para Business Intelligence.

📍 Contexto en Colombia

El análisis de las IPS registradas en el REPS es fundamental para entender la distribución, capacidad y cobertura de los servicios de salud.
Este proyecto permite transformar datos oficiales del Ministerio de Salud en información accesible y visualizable, útil para análisis públicos, institucionales o de investigación.

🧾 Licencia

Este proyecto está bajo la Licencia MIT, lo que permite su uso, copia, modificación y distribución con atribución correspondiente.

👤 Autor

Fabian Ramirez
💼 Data Analyst | SQL & Python Developer
📍 Colombia
🌐 GitHub: Fabian-Ra


💡 “La calidad del análisis depende de la calidad de los datos, y la calidad de los datos depende del proceso que los transforma.”


