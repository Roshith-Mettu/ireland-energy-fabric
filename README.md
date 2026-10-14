# Ireland Energy Analytics | Microsoft Fabric End-to-End Project

## Project Overview

An end-to-end data engineering and business intelligence portfolio project analysing Ireland's 2024 primary energy supply data using Microsoft Fabric, Dataflow Gen2, PySpark, SQL, Delta Lake and Power BI.

The solution demonstrates Bronze–Silver–Gold architecture, orchestrated data transformations, SQL-based data quality validation and interactive energy reporting.

**Project status:** Core SEAI energy analytics workflow completed and validated for 2024.

## Technology Stack

- Microsoft Fabric and OneLake
- Fabric Lakehouse and Delta Lake
- Dataflow Gen2 and Power Query
- PySpark and Fabric Notebooks
- Fabric Data Pipelines
- SQL and Spark SQL
- Power BI and DAX
- GitHub

## Data Source

**Organisation:** Sustainable Energy Authority of Ireland (SEAI)

**Dataset:** National Energy Balance

**Reporting year:** 2024

**Analytical classification:** Primary Energy Supply (incl non-energy)

**Unit:** ktoe (kilotonnes of oil equivalent)

The Fabric environment also contains Bronze ingestion folders for SEAI and EPA data. However, the demonstrated analytical pipeline and dashboard use SEAI data only.

EPA emissions analysis is outside the completed project scope.

## Data Architecture

```text
SEAI National Energy Balance
           |
           v
Bronze Layer
Raw source data in Fabric Lakehouse
           |
           v
Silver Layer
Dataflow Gen2: df_seai_silver
Table: dbo.seai_energy_balance_silver
           |
           v
Gold Layer
PySpark Notebook: nb_gold_energy
Table: dbo.gold_primary_energy_supply
           |
           v
Power BI Semantic Model
DAX Measures
           |
           v
Ireland Energy Analytics Dashboard
```

### Bronze Layer

Stores the raw source data used by the Fabric transformation workflow.

### Silver Layer

The Dataflow Gen2 transformation prepares structured energy balance data by applying column transformations, type conversions, unpivoting and filtering.

The resulting table is `dbo.seai_energy_balance_silver`.

### Gold Layer

The PySpark notebook filters the Silver table to Primary Energy Supply (including non-energy use), groups records by year and fuel type, and calculates aggregated energy values.

The resulting Delta table is `dbo.gold_primary_energy_supply`.

## Data Pipeline

**Pipeline:** `pl_ireland_energy_etl`

The pipeline runs two activities sequentially:

1. `Run_SEAI_Silver` — Executes Dataflow Gen2 `df_seai_silver`.
2. `Run_Gold_Energy` — Executes the PySpark notebook `nb_gold_energy` after successful Silver processing.

Both activities completed successfully in the recorded pipeline execution.

Execution evidence is included in the `pipelines/` and `screenshots/` folders.

## Data Quality Validation

The project includes SQL validation of the Silver and Gold analytical datasets.

Checks include:

- Total record counts and distinct fuel types.
- Missing or blank values.
- Duplicate business keys.
- Unexpected reporting years.
- Negative energy value inspection.
- Silver-to-Gold energy reconciliation.
- Renewable category share calculation.

### Verified Gold Layer Results — 2024

| Validation | Result |
|---|---:|
| Gold records | 40 |
| Distinct fuel types | 40 |
| Missing fuel types | 0 |
| Missing energy values | 0 |
| Duplicate year/fuel combinations | 0 |
| Unexpected reporting year records | 0 |
| Negative energy values | 4 |
| Filtered Silver total | 24,186.71 ktoe |
| Gold aggregated total | 24,186.71 ktoe |
| Reconciliation difference | 0.00 ktoe |
| Renewables category | 2,089.95 ktoe |
| Renewable category share | 8.64% |

The Silver and Gold totals reconcile for the selected energy balance classification.

Four negative values were retained for source-level interpretation rather than automatically removed.

The validation demonstrates consistency of the tested transformations; it does not independently verify every source value.

## Power BI Dashboard

The Ireland Energy Analytics Dashboard provides:

