
-- Silver Layer quality validation
-- SEAI National Energy Balance 2024

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT fuel_type) AS fuel_types,
    COUNT(DISTINCT energy_balance_item) AS balance_items,
    MIN(year) AS first_year,
    MAX(year) AS last_year,
    SUM(CASE WHEN energy_ktoe IS NULL
        THEN 1 ELSE 0 END) AS missing_energy_values
FROM dbo.seai_energy_balance_silver;

-- Check duplicate business keys
SELECT
    energy_balance_item,
    year,
    fuel_type,
    COUNT(*) AS duplicate_count
FROM dbo.seai_energy_balance_silver
GROUP BY energy_balance_item, year, fuel_type
HAVING COUNT(*) > 1;

-- Check missing dimension values
SELECT
    SUM(CASE WHEN energy_balance_item IS NULL
        OR TRIM(energy_balance_item) = ''
        THEN 1 ELSE 0 END) AS missing_balance_items,
    SUM(CASE WHEN fuel_type IS NULL
        OR TRIM(fuel_type) = ''
        THEN 1 ELSE 0 END) AS missing_fuel_types,
    SUM(CASE WHEN year IS NULL
        THEN 1 ELSE 0 END) AS missing_years
FROM dbo.seai_energy_balance_silver;
