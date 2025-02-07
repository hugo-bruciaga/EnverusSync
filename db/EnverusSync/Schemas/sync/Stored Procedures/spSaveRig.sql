/***********************************************************************************

	Procedure Name:		sync.spSaveRig
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
CREATE PROCEDURE sync.spSaveRig (
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

				  -- #Rig
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; #Rig')
			  
				  DROP TABLE IF EXISTS #Rig
				  CREATE TABLE #Rig (
					 _row_id							BIGINT IDENTITY(1,1)	NOT NULL	PRIMARY KEY CLUSTERED
					,_delete							BIT				NULL
					,_duplicate							BIT				NULL
					,_error								BIT				NULL
					,_message							VARCHAR			NULL
																		
					,Abstract							VARCHAR(16)		NULL
					,ActiveStatus						VARCHAR(8)		NULL
					,API_UWI							VARCHAR(32)		NULL
					,API_UWI_Unformatted				VARCHAR(32)		NULL
					,API_UWI_12							VARCHAR(32)		NULL
					,API_UWI_12_Unformatted				VARCHAR(32)		NULL
					,API_UWI_14							VARCHAR(32)		NULL
					,API_UWI_14_Unformatted				VARCHAR(32)		NULL
					,Block								VARCHAR(64)		NULL
					,CompletionID						BIGINT			NOT NULL
					,CompletionNumber					INT				NULL
					,ContractorName						VARCHAR(64)		NULL
					,CoordinateSource					VARCHAR(64)		NULL
					,Country							VARCHAR(2)		NULL
					,County								VARCHAR(32)		NULL
					,DaysOnLocation						BIGINT			NULL
					,DeletedDate						DATETIME		NULL
					,District							VARCHAR(256)	NULL
					,DrawWorks							VARCHAR(64)		NULL
					,DrillingEndDate					DATETIME		NULL
					,DUC_EndDate						DATETIME		NULL
					,DUC_StartDate						DATETIME		NULL
					,DUC_Status							VARCHAR(32)		NULL
					,ElevationGL_FT						FLOAT(53)		NULL
					,ElevationKB_FT						FLOAT(53)		NULL
					,ENVBasin							VARCHAR(64)		NULL
					,ENVCompInsertedDate				DATETIME		NULL
					,ENVFluidType						VARCHAR(128)	NULL
					,ENVFracJobType						VARCHAR(32)		NULL
					,ENVGasGatherer						VARCHAR(256)	NULL
					,ENVGasGatheringSystem				VARCHAR(256)	NULL
					,ENVInterval						VARCHAR(128)	NULL
					,ENVOilGatherer						VARCHAR(256)	NULL
					,ENVOilGatheringSystem				VARCHAR(256)	NULL
					,ENVOperator						VARCHAR(256)	NULL
					,ENVPlay							VARCHAR(128)	NULL
					,ENVProdWellType					VARCHAR(64)		NULL
					,ENVProppantBrand					VARCHAR(256)	NULL
					,ENVProppantType					VARCHAR(32)		NULL
					,ENVRegion							VARCHAR(32)		NULL
					,ENVSubPlay							VARCHAR(64)		NULL
					,ENVTicker							VARCHAR(128)	NULL
					,ENVWellGrouping					VARCHAR(128)	NULL
					,ENVWellServiceProvider				VARCHAR(256)	NULL
					,ENVWellStatus						VARCHAR(64)		NULL
					,Field								VARCHAR(256)	NULL
					,FirstDay							DATETIME		NULL
					,FootagePerDayWell					FLOAT(53)		NULL
					,Formation							VARCHAR(256)	NULL
					,InitialOperator					VARCHAR(256)	NULL
					,LastDay							DATETIME		NULL
					,Lease								VARCHAR(64)		NULL
					,LeaseName							VARCHAR(256)	NULL
					,MD_FT								FLOAT(53)		NULL
					,Mobility							VARCHAR(8)		NULL
					,MoveDistanceFromLastJob_MI			FLOAT(53)		NULL
					,MoveDistanceToNextJob_MI			FLOAT(53)		NULL
					,NumberOfStrings					INT				NULL
					,OperatorCity						VARCHAR(64)		NULL
					,OperatorCity30mi					VARCHAR(16)		NULL
					,OperatorCity50mi					VARCHAR(16)		NULL
					,PadID								VARCHAR(128)	NULL
					,PermitApprovedDate					DATETIME		NULL
					,PermitSubmittedDate				DATETIME		NULL
					,PermitToSpud_DAYS					BIGINT			NULL
					,Platform							VARCHAR(256)	NULL
					,PowerType							VARCHAR(4)		NULL
					,Range								VARCHAR(32)		NULL
					,RatedHP							INT				NULL
					,RatedWaterDepth					INT				NULL
					,RawOperator						VARCHAR(256)	NULL
					,RigClass							VARCHAR(16)		NULL
					,RigLatitudeWGS84					FLOAT(53)		NULL
					,RigLongitudeWGS84					FLOAT(53)		NULL
					,RigName_Number						VARCHAR(32)		NULL
					,RigReleaseDate						DATETIME		NULL
					,RigType							VARCHAR(32)		NULL
					,Section							VARCHAR(32)		NULL
					,Section_Township_Range				VARCHAR(128)	NULL
					,SoakTime_DAYS						BIGINT			NULL
					,SpudDate							DATETIME		NULL
					,SpudDateSource						VARCHAR(8)		NULL
					,SpudToCompletion_DAYS				BIGINT			NULL
					,SpudToRigRelease_DAYS				BIGINT			NULL
					,SpudToSales_DAYS					BIGINT			NULL
					,StateFileNumber					VARCHAR(256)	NULL
					,StateProvince						VARCHAR(64)		NULL
					,StateWellType						VARCHAR(256)	NULL
					,Township							VARCHAR(32)		NULL
					,Trajectory							VARCHAR(64)		NULL
					,TVD_FT								FLOAT(53)		NULL
					,UpdatedDate						DATETIME		NULL
					,WaterDepth							FLOAT(53)		NULL
					,WellID								BIGINT			NOT NULL
					,WellPadCount						BIGINT			NULL
					,WellPadDirection					VARCHAR(32)		NULL
					,WellPadID							VARCHAR(128)	NULL
				
					
					,ETL_Load_Date						DATETIME		NULL
				  
					,INDEX idx_tempdb_Rig_CompletionID_WellID
						NONCLUSTERED (
							CompletionID, WellID
						)
				  )

			------------------------------------------------------------------------
			-- Save Rig data
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Save Rig data')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				--------------------------------------------------------------------
				-- Unpack Rig JSON
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Unpack Rig JSON')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					INSERT INTO #Rig (
						 _duplicate
						,_error
						,_delete

						,Abstract							
						,ActiveStatus						
						,API_UWI							
						,API_UWI_Unformatted				
						,API_UWI_12							
						,API_UWI_12_Unformatted				
						,API_UWI_14							
						,API_UWI_14_Unformatted				
						,Block								
						,CompletionID						
						,CompletionNumber					
						,ContractorName						
						,CoordinateSource					
						,Country							
						,County								
						,DaysOnLocation						
						,DeletedDate						
						,District							
						,DrawWorks							
						,DrillingEndDate					
						,DUC_EndDate						
						,DUC_StartDate						
						,DUC_Status							
						,ElevationGL_FT						
						,ElevationKB_FT						
						,ENVBasin							
						,ENVCompInsertedDate				
						,ENVFluidType						
						,ENVFracJobType						
						,ENVGasGatherer						
						,ENVGasGatheringSystem				
						,ENVInterval						
						,ENVOilGatherer						
						,ENVOilGatheringSystem				
						,ENVOperator						
						,ENVPlay							
						,ENVProdWellType					
						,ENVProppantBrand					
						,ENVProppantType					
						,ENVRegion							
						,ENVSubPlay							
						,ENVTicker							
						,ENVWellGrouping					
						,ENVWellServiceProvider				
						,ENVWellStatus						
						,Field								
						,FirstDay							
						,FootagePerDayWell					
						,Formation							
						,InitialOperator					
						,LastDay							
						,Lease								
						,LeaseName							
						,MD_FT								
						,Mobility							
						,MoveDistanceFromLastJob_MI			
						,MoveDistanceToNextJob_MI			
						,NumberOfStrings					
						,OperatorCity						
						,OperatorCity30mi					
						,OperatorCity50mi					
						,PadID								
						,PermitApprovedDate					
						,PermitSubmittedDate				
						,PermitToSpud_DAYS					
						,Platform							
						,PowerType							
						,Range								
						,RatedHP							
						,RatedWaterDepth					
						,RawOperator						
						,RigClass							
						,RigLatitudeWGS84					
						,RigLongitudeWGS84					
						,RigName_Number						
						,RigReleaseDate						
						,RigType							
						,Section							
						,Section_Township_Range				
						,SoakTime_DAYS						
						,SpudDate							
						,SpudDateSource						
						,SpudToCompletion_DAYS				
						,SpudToRigRelease_DAYS				
						,SpudToSales_DAYS					
						,StateFileNumber					
						,StateProvince						
						,StateWellType						
						,Township							
						,Trajectory							
						,TVD_FT								
						,UpdatedDate						
						,WaterDepth							
						,WellID								
						,WellPadCount						
						,WellPadDirection					
						,WellPadID							

						,ETL_Load_Date
						)
					SELECT
						 _duplicate = count(*) OVER (PARTITION BY t0.CompletionID, t0.WellID)-1
						,_error		= 0
						,*
						,sysdatetime()
					FROM
						OPENJSON(@data)
						WITH (
							 _delete							BIT

							 ,Abstract							VARCHAR(16)		
							 ,ActiveStatus						VARCHAR(8)		
							 ,API_UWI							VARCHAR(32)		
							 ,API_UWI_Unformatted				VARCHAR(32)		
							 ,API_UWI_12						VARCHAR(32)		
							 ,API_UWI_12_Unformatted			VARCHAR(32)		
							 ,API_UWI_14						VARCHAR(32)		
							 ,API_UWI_14_Unformatted			VARCHAR(32)		
							 ,Block								VARCHAR(64)		
							 ,CompletionID						BIGINT			
							 ,CompletionNumber					INT				
							 ,ContractorName					VARCHAR(64)		
							 ,CoordinateSource					VARCHAR(64)		
							 ,Country							VARCHAR(2)		
							 ,County							VARCHAR(32)		
							 ,DaysOnLocation					BIGINT			
							 ,DeletedDate						DATETIME		
							 ,District							VARCHAR(256)	
							 ,DrawWorks							VARCHAR(64)		
							 ,DrillingEndDate					DATETIME		
							 ,DUC_EndDate						DATETIME		
							 ,DUC_StartDate						DATETIME		
							 ,DUC_Status						VARCHAR(32)		
							 ,ElevationGL_FT					FLOAT(53)		
							 ,ElevationKB_FT					FLOAT(53)		
							 ,ENVBasin							VARCHAR(64)		
							 ,ENVCompInsertedDate				DATETIME		
							 ,ENVFluidType						VARCHAR(128)	
							 ,ENVFracJobType					VARCHAR(32)		
							 ,ENVGasGatherer					VARCHAR(256)	
							 ,ENVGasGatheringSystem				VARCHAR(256)	
							 ,ENVInterval						VARCHAR(128)	
							 ,ENVOilGatherer					VARCHAR(256)	
							 ,ENVOilGatheringSystem				VARCHAR(256)	
							 ,ENVOperator						VARCHAR(256)	
							 ,ENVPlay							VARCHAR(128)	
							 ,ENVProdWellType					VARCHAR(64)		
							 ,ENVProppantBrand					VARCHAR(256)	
							 ,ENVProppantType					VARCHAR(32)		
							 ,ENVRegion							VARCHAR(32)		
							 ,ENVSubPlay						VARCHAR(64)		
							 ,ENVTicker							VARCHAR(128)	
							 ,ENVWellGrouping					VARCHAR(128)	
							 ,ENVWellServiceProvider			VARCHAR(256)	
							 ,ENVWellStatus						VARCHAR(64)		
							 ,Field								VARCHAR(256)	
							 ,FirstDay							DATETIME		
							 ,FootagePerDayWell					FLOAT(53)		
							 ,Formation							VARCHAR(256)	
							 ,InitialOperator					VARCHAR(256)	
							 ,LastDay							DATETIME		
							 ,Lease								VARCHAR(64)		
							 ,LeaseName							VARCHAR(256)	
							 ,MD_FT								FLOAT(53)		
							 ,Mobility							VARCHAR(8)		
							 ,MoveDistanceFromLastJob_MI		FLOAT(53)		
							 ,MoveDistanceToNextJob_MI			FLOAT(53)		
							 ,NumberOfStrings					INT				
							 ,OperatorCity						VARCHAR(64)		
							 ,OperatorCity30mi					VARCHAR(16)		
							 ,OperatorCity50mi					VARCHAR(16)		
							 ,PadID								VARCHAR(128)	
							 ,PermitApprovedDate				DATETIME		
							 ,PermitSubmittedDate				DATETIME		
							 ,PermitToSpud_DAYS					BIGINT			
							 ,Platform							VARCHAR(256)	
							 ,PowerType							VARCHAR(4)		
							 ,Range								VARCHAR(32)		
							 ,RatedHP							INT				
							 ,RatedWaterDepth					INT				
							 ,RawOperator						VARCHAR(256)	
							 ,RigClass							VARCHAR(16)		
							 ,RigLatitudeWGS84					FLOAT(53)		
							 ,RigLongitudeWGS84					FLOAT(53)		
							 ,RigName_Number					VARCHAR(32)		
							 ,RigReleaseDate					DATETIME		
							 ,RigType							VARCHAR(32)		
							 ,Section							VARCHAR(32)		
							 ,Section_Township_Range			VARCHAR(128)	
							 ,SoakTime_DAYS						BIGINT			
							 ,SpudDate							DATETIME		
							 ,SpudDateSource					VARCHAR(8)		
							 ,SpudToCompletion_DAYS				BIGINT			
							 ,SpudToRigRelease_DAYS				BIGINT			
							 ,SpudToSales_DAYS					BIGINT			
							 ,StateFileNumber					VARCHAR(256)	
							 ,StateProvince						VARCHAR(64)		
							 ,StateWellType						VARCHAR(256)	
							 ,Township							VARCHAR(32)		
							 ,Trajectory						VARCHAR(64)		
							 ,TVD_FT							FLOAT(53)		
							 ,UpdatedDate						DATETIME		
							 ,WaterDepth						FLOAT(53)		
							 ,WellID							BIGINT			
							 ,WellPadCount						BIGINT			
							 ,WellPadDirection					VARCHAR(32)		
							 ,WellPadID							VARCHAR(128)	


							--,ETL_Load_Date		DATETIME
						) t0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Validate Rig data
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Validate Rig data')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					UPDATE #Rig SET 
						 _delete	= coalesce(_delete, 0)
						,_error		= CASE 
										-- Set error true if duplicate detected
										WHEN _duplicate = 1 THEN 1
										
										-- Set error true if CompletionID is null or empty string
										WHEN CompletionID IS NULL OR CompletionID = '' THEN 1
										WHEN WellID		  IS NULL OR WellID = '' THEN 1
										ELSE 0
									  END
						,_message	=   -- Add error message duplicate detected
									+ CASE WHEN _duplicate = 1 THEN '[ERROR: There were one or more records with the same CompletionID,WellID this record will be ignored ( '+CompletionID+','+WellID+')];' ELSE '' END
									+ CASE WHEN CompletionID IS NULL OR CompletionID  = '' THEN '[ERROR: CompletionID cannot be null or empty string)];' ELSE '' END
									+ CASE WHEN WellID       IS NULL OR WellID = '' THEN '[ERROR: WellID cannot be null or empty string)];' ELSE '' END
					
					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Save data to data.Rig
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Save data to data.Rig')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					----------------------------------------------------------------
					-- Process Deletes
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Rig; Process Deletes')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						DELETE t0
						FROM
							data.Rig t0

							INNER JOIN #Rig t1
							   ON t0.CompletionID = t1.CompletionID
							AND t0.WellID = t1.WellID
						
						WHERE 1=1
							AND t1.DeletedDate is null
							AND t1._delete = 1
							AND t1._error = 0

						SET @ErrPos += concat(' [ ',@@rowcount,' ]')
						PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Updates
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Rig; Process Updates')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						UPDATE t0 SET
								 [Abstract]                   = t1.[Abstract]                   
								,[ActiveStatus]               = t1.[ActiveStatus]               
								,[API_UWI]                    = t1.[API_UWI]                    
								,[API_UWI_Unformatted]        = t1.[API_UWI_Unformatted]        
								,[API_UWI_12]                 = t1.[API_UWI_12]                 
								,[API_UWI_12_Unformatted]     = t1.[API_UWI_12_Unformatted]     
								,[API_UWI_14]                 = t1.[API_UWI_14]                 
								,[API_UWI_14_Unformatted]     = t1.[API_UWI_14_Unformatted]     
								,[Block]                      = t1.[Block]                      
								,[CompletionID]               = t1.[CompletionID]               
								,[CompletionNumber]           = t1.[CompletionNumber]           
								,[ContractorName]             = t1.[ContractorName]             
								,[CoordinateSource]           = t1.[CoordinateSource]           
								,[Country]                    = t1.[Country]                    
								,[County]                     = t1.[County]                     
								,[DaysOnLocation]             = t1.[DaysOnLocation]             
								,[DeletedDate]                = t1.[DeletedDate]                
								,[District]                   = t1.[District]                   
								,[DrawWorks]                  = t1.[DrawWorks]                  
								,[DrillingEndDate]            = t1.[DrillingEndDate]            
								,[DUC_EndDate]                = t1.[DUC_EndDate]                
								,[DUC_StartDate]              = t1.[DUC_StartDate]              
								,[DUC_Status]                 = t1.[DUC_Status]                 
								,[ElevationGL_FT]             = t1.[ElevationGL_FT]             
								,[ElevationKB_FT]             = t1.[ElevationKB_FT]             
								,[ENVBasin]                   = t1.[ENVBasin]                   
								,[ENVCompInsertedDate]        = t1.[ENVCompInsertedDate]        
								,[ENVFluidType]               = t1.[ENVFluidType]               
								,[ENVFracJobType]             = t1.[ENVFracJobType]             
								,[ENVGasGatherer]             = t1.[ENVGasGatherer]             
								,[ENVGasGatheringSystem]      = t1.[ENVGasGatheringSystem]      
								,[ENVInterval]                = t1.[ENVInterval]                
								,[ENVOilGatherer]             = t1.[ENVOilGatherer]             
								,[ENVOilGatheringSystem]      = t1.[ENVOilGatheringSystem]      
								,[ENVOperator]                = t1.[ENVOperator]                
								,[ENVPlay]                    = t1.[ENVPlay]                    
								,[ENVProdWellType]            = t1.[ENVProdWellType]            
								,[ENVProppantBrand]           = t1.[ENVProppantBrand]           
								,[ENVProppantType]            = t1.[ENVProppantType]            
								,[ENVRegion]                  = t1.[ENVRegion]                  
								,[ENVSubPlay]                 = t1.[ENVSubPlay]                 
								,[ENVTicker]                  = t1.[ENVTicker]                  
								,[ENVWellGrouping]            = t1.[ENVWellGrouping]            
								,[ENVWellServiceProvider]     = t1.[ENVWellServiceProvider]     
								,[ENVWellStatus]              = t1.[ENVWellStatus]              
								,[Field]                      = t1.[Field]                      
								,[FirstDay]                   = t1.[FirstDay]                   
								,[FootagePerDayWell]          = t1.[FootagePerDayWell]          
								,[Formation]                  = t1.[Formation]                  
								,[InitialOperator]            = t1.[InitialOperator]            
								,[LastDay]                    = t1.[LastDay]                    
								,[Lease]                      = t1.[Lease]                      
								,[LeaseName]                  = t1.[LeaseName]                  
								,[MD_FT]                      = t1.[MD_FT]                      
								,[Mobility]                   = t1.[Mobility]                   
								,[MoveDistanceFromLastJob_MI] = t1.[MoveDistanceFromLastJob_MI] 
								,[MoveDistanceToNextJob_MI]   = t1.[MoveDistanceToNextJob_MI]   
								,[NumberOfStrings]            = t1.[NumberOfStrings]            
								,[OperatorCity]               = t1.[OperatorCity]               
								,[OperatorCity30mi]           = t1.[OperatorCity30mi]           
								,[OperatorCity50mi]           = t1.[OperatorCity50mi]           
								,[PadID]                      = t1.[PadID]                      
								,[PermitApprovedDate]         = t1.[PermitApprovedDate]         
								,[PermitSubmittedDate]        = t1.[PermitSubmittedDate]        
								,[PermitToSpud_DAYS]          = t1.[PermitToSpud_DAYS]          
								,[Platform]                   = t1.[Platform]                   
								,[PowerType]                  = t1.[PowerType]                  
								,[Range]                      = t1.[Range]                      
								,[RatedHP]                    = t1.[RatedHP]                    
								,[RatedWaterDepth]            = t1.[RatedWaterDepth]            
								,[RawOperator]                = t1.[RawOperator]                
								,[RigClass]                   = t1.[RigClass]                   
								,[RigLatitudeWGS84]           = t1.[RigLatitudeWGS84]           
								,[RigLongitudeWGS84]          = t1.[RigLongitudeWGS84]          
								,[RigName_Number]             = t1.[RigName_Number]             
								,[RigReleaseDate]             = t1.[RigReleaseDate]             
								,[RigType]                    = t1.[RigType]                    
								,[Section]                    = t1.[Section]                    
								,[Section_Township_Range]     = t1.[Section_Township_Range]     
								,[SoakTime_DAYS]              = t1.[SoakTime_DAYS]              
								,[SpudDate]                   = t1.[SpudDate]                   
								,[SpudDateSource]             = t1.[SpudDateSource]             
								,[SpudToCompletion_DAYS]      = t1.[SpudToCompletion_DAYS]      
								,[SpudToRigRelease_DAYS]      = t1.[SpudToRigRelease_DAYS]      
								,[SpudToSales_DAYS]           = t1.[SpudToSales_DAYS]           
								,[StateFileNumber]            = t1.[StateFileNumber]            
								,[StateProvince]              = t1.[StateProvince]              
								,[StateWellType]              = t1.[StateWellType]              
								,[Township]                   = t1.[Township]                   
								,[Trajectory]                 = t1.[Trajectory]                 
								,[TVD_FT]                     = t1.[TVD_FT]                     
								,[UpdatedDate]                = t1.[UpdatedDate]                
								,[WaterDepth]                 = t1.[WaterDepth]                 
								,[WellID]                     = t1.[WellID]                     
								,[WellPadCount]               = t1.[WellPadCount]               
								,[WellPadDirection]           = t1.[WellPadDirection]           
								,[WellPadID]                  = t1.[WellPadID]                  

								--,ETL_Load_Date			= t1.ETL_Load_Date

						FROM
							data.Rig t0

							INNER JOIN #Rig t1
								ON t0.CompletionID = t1.CompletionID
								AND t0.WellID = t1.WellID 
								
						WHERE 1=1
							AND t1._delete = 0
							AND t1._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Inserts
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Rig; Process Inserts')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						INSERT INTO data.Rig ( 
							 Abstract				   
							,ActiveStatus			   
							,API_UWI					   
							,API_UWI_Unformatted		   
							,API_UWI_12				   
							,API_UWI_12_Unformatted	   
							,API_UWI_14				   
							,API_UWI_14_Unformatted	   
							,Block					   
							,CompletionID			   
							,CompletionNumber		   
							,ContractorName			   
							,CoordinateSource		   
							,Country					   
							,County					   
							,DaysOnLocation			   
							,DeletedDate				   
							,District				   
							,DrawWorks				   
							,DrillingEndDate			   
							,DUC_EndDate				   
							,DUC_StartDate			   
							,DUC_Status				   
							,ElevationGL_FT			   
							,ElevationKB_FT			   
							,ENVBasin				   
							,ENVCompInsertedDate		   
							,ENVFluidType			   
							,ENVFracJobType			   
							,ENVGasGatherer			   
							,ENVGasGatheringSystem	   
							,ENVInterval				   
							,ENVOilGatherer			   
							,ENVOilGatheringSystem	   
							,ENVOperator				   
							,ENVPlay					   
							,ENVProdWellType			   
							,ENVProppantBrand		   
							,ENVProppantType			   
							,ENVRegion				   
							,ENVSubPlay				   
							,ENVTicker				   
							,ENVWellGrouping			   
							,ENVWellServiceProvider	   
							,ENVWellStatus			   
							,Field					   
							,FirstDay				   
							,FootagePerDayWell		   
							,Formation				   
							,InitialOperator			   
							,LastDay					   
							,Lease					   
							,LeaseName				   
							,MD_FT					   
							,Mobility				   
							,MoveDistanceFromLastJob_MI 
							,MoveDistanceToNextJob_MI   
							,NumberOfStrings			   
							,OperatorCity			   
							,OperatorCity30mi		   
							,OperatorCity50mi		   
							,PadID					   
							,PermitApprovedDate		   
							,PermitSubmittedDate		   
							,PermitToSpud_DAYS		   
							,Platform				   
							,PowerType				   
							,Range					   
							,RatedHP					   
							,RatedWaterDepth			   
							,RawOperator				   
							,RigClass				   
							,RigLatitudeWGS84		   
							,RigLongitudeWGS84		   
							,RigName_Number			   
							,RigReleaseDate			   
							,RigType					   
							,Section					   
							,Section_Township_Range	   
							,SoakTime_DAYS			   
							,SpudDate				   
							,SpudDateSource			   
							,SpudToCompletion_DAYS	   
							,SpudToRigRelease_DAYS	   
							,SpudToSales_DAYS		   
							,StateFileNumber			   
							,StateProvince			   
							,StateWellType			   
							,Township				   
							,Trajectory				   
							,TVD_FT					   
							,UpdatedDate				   
							,WaterDepth				   
							,WellID					   
							,WellPadCount			   
							,WellPadDirection		   
							,WellPadID		   
					
							,ETL_Load_Date
							)
						SELECT					
							 Abstract				   		= t0.Abstract				   
							,ActiveStatus			   		= t0.ActiveStatus			   
							,API_UWI					 	= t0.API_UWI					 
							,API_UWI_Unformatted		 	= t0.API_UWI_Unformatted		 
							,API_UWI_12				   		= t0.API_UWI_12				   
							,API_UWI_12_Unformatted	   		= t0.API_UWI_12_Unformatted	   
							,API_UWI_14				   		= t0.API_UWI_14				   
							,API_UWI_14_Unformatted	   		= t0.API_UWI_14_Unformatted	   
							,Block					   		= t0.Block					   
							,CompletionID			   		= t0.CompletionID			   
							,CompletionNumber		   		= t0.CompletionNumber		   
							,ContractorName			   		= t0.ContractorName			   
							,CoordinateSource		   		= t0.CoordinateSource		   
							,Country					 	= t0.Country					 
							,County					   		= t0.County					   
							,DaysOnLocation			   		= t0.DaysOnLocation			   
							,DeletedDate				 	= t0.DeletedDate				 
							,District				   		= t0.District				   
							,DrawWorks				   		= t0.DrawWorks				   
							,DrillingEndDate			 	= t0.DrillingEndDate			 
							,DUC_EndDate				 	= t0.DUC_EndDate				 
							,DUC_StartDate			   		= t0.DUC_StartDate			   
							,DUC_Status				   		= t0.DUC_Status				   
							,ElevationGL_FT			   		= t0.ElevationGL_FT			   
							,ElevationKB_FT			   		= t0.ElevationKB_FT			   
							,ENVBasin				   		= t0.ENVBasin				   
							,ENVCompInsertedDate		 	= t0.ENVCompInsertedDate		 
							,ENVFluidType			   		= t0.ENVFluidType			   
							,ENVFracJobType			   		= t0.ENVFracJobType			   
							,ENVGasGatherer			   		= t0.ENVGasGatherer			   
							,ENVGasGatheringSystem	   		= t0.ENVGasGatheringSystem	   
							,ENVInterval				 	= t0.ENVInterval				 
							,ENVOilGatherer			   		= t0.ENVOilGatherer			   
							,ENVOilGatheringSystem	   		= t0.ENVOilGatheringSystem	   
							,ENVOperator				 	= t0.ENVOperator				 
							,ENVPlay					 	= t0.ENVPlay					 
							,ENVProdWellType			 	= t0.ENVProdWellType			 
							,ENVProppantBrand		   		= t0.ENVProppantBrand		   
							,ENVProppantType			 	= t0.ENVProppantType			 
							,ENVRegion				   		= t0.ENVRegion				   
							,ENVSubPlay				   		= t0.ENVSubPlay				   
							,ENVTicker				   		= t0.ENVTicker				   
							,ENVWellGrouping			 	= t0.ENVWellGrouping			 
							,ENVWellServiceProvider	   		= t0.ENVWellServiceProvider	   
							,ENVWellStatus			   		= t0.ENVWellStatus			   
							,Field					   		= t0.Field					   
							,FirstDay				   		= t0.FirstDay				   
							,FootagePerDayWell		   		= t0.FootagePerDayWell		   
							,Formation				   		= t0.Formation				   
							,InitialOperator			 	= t0.InitialOperator			 
							,LastDay					 	= t0.LastDay					 
							,Lease					   		= t0.Lease					   
							,LeaseName				   		= t0.LeaseName				   
							,MD_FT					   		= t0.MD_FT					   
							,Mobility				   		= t0.Mobility				   
							,MoveDistanceFromLastJob_MI 	= t0.MoveDistanceFromLastJob_MI 
							,MoveDistanceToNextJob_MI   	= t0.MoveDistanceToNextJob_MI   
							,NumberOfStrings			 	= t0.NumberOfStrings			 
							,OperatorCity			   		= t0.OperatorCity			   
							,OperatorCity30mi		   		= t0.OperatorCity30mi		   
							,OperatorCity50mi		   		= t0.OperatorCity50mi		   
							,PadID					   		= t0.PadID					   
							,PermitApprovedDate		   		= t0.PermitApprovedDate		   
							,PermitSubmittedDate		 	= t0.PermitSubmittedDate		 
							,PermitToSpud_DAYS		   		= t0.PermitToSpud_DAYS		   
							,Platform				   		= t0.Platform				   
							,PowerType				   		= t0.PowerType				   
							,Range					   		= t0.Range					   
							,RatedHP					 	= t0.RatedHP					 
							,RatedWaterDepth			 	= t0.RatedWaterDepth			 
							,RawOperator				 	= t0.RawOperator				 
							,RigClass				   		= t0.RigClass				   
							,RigLatitudeWGS84		   		= t0.RigLatitudeWGS84		   
							,RigLongitudeWGS84		   		= t0.RigLongitudeWGS84		   
							,RigName_Number			   		= t0.RigName_Number			   
							,RigReleaseDate			   		= t0.RigReleaseDate			   
							,RigType					 	= t0.RigType					 
							,Section					 	= t0.Section					 
							,Section_Township_Range	   		= t0.Section_Township_Range	   
							,SoakTime_DAYS			   		= t0.SoakTime_DAYS			   
							,SpudDate				   		= t0.SpudDate				   
							,SpudDateSource			   		= t0.SpudDateSource			   
							,SpudToCompletion_DAYS	   		= t0.SpudToCompletion_DAYS	   
							,SpudToRigRelease_DAYS	   		= t0.SpudToRigRelease_DAYS	   
							,SpudToSales_DAYS		   		= t0.SpudToSales_DAYS		   
							,StateFileNumber			 	= t0.StateFileNumber			 
							,StateProvince			   		= t0.StateProvince			   
							,StateWellType			   		= t0.StateWellType			   
							,Township				   		= t0.Township				   
							,Trajectory				   		= t0.Trajectory				   
							,TVD_FT					   		= t0.TVD_FT					   
							,UpdatedDate				 	= t0.UpdatedDate				 
							,WaterDepth				   		= t0.WaterDepth				   
							,WellID					   		= t0.WellID					   
							,WellPadCount			   		= t0.WellPadCount			   
							,WellPadDirection		   		= t0.WellPadDirection		   
							,WellPadID						= t0.WellPadID		   			

							,ETL_Load_Date					= t0.ETL_Load_Date				
						FROM
							#Rig t0

							LEFT OUTER JOIN data.Rig t1
	
								ON t0.CompletionID	= t1.CompletionID
								AND t0.WellID		= t1.WellID

						WHERE 1=1
							AND t1.CompletionID		IS NULL

							AND t0._delete = 0
							AND t0._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Error Output
				--------------------------------------------------------------------
					IF @NoOutput = 0
					BEGIN
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Rig')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						SELECT 
							 _row_id
                            ,_delete
                            ,_error
                            ,_message

							,Abstract				   
							,ActiveStatus			   
							,API_UWI					 
							,API_UWI_Unformatted		 
							,API_UWI_12				   
							,API_UWI_12_Unformatted	   
							,API_UWI_14				   
							,API_UWI_14_Unformatted	   
							,Block					   
							,CompletionID			   
							,CompletionNumber		   
							,ContractorName			   
							,CoordinateSource		   
							,Country					 
							,County					   
							,DaysOnLocation			   
							,DeletedDate				 
							,District				   
							,DrawWorks				   
							,DrillingEndDate			 
							,DUC_EndDate				 
							,DUC_StartDate			   
							,DUC_Status				   
							,ElevationGL_FT			   
							,ElevationKB_FT			   
							,ENVBasin				   
							,ENVCompInsertedDate		 
							,ENVFluidType			   
							,ENVFracJobType			   
							,ENVGasGatherer			   
							,ENVGasGatheringSystem	   
							,ENVInterval				 
							,ENVOilGatherer			   
							,ENVOilGatheringSystem	   
							,ENVOperator				 
							,ENVPlay					 
							,ENVProdWellType			 
							,ENVProppantBrand		   
							,ENVProppantType			 
							,ENVRegion				   
							,ENVSubPlay				   
							,ENVTicker				   
							,ENVWellGrouping			 
							,ENVWellServiceProvider	   
							,ENVWellStatus			   
							,Field					   
							,FirstDay				   
							,FootagePerDayWell		   
							,Formation				   
							,InitialOperator			 
							,LastDay					 
							,Lease					   
							,LeaseName				   
							,MD_FT					   
							,Mobility				   
							,MoveDistanceFromLastJob_MI 
							,MoveDistanceToNextJob_MI   
							,NumberOfStrings			 
							,OperatorCity			   
							,OperatorCity30mi		   
							,OperatorCity50mi		   
							,PadID					   
							,PermitApprovedDate		   
							,PermitSubmittedDate		 
							,PermitToSpud_DAYS		   
							,Platform				   
							,PowerType				   
							,Range					   
							,RatedHP					 
							,RatedWaterDepth			 
							,RawOperator				 
							,RigClass				   
							,RigLatitudeWGS84		   
							,RigLongitudeWGS84		   
							,RigName_Number			   
							,RigReleaseDate			   
							,RigType					 
							,Section					 
							,Section_Township_Range	   
							,SoakTime_DAYS			   
							,SpudDate				   
							,SpudDateSource			   
							,SpudToCompletion_DAYS	   
							,SpudToRigRelease_DAYS	   
							,SpudToSales_DAYS		   
							,StateFileNumber			 
							,StateProvince			   
							,StateWellType			   
							,Township				   
							,Trajectory				   
							,TVD_FT					   
							,UpdatedDate				 
							,WaterDepth				   
							,WellID					   
							,WellPadCount			   
							,WellPadDirection		   
							,WellPadID		   
												
							,ETL_Load_Date
						FROM 
							#Rig
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