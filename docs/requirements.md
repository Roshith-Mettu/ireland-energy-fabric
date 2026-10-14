# Ireland Energy Analytics | Microsoft Fabric

## Business Requirements Document

### 1. Project Overview

This project demonstrates an end-to-end data engineering and business intelligence solution for analysing Ireland's energy supply using publicly available Sustainable Energy Authority of Ireland (SEAI) data.

The solution uses Microsoft Fabric, OneLake, Dataflow Gen2, PySpark, Delta Lake, SQL and Power BI to transform source energy data into a reporting-ready analytical dataset.

**Project status:** Core SEAI energy analytics workflow implemented and validated for the 2024 reporting year.

### 2. Business Objectives

- Build a repeatable data transformation workflow using Microsoft Fabric.
- Organise energy data using Bronze, Silver and Gold architecture.
- Transform and aggregate energy supply data by year and fuel type.
- Validate completeness, uniqueness and energy totals.
- Create an interactive Power BI dashboard for energy mix analysis.
- Document processing steps and validation results in GitHub.

### 3. Data Source

**Source organisation:** Sustainable Energy Authority of Ireland (SEAI)

**Dataset:** National Energy Balance

**Reporting period demonstrated:** 2024

**Analytical focus:** Primary Energy Supply, including non-energy use.

**Reporting unit:** ktoe (kilotonnes of oil equivalent)

The exact source release, download URL and licensing information should be recorded in the source documentation.

### 4. Data Architecture

**Bronze Layer — Raw Data**

- Stores source files in the Microsoft Fabric Lakehouse.
- Provides the starting point for the data transformation workflow.

**Silver Layer — Cleaned Data**

- Uses Microsoft Fabric Dataflow Gen2.
- Produces the `seai_energy_balance_silver` table.
- Supports SQL-based data quality checks.

**Gold Layer — Analytical Data**

- Uses a PySpark notebook.
- Filters records to Primary Energy Supply, including non-energy use.
- Groups data by year and fuel type.
- Aggregates energy values in ktoe.
- Stores the result in the Delta table `gold_primary_energy_supply`.

### 5. Pipeline Orchestration

**Pipeline:** `pl_ireland_energy_etl`

The pipeline runs two activities in sequence:

1. `Run_SEAI_Silver` — Executes the Silver Dataflow Gen2 transformation.
2. `Run_Gold_Energy` — Executes the Gold PySpark notebook after successful Silver processing.

A successful execution of both activities has been verified and documented.

### 6. Reporting Requirements

The Power BI dashboard supports:

- Total Primary Energy Supply in ktoe.
- Fuel-type analysis.
- Identification of the largest fuel category.
- Renewable energy share.
- Year filtering.

The demonstrated dashboard uses 2024 energy data.

### 7. Data Quality Requirements

The analytical dataset should be checked for:

- Missing fuel-type values.
- Missing energy values.
- Duplicate year and fuel-type combinations.
- Negative energy values.
- Differences between Silver and Gold totals.
- Correct renewable energy share calculations.

**Validated results for 2024:**

| Metric | Result |
|---|---|
| Gold records | 40 |
| Distinct fuel types | 40 |
| Missing fuel types | 0 |
| Missing energy values | 0 |
| Duplicate year/fuel combinations | 0 |
| Negative energy values | 4 |
| Silver energy total | 24,186.71 ktoe |
| Gold energy total | 24,186.71 ktoe |
| Renewable energy share | 8.64% |

The four negative values are retained and documented for source-level interpretation rather than automatically removed.

### 8. Acceptance Criteria

The implemented workflow is considered technically validated when:

1. The Silver transformation executes successfully.
2. The Gold notebook executes after successful Silver processing.
3. The Gold Delta table is created and can be queried.
4. No missing fuel types or energy values are found in the tested dataset.
5. No duplicate year and fuel-type combinations are found.
6. Silver and Gold totals reconcile.
7. The renewable energy share matches the SQL validation.
8. The Power BI dashboard displays the analytical results.
9. Pipeline and validation evidence are documented in GitHub.

These checks have supporting evidence from the completed 2024 workflow.

### 9. Known Limitations

- The demonstrated analysis covers 2024.
- Negative energy values require source-level interpretation.
- The current reporting scope is Primary Energy Supply, not Final Energy Consumption.
- Automated scheduling and incremental ingestion have not been verified.
- Repeated-file ingestion, source-release versioning and historical preservation have not been verified.
- The project does not currently demonstrate EPA emissions integration, scenario modelling or Row-Level Security.

### 10. Future Enhancements

Potential future improvements include:

- Integrating EPA greenhouse gas emissions datasets.
- Adding multiple reporting years and trend analysis.
- Introducing scheduled ingestion and refresh.
- Implementing source-release tracking and incremental processing.
- Adding sector-level reporting.
- Implementing scenario modelling.
- Demonstrating Power BI Row-Level Security.
- Adding automated blocking data quality rules.

These are future enhancements, not completed project features.
