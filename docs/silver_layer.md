# Silver Layer – SEAI Energy Balance

## Objective

Transform raw SEAI National Energy Balance data into a cleaned, structured Delta table for SQL analysis, downstream aggregation, and Power BI reporting.

## Microsoft Fabric Components

- **Lakehouse:** `lh_ireland_energy`
- **Dataflow Gen2:** `df_seai_silver`
- **Silver output table:** `dbo.seai_energy_balance_silver`
- **Source:** SEAI National Energy Balance, 2024
- **Pipeline:** `pl_ireland_energy_etl`

## Data Transformations

The Silver Layer uses Microsoft Fabric Dataflow Gen2 and Power Query to prepare the source data.

Transformations include:

1. Promoting source headers and renaming columns.
2. Converting columns to appropriate data types.
3. Unpivoting energy data into a long-format structure.
4. Filtering unwanted categories.
5. Preparing numeric energy values for aggregation and reporting.

## Silver Table Schema

| Column | Data Type |
|---|---|
| energy_balance_item | Text |
| year | Whole number |
| fuel_type | Text |
| energy_ktoe | Decimal number |

## SQL Data Quality Checks

The following validation results were recorded for the 2024 Silver dataset.

| Validation | Reported Result |
|---|---|
| Total records | 1,225 |
| Distinct fuel types | 40 |
| Distinct energy balance items | 70 |
| Year range | 2024–2024 |
| Missing energy values | 0 |
| Missing balance items | 0 |
| Missing fuel types | 0 |
| Missing years | 0 |
| Duplicate-key check | No rows returned |

These checks support the completeness and uniqueness of the tested dataset.

## Pipeline Integration

The Silver Layer is executed through the Microsoft Fabric pipeline `pl_ireland_energy_etl`.

The `Run_SEAI_Silver` activity executes the Dataflow Gen2 transformation.

On successful completion, the pipeline proceeds to `Run_Gold_Energy`, which executes the Gold Layer PySpark notebook.

Both activities completed successfully in the recorded pipeline execution.

## Data Quality Limitations

The reported validation checks do not independently establish that all source values are correct.

Source-to-target reconciliation, handling of revised source releases, and repeat-load behaviour require separate verification.

## Outcome

The Silver Layer was loaded into the Microsoft Fabric Lakehouse and validated using SQL quality checks.

The resulting structured data supports downstream Gold Layer aggregation and Power BI reporting.

## Next Stage

The Gold Layer uses PySpark to aggregate the Silver data into analytical tables for energy supply and fuel mix reporting.
