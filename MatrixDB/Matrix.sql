CREATE TABLE [dbo].[Matrix]
(
    [datasourceID] INT NOT NULL, 
    [identID] INT NOT NULL, 
    [identString] NVARCHAR(50) NOT NULL, 
    [identOriginalString] NVARCHAR(50) NOT NULL, 
    [compareMetadata] NVARCHAR(50) NOT NULL, 
    CONSTRAINT [PK_Matrix] PRIMARY KEY ([datasourceID], [identID])
)
