CREATE TABLE [dbo].[DataSources]
(
	[DatasourceID] INT NOT NULL PRIMARY KEY, 
    [DatasourceName] NCHAR(10) NOT NULL, 
    [DatasourceConnectionString] NVARCHAR(MAX) NOT NULL, 
    [DatasourceWatermark] NVARCHAR(50) NOT NULL, 
    [DatasourceType] NCHAR(10) NOT NULL 
)
