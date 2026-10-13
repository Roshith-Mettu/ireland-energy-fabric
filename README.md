# Ireland Energy Analytics | Microsoft Fabric End-to-End Project

## Project Overview
An end-to-end data engineering and business intelligence project analyzing Ireland's primary energy supply using Microsoft Fabric, SQL, PySpark, Dataflow Gen2, and Power BI.

The solution implements a Bronze–Silver–Gold data architecture, automated ETL orchestration, data quality validation, and interactive energy reporting.

## Technology Stack
- Microsoft Fabric
- OneLake and Lakehouse
- Dataflow Gen2 / Power Query
- PySpark and Fabric Notebooks
- Delta Lake
- SQL
- Power BI and DAX
- Fabric Data Pipelines
- GitHub

## Data Source
SEAI National Energy Balance data, with a primary energy supply analysis for 2024. The project also includes Bronze ingestion folders for SEAI and EPA data.

## Data Architecture
Source Data
    |
    v
Bronze Layer - Raw Data in Fabric Lakehouse
    |
    v
Silver Layer - Dataflow Gen2 Cleaning and Transformation
    |
    v
Gold Layer - PySpark Aggregation and Analytical Tables
    |
    v
Semantic Model - Power BI DAX Measures
    |
    v
Power BI - Ireland Energy Analytics Dashboard

## Data Pipeline
Pipeline: `pl_ireland_energy_etl`

1. `Run_SEAI_Silver` executes the Dataflow Gen2 transformation `df_seai_silver`.
2. On successful completion, `Run_Gold_Energy` executes the Fabric notebook `nb_gold_energy`.
3. The pipeline was validated and executed successfully, with both activities reporting Succeeded.

Execution evidence is available in the `pipelines/` and `screenshots/` folders.

## Data Quality
SQL validation includes:
- Total records and energy reconciliation
- Duplicate detection
- Data quality checks on transformed tables

See `sql/energy_validation.sql` and the other SQL scripts.

## Power BI Dashboard
The Ireland Energy Analytics Dashboard provides:
- Total Primary Energy Supply
- Total Fuel Types
- Top Fuel Type
- Renewable Energy Share
- Primary Energy Supply by Fuel Type
- Year filtering

### Dashboard Preview

![Ireland Energy Analytics Dashboard](screenshots/powerbi_dashboard.png)



### 2024 Dashboard Results
- Total primary energy supply: 24,186.71 ktoe
- Fuel types displayed in the KPI: 40
- Top fuel type: Oil
- Renewable energy share: 8.64%

The renewable share measure uses the Renewables fuel category divided by total primary energy supply.

The report file is available at:
`powerbi/Ireland Energy Analytics Dashboard.pbix`

## Repository Structure
```text
ireland-energy-fabric/
├── dax/
├── docs/
├── notebooks/
├── pipelines/
├── powerbi/
├── sample_data/
├── screenshots/
├── sql/
└── README.md
```

## Project Deliverables
- Fabric Lakehouse with Bronze, Silver, and Gold data processing
- Dataflow Gen2 transformations
- PySpark notebook processing
- SQL validation scripts
- DAX measures
- Power BI report
- Successfully executed Fabric ETL pipeline
- GitHub project documentation and execution evidence

## Future Improvements
- Configure and test scheduled pipeline execution
- Add automated quality alerts
- Expand year-over-year reporting
- Add additional EPA emissions analysis

## Author
Roshith Mettu

Data Analytics | Microsoft Fabric | SQL | Power BI | PySpark

