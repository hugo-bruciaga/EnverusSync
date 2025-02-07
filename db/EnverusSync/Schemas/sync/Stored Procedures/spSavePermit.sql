/***********************************************************************************

	Procedure Name:		sync.spPermit
	Author:				Enterprise Database Development Team
	______________________________________________________________________________

	Purpose:			
	  TODO: Add text to describe the purpose of the procedure

	Parameters:
	  @Param1 (varchar 128)
		Description goes here

	  @Param2 (varchar 128)
		Description goes here

	Returns:
	  TODO: Add help text to describe any return values and/or result sets

	Remarks:
	  TODO: Add help text to provide more detailed usage instructions

	Example:
	  TODO: Add examples of calling and using the stored procedure
	______________________________________________________________________________

***********************************************************************************/
CREATE PROCEDURE sync.spSavePermit (
	 @data			VARCHAR(max)
	,@NoOutput		BIT				= 0
)
AS
BEGIN
	SET XACT_ABORT ON
	SET NOCOUNT ON

	--------------------------------------------------------------------------------
	-- Variable Declaration
	--------------------------------------------------------------------------------
		DECLARE
			 @ErrPos			VARCHAR(512)	= ''
			,@ErrMsg			VARCHAR(2048)	= ''
			,@MsgTitle			VARCHAR(256)	= concat('Execute ', object_schema_name(@@procid), '.', object_name(@@procid))
	
		-- Parameter Override
		SELECT @NoOutput = coalesce(@NoOutput, 0)

	--------------------------------------------------------------------------------
	-- BEGIN TRY... CATCH
	--------------------------------------------------------------------------------
		BEGIN TRY
			PRINT concat(sysdatetime(),' | INFO | ',@MsgTitle, '; *** Started ***')

			------------------------------------------------------------------------
			-- Validate Parameters
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Validate parameters')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				  -- @data
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; @data')
			  	  IF ISJSON(@data) = 0
				  BEGIN
				      SET @ErrMsg = 'The @data must be a well formed JSON structure';
					  THROW 2147483647,@ErrMsg,1;
				  END
				  
			------------------------------------------------------------------------
			-- Initialize procedure resources
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Initialize procedure resources')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				  -- #Permit
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; #Permit')
			  
				  DROP TABLE IF EXISTS #Permit
				  CREATE TABLE #Permit (
					 _row_id						 BIGINT IDENTITY(1,1)	NOT NULL	PRIMARY KEY CLUSTERED
					,_delete						 BIT			NULL
					,_duplicate						 BIT			NULL
					,_error							 BIT			NULL
					,_message						 VARCHAR		NULL

					,[Abstract]                      VARCHAR (8)      
					,[Amended_Date]                  DATETIME         
					,[API_UWI]                       VARCHAR (32)     
					,[API_UWI_Unformatted]           VARCHAR (32)     
					,[ApprovedDate]                  DATETIME         
					,[Block]                         VARCHAR (16)     
					,[ContactName]                   VARCHAR (128)    
					,[ContactPhone]                  VARCHAR (32)     
					,[Country]                       VARCHAR (64)     
					,[County]                        VARCHAR (64)     
					,[DeletedDate]                   DATETIME         
					,[District]                      VARCHAR (16)     
					,[ENVBasin]                      VARCHAR (64)     
					,[ENVInterval]                   VARCHAR (128)    
					,[ENVOperator]                   VARCHAR (256)    
					,[ENVPeerGroup]                  VARCHAR (64)     
					,[ENVPlay]                       VARCHAR (128)    
					,[ENVRegion]                     VARCHAR (32)     
					,[ENVStockExchange]              VARCHAR (32)     
					,[ENVTicker]                     VARCHAR (8)      
					,[ENVWellStatus]                 VARCHAR (64)     
					,[ExpiredDate]                   DATETIME         
					,[Field]                         VARCHAR (64)     
					,[Formation]                     VARCHAR (256)    
					,[GeomBHL_Point]               [sys].[geometry] 
					,[GeomPermitted_Line]          [sys].[geometry] 
					,[GeomSHL_Point]               [sys].[geometry] 
					,[H2SArea]                       INT              
					,[Latitude]                      FLOAT (53)       
					,[Latitude_BH]                   FLOAT (53)       
					,[Lease_Acres]                   FLOAT (53)       
					,[LeaseName]                     VARCHAR (64)     
					,[LeaseNumber]                   VARCHAR (64)     
					,[Longitude]                     FLOAT (53)       
					,[Longitude_BH]                  FLOAT (53)       
					,[OperatorAddress]               VARCHAR (128)    
					,[OperatorCity]                  VARCHAR (32)     
					,[OperatorCity_30mi]             VARCHAR (16)     
					,[OperatorCity_50mi]             VARCHAR (16)     
					,[OperatorState]                 VARCHAR (16)     
					,[OperatorZip]                   VARCHAR (16)     
					,[PadID]                         VARCHAR (128)    
					,[PermitDepth_FT]                INT              
					,[PermitID]                      INT              
					,[PermitNumber]                  VARCHAR (32)     
					,[PermitStatus]                  VARCHAR (16)     
					,[PermittedLateralLength_FT]     FLOAT (53)       
					,[PermittedLateralLengthSource]  VARCHAR (16)     
					,[PermittedMeasuredDepth_FT]     INT              
					,[PermittedTrueVerticalDepth_FT] INT              
					,[PermitType]                    VARCHAR (16)     
					,[Range]                         VARCHAR (4)      
					,[RawOperator]                   VARCHAR (128)    
					,[Section]                       VARCHAR (8)      
					,[StateProvince]                 VARCHAR (8)      
					,[SubmittedDate]                 DATETIME         
					,[SurfaceLatLongSource]          VARCHAR (128)    
					,[Survey]                        VARCHAR (64)     
					,[Township]                      VARCHAR (8)      
					,[Trajectory]                    VARCHAR (16)     
					,[UpdatedDate]                   DATETIME         
					,[WellId]                        BIGINT           
					,[WellName]                      VARCHAR (128)    
					,[WellNumber]                    VARCHAR (64)     
					,[WellType]                      VARCHAR (32)     

					,ETL_Load_Date						DATETIME
				  
					,INDEX idx_tempdb_Permit_PermitID
						NONCLUSTERED (
							PermitID
						)
				  )

			------------------------------------------------------------------------
			-- Save Permit data
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Save Permit data')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				--------------------------------------------------------------------
				-- Unpack Permit JSON
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Unpack Permit JSON')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					INSERT INTO #Permit (
						 _duplicate
						,_error
						,_delete

						,[Abstract]                      
						,[Amended_Date]                  
						,[API_UWI]                       
						,[API_UWI_Unformatted]           
						,[ApprovedDate]                  
						,[Block]                         
						,[ContactName]                   
						,[ContactPhone]                  
						,[Country]                       
						,[County]                        
						,[DeletedDate]                   
						,[District]                      
						,[ENVBasin]                      
						,[ENVInterval]                   
						,[ENVOperator]                   
						,[ENVPeerGroup]                  
						,[ENVPlay]                       
						,[ENVRegion]                     
						,[ENVStockExchange]              
						,[ENVTicker]                     
						,[ENVWellStatus]                 
						,[ExpiredDate]                   
						,[Field]                         
						,[Formation]                     
						,[H2SArea]                       
						,[Latitude]                      
						,[Latitude_BH]                   
						,[Lease_Acres]                   
						,[LeaseName]                     
						,[LeaseNumber]                   
						,[Longitude]                     
						,[Longitude_BH]                  
						,[OperatorAddress]               
						,[OperatorCity]                  
						,[OperatorCity_30mi]             
						,[OperatorCity_50mi]             
						,[OperatorState]                 
						,[OperatorZip]                   
						,[PadID]                         
						,[PermitDepth_FT]                
						,[PermitID]                      
						,[PermitNumber]                  
						,[PermitStatus]                  
						,[PermittedLateralLength_FT]     
						,[PermittedLateralLengthSource]  
						,[PermittedMeasuredDepth_FT]     
						,[PermittedTrueVerticalDepth_FT] 
						,[PermitType]                    
						,[Range]                         
						,[RawOperator]                   
						,[Section]                       
						,[StateProvince]                 
						,[SubmittedDate]                 
						,[SurfaceLatLongSource]          
						,[Survey]                        
						,[Township]                      
						,[Trajectory]                    
						,[UpdatedDate]                   
						,[WellId]                        
						,[WellName]                      
						,[WellNumber]                    
						,[WellType]      
						,[GeomBHL_Point]                 
						,[GeomPermitted_Line]            
						,[GeomSHL_Point]                 


						,ETL_Load_Date
						)
					SELECT
						 _duplicate = count(*) OVER (PARTITION BY t0.PermitID)-1
						,_error		= 0
						,_delete			BIT

						,Abstract                      
						,Amended_Date                  
						,API_UWI                       
						,API_UWI_Unformatted           
						,ApprovedDate                  
						,Block                         
						,ContactName                   
						,ContactPhone                  
						,Country                       
						,County                        
						,DeletedDate                   
						,District                      
						,ENVBasin                      
						,ENVInterval                   
						,ENVOperator                   
						,ENVPeerGroup                  
						,ENVPlay                       
						,ENVRegion                     
						,ENVStockExchange              
						,ENVTicker                     
						,ENVWellStatus                 
						,ExpiredDate                   
						,Field                         
						,Formation                     
						,H2SArea                       
						,Latitude                      
						,Latitude_BH                   
						,Lease_Acres                   
						,LeaseName                     
						,LeaseNumber                   
						,Longitude                     
						,Longitude_BH                  
						,OperatorAddress               
						,OperatorCity                  
						,OperatorCity_30mi             
						,OperatorCity_50mi             
						,OperatorState                 
						,OperatorZip                   
						,PadID                         
						,PermitDepth_FT                
						,PermitID                      
						,PermitNumber                  
						,PermitStatus                  
						,PermittedLateralLength_FT     
						,PermittedLateralLengthSource  
						,PermittedMeasuredDepth_FT     
						,PermittedTrueVerticalDepth_FT 
						,PermitType                    
						,Range                         
						,RawOperator                   
						,Section                       
						,StateProvince                 
						,SubmittedDate                 
						,SurfaceLatLongSource          
						,Survey                        
						,Township                      
						,Trajectory                    
						,UpdatedDate                   
						,WellId                        
						,WellName                      
						,WellNumber                    
						,WellType                 
						,t1.GeoData GeomBHL_Point
						,t2.GeoData GeomPermitted_Line
						,t3.GeoData GeomSHL_Point

						,sysdatetime()
					FROM
						OPENJSON(@data)
						WITH (
							 _delete						 BIT

							,Abstract						VARCHAR (8)      
							,Amended_Date					DATETIME         
							,API_UWI						VARCHAR (32)     
							,API_UWI_Unformatted			VARCHAR (32)     
							,ApprovedDate					DATETIME         
							,Block							VARCHAR (16)     
							,ContactName					VARCHAR (128)    
							,ContactPhone					VARCHAR (32)     
							,Country						VARCHAR (64)     
							,County							VARCHAR (64)     
							,DeletedDate					DATETIME         
							,District						VARCHAR (16)     
							,ENVBasin						VARCHAR (64)     
							,ENVInterval					VARCHAR (128)    
							,ENVOperator					VARCHAR (256)    
							,ENVPeerGroup					VARCHAR (64)     
							,ENVPlay						VARCHAR (128)    
							,ENVRegion						VARCHAR (32)     
							,ENVStockExchange				VARCHAR (32)     
							,ENVTicker						VARCHAR (8)      
							,ENVWellStatus					VARCHAR (64)     
							,ExpiredDate					DATETIME         
							,Field							VARCHAR (64)     
							,Formation						VARCHAR (256)    
							,GeomBHL_Point					VARCHAR (MAX) 
							,GeomPermitted_Line				VARCHAR (max) 
							,GeomSHL_Point					VARCHAR (MAX)
							,H2SArea						INT              
							,Latitude						FLOAT (53)       
							,Latitude_BH					FLOAT (53)       
							,Lease_Acres					FLOAT (53)       
							,LeaseName						VARCHAR (64)     
							,LeaseNumber					VARCHAR (64)     
							,Longitude						FLOAT (53)       
							,Longitude_BH					FLOAT (53)       
							,OperatorAddress				VARCHAR (128)    
							,OperatorCity					VARCHAR (32)     
							,OperatorCity_30mi				VARCHAR (16)     
							,OperatorCity_50mi				VARCHAR (16)     
							,OperatorState					VARCHAR (16)     
							,OperatorZip					VARCHAR (16)     
							,PadID							VARCHAR (128)    
							,PermitDepth_FT					INT              
							,PermitID						INT              
							,PermitNumber					VARCHAR (32)     
							,PermitStatus					VARCHAR (16)     
							,PermittedLateralLength_FT		FLOAT (53)       
							,PermittedLateralLengthSource	VARCHAR (16)     
							,PermittedMeasuredDepth_FT		INT              
							,PermittedTrueVerticalDepth_FT	INT              
							,PermitType						VARCHAR (16)     
							,Range							VARCHAR (4)      
							,RawOperator					VARCHAR (128)    
							,Section						VARCHAR (8)      
							,StateProvince					VARCHAR (8)      
							,SubmittedDate					DATETIME         
							,SurfaceLatLongSource			VARCHAR (128)    
							,Survey							VARCHAR (64)     
							,Township						VARCHAR (8)      
							,Trajectory						VARCHAR (16)     
							,UpdatedDate					DATETIME         
							,WellId							BIGINT           
							,WellName						VARCHAR (128)    
							,WellNumber						VARCHAR (64)     
							,WellType						VARCHAR (32)     

							--,ETL_Load_Date		DATETIME
						) t0
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.GeomBHL_Point) t1
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.GeomPermitted_Line) t2
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.GeomSHL_Point) t3

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Validate Permit data
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Validate Permit data')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					UPDATE #Permit SET 
						 _delete	= coalesce(_delete, 0)
						,_error		= CASE 
										-- Set error true if duplicate detected
										WHEN _duplicate = 1 THEN 1
										
										-- Set error true if PermitID is null or empty string
										--WHEN PermitID IS NULL OR PermitID = '' THEN 1
										WHEN PermitID IS NULL THEN 1
										ELSE 0
									  END
						,_message	=   -- Add error message duplicate detected
									+ CASE WHEN _duplicate = 1 THEN '[ERROR: There were one or more records with the same PermitID this record will be ignored ( '+PermitID+')];' ELSE '' END
									+ CASE WHEN PermitID IS NULL OR PermitID = '' THEN '[ERROR: PermitID cannot be null or empty string)];' ELSE '' END
								
					
					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Save data to data.Permit
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Save data to data.Permit')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					----------------------------------------------------------------
					-- Process Deletes
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Permit; Process Deletes')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						DELETE t0
						FROM
							data.Permit t0

							INNER JOIN #Permit t1
							   ON t0.PermitID = t1.PermitID

						WHERE 1=1
							AND t1.DeletedDate is null
							AND t1._delete = 1
							AND t1._error = 0

						SET @ErrPos += concat(' [ ',@@rowcount,' ]')
						PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Updates
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Permit; Process Updates')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						UPDATE t0 SET	
							 [Abstract]                      = t1.[Abstract]                      
							,[Amended_Date]                  = t1.[Amended_Date]                  
							,[API_UWI]                       = t1.[API_UWI]                       
							,[API_UWI_Unformatted]           = t1.[API_UWI_Unformatted]           
							,[ApprovedDate]                  = t1.[ApprovedDate]                  
							,[Block]                         = t1.[Block]                         
							,[ContactName]                   = t1.[ContactName]                   
							,[ContactPhone]                  = t1.[ContactPhone]                  
							,[Country]                       = t1.[Country]                       
							,[County]                        = t1.[County]                        
							,[DeletedDate]                   = t1.[DeletedDate]                   
							,[District]                      = t1.[District]                      
							,[ENVBasin]                      = t1.[ENVBasin]                      
							,[ENVInterval]                   = t1.[ENVInterval]                   
							,[ENVOperator]                   = t1.[ENVOperator]                   
							,[ENVPeerGroup]                  = t1.[ENVPeerGroup]                  
							,[ENVPlay]                       = t1.[ENVPlay]                       
							,[ENVRegion]                     = t1.[ENVRegion]                     
							,[ENVStockExchange]              = t1.[ENVStockExchange]              
							,[ENVTicker]                     = t1.[ENVTicker]                     
							,[ENVWellStatus]                 = t1.[ENVWellStatus]                 
							,[ExpiredDate]                   = t1.[ExpiredDate]                   
							,[Field]                         = t1.[Field]                         
							,[Formation]                     = t1.[Formation]    
							,[GeomBHL_Point]				 = t1.[GeomBHL_Point]                 
							,[GeomPermitted_Line]			 = t1.[GeomPermitted_Line]            
							,[GeomSHL_Point]				 = t1.[GeomSHL_Point]   
							,[H2SArea]                       = t1.[H2SArea]                       
							,[Latitude]                      = t1.[Latitude]                      
							,[Latitude_BH]                   = t1.[Latitude_BH]                   
							,[Lease_Acres]                   = t1.[Lease_Acres]                   
							,[LeaseName]                     = t1.[LeaseName]                     
							,[LeaseNumber]                   = t1.[LeaseNumber]                   
							,[Longitude]                     = t1.[Longitude]                     
							,[Longitude_BH]                  = t1.[Longitude_BH]                  
							,[OperatorAddress]               = t1.[OperatorAddress]               
							,[OperatorCity]                  = t1.[OperatorCity]                  
							,[OperatorCity_30mi]             = t1.[OperatorCity_30mi]             
							,[OperatorCity_50mi]             = t1.[OperatorCity_50mi]             
							,[OperatorState]                 = t1.[OperatorState]                 
							,[OperatorZip]                   = t1.[OperatorZip]                   
							,[PadID]                         = t1.[PadID]                         
							,[PermitDepth_FT]                = t1.[PermitDepth_FT]                
							,[PermitID]                      = t1.[PermitID]                      
							,[PermitNumber]                  = t1.[PermitNumber]                  
							,[PermitStatus]                  = t1.[PermitStatus]                  
							,[PermittedLateralLength_FT]     = t1.[PermittedLateralLength_FT]     
							,[PermittedLateralLengthSource]  = t1.[PermittedLateralLengthSource]  
							,[PermittedMeasuredDepth_FT]     = t1.[PermittedMeasuredDepth_FT]     
							,[PermittedTrueVerticalDepth_FT] = t1.[PermittedTrueVerticalDepth_FT] 
							,[PermitType]                    = t1.[PermitType]                    
							,[Range]                         = t1.[Range]                         
							,[RawOperator]                   = t1.[RawOperator]                   
							,[Section]                       = t1.[Section]                       
							,[StateProvince]                 = t1.[StateProvince]                 
							,[SubmittedDate]                 = t1.[SubmittedDate]                 
							,[SurfaceLatLongSource]          = t1.[SurfaceLatLongSource]          
							,[Survey]                        = t1.[Survey]                        
							,[Township]                      = t1.[Township]                      
							,[Trajectory]                    = t1.[Trajectory]                    
							,[UpdatedDate]                   = t1.[UpdatedDate]                   
							,[WellId]                        = t1.[WellId]                        
							,[WellName]                      = t1.[WellName]                      
							,[WellNumber]                    = t1.[WellNumber]                    
							,[WellType]                      = t1.[WellType]                      
					
							
							--,ETL_Load_Date				= t1.ETL_Load_Date

						FROM
							data.Permit t0

							INNER JOIN #Permit t1
								ON t0.PermitID = t1.PermitID

						WHERE 1=1
							AND t1._delete = 0
							AND t1._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Inserts
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Permit; Process Inserts')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						INSERT INTO data.Permit ( 
							  [Abstract]                       
							 ,[Amended_Date]                   
							 ,[API_UWI]                        
							 ,[API_UWI_Unformatted]            
							 ,[ApprovedDate]                   
							 ,[Block]                          
							 ,[ContactName]                    
							 ,[ContactPhone]                   
							 ,[Country]                        
							 ,[County]                         
							 ,[DeletedDate]                    
							 ,[District]                       
							 ,[ENVBasin]                       
							 ,[ENVInterval]                    
							 ,[ENVOperator]                    
							 ,[ENVPeerGroup]                   
							 ,[ENVPlay]                        
							 ,[ENVRegion]                      
							 ,[ENVStockExchange]               
							 ,[ENVTicker]                      
							 ,[ENVWellStatus]                  
							 ,[ExpiredDate]                    
							 ,[Field]                          
							 ,[Formation]           
							 ,[GeomBHL_Point]     
							 ,[GeomPermitted_Line]
							 ,[GeomSHL_Point]     
							 ,[H2SArea]                        
							 ,[Latitude]                       
							 ,[Latitude_BH]                    
							 ,[Lease_Acres]                    
							 ,[LeaseName]                      
							 ,[LeaseNumber]                    
							 ,[Longitude]                      
							 ,[Longitude_BH]                   
							 ,[OperatorAddress]                
							 ,[OperatorCity]                   
							 ,[OperatorCity_30mi]              
							 ,[OperatorCity_50mi]              
							 ,[OperatorState]                  
							 ,[OperatorZip]                    
							 ,[PadID]                          
							 ,[PermitDepth_FT]                 
							 ,[PermitID]                       
							 ,[PermitNumber]                   
							 ,[PermitStatus]                   
							 ,[PermittedLateralLength_FT]      
							 ,[PermittedLateralLengthSource]   
							 ,[PermittedMeasuredDepth_FT]      
							 ,[PermittedTrueVerticalDepth_FT]  
							 ,[PermitType]                     
							 ,[Range]                          
							 ,[RawOperator]                    
							 ,[Section]                        
							 ,[StateProvince]                  
							 ,[SubmittedDate]                  
							 ,[SurfaceLatLongSource]           
							 ,[Survey]                         
							 ,[Township]                       
							 ,[Trajectory]                     
							 ,[UpdatedDate]                    
							 ,[WellId]                         
							 ,[WellName]                       
							 ,[WellNumber]                     
							 ,[WellType]                       
					
							,ETL_Load_Date
							)
						SELECT					
							[Abstract]                      = t0.[Abstract]                     
						   ,[Amended_Date]                  = t0.[Amended_Date]                 
						   ,[API_UWI]                       = t0.[API_UWI]                      
						   ,[API_UWI_Unformatted]           = t0.[API_UWI_Unformatted]          
						   ,[ApprovedDate]                  = t0.[ApprovedDate]                 
						   ,[Block]                         = t0.[Block]                        
						   ,[ContactName]                   = t0.[ContactName]                  
						   ,[ContactPhone]                  = t0.[ContactPhone]                 
						   ,[Country]                       = t0.[Country]                      
						   ,[County]                        = t0.[County]                       
						   ,[DeletedDate]                   = t0.[DeletedDate]                  
						   ,[District]                      = t0.[District]                     
						   ,[ENVBasin]                      = t0.[ENVBasin]                     
						   ,[ENVInterval]                   = t0.[ENVInterval]                  
						   ,[ENVOperator]                   = t0.[ENVOperator]                  
						   ,[ENVPeerGroup]                  = t0.[ENVPeerGroup]                 
						   ,[ENVPlay]                       = t0.[ENVPlay]                      
						   ,[ENVRegion]                     = t0.[ENVRegion]                    
						   ,[ENVStockExchange]              = t0.[ENVStockExchange]             
						   ,[ENVTicker]                     = t0.[ENVTicker]                    
						   ,[ENVWellStatus]                 = t0.[ENVWellStatus]                
						   ,[ExpiredDate]                   = t0.[ExpiredDate]                  	
						   ,[Field]                         = t0.[Field]                        
						   ,[Formation]                     = t0.[Formation]
						   ,[GeomBHL_Point]				= t0.[GeomBHL_Point]     
						   ,[GeomPermitted_Line]			= t0.[GeomPermitted_Line]
						   ,[GeomSHL_Point]				= t0.[GeomSHL_Point]     
						   ,[H2SArea]                       = t0.[H2SArea]                      
						   ,[Latitude]                      = t0.[Latitude]                     
						   ,[Latitude_BH]                   = t0.[Latitude_BH]                  
						   ,[Lease_Acres]                   = t0.[Lease_Acres]                  
						   ,[LeaseName]                     = t0.[LeaseName]                    
						   ,[LeaseNumber]                   = t0.[LeaseNumber]                  
						   ,[Longitude]                     = t0.[Longitude]                    
						   ,[Longitude_BH]                  = t0.[Longitude_BH]                 
						   ,[OperatorAddress]               = t0.[OperatorAddress]              
						   ,[OperatorCity]                  = t0.[OperatorCity]                 
						   ,[OperatorCity_30mi]             = t0.[OperatorCity_30mi]            
						   ,[OperatorCity_50mi]             = t0.[OperatorCity_50mi]            
						   ,[OperatorState]                 = t0.[OperatorState]                
						   ,[OperatorZip]                   = t0.[OperatorZip]                  
						   ,[PadID]                         = t0.[PadID]                        
						   ,[PermitDepth_FT]                = t0.[PermitDepth_FT]               
						   ,[PermitID]                      = t0.[PermitID]                     
						   ,[PermitNumber]                  = t0.[PermitNumber]                 
						   ,[PermitStatus]                  = t0.[PermitStatus]                 
						   ,[PermittedLateralLength_FT]     = t0.[PermittedLateralLength_FT]    
						   ,[PermittedLateralLengthSource]  = t0.[PermittedLateralLengthSource] 
						   ,[PermittedMeasuredDepth_FT]     = t0.[PermittedMeasuredDepth_FT]    
						   ,[PermittedTrueVerticalDepth_FT] = t0.[PermittedTrueVerticalDepth_FT]
						   ,[PermitType]                    = t0.[PermitType]                   
						   ,[Range]                         = t0.[Range]                        
						   ,[RawOperator]                   = t0.[RawOperator]                  
						   ,[Section]                       = t0.[Section]                      
						   ,[StateProvince]                 = t0.[StateProvince]                
						   ,[SubmittedDate]                 = t0.[SubmittedDate]                
						   ,[SurfaceLatLongSource]          = t0.[SurfaceLatLongSource]         
						   ,[Survey]                        = t0.[Survey]                       
						   ,[Township]                      = t0.[Township]                     
						   ,[Trajectory]                    = t0.[Trajectory]                   
						   ,[UpdatedDate]                   = t0.[UpdatedDate]                  
						   ,[WellId]                        = t0.[WellId]                       
						   ,[WellName]                      = t0.[WellName]                     
						   ,[WellNumber]                    = t0.[WellNumber]                   
						   ,[WellType]                      = t0.[WellType]                     

							,ETL_Load_Date					= t0.ETL_Load_Date				
						FROM
							#Permit t0

							LEFT OUTER JOIN data.Permit t1
								ON t0.PermitID = t1.PermitID

						WHERE 1=1
							AND t1.PermitID		IS NULL

							AND t0._delete = 0
							AND t0._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Error Output
				--------------------------------------------------------------------
					IF @NoOutput = 0
					BEGIN
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Permit')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						SELECT 
							 _row_id
                            ,_delete
                            ,_error
                            ,_message

							,[Abstract]                     
							,[Amended_Date]                 
							,[API_UWI]                      
							,[API_UWI_Unformatted]          
							,[ApprovedDate]                 
							,[Block]                        
							,[ContactName]                  
							,[ContactPhone]                 
							,[Country]                      
							,[County]                       
							,[DeletedDate]                  
							,[District]                     
							,[ENVBasin]                     
							,[ENVInterval]                  
							,[ENVOperator]                  
							,[ENVPeerGroup]                 
							,[ENVPlay]                      
							,[ENVRegion]                    
							,[ENVStockExchange]             
							,[ENVTicker]                    
							,[ENVWellStatus]                
							,[ExpiredDate]                  
							,[Field]                        
							,[Formation]                    
							,[GeomBHL_Point]                
							,[GeomPermitted_Line]           
							,[GeomSHL_Point]                
							,[H2SArea]                      
							,[Latitude]                     
							,[Latitude_BH]                  
							,[Lease_Acres]                  
							,[LeaseName]                    
							,[LeaseNumber]                  
							,[Longitude]                    
							,[Longitude_BH]                 
							,[OperatorAddress]              
							,[OperatorCity]                 
							,[OperatorCity_30mi]            
							,[OperatorCity_50mi]            
							,[OperatorState]                
							,[OperatorZip]                  
							,[PadID]                        
							,[PermitDepth_FT]               
							,[PermitID]                     
							,[PermitNumber]                 
							,[PermitStatus]                 
							,[PermittedLateralLength_FT]    
							,[PermittedLateralLengthSource] 
							,[PermittedMeasuredDepth_FT]    
							,[PermittedTrueVerticalDepth_FT]
							,[PermitType]                   
							,[Range]                        
							,[RawOperator]                  
							,[Section]                      
							,[StateProvince]                
							,[SubmittedDate]                
							,[SurfaceLatLongSource]         
							,[Survey]                       
							,[Township]                     
							,[Trajectory]                   
							,[UpdatedDate]                  
							,[WellId]                       
							,[WellName]                     
							,[WellNumber]                   
							,[WellType]                     
					
							,ETL_Load_Date
						FROM 
							#Permit
						WHERE 1=1
							AND _error = 1

						SET @ErrPos += concat(' [ ',@@rowcount,' ]')
						PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)
					END

		END TRY
		BEGIN CATCH
			-- Errors here are fatal; format and throw exception to caller
			SET @ErrMsg = concat('Failed to ',@ErrPos,'  { ',error_number(),' } ',error_message())
			PRINT concat(sysdatetime(),' | *ERR | ',@ErrMsg);
			THROW 2147483647,@ErrMsg,1;
		END CATCH	
		
		PRINT concat(sysdatetime(),' | INFO | ',@MsgTitle, '; *** Completed ***')
END