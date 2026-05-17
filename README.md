# Pharmacy Sales Data Warehouse & Business Intelligence Solution

## Overview

This project demonstrates the end-to-end design and implementation of a pharmacy sales data warehouse and business intelligence solution using Microsoft SQL Server technologies.

The solution transforms raw OLTP pharmacy transaction data into a dimensional warehouse architecture that supports analytical reporting, OLAP operations, and interactive business intelligence dashboards.

The project was developed as part of the Sri Lanka Institute of Information Technology Data Warehousing and Business Intelligence module.

---

# Project Objectives

- Design a dimensional data warehouse for pharmacy sales analytics
- Implement ETL pipelines using SSIS
- Build and process an SSAS OLAP cube
- Demonstrate OLAP operations using Excel
- Create interactive Power BI reports and dashboards
- Handle realistic data quality and integration challenges
- Implement accumulating fact table updates

---

## Components
- Data warehouse schema design
- ETL pipelines developed in SSIS
- SSAS cube implementation
- Excel OLAP operations
- Power BI reports and dashboards

# Business Scenario

The system analyzes pharmacy retail sales transactions to support business reporting and decision-making.

The warehouse enables analysis such as:

- Sales trends over time
- Product category performance
- Customer purchasing behavior
- Doctor prescription activity
- Transaction processing duration
- Revenue analysis by dimensions

---

# Solution Architecture

The implementation follows a layered enterprise-style DWBI architecture.

## Architecture Layers

| Layer | Purpose |
|---|---|
| Source Layer | Raw OLTP pharmacy transaction data |
| Staging Layer | Temporary ETL processing area |
| Debug Layer | Lookup failure and no-match analysis |
| Data Warehouse Layer | Star schema dimensional warehouse |
| OLAP Layer | SSAS multidimensional cube |
| Reporting Layer | Excel OLAP analysis and Power BI dashboards |

## Databases Used

| Database | Description |
|---|---|
| PharmacySource | Operational source database |
| PharmacyStaging | Intermediate ETL staging database |
| PharmacyDW | Dimensional warehouse |
| PharmacyDebug | ETL troubleshooting and validation |

---

# Data Warehouse Design

## Schema Type

Star Schema

## Fact Table

### FactSales

Stores transaction-level pharmacy sales measures.

### Measures

- Quantity Sold
- Sales Amount
- Transaction Processing Hours

## Dimensions

### DimDate

Supports time-based analysis.

### DimProduct

Includes:

- Product Name
- Category
- Manufacturer
- SCD Type 2 structure

### DimCustomer

Customer dimension with generated descriptive attributes.

### DimDoctor

Doctor dimension with generated descriptive attributes.

---

# Slowly Changing Dimension (SCD)

`DimProduct` was designed as a Slowly Changing Dimension Type 2 structure using:

- EffectiveFromDate
- EffectiveToDate
- IsCurrent

The implementation is SCD-ready and supports future historical version tracking.

---

# ETL Implementation (SSIS)

## SSIS Packages

| Package | Purpose |
|---|---|
| Load_PharmacyStg.dtsx | Load CSV files into staging |
| Load_PharmacyDW.dtsx | Load dimensions and fact table |
| Update_FactSales_Accumulating.dtsx | Process accumulating fact updates |

## ETL Features

- Multi-source integration
- CSV and SQL Server ingestion
- Lookup transformations
- Merge joins
- Derived columns
- Surrogate key generation
- Fact loading
- Data cleansing
- Validation queries
- Error/debug handling

---

# Accumulating Fact Table Implementation

The warehouse supports accumulating fact processing through:

- `accm_txn_create_time`
- `accm_txn_complete_time`
- `txn_process_time_hours`

A separate ETL package updates transaction completion timestamps and calculates processing duration.

---

# SSAS Cube Implementation

An SSAS multidimensional cube was developed using the warehouse as the data source.

## Cube Features

- Measures from FactSales
- Connected dimensions
- Time hierarchy implementation
- Product hierarchy support
- Aggregated analytical processing

## Hierarchies

### Date Hierarchy

```text
Year → Quarter → Month → Day
```

---

# Excel OLAP Analysis

Excel was connected directly to the SSAS cube to perform OLAP analysis using PivotTables and PivotCharts.

## OLAP Operations Demonstrated

- Roll-up
- Drill-down
- Slice
- Dice
- Pivot

---

# Power BI Reports

Interactive Power BI dashboards were developed and published.

## Reports Included

### Report 1 — Matrix Report

Detailed tabular analysis with grouped rows and columns.

### Report 2 — Cascading Slicer Dashboard

Interactive filtering using dependent slicers and multiple visuals.

### Report 3 — Drill-Down Report

Hierarchical exploration from:

```text
Year → Quarter → Month
```

### Report 4 — Drill-Through Report

Right-click navigation to detailed analytical pages.

## Power BI Features Used

- DAX measures
- Drill-through
- Drill-down
- Slicers
- Matrix visuals
- Interactive filtering
- Cross-report analysis

---

# Data Quality Challenges

Several real-world data quality issues were identified and handled:

- Missing product master records
- Unmatched transaction headers/details
- VARCHAR/NVARCHAR mismatches
- Lookup failures
- Referential integrity issues

Debug databases and validation queries were used to investigate ETL mismatches.

---

# Technologies Used
- Microsoft SQL Server
- SQL Server Integration Services (SSIS)
- SQL Server Analysis Services (SSAS)
- Microsoft Excel
- Microsoft Power BI

---

## Project Structure
- `sql/` SQL scripts for source preparation and warehouse implementation
- `data/` source CSV files used for enrichment and accumulating fact updates
- `etl/` SSIS project files
- `cube/` SSAS cube project files
- `excel/` Excel workbook for OLAP analysis
- `powerbi/` Power BI report files

---

# Project Structure

```text
project-root/
│
├── sql/
│   ├── source preparation scripts
│   ├── warehouse schema scripts
│   └── validation queries
│
├── data/
│   ├── product_enrichment.csv
│   └── txn_completion_top20.csv
│
├── etl/
│   ├── Load_PharmacyStg.dtsx
│   ├── Load_PharmacyDW.dtsx
│   └── Update_FactSales_Accumulating.dtsx
│
├── cube/
│   └── SSAS cube project
│
├── excel/
│   └── OLAP analysis workbook
│
├── powerbi/
│   └── Power BI report files
│
├── docs/
│   └── Project report and screenshots
│
└── README.md
```

---

# Key Learning Outcomes

- Dimensional modeling
- Star schema design
- ETL development with SSIS
- SSAS cube implementation
- OLAP operations
- Power BI dashboard design
- Data warehouse validation
- Data quality handling
- Enterprise DWBI architecture

---

# Conclusion

This project successfully demonstrates the complete lifecycle of a modern data warehousing and business intelligence solution using Microsoft BI technologies.

The implementation combines dimensional modeling, ETL processing, OLAP cube development, Excel analytics, and Power BI reporting into a unified analytical platform capable of supporting business decision-making in a pharmacy retail environment.