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
USE [$(DatabaseName)];


GO
/*
The column [dbo].[Matrix].[Id] is being dropped, data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[Matrix])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Starting rebuilding table [dbo].[Matrix]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Matrix] (
    [datasourceID]        INT           NOT NULL,
    [identString]         NVARCHAR (50) NOT NULL,
    [identOriginalString] NVARCHAR (50) NOT NULL,
    [identID]             INT           NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Matrix] PRIMARY KEY CLUSTERED ([datasourceID] ASC, [identID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Matrix])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Matrix] ([datasourceID], [identID], [identString], [identOriginalString])
        SELECT   [datasourceID],
                 [identID],
                 [identString],
                 [identOriginalString]
        FROM     [dbo].[Matrix]
        ORDER BY [datasourceID] ASC, [identID] ASC;
    END

DROP TABLE [dbo].[Matrix];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Matrix]', N'Matrix';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_Matrix]', N'PK_Matrix', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Update complete.';


GO
