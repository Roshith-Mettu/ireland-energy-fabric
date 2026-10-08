# Silver Layer – SEAI Energy Balance

## Objective
Transform raw SEAI energy balance data into a cleaned, structured Delta table for SQL analysis and downstream reporting.

## Microsoft Fabric Components
- Lakehouse: lh_ireland_energy
- Dataflow Gen2: df_seai_silver
- Silver output table: dbo.seai_energy_balance_silver
- Source: SEAI National Energy Balance, 2024

## Transformations
- Promoted headers and renamed columns
- Converted data types
- Unpivoted energy data into long format
- Filtered unwanted categories
- Prepared numeric energy values

## Silver Table Schema
| Column | Data type |
| --- | --- |
| energy_balance_item | Text |
| year | Whole number |
| fuel_type | Text |
| energy_ktoe | Decimal number |

## SQL Quality Checks
- Total records: 1,225
- Distinct fuel types: 40
- Distinct energy balance items: 70
- Year range: 2024–2024
- Missing energy values: 0
- Missing balance items: 0
- Missing fuel types: 0
- Missing years: 0
- Duplicate-key check returned no rows

## Outcome
The Silver table was successfully loaded into the Fabric Lakehouse and validated using its SQL analytics endpoint.

## Next Stage
Build Gold Layer analytical tables and Power BI reports.
