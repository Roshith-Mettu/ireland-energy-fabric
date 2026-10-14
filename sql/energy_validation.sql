
-- Ireland Energy Fabric Project
-- Gold Layer Data Quality Validation
-- Reporting year: 2024
-- Units: ktoe

-- 1. Gold dataset summary
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT fuel_type) AS distinct_fuel_types,
    ROUND(SUM(total_energy_ktoe), 2) AS total_energy_ktoe
FROM dbo.gold_primary_energy_supply
WHERE year = 2024;


-- 2. Duplicate year and fuel combinations
-- Expected result: zero rows
SELECT
    year,
    fuel_type,
    COUNT(*) AS duplicate_count
FROM dbo.gold_primary_energy_supply
GROUP BY year, fuel_type
HAVING COUNT(*) > 1;


-- 3. Missing and blank values
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN year IS NULL
        THEN 1 ELSE 0 END) AS null_years,
    SUM(CASE WHEN fuel_type IS NULL
        OR TRIM(fuel_type) = ''
        THEN 1 ELSE 0 END) AS missing_fuel_types,
    SUM(CASE WHEN total_energy_ktoe IS NULL
        THEN 1 ELSE 0 END) AS null_energy_values
FROM dbo.gold_primary_energy_supply;


-- 4. Top 5 fuel categories
SELECT TOP 5
    fuel_type,
    ROUND(total_energy_ktoe, 2) AS energy_ktoe
FROM dbo.gold_primary_energy_supply
WHERE year = 2024
ORDER BY total_energy_ktoe DESC;


-- 5. Silver-to-Gold energy reconciliation
WITH silver_total AS (
    SELECT
        SUM(energy_ktoe) AS energy_ktoe
    FROM dbo.seai_energy_balance_silver
    WHERE year = 2024
      AND energy_balance_item =
          'Primary Energy Supply (incl non-energy)'
),
gold_total AS (
    SELECT
        SUM(total_energy_ktoe) AS energy_ktoe
    FROM dbo.gold_primary_energy_supply
    WHERE year = 2024
)
SELECT
    ROUND(s.energy_ktoe, 2) AS silver_total_ktoe,
    ROUND(g.energy_ktoe, 2) AS gold_total_ktoe,
    ROUND(
        s.energy_ktoe - g.energy_ktoe, 2
    ) AS difference_ktoe
FROM silver_total s
CROSS JOIN gold_total g;


-- 6. Renewable category share
-- Share of summed Gold records, not an official
-- national renewable energy percentage.
SELECT
    ROUND(
        SUM(CASE
            WHEN LOWER(TRIM(fuel_type)) = 'renewables'
            THEN total_energy_ktoe
            ELSE 0
        END), 2
    ) AS renewable_energy_ktoe,

    ROUND(SUM(total_energy_ktoe), 2)
        AS total_energy_ktoe,

    ROUND(
        100.0 * SUM(CASE
            WHEN LOWER(TRIM(fuel_type)) = 'renewables'
            THEN total_energy_ktoe
            ELSE 0
        END)
        / NULLIF(SUM(total_energy_ktoe), 0),
        2
    ) AS renewable_share_pct
FROM dbo.gold_primary_energy_supply
WHERE year = 2024;


-- 7. Negative energy value inspection
-- Review negative values against the SEAI source.
SELECT
    year,
    fuel_type,
    total_energy_ktoe
FROM dbo.gold_primary_energy_supply
WHERE total_energy_ktoe < 0
ORDER BY total_energy_ktoe;


-- 8. Unexpected reporting years
-- Expected result: zero rows for this 2024 dataset
SELECT
    year,
    COUNT(*) AS record_count
FROM dbo.gold_primary_energy_supply
WHERE year IS NULL OR year <> 2024
GROUP BY year;
