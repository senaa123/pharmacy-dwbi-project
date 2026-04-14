/*
Task 4 - Data Warehouse Design & Development (NVARCHAR version)
Scenario: Pharmacy Sales Data Warehouse
This version changes warehouse text columns to NVARCHAR to avoid SSIS
Unicode/non-Unicode mapping errors.
*/

IF DB_ID('PharmacyDW') IS NULL
    CREATE DATABASE PharmacyDW;
GO

USE PharmacyDW;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dw')
    EXEC('CREATE SCHEMA dw');
GO

/* Drop old objects if rerunning */
IF OBJECT_ID('dw.FactSales', 'U') IS NOT NULL DROP TABLE dw.FactSales;
IF OBJECT_ID('dw.DimProduct', 'U') IS NOT NULL DROP TABLE dw.DimProduct;
IF OBJECT_ID('dw.DimCustomer', 'U') IS NOT NULL DROP TABLE dw.DimCustomer;
IF OBJECT_ID('dw.DimDoctor', 'U') IS NOT NULL DROP TABLE dw.DimDoctor;
IF OBJECT_ID('dw.DimDate', 'U') IS NOT NULL DROP TABLE dw.DimDate;
GO

CREATE TABLE dw.DimDate (
    DateKey         INT            NOT NULL PRIMARY KEY,
    FullDate        DATE           NOT NULL,
    DayNumber       TINYINT        NOT NULL,
    DayName         NVARCHAR(20)   NOT NULL,
    MonthNumber     TINYINT        NOT NULL,
    MonthName       NVARCHAR(20)   NOT NULL,
    QuarterNumber   TINYINT        NOT NULL,
    YearNumber      SMALLINT       NOT NULL,
    WeekNumber      TINYINT        NOT NULL,
    IsWeekend       BIT            NOT NULL
);
GO

CREATE TABLE dw.DimProduct (
    ProductKey          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    KD_OBAT             NVARCHAR(50)      NOT NULL,
    ProductName         NVARCHAR(150)     NOT NULL,
    UnitType            NVARCHAR(20)      NULL,
    ManufacturerCode    NVARCHAR(20)      NULL,
    BaseSellingPrice    DECIMAL(18,2)     NULL,
    Category            NVARCHAR(100)     NULL,
    Subcategory         NVARCHAR(100)     NULL,
    BrandGroup          NVARCHAR(100)     NULL,
    Manufacturer        NVARCHAR(100)     NULL,
    EffectiveFromDate   DATETIME          NOT NULL,
    EffectiveToDate     DATETIME          NOT NULL,
    IsCurrent           BIT               NOT NULL,
    SourceSystem        NVARCHAR(20)      NOT NULL DEFAULT N'SQL+CSV',
    CONSTRAINT UQ_DimProduct_SCD UNIQUE (KD_OBAT, EffectiveFromDate)
);
GO

CREATE TABLE dw.DimCustomer (
    CustomerKey         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    KD_CUST             NVARCHAR(25)      NOT NULL,
    CustomerName        NVARCHAR(150)     NULL,
    CustomerType        NVARCHAR(50)      NULL,
    RegistrationType    NVARCHAR(20)      NULL,
    EffectiveFromDate   DATETIME          NOT NULL DEFAULT GETDATE(),
    EffectiveToDate     DATETIME          NOT NULL DEFAULT ('9999-12-31'),
    IsCurrent           BIT               NOT NULL DEFAULT 1,
    CONSTRAINT UQ_DimCustomer UNIQUE (KD_CUST, EffectiveFromDate)
);
GO

CREATE TABLE dw.DimDoctor (
    DoctorKey           INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    KD_DOKTER           NVARCHAR(25)      NOT NULL,
    DoctorName          NVARCHAR(150)     NULL,
    DoctorSpecialty     NVARCHAR(100)     NULL,
    DoctorGroup         NVARCHAR(50)      NULL,
    EffectiveFromDate   DATETIME          NOT NULL DEFAULT GETDATE(),
    EffectiveToDate     DATETIME          NOT NULL DEFAULT ('9999-12-31'),
    IsCurrent           BIT               NOT NULL DEFAULT 1,
    CONSTRAINT UQ_DimDoctor UNIQUE (KD_DOKTER, EffectiveFromDate)
);
GO

