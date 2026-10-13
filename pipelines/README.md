
# Microsoft Fabric ETL Pipeline

## Project Overview
This pipeline orchestrates the transformation of Ireland's energy data using Microsoft Fabric Dataflow Gen2 and PySpark notebooks.

## Pipeline Name
`pl_ireland_energy_etl`

## Pipeline Workflow
1. `Run_SEAI_Silver` — Executes Dataflow Gen2 `df_seai_silver` to prepare Silver-layer energy data.
2. `Run_Gold_Energy` — Executes PySpark notebook `nb_gold_energy` after the Silver activity succeeds, preparing Gold-layer data for reporting.

## Execution Results
- Date: 13 October 2026
- Silver Dataflow: Succeeded (1m 36s)
- Gold Notebook: Succeeded (56s)
- Overall pipeline: Succeeded

## Pipeline Screenshot
![Successful pipeline execution](../screenshots/pipeline_execution_success.png)

## Technologies
- Microsoft Fabric Data Factory
- Dataflow Gen2
- Fabric Lakehouse
- PySpark
- Delta Lake
- Power BI

## Validation
Both activities succeeded during the documented run.
Execution results are also available in the exported activity-run CSV.

