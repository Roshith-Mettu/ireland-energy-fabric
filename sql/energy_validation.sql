
-- IRELAND ENERGY FABRIC PROJECT
-- COMPLETE GOLD LAYER VALIDATION
-- Microsoft Fabric Spark SQL
-- Reporting Year: 2024

WITH gold_data AS (
    SELECT
        year,
        fuel_type,
        total_energy_ktoe
    FROM dbo.gold_primary_energy_supply
),

silver_total AS (
    SELECT
        SUM(energy_ktoe) AS total_ktoe
    FROM dbo.seai_energy_balance_silver
    WHERE year = 2024
      AND energy_balance_item =
          'Primary Energy Supply (incl non-energy)'
),

gold_summary AS (
    SELECT
        COUNT(*) AS total_rows,
        COUNT(DISTINCT fuel_type) AS distinct_fuel_types,
        ROUND(SUM(total_energy_ktoe), 2) AS total_energy,
        SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END)
            AS null_years,
        SUM(CASE
            WHEN fuel_type IS NULL
              OR TRIM(fuel_type) = ''
            THEN 1 ELSE 0 END) AS missing_fuel_types,
        SUM(CASE
            WHEN total_energy_ktoe IS NULL
            THEN 1 ELSE 0 END) AS null_energy_values,
        SUM(CASE
            WHEN total_energy_ktoe < 0
            THEN 1 ELSE 0 END) AS negative_energy_values,
        SUM(CASE
            WHEN year IS NULL OR year <> 2024
            THEN 1 ELSE 0 END) AS unexpected_year_rows
    FROM gold_data
),

duplicate_summary AS (
    SELECT COUNT(*) AS duplicate_groups
    FROM (
        SELECT year, fuel_type
        FROM gold_data
        GROUP BY year, fuel_type
        HAVING COUNT(*) > 1
    ) duplicates
),

renewable_summary AS (
    SELECT
        ROUND(SUM(CASE
            WHEN LOWER(TRIM(fuel_type)) = 'renewables'
            THEN total_energy_ktoe
            ELSE 0
        END), 2) AS renewable_energy
    FROM gold_data
    WHERE year = 2024
)

SELECT
    g.total_rows,
    g.distinct_fuel_types,
    g.total_energy AS gold_total_ktoe,
    ROUND(s.total_ktoe, 2) AS silver_total_ktoe,
    ROUND(s.total_ktoe - g.total_energy, 2)
        AS reconciliation_difference,
    d.duplicate_groups,
    g.null_years,
    g.missing_fuel_types,
    g.null_energy_values,
    g.negative_energy_values,
    g.unexpected_year_rows,
    r.renewable_energy AS renewable_energy_ktoe,
    ROUND(
        100.0 * r.renewable_energy
        / NULLIF(g.total_energy, 0),
        2
    ) AS renewable_share_pct
FROM gold_summary g
CROSS JOIN silver_total s
CROSS JOIN duplicate_summary d
CROSS JOIN renewable_summary r;