CREATE TABLE dw.FactSales (
    SalesFactKey            BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TxnID                   NVARCHAR(50)         NOT NULL,
    DateKey                 INT                  NOT NULL,
    ProductKey              INT                  NOT NULL,
    CustomerKey             INT                  NOT NULL,
    DoctorKey               INT                  NOT NULL,
    Quantity                DECIMAL(18,2)        NOT NULL,
    UnitCost                DECIMAL(18,2)        NOT NULL,
    UnitPrice               DECIMAL(18,2)        NOT NULL,
    TaxPercent              DECIMAL(9,2)         NULL,
    GrossAmount             DECIMAL(18,2)        NOT NULL,
    CostAmount              DECIMAL(18,2)        NOT NULL,
    ProfitAmount            DECIMAL(18,2)        NOT NULL,
    IsRacik                 NVARCHAR(10)         NULL,
    RegistrationType        NVARCHAR(20)         NULL,
    SalesTime               TIME                 NULL,
    accm_txn_create_time    DATETIME             NULL,
    accm_txn_complete_time  DATETIME             NULL,
    txn_process_time_hours  DECIMAL(18,2)        NULL,
    CONSTRAINT FK_FactSales_DimDate
        FOREIGN KEY (DateKey) REFERENCES dw.DimDate(DateKey),
    CONSTRAINT FK_FactSales_DimProduct
        FOREIGN KEY (ProductKey) REFERENCES dw.DimProduct(ProductKey),
    CONSTRAINT FK_FactSales_DimCustomer
        FOREIGN KEY (CustomerKey) REFERENCES dw.DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_DimDoctor
        FOREIGN KEY (DoctorKey) REFERENCES dw.DimDoctor(DoctorKey)
);
GO

CREATE INDEX IX_FactSales_TxnID       ON dw.FactSales(TxnID);
CREATE INDEX IX_FactSales_DateKey     ON dw.FactSales(DateKey);
CREATE INDEX IX_FactSales_ProductKey  ON dw.FactSales(ProductKey);
CREATE INDEX IX_FactSales_CustomerKey ON dw.FactSales(CustomerKey);
CREATE INDEX IX_FactSales_DoctorKey   ON dw.FactSales(DoctorKey);
GO

SET IDENTITY_INSERT dw.DimProduct ON;
INSERT INTO dw.DimProduct (
    ProductKey, KD_OBAT, ProductName, UnitType, ManufacturerCode, BaseSellingPrice,
    Category, Subcategory, BrandGroup, Manufacturer,
    EffectiveFromDate, EffectiveToDate, IsCurrent, SourceSystem
)
VALUES (
    0, N'UNKNOWN', N'Unknown Product', N'Unknown', N'Unknown', 0,
    N'Unknown', N'Unknown', N'Unknown', N'Unknown',
    '1900-01-01', '9999-12-31', 1, N'SYSTEM'
);
SET IDENTITY_INSERT dw.DimProduct OFF;
GO

SET IDENTITY_INSERT dw.DimCustomer ON;
INSERT INTO dw.DimCustomer (
    CustomerKey, KD_CUST, CustomerName, CustomerType, RegistrationType,
    EffectiveFromDate, EffectiveToDate, IsCurrent
)
VALUES (
    0, N'UNKNOWN', N'Unknown Customer', N'Unknown', N'Unknown',
    '1900-01-01', '9999-12-31', 1
);
SET IDENTITY_INSERT dw.DimCustomer OFF;
GO

SET IDENTITY_INSERT dw.DimDoctor ON;
INSERT INTO dw.DimDoctor (
    DoctorKey, KD_DOKTER, DoctorName, DoctorSpecialty, DoctorGroup,
    EffectiveFromDate, EffectiveToDate, IsCurrent
)
VALUES (
    0, N'UNKNOWN', N'Unknown Doctor', N'Unknown', N'Unknown',
    '1900-01-01', '9999-12-31', 1
);
SET IDENTITY_INSERT dw.DimDoctor OFF;
GO

/* Optional cleanup statements for reruns */
-- TRUNCATE TABLE dw.FactSales;
-- TRUNCATE TABLE dw.DimProduct;
-- TRUNCATE TABLE dw.DimCustomer;
-- TRUNCATE TABLE dw.DimDoctor;
-- TRUNCATE TABLE dw.DimDate;
