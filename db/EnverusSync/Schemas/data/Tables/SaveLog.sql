CREATE TABLE dbo.SaveLog (
	 SaveLogId		BIGINT IDENTITY(1,1)	NOT NULL
	,SavedDate		DATETIME2				NOT NULL	CONSTRAINT DF_dbo_SaveLog_SaveDate DEFAULT (SYSDATETIMEOFFSET())
	,SavedBy		VARCHAR(128)			NOT NULL
	,SavedData		NVARCHAR(max)			NULL

	,CONSTRAINT PK_dbo_SaveLog_SaveLogId
	 	PRIMARY KEY CLUSTERED (
	 		SaveLogId
	 	)

	,INDEX idx_dbo_SaveLog_SavedDate
	 	NONCLUSTERED (
	 		SavedDate
	 	)
)