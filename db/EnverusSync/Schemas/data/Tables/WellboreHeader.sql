CREATE TABLE [data].[WellboreHeader](
	[API_UWI] [VARCHAR](32) NULL,
	[API_UWI_Unformatted] [VARCHAR](32) NULL,
	[API_UWI_12] [VARCHAR](32) NULL,
	[API_UWI_12_Unformatted] [VARCHAR](32) NULL,
	[Country] [VARCHAR](2) NULL,
	[County] [VARCHAR](32) NULL,
	[DeletedDate] [DATETIME] NULL,
	[ENVBasin] [VARCHAR](64) NULL,
	[ENVInterval] [VARCHAR](128) NULL,
	[ENVOperator] [VARCHAR](256) NULL,
	[ENVPlay] [VARCHAR](128) NULL,
	[ENVRegion] [VARCHAR](32) NULL,
	[ENVWellboreType] [VARCHAR](256) NULL,
	[GeomBHL_Point] [GEOMETRY] NULL,
	[GeomSHL_Point] [GEOMETRY] NULL,
	[LateralLine] [GEOMETRY] NULL,
	[Latitude] [FLOAT] NULL,
	[Latitude_BH] [FLOAT] NULL,
	[Longitude] [FLOAT] NULL,
	[Longitude_BH] [FLOAT] NULL,
	[MD_FT] [FLOAT] NULL,
	[PlugbackMeasuredDepth_FT] [INT] NULL,
	[PlugbackTrueVerticalDepth_FT] [INT] NULL,
	[StateProvince] [VARCHAR](64) NULL,
	[Trajectory] [VARCHAR](64) NULL,
	[TVD_FT] [FLOAT] NULL,
	[UpdatedDate] [DATETIME] NULL,
	[WellboreID] [BIGINT] NOT NULL,
	[WellID] [BIGINT] NULL,
	[WellSymbols] [VARCHAR](256) NULL,
	[ETL_Load_Date] DATETIME      NULL,
	constraint pk_data_WellboreHeader_WellboreID primary key clustered (WellboreID)
);

GO