- Total aggregated energy in ktoe.
- Distinct fuel-type count.
- Largest fuel category.
- Renewable category share.
- Energy values by fuel type.
- Reporting year filtering.

### Dashboard Preview

![Ireland Energy Analytics Dashboard](screenshots/powerbi_dashboard.png.png)

### Dashboard Results — 2024

| KPI | Value |
|---|---:|
| Total aggregated energy | 24,186.71 ktoe |
| Fuel types | 40 |
| Largest fuel category | Oil |
| Renewable category share | 8.64% |

The renewable percentage is calculated using the Renewables category divided by the total of the selected aggregated Gold records.

Because some fuel categories may overlap or represent broader classifications, these totals and percentages should not automatically be interpreted as official national energy mix statistics.

**Power BI report:** `powerbi/Ireland Energy Analytics Dashboard.pbix`

## Repository Structure

```text
ireland-energy-fabric/
├── dax/
│   └── energy_measures.dax
├── docs/
│   ├── requirements.md
│   ├── silver_layer.md
│   └── gold_layer.md
├── notebooks/
│   └── nb_gold_energy.ipynb
├── pipelines/
├── powerbi/
│   └── Ireland Energy Analytics Dashboard.pbix
├── sample_data/
├── screenshots/
├── sql/
│   ├── 01_silver_quality_checks.sql
│   └── energy_validation.sql
└── README.md
```

Additional folder-level README files provide supporting documentation.

## Reproducing the Project

The repository provides implementation code, documentation, validation queries and execution evidence.

To reproduce the workflow:

1. Create a Microsoft Fabric workspace and Lakehouse.
2. Obtain the relevant SEAI National Energy Balance source file.
3. Configure the source ingestion and Dataflow Gen2 transformations described in the documentation.
4. Create the Silver Delta table.
5. Import or recreate the Gold PySpark notebook and attach the correct Lakehouse.
6. Execute the notebook to generate the Gold Delta table.
7. Run the SQL validation scripts.
8. Configure the Fabric pipeline with the Silver Dataflow and Gold notebook activities.
9. Open the Power BI report and configure its data connection to the recreated Gold table.
10. Validate the report measures against the SQL outputs.

**Reproducibility limitation:** The repository does not yet provide a fully automated deployment package or all source-ingestion configuration details. Some Fabric resources must be recreated or configured manually.

## Evidence

The `screenshots/` folder contains supporting evidence for:

![Gold Layer Validation](screenshots/gold_layer_validation%201%20.png.png)

![Gold Layer Validation](screenshots/gold_layer_validation%202%20.png.png)

![Gold Layer Validation](screenshots/gold_layer_validation%203%20.png.png)

![Gold Lakehouse Table](screenshots/gold_lakehouse_table.png.png)

![Successful Pipeline Execution](screenshots/pipeline_execution_success.png.png)

![Power BI Dashboard](screenshots/powerbi_dashboard.png.png)

## Known Limitations

- The demonstrated analysis covers 2024 only.
- Fuel classifications may overlap or contain subtotals.
- Four negative energy values require source-level interpretation.
- Scheduled pipeline execution has not been verified.
- Incremental ingestion and source-release history preservation have not been demonstrated.
- The GitHub DAX file documents report measures but does not automatically update the Power BI report.
- EPA emissions integration, scenario modelling and Row-Level Security are outside the demonstrated scope.

## Future Improvements

- Add multi-year energy analysis.
- Integrate EPA greenhouse gas emissions datasets.
- Implement scheduled refresh and data quality alerts.
- Add source-release tracking and incremental ingestion.
- Introduce automated deployment and testing.
- Extend reporting with sector analysis and scenario modelling.

## Project Outcome

This project demonstrates an operational Microsoft Fabric analytics workflow using Dataflow Gen2, PySpark, Delta tables, SQL validation, pipeline orchestration and Power BI.

The 2024 Gold dataset contains 40 aggregated records. Silver and Gold totals reconcile, and the tested completeness and uniqueness checks passed.

The repository documents the implemented workflow, validation evidence and known limitations.

## Author

Roshith Mettu

Data Analytics | Microsoft Fabric | SQL | Power BI | PySpark
