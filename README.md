# 🧠 MySQL IPS Colombia
### ETL Avanzado, Normalización Geográfica y Vistas Analíticas para BI

📊 Proyecto de ingeniería y análisis de datos basado en el **REPS (Registro Especial de Prestadores de Servicios de Salud)** de Colombia, orientado a la preparación de información confiable para **Business Intelligence** y **análisis territorial**.

Este repositorio implementa un **pipeline ETL completo en MySQL**, diseñado para transformar datos públicos crudos en un **modelo analítico estructurado**, listo para consumo en **herramientas BI**.

- limpieza y tipado robusto de datos reales  
- estandarización de claves geográficas  
- control de calidad post-carga
- modelado analítico mediante vistas reutilizables  
- consultas ejecutivas orientadas a toma de decisiones
---

## 🎯 Objetivo del Proyecto

Diseñar e implementar una **base de datos relacional reproducible** que transforme datos crudos del REPS en **métricas accionables**, permitiendo responder preguntas estratégicas como:

- ¿Cuál es la cobertura real de IPS por municipio ajustada por población?  
- ¿Qué instituciones presentan alertas regulatorias por vencimiento?  
- ¿Cómo se distribuyen las IPS según naturaleza jurídica y antigüedad?
- ¿Dónde existen posibles brechas territoriales en infraestructura sanitaria?  

---

## 🧩 Alcance Técnico

- ✔️ Pipeline ETL implementado 100% en SQL (MySQL 8+)  
- ✔️ Carga masiva con `LOAD DATA INFILE`  
- ✔️ Manejo de inconsistencias reales (nulos, formatos de fecha, codificación)  
- ✔️ Normalización geográfica para JOINs confiables  
- ✔️ Separación clara por capas: DDL → ETL → Vistas → Consultas  
- ✔️ Diseño preparado para integración con Power BI  

---

## 📂 Estructura de Archivos del Proyecto

A continuación se detalla la organización del repositorio, pensada para mantener un flujo claro y modular del proceso ETL y de análisis de datos.




📁 mysql-ips-colombia/

│

📂 sql/

│   ├──📄 01_create_schema.sql          >**Creación del esquema y modelo relacional base.**

│   ├──📄 02_load_and_clean_data.sql    >**ETL: carga masiva, limpieza y tipado.**

│   ├──📄 03_views_analytics.sql        >**Vistas analíticas de negocio para consultas y dashboards.**

│   └──📄 04_reports_queries.sql        >**Consultas finales para reporting o análisis específicos.**

│

📂 datos/

│   └── 📊 mi_data_ips.csv              >**Dataset REPS: registro de IPS (prestadores de salud).**

│   └── 📊 poblacion_dane_final.csv     >**Dataset DANE: Población oficial por departamento y municipio, para métricas de cobertura sanitaria.**

|

├── 📘 README.md                        >**Documentación completa del proyecto.**

└── 📜 LICENCIA                         >**Licencia MIT para uso abierto.**



---

## ⚙️ Tecnologías y Herramientas

- **MySQL 8.0+**
- **MySQL Workbench / MySQL CLI**
- **SQL ANSI**
- Modelado relacional
- ETL y limpieza de datos
- Diseño de capa semántica para BI

---

## 🔄 Pipeline ETL Implementado

### ⚙️ Configuración del Entorno MySQL 🛠️

Para ejecutar la **carga masiva desde CSV** en entorno local:
```sql
SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';
SELECT VERSION();
```

> ⚠️ **IMPORTANTE:** Esto es necesario únicamente en **entornos locales**.
> En servidores gestionados (RDS, hosting) puede no estar permitido
> y **no debe incluirse en los scripts ETL**.

---

### ✅ 1. Extracción y Carga

- Importación masiva mediante `LOAD DATA INFILE`  
- Manejo explícito de:
  - valores vacíos  
  - guiones (`--`)  
  - campos opcionales
- Uso de variables intermedias (@campo) para limpieza controlada

### ✅ 2. Transformación y Limpieza

- Conversión robusta de fechas en múltiples formatos  
- Normalización de tipos numéricos y campos nulos  
- Control de calidad post-carga (conteo y validación de campos críticos)  

### ✅ 3. Normalización Geográfica (Componente Crítico)

- Creación de claves de unión estandarizadas:
  - eliminación de tildes
  - normalización a mayúsculas
  - reemplazo de espacios  
- Garantiza JOIN consistente entre:
  - tabla de IPS
  - tabla de población (DANE)
Este paso asegura **integridad analítica** en **métricas territoriales**.

### ✅ 4.Capa Semántica (Vistas Analíticas)
*Se diseñaron vistas reutilizables para consumo directo en BI:*

- 📌 Cobertura de IPS por 100.000 habitantes  
- 📌 Análisis de naturaleza jurídica y antigüedad institucional  
- 📌 Alertas operativas de vencimiento regulatorio

*Separación clara entre:*
- Definición de vistas (capa analítica)
- Consultas ejecutivas (capa de consumo)

---

## 📊 Ejemplos de Métricas Generadas

- Cobertura sanitaria ajustada por población
- Densidad de IPS por municipio  
- Distribución público vs. privado  
- Antigüedad institucional (años)  
- Clasificación de riesgo regulatorio:
  - Vigente  
  - Próxima a vencer (≤ 90 días)  
  - Vencida  

---

## 📈 Resultado del Proyecto

- ✔️ Base de datos reproducible y documentada
- ✔️ Dataset limpio, tipado y validado  
- ✔️ JOINs geográficos consistentes  
- ✔️ Métricas normalizadas listas para visualización
- ✔️ Base escalable para análisis descriptivo o predictivo  

---

## 📍 Fuentes de Datos

- **REPS** – Registro Especial de Prestadores de Servicios de Salud  
- **DANE** – Proyecciones oficiales de población por departamento y municipio

---

## 🧠 Enfoque Profesional

Este proyecto refleja competencias en:

- Ingeniería de datos con SQL  
- Diseño de pipelines ETL reproducibles
- Control de calidad y validación de datos  
- Modelado relacional orientado a análisis 
- Preparación de datos para Business Intelligence
- Pensamiento analítico aplicado a datos públicos  
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
