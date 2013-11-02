﻿/*
Deployment script for MatrixDB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar MatrixDB "MatrixDB"
:setvar DatabaseName "MatrixDB"
:setvar DefaultFilePrefix "MatrixDB"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Rename refactoring operation with key 5680d884-90a6-4c5c-98db-8259685630df is skipped, element [dbo].[Matrix].[ident] (SqlSimpleColumn) will not be renamed to identString';


GO
PRINT N'Rename refactoring operation with key e86c94bb-3694-4677-89f1-c8d24eacd3be is skipped, element [dbo].[DataSources].[Id] (SqlSimpleColumn) will not be renamed to DatasourceID';


GO
PRINT N'Rename refactoring operation with key aabc5cd7-0c0f-4178-889f-de03484bc02d is skipped, element [dbo].[DataSources].[Datasource] (SqlSimpleColumn) will not be renamed to DatasourceConnectionString';


GO
PRINT N'Creating [dbo].[DataSources]...';


GO
CREATE TABLE [dbo].[DataSources] (
    [DatasourceID]               INT            NOT NULL,
    [DatasourceName]             NCHAR (10)     NOT NULL,
    [DatasourceConnectionString] NVARCHAR (MAX) NOT NULL,
    [DatasourceWatermark]        NVARCHAR (50)  NOT NULL,
    [DatasourceType]             NCHAR (10)     NOT NULL,
    PRIMARY KEY CLUSTERED ([DatasourceID] ASC)
);


GO
PRINT N'Creating [dbo].[Matrix]...';


GO
CREATE TABLE [dbo].[Matrix] (
    [Id]                  INT           NOT NULL,
    [datasourceID]        INT           NOT NULL,
    [identString]         NVARCHAR (50) NOT NULL,
    [identOriginalString] NVARCHAR (50) NOT NULL,
    [identID]             INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5680d884-90a6-4c5c-98db-8259685630df')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5680d884-90a6-4c5c-98db-8259685630df')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e86c94bb-3694-4677-89f1-c8d24eacd3be')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e86c94bb-3694-4677-89f1-c8d24eacd3be')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'aabc5cd7-0c0f-4178-889f-de03484bc02d')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('aabc5cd7-0c0f-4178-889f-de03484bc02d')

GO

GO
PRINT N'Update complete.';


GO
