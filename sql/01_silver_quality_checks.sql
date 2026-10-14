
-- Silver Layer Data Quality Validation
-- Source: SEAI National Energy Balance
-- Reporting year: 2024
-- Table: dbo.seai_energy_balance_silver

-- 1. Dataset summary and completeness
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT fuel_type) AS distinct_fuel_types,
    COUNT(DISTINCT energy_balance_item) AS distinct_balance_items,
    MIN(year) AS first_year,
    MAX(year) AS last_year,
    SUM(CASE WHEN energy_ktoe IS NULL
        THEN 1 ELSE 0 END) AS missing_energy_values
FROM dbo.seai_energy_balance_silver;


-- 2. Duplicate business key validation
-- Expected result: zero rows
SELECT
    energy_balance_item,
    year,
    fuel_type,
    COUNT(*) AS duplicate_count
FROM dbo.seai_energy_balance_silver
GROUP BY energy_balance_item, year, fuel_type
HAVING COUNT(*) > 1;


-- 3. Missing and blank dimension validation
SELECT
    SUM(CASE
        WHEN energy_balance_item IS NULL
          OR TRIM(energy_balance_item) = ''
        THEN 1 ELSE 0
    END) AS missing_balance_items,

    SUM(CASE
        WHEN fuel_type IS NULL
          OR TRIM(fuel_type) = ''
        THEN 1 ELSE 0
    END) AS missing_fuel_types,

    SUM(CASE
        WHEN year IS NULL
        THEN 1 ELSE 0
    END) AS missing_years
FROM dbo.seai_energy_balance_silver;


-- 4. Unexpected reporting year validation
-- Expected result: zero rows for the 2024 dataset
SELECT
    year,
    COUNT(*) AS record_count
FROM dbo.seai_energy_balance_silver
WHERE year IS NULL OR year <> 2024
GROUP BY year;


-- 5. Negative energy value inspection
-- Negative values may be valid energy balance adjustments.
-- Review against the SEAI source before classifying as errors.
SELECT
    energy_balance_item,
    year,
    fuel_type,
    energy_ktoe
FROM dbo.seai_energy_balance_silver
WHERE energy_ktoe < 0
ORDER BY energy_balance_item, fuel_type;
