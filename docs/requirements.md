# Ireland Energy & Emissions Analytics Platform

## Business Requirements Document

## 1. Client Brief
An Irish energy advisory team prepares reports from separate SEAI and EPA
spreadsheets. It needs a repeatable analytics platform to compare energy
consumption and emissions trends, explore reduction scenarios, and identify
unreliable data before publishing.

## 2. Users
### Analyst
Uses the platform to investigate energy consumption and emissions trends.

### Reporting Manager
Uses the Power BI report to monitor KPIs and trends.

### Platform Maintainer
Maintains data ingestion, transformations, data-quality checks and pipeline
execution.

## 3. Business Questions
1. Which sectors consume the most energy?
2. Which sectors show the largest emissions changes?
3. How has the energy mix changed?
4. What would emissions look like under different annual reduction assumptions?
5. Can a user trace a dashboard value back to its source?
6. Can the pipeline handle revised files and bad data reliably?

## 4. KPI Definitions
### Final Energy Consumption

- Name: Final Energy Consumption
- Unit: GWh
- Source: SEAI National Energy Balance
- Includes: Final consumption detail rows
- Excludes: Primary energy, subtotals and totals

## 5. Source Coverage and Limitations
### SEAI
Source: SEAI National Energy Balance
The exact years, units, release date and source structure will be documented
after inspecting the downloaded source file.

### EPA
Source: EPA Ireland Greenhouse Gas Emissions Inventory
The exact years, units, release date and source structure will be documented
after inspecting the downloaded source file.

### Limitations
This project uses publicly available national-level data.
The final common analysis period will be selected after inspecting both
datasets.

## 6. Refresh Approach

The platform will check for new source releases monthly.
The source datasets contain annual data, so daily refreshes are not required.
Each source release will be tracked using release information and ingestion
metadata.

## 7. Security Requirements

The Power BI semantic model will use Row-Level Security (RLS) to demonstrate
restricted access to selected sectors.
Security will be tested before the project is considered complete.
Direct access to the Lakehouse and SQL endpoint will be documented separately
from Power BI semantic-model security.

## 8. Acceptance Criteria

The project will be considered complete when:
1. Source values can be reconciled with report values.
2. Running the same file twice does not create duplicates.
3. A revised source release updates current reporting while preserving history.
4. Blocking data-quality failures prevent publication.
5. Sector filters work correctly.
6. Row-Level Security works for the tested role.
7. Scenario calculations match manual calculations.
8. Another person can follow the README and understand how the project works.
