CREATE PROCEDURE [dbo].[ImportDS]
	@DSType int,
	@Ident int,
	@NormalizedName nvarchar(50),
	@OriginalName nvarchar(50),
	@CompareMetadata nvarchar(50)
AS
	IF(	SELECT (1) FROM dbo.Matrix WHERE datasourceID = @DSType AND identID = @Ident) is null
	BEGIN
		INSERT 	INTO dbo.Matrix
		VALUES (@DSType,@Ident,@OriginalName,@NormalizedName,@CompareMetadata)
	END
RETURN 0
