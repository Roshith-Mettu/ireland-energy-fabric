# Gold Layer – SEAI Energy Analysis

## 1. Overview

The Gold Layer prepares aggregated analytical data from the cleaned SEAI National Energy Balance dataset using Microsoft Fabric PySpark.

The transformation focuses on **Primary Energy Supply (including non-energy use)** for 2024.

The output is stored in a Delta table and used for SQL validation and Power BI reporting.

## 2. Microsoft Fabric Components

- **Workspace:** `ws_ireland_energy`
- **Lakehouse:** `lh_ireland_energy`
- **Source table:** `dbo.seai_energy_balance_silver`
- **Gold table:** `dbo.gold_primary_energy_supply`
- **Notebook:** `nb_gold_energy`
- **Pipeline:** `pl_ireland_energy_etl`
- **Processing technology:** PySpark and Delta Lake
- **Reporting year:** 2024
- **Unit:** ktoe (kilotonnes of oil equivalent)

## 3. Source Schema

The Silver table provides four fields:

| Column | Description |
|---|---|
| energy_balance_item | Energy balance classification |
| year | Reporting year |
| fuel_type | Fuel or energy category |
| energy_ktoe | Energy value measured in ktoe |

## 4. Gold Layer Transformation

The notebook performs three primary operations:

1. Reads the cleaned Silver Delta table.
2. Filters the energy balance classification to `Primary Energy Supply (incl non-energy)`.
3. Groups records by year and fuel type, summing the energy values.

### PySpark Transformation

```python
from pyspark.sql import functions as F

silver = spark.table("lh_ireland_energy.dbo.seai_energy_balance_silver")

gold = (
    silver
    .filter(
        F.col("energy_balance_item") ==
        "Primary Energy Supply (incl non-energy)"
    )
    .groupBy("year", "fuel_type")
    .agg(
        F.sum("energy_ktoe").alias("total_energy_ktoe")
    )
)
```

## 5. Saving the Gold Table

The aggregated DataFrame is written to the Fabric Lakehouse as a Delta table.

```python
gold.write.format("delta") \
    .mode("overwrite") \
    .saveAsTable("dbo.gold_primary_energy_supply")
```

The output is available at:

`Tables / dbo / gold_primary_energy_supply`

Overwrite mode replaces the target table's current data during execution. This does not independently demonstrate source-release history preservation or incremental ingestion.

## 6. Gold Table Schema

| Column | Data Type | Description |
|---|---|---|
| year | Long | Reporting year |
| fuel_type | String | Fuel or energy category |
| total_energy_ktoe | Double | Aggregated energy value in ktoe |

## 7. Data Validation

The Gold Layer was checked using PySpark and SQL.

### Structural Validation

| Check | Result |
|---|---|
| Reporting year | 2024 |
| Total Gold records | 40 |
| Distinct fuel types | 40 |
| Total columns | 3 |
| Missing fuel types | 0 |
| Missing energy values | 0 |
| Duplicate year/fuel combinations | 0 |
| Negative energy values | 4 |

Four negative energy values were identified during validation. They were retained rather than automatically removed, pending source-level interpretation.

### Silver-to-Gold Reconciliation

The Gold energy total was compared with the Silver energy total for the same Primary Energy Supply classification.

| Metric | Result |
|---|---:|
| Filtered Silver energy total | 24,186.71 ktoe |
| Gold aggregated energy total | 24,186.71 ktoe |
| Difference | 0.00 ktoe |

The matching totals demonstrate that the Gold aggregation preserves the summed values of the selected Silver records.

### Renewable Energy Validation

| Metric | Result |
|---|---:|
| Renewables category | 2,089.95 ktoe |
| Aggregated energy total | 24,186.71 ktoe |
| Calculated renewable share | 8.64% |

The renewable share is calculated as:

`Renewables category energy / Total aggregated energy × 100`

This percentage describes the share of the aggregated selected records, not necessarily the official national renewable energy share.

The SQL validation used normalised fuel-type text to handle case and whitespace differences.

## 8. Example Gold Records

Selected high-value records from the 2024 output:

| Fuel Type | Energy (ktoe) |
|---|---:|
| Oil | 7,161.71 |
| Natural Gas | 4,273.75 |
| Gasoil / Diesel / DERV | 3,051.06 |
| Renewables | 2,089.95 |
| Crude | 2,038.36 |

Some fuel categories may represent totals or overlapping classifications. These records should not automatically be interpreted as mutually exclusive components of the national energy mix.

## 9. Pipeline Integration

The Gold Layer is executed as part of the Fabric pipeline `pl_ireland_energy_etl`.

The pipeline contains two sequential activities:

1. `Run_SEAI_Silver` – Executes the Dataflow Gen2 Silver transformation.
2. `Run_Gold_Energy` – Executes the Gold PySpark notebook after successful completion of the Silver activity.

Both activities completed successfully in the recorded pipeline execution.

## 10. Power BI Integration

The Gold table is used for the Ireland Energy Analytics Power BI dashboard.

The demonstrated dashboard includes:

- Total aggregated energy in ktoe.
- Distinct fuel-type count.
- Largest fuel category.
- Renewable category share.
- Energy values by fuel type.
- Reporting year filter.

The Power BI project file is available at:

`powerbi/Ireland Energy Analytics Dashboard.pbix`

## 11. Limitations

- The demonstrated dataset covers 2024.
- Four negative values require source-level interpretation.
- Some fuel categories may overlap or represent subtotals.
- The summed Gold value should not be presented as an independently verified national energy supply total.
- The renewable percentage is calculated from the selected aggregated records.
- Incremental processing and historical release preservation have not been demonstrated.
- The workflow does not currently include EPA emissions integration or scenario modelling.

## 12. Outcome

The Gold Layer successfully transforms Silver energy balance data into an aggregated Delta table using PySpark.

The output contains 40 records for 2024, with no missing values or duplicate year/fuel combinations in the tested results.

The Silver and Gold aggregation totals reconcile, and the data is available for SQL analysis and Power BI reporting.
