
-- Ireland Energy Fabric Project
-- Gold Layer Data Quality Validation

-- 1. Check total records and energy
SELECT
    COUNT(*) AS total_rows,
    ROUND(SUM(total_energy_ktoe), 2) AS total_energy_ktoe
FROM dbo.gold_primary_energy_supply
WHERE year = 2024;

-- 2. Check for duplicate records
SELECT
    year,
    fuel_type,
    COUNT(*) AS duplicate_count
FROM dbo.gold_primary_energy_supply
GROUP BY year, fuel_type
HAVING COUNT(*) > 1;

-- 3. Check for missing values
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END)
        AS null_years,
    SUM(CASE WHEN fuel_type IS NULL THEN 1 ELSE 0 END)
        AS null_fuel_types,
    SUM(CASE WHEN total_energy_ktoe IS NULL THEN 1 ELSE 0 END)
        AS null_energy_values
FROM dbo.gold_primary_energy_supply;

-- 4. Top 5 fuel categories
SELECT TOP 5
    fuel_type,
    ROUND(total_energy_ktoe, 2) AS energy_ktoe
FROM dbo.gold_primary_energy_supply
WHERE year = 2024
ORDER BY total_energy_ktoe DESC;
