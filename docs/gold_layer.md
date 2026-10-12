
# Gold Layer - SEAI Energy Analysis

## Overview

The Gold layer contains the aggregated energy data prepared from the cleaned SEAI Energy Balance dataset.

I used PySpark in Microsoft Fabric to read the Silver table, select the primary energy supply records, and calculate total energy values for each fuel type.

The output is stored as a Delta table in the same Fabric Lakehouse. This table will be used for further analysis and Power BI reporting.

## Data source

The Gold layer uses the Silver table created earlier in the project.

- Lakehouse: `lh_ireland_energy`
- Source table: `dbo.seai_energy_balance_silver`
- Dataset: SEAI National Energy Balance 2024
- Processing tool: Microsoft Fabric Notebook (PySpark)
- Notebook: `nb_gold_energy.ipynb`

The Silver table contains cleaned energy balance records with the following columns:

- `energy_balance_item`
- `year`
- `fuel_type`
- `energy_ktoe`

## Gold transformation

For this stage, I focused on Primary Energy Supply, including non-energy use.

The Silver dataset was filtered using the energy balance item:

`Primary Energy Supply (incl non-energy)`

After filtering, I grouped the records by year and fuel type and calculated the sum of `energy_ktoe`.

The resulting table contains one aggregated record for each year and fuel type combination.

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

## Saving the Gold table

I saved the aggregated DataFrame as a Delta table using overwrite mode.

```python
gold.write.format("delta") \
    .mode("overwrite") \
    .saveAsTable("dbo.gold_primary_energy_supply")
```

The Gold table is available in the Lakehouse under:

`Tables / dbo / gold_primary_energy_supply`

## Validation

After creating the table, I checked the output using the Fabric notebook.

The table was created successfully and the Spark execution completed without errors.

The validation returned:

- Total records: 40
- Total columns: 3
- Year available in the dataset: 2024
- Spark validation jobs: 7 of 7 succeeded

The Gold table contains the following columns:

| Column | Data type | Description |
|---|---|---|
| year | Long | Reporting year |
| fuel_type | String | Energy source or fuel category |
| total_energy_ktoe | Double | Aggregated energy value in ktoe |

The output was also checked by displaying the aggregated records.

Some of the largest values in the results were:

| Fuel type | Energy (ktoe) |
|---|---:|
| Oil | 7161.71 |
| Natural Gas | 4273.75 |
| Gasoil / Diesel / DERV | 3051.06 |
| Renewables | 2089.95 |
| Crude | 2038.36 |

These values are based on the 2024 Primary Energy Supply records. Some fuel categories represent broader totals or overlapping classifications, so they should not automatically be treated as mutually exclusive shares of national energy supply.

## Output and next steps

The Gold table is ready to be used as a reporting source.

The next stage of the project is to connect Power BI to the Fabric Lakehouse and create visualisations showing energy supply by fuel type.

The initial report will focus on comparing fuel categories and identifying the largest energy supply values for 2024.

The transformation code is available in `notebooks/nb_gold_energy.ipynb`.
