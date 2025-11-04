# 🧠 MySQL IPS Colombia — ETL Pipeline & Data Analysis

📊 Proyecto de modelado y análisis de datos del REPS (Registro Especial de Prestadores de Servicios de Salud) en Colombia.

Este proyecto implementa un pipeline **ETL (Extracto, Transformación, Carga)** completo en **MySQL**, para diseñar, estructurar y transformar la información de las **IPS (Instituciones Prestadoras de Servicios de Salud)** registradas en el **REPS del Ministerio de Salud de Colombia**.

El objetivo es generar **vistas listas para análisis y exploración de datos** en herramientas como **Power BI, Tableau o Python**.

---

## 🚀 Objetivos del Proyecto

- Automatizar la carga y limpieza de datos del REPS en MySQL.  
- Estandarizar columnas, tipos de datos e información inconsistente.  
- Implementar un flujo ETL modular, documentado y optimizado.  
- Crear vistas finales preparadas para visualización y reporting.  
- Proveer una base sólida para análisis geográficos y estadísticos.  

---

🧩 **Estructura del Repositorio**


📁 mysql-ips-colombia/

│

📂 sql/

│   ├──📄 01_create_schema.sql         # Creación del esquema, tablas y base.

│   ├──📄 02_load_and_clean_data.sql   # Carga y limpieza de datos (normalización y validaciones).

│   ├──📄 03_views_analytics.sql       # Vistas analíticas para consultas y dashboards.

│   └──📄 04_reports_queries.sql       # Consultas finales para reportes o análisis específicos.

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

## 🧰 Funcionalidades Principales

### ✅ 1. Extracción (Extracto)
- Importa el dataset REPS (.csv o .xlsx) a tablas temporales.  
- Verifica integridad de columnas y formatos.  

### ✅ 2. Transformación (Transformación)
- Limpieza de datos: eliminación de duplicados, nulos y errores.  
- Homogeneización de nombres de municipios y departamentos.  
- Conversión y normalización de tipos de datos.  

### ✅ 3. Carga Final (Carga)
- Inserción en tablas optimizadas.  
- Creación de vistas:
  - IPS por tipo y departamento.  
  - Tendencias de habilitación.  
  - Cobertura nacional por servicio.  

### ✅ 4. Consultas Analíticas
- Preparadas para dashboards en herramientas BI.  

---

### 🧪 Ejemplo de Consulta

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
```


---
## 📈 Resultados Esperados

Dataset limpio y estructurado en base MySQL.

Vistas analíticas listas para visualización inmediata.

Flujo ETL reproducible, escalable y mantenible.

Base sólida para analítica descriptiva o predictiva.



## 🧠 Aprendizajes y Enfoque Técnico

Este proyecto demuestra competencias en:

Modelado de datos relacional.

Diseño y optimización de consultas SQL.

Procesos ETL aplicados a entornos reales.

Pensamiento analítico orientado a la calidad de datos.

Preparación de información para Business Intelligence.



## 📍 Contexto en Colombia

El análisis de las IPS registradas en el REPS es fundamental para entender la distribución, capacidad y cobertura de los servicios de salud.
Este proyecto transforma datos oficiales del Ministerio de Salud en información accesible y visualizable, útil para análisis públicos, institucionales o de investigación.

---
🧾 Licencia
---
Este proyecto está bajo la Licencia MIT, lo que permite su uso, copia, modificación y distribución con atribución correspondiente.

---
👤 Autor
---
Fabian Ramirez

💼 Data Analyst | SQL & Python Developer

📍 Colombia

🌐 GitHub: Fabian-Ra



 💡 “La calidad del análisis depende de la calidad de los datos,
 y la calidad de los datos depende del proceso que los transforma.”
