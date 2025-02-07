/***********************************************************************************

	Procedure Name:		sync.spLandtracUnit
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
CREATE PROCEDURE sync.spSaveLandtracUnit (
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

				  -- #LandtracUnit
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; #LandtracUnit')
			  
				  DROP TABLE IF EXISTS #LandtracUnit
				  CREATE TABLE #LandtracUnit (
					 _row_id						BIGINT IDENTITY(1,1)	NOT NULL	PRIMARY KEY CLUSTERED
					,_delete						BIT			NULL
					,_duplicate						BIT			NULL
					,_error							BIT			NULL
					,_message						VARCHAR		NULL

					,Abstract						VARCHAR(16)  NULL
					,API_UWI					  	VARCHAR(32)  NULL
					,API_UWI_Unformatted			VARCHAR(32)  NOT NULL
					,AreaAcres						FLOAT(53)	   NULL
					,BottomOfZone_FT				FLOAT(53)	   NULL
					,CompletionDate					DATETIME	   NULL
					,County							VARCHAR(32)  NULL
					,CumGasProd_Mcf					REAL		   NULL
					,CumOilProd_BBL					REAL		   NULL
					,CumProd_BOE					REAL		   NULL
					,CumWaterProd_BBL				REAL		   NULL
					,CumWHLiquids_PCT				REAL		   NULL
					,DeletedDate					DATETIME	   NULL
					,DrillingEndDate				DATETIME	   NULL
					,ENVBasin						VARCHAR(64)  NULL
					,ENVInterval					VARCHAR(128) NULL
					,ENVOperatorCurrent				VARCHAR(256) NULL
					,ENVOperatorPermitted			VARCHAR(256) NULL
					,ENVPeerGroupPermitted			VARCHAR(64)  NULL
					,ENVPlay						VARCHAR(128) NULL
					,ENVRegion						VARCHAR(32)  NULL
					,ENVStockExchangePermitted		VARCHAR(32)  NULL
					,ENVTickerPermitted				VARCHAR(128) NULL
					,ENVWellStatus					VARCHAR(64)  NULL
					,EURWHMBOE						FLOAT(53)	   NULL
					,FirstProdDate					DATETIME	   NULL
					,GasEURWH_BCF					FLOAT(53)	   NULL
					,Geom_Poly						sys.GEOMETRY NULL
					,GOR_SCFPerBBL					REAL		   NULL
					,Instrument						VARCHAR(32)  NULL
					,LandUnitID_TX					VARCHAR(256) NULL
					,LeaseNumber					VARCHAR(256) NULL
					,OilEURWH_MBBL					FLOAT(53)	   NULL
					,PermitApprovedDate				DATETIME	   NULL
					,PermitSubmittedDate			DATETIME	   NULL
					,RAWOperatorPermitted			VARCHAR(256) NULL
					,RigReleaseDate					DATETIME	   NULL
					,SpudDate						DATETIME	   NULL
					,StateProvince					VARCHAR(32)  NULL
					,TestDate						DATETIME	   NULL
					,TopOfZone_FT					FLOAT(53)	   NULL
					,Trajectory						VARCHAR(64)  NULL
					,UnitName						VARCHAR(128) NULL
					,UpdatedDate					DATETIME	   NULL
					,WellID							BIGINT	   NULL
					,WellName						VARCHAR(256) NULL


					,ETL_Load_Date					DATETIME	 NULL
				  
					,INDEX idx_tempdb_LandtracUnit_API_UWI_Unformatted
						NONCLUSTERED (
							API_UWI_Unformatted
						)
				  )

			------------------------------------------------------------------------
			-- Save LandtracUnit data
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Save LandtracUnit data')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				--------------------------------------------------------------------
				-- Unpack LandtracUnit JSON
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Unpack LandtracUnit JSON')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					INSERT INTO #LandtracUnit (
						 _duplicate
						,_error
						,_delete

						,Abstract						
						,API_UWI					  	
						,API_UWI_Unformatted			
						,AreaAcres						
						,BottomOfZone_FT				
						,CompletionDate					
						,County							
						,CumGasProd_Mcf					
						,CumOilProd_BBL					
						,CumProd_BOE					
						,CumWaterProd_BBL				
						,CumWHLiquids_PCT				
						,DeletedDate					
						,DrillingEndDate				
						,ENVBasin						
						,ENVInterval					
						,ENVOperatorCurrent				
						,ENVOperatorPermitted			
						,ENVPeerGroupPermitted			
						,ENVPlay						
						,ENVRegion						
						,ENVStockExchangePermitted		
						,ENVTickerPermitted				
						,ENVWellStatus					
						,EURWHMBOE						
						,FirstProdDate					
						,GasEURWH_BCF					
						,GOR_SCFPerBBL					
						,Instrument						
						,LandUnitID_TX					
						,LeaseNumber					
						,OilEURWH_MBBL					
						,PermitApprovedDate				
						,PermitSubmittedDate			
						,RAWOperatorPermitted			
						,RigReleaseDate					
						,SpudDate						
						,StateProvince					
						,TestDate						
						,TopOfZone_FT					
						,Trajectory						
						,UnitName						
						,UpdatedDate					
						,WellID							
						,WellName
						,Geom_Poly						

						,ETL_Load_Date
						)
					SELECT
						 _duplicate = count(*) OVER (PARTITION BY t0.API_UWI_Unformatted)-1
						,_error		= 0
						,_delete		bit
						,Abstract						
						,API_UWI					  	
						,API_UWI_Unformatted			
						,AreaAcres						
						,BottomOfZone_FT				
						,CompletionDate					
						,County							
						,CumGasProd_Mcf					
						,CumOilProd_BBL					
						,CumProd_BOE					
						,CumWaterProd_BBL				
						,CumWHLiquids_PCT				
						,DeletedDate					
						,DrillingEndDate				
						,ENVBasin						
						,ENVInterval					
						,ENVOperatorCurrent				
						,ENVOperatorPermitted			
						,ENVPeerGroupPermitted			
						,ENVPlay						
						,ENVRegion						
						,ENVStockExchangePermitted		
						,ENVTickerPermitted				
						,ENVWellStatus					
						,EURWHMBOE						
						,FirstProdDate					
						,GasEURWH_BCF					
						,GOR_SCFPerBBL					
						,Instrument						
						,LandUnitID_TX					
						,LeaseNumber					
						,OilEURWH_MBBL					
						,PermitApprovedDate				
						,PermitSubmittedDate			
						,RAWOperatorPermitted			
						,RigReleaseDate					
						,SpudDate						
						,StateProvince					
						,TestDate						
						,TopOfZone_FT					
						,Trajectory						
						,UnitName						
						,UpdatedDate					
						,WellID							
						,WellName
						,t1.GeoData Geom_Poly


						,sysdatetime()
					FROM
						OPENJSON(@data)
						WITH (
							 _delete						BIT

							,Abstract						VARCHAR(16)  
							,API_UWI					  	VARCHAR(32)  
							,API_UWI_Unformatted			VARCHAR(32)  
							,AreaAcres						FLOAT(53)	 
							,BottomOfZone_FT				FLOAT(53)	 
							,CompletionDate					DATETIME	 
							,County							VARCHAR(32)  
							,CumGasProd_Mcf					REAL		 
							,CumOilProd_BBL					REAL		 
							,CumProd_BOE					REAL		 
							,CumWaterProd_BBL				REAL		 
							,CumWHLiquids_PCT				REAL		 
							,DeletedDate					DATETIME	 
							,DrillingEndDate				DATETIME	 
							,ENVBasin						VARCHAR(64)  
							,ENVInterval					VARCHAR(128) 
							,ENVOperatorCurrent				VARCHAR(256) 
							,ENVOperatorPermitted			VARCHAR(256) 
							,ENVPeerGroupPermitted			VARCHAR(64)  
							,ENVPlay						VARCHAR(128) 
							,ENVRegion						VARCHAR(32)  
							,ENVStockExchangePermitted		VARCHAR(32)  
							,ENVTickerPermitted				VARCHAR(128) 
							,ENVWellStatus					VARCHAR(64)  
							,EURWHMBOE						FLOAT(53)	 
							,FirstProdDate					DATETIME	 
							,GasEURWH_BCF					FLOAT(53)	 
							,Geom_Poly						varchar(max) 
							,GOR_SCFPerBBL					REAL		 
							,Instrument						VARCHAR(32)  
							,LandUnitID_TX					VARCHAR(256) 
							,LeaseNumber					VARCHAR(256) 
							,OilEURWH_MBBL					FLOAT(53)	 
							,PermitApprovedDate				DATETIME	 
							,PermitSubmittedDate			DATETIME	 
							,RAWOperatorPermitted			VARCHAR(256) 
							,RigReleaseDate					DATETIME	 
							,SpudDate						DATETIME	 
							,StateProvince					VARCHAR(32)  
							,TestDate						DATETIME	 
							,TopOfZone_FT					FLOAT(53)	 
							,Trajectory						VARCHAR(64)  
							,UnitName						VARCHAR(128) 
							,UpdatedDate					DATETIME	 
							,WellID							BIGINT
							,WellName						VARCHAR(256) 

							--,ETL_Load_Date		DATETIME
						) t0
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.Geom_Poly) t1

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Validate LandtracUnit data
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Validate LandtracUnit data')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					UPDATE #LandtracUnit SET 
						 _delete	= coalesce(_delete, 0)
						,_error		= CASE 
										-- Set error true if duplicate detected
										WHEN _duplicate = 1 THEN 1
										
										-- Set error true if API_UWI_Unformatted is null or empty string
										WHEN API_UWI_Unformatted IS NULL OR API_UWI_Unformatted = '' THEN 1
										ELSE 0
									  END
						,_message	=   -- Add error message duplicate detected
									+ CASE WHEN _duplicate = 1 THEN '[ERROR: There were one or more records with the same API_UWI_Unformatted this record will be ignored ( '+API_UWI_Unformatted+')];' ELSE '' END
									+ CASE WHEN API_UWI_Unformatted IS NULL OR API_UWI_Unformatted = '' THEN '[ERROR: API_UWI_Unformatted cannot be null or empty string)];' ELSE '' END
								
					
					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Save data to data.LandtracUnit
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Save data to data.LandtracUnit')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					----------------------------------------------------------------
					-- Process Deletes
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.LandtracUnit; Process Deletes')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						DELETE t0
						FROM
							data.LandtracUnit t0

							INNER JOIN #LandtracUnit t1
							   ON t0.API_UWI_Unformatted = t1.API_UWI_Unformatted
							  
						WHERE 1=1
							AND t1.DeletedDate is null
							AND t1._delete = 1
							AND t1._error = 0

						SET @ErrPos += concat(' [ ',@@rowcount,' ]')
						PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Updates
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.LandtracUnit; Process Updates')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						UPDATE t0 SET	
							 Abstract						=t1.Abstract						
							,API_UWI					  	=t1.API_UWI					  	
							,API_UWI_Unformatted			=t1.API_UWI_Unformatted			
							,AreaAcres						=t1.AreaAcres						
							,BottomOfZone_FT				=t1.BottomOfZone_FT				
							,CompletionDate					=t1.CompletionDate					
							,County							=t1.County							
							,CumGasProd_Mcf					=t1.CumGasProd_Mcf					
							,CumOilProd_BBL					=t1.CumOilProd_BBL					
							,CumProd_BOE					=t1.CumProd_BOE					
							,CumWaterProd_BBL				=t1.CumWaterProd_BBL				
							,CumWHLiquids_PCT				=t1.CumWHLiquids_PCT				
							,DeletedDate					=t1.DeletedDate					
							,DrillingEndDate				=t1.DrillingEndDate				
							,ENVBasin						=t1.ENVBasin						
							,ENVInterval					=t1.ENVInterval					
							,ENVOperatorCurrent				=t1.ENVOperatorCurrent				
							,ENVOperatorPermitted			=t1.ENVOperatorPermitted			
							,ENVPeerGroupPermitted			=t1.ENVPeerGroupPermitted			
							,ENVPlay						=t1.ENVPlay						
							,ENVRegion						=t1.ENVRegion						
							,ENVStockExchangePermitted		=t1.ENVStockExchangePermitted		
							,ENVTickerPermitted				=t1.ENVTickerPermitted				
							,ENVWellStatus					=t1.ENVWellStatus					
							,EURWHMBOE						=t1.EURWHMBOE						
							,FirstProdDate					=t1.FirstProdDate					
							,GasEURWH_BCF					=t1.GasEURWH_BCF					
							,Geom_Poly						=t1.Geom_Poly						
							,GOR_SCFPerBBL					=t1.GOR_SCFPerBBL					
							,Instrument						=t1.Instrument						
							,LandUnitID_TX					=t1.LandUnitID_TX					
							,LeaseNumber					=t1.LeaseNumber					
							,OilEURWH_MBBL					=t1.OilEURWH_MBBL					
							,PermitApprovedDate				=t1.PermitApprovedDate				
							,PermitSubmittedDate			=t1.PermitSubmittedDate			
							,RAWOperatorPermitted			=t1.RAWOperatorPermitted			
							,RigReleaseDate					=t1.RigReleaseDate					
							,SpudDate						=t1.SpudDate						
							,StateProvince					=t1.StateProvince					
							,TestDate						=t1.TestDate						
							,TopOfZone_FT					=t1.TopOfZone_FT					
							,Trajectory						=t1.Trajectory						
							,UnitName						=t1.UnitName						
							,UpdatedDate					=t1.UpdatedDate					
							,WellID							=t1.WellID
							,WellName						=t1.WellName
							
							--,ETL_Load_Date					= t1.ETL_Load_Date

						FROM
							data.LandtracUnit t0

							INNER JOIN #LandtracUnit t1
								ON t0.API_UWI_Unformatted = t1.API_UWI_Unformatted

						WHERE 1=1
							AND t1._delete = 0
							AND t1._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Inserts
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.LandtracUnit; Process Inserts')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						INSERT INTO data.LandtracUnit (					
							  Abstract						
							 ,API_UWI					  	
							 ,API_UWI_Unformatted			
							 ,AreaAcres						
							 ,BottomOfZone_FT				
							 ,CompletionDate					
							 ,County							
							 ,CumGasProd_Mcf					
							 ,CumOilProd_BBL					
							 ,CumProd_BOE					
							 ,CumWaterProd_BBL				
							 ,CumWHLiquids_PCT				
							 ,DeletedDate					
							 ,DrillingEndDate				
							 ,ENVBasin						
							 ,ENVInterval					
							 ,ENVOperatorCurrent				
							 ,ENVOperatorPermitted			
							 ,ENVPeerGroupPermitted			
							 ,ENVPlay						
							 ,ENVRegion						
							 ,ENVStockExchangePermitted		
							 ,ENVTickerPermitted				
							 ,ENVWellStatus					
							 ,EURWHMBOE						
							 ,FirstProdDate					
							 ,GasEURWH_BCF					
							 ,Geom_Poly						
							 ,GOR_SCFPerBBL					
							 ,Instrument						
							 ,LandUnitID_TX					
							 ,LeaseNumber					
							 ,OilEURWH_MBBL					
							 ,PermitApprovedDate				
							 ,PermitSubmittedDate			
							 ,RAWOperatorPermitted			
							 ,RigReleaseDate					
							 ,SpudDate						
							 ,StateProvince					
							 ,TestDate						
							 ,TopOfZone_FT					
							 ,Trajectory						
							 ,UnitName						
							 ,UpdatedDate					
							 ,WellID							
							 ,WellName						
						
							,ETL_Load_Date
							)
						SELECT					
							 Abstract					= t0.Abstract					
							,API_UWI					= t0.API_UWI					
							,API_UWI_Unformatted		= t0.API_UWI_Unformatted		
							,AreaAcres					= t0.AreaAcres					
							,BottomOfZone_FT			= t0.BottomOfZone_FT			
							,CompletionDate				= t0.CompletionDate				
							,County						= t0.County						
							,CumGasProd_Mcf				= t0.CumGasProd_Mcf				
							,CumOilProd_BBL				= t0.CumOilProd_BBL				
							,CumProd_BOE				= t0.CumProd_BOE				
							,CumWaterProd_BBL			= t0.CumWaterProd_BBL			
							,CumWHLiquids_PCT			= t0.CumWHLiquids_PCT			
							,DeletedDate				= t0.DeletedDate				
							,DrillingEndDate			= t0.DrillingEndDate			
							,ENVBasin					= t0.ENVBasin					
							,ENVInterval				= t0.ENVInterval				
							,ENVOperatorCurrent			= t0.ENVOperatorCurrent			
							,ENVOperatorPermitted		= t0.ENVOperatorPermitted		
							,ENVPeerGroupPermitted		= t0.ENVPeerGroupPermitted		
							,ENVPlay					= t0.ENVPlay					
							,ENVRegion					= t0.ENVRegion					
							,ENVStockExchangePermitted	= t0.ENVStockExchangePermitted	
							,ENVTickerPermitted			= t0.ENVTickerPermitted			
							,ENVWellStatus				= t0.ENVWellStatus				
							,EURWHMBOE					= t0.EURWHMBOE					
							,FirstProdDate				= t0.FirstProdDate				
							,GasEURWH_BCF				= t0.GasEURWH_BCF				
							,Geom_Poly					= t0.Geom_Poly					
							,GOR_SCFPerBBL				= t0.GOR_SCFPerBBL				
							,Instrument					= t0.Instrument					
							,LandUnitID_TX				= t0.LandUnitID_TX				
							,LeaseNumber				= t0.LeaseNumber				
							,OilEURWH_MBBL				= t0.OilEURWH_MBBL				
							,PermitApprovedDate			= t0.PermitApprovedDate			
							,PermitSubmittedDate		= t0.PermitSubmittedDate		
							,RAWOperatorPermitted		= t0.RAWOperatorPermitted		
							,RigReleaseDate				= t0.RigReleaseDate				
							,SpudDate					= t0.SpudDate					
							,StateProvince				= t0.StateProvince				
							,TestDate					= t0.TestDate					
							,TopOfZone_FT				= t0.TopOfZone_FT				
							,Trajectory					= t0.Trajectory					
							,UnitName					= t0.UnitName					
							,UpdatedDate				= t0.UpdatedDate				
							,WellID						= t0.WellID						
							,WellName					= t0.WellName					

							,ETL_Load_Date			= t0.ETL_Load_Date				
						FROM
							#LandtracUnit t0

							LEFT OUTER JOIN data.LandtracUnit t1
								ON t0.API_UWI_Unformatted = t1.API_UWI_Unformatted

						WHERE 1=1
							AND t1.API_UWI_Unformatted		IS NULL

							AND t0._delete = 0
							AND t0._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Error Output
				--------------------------------------------------------------------
					IF @NoOutput = 0
					BEGIN
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.LandtracUnit')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						SELECT 
							 _row_id
                            ,_delete
                            ,_error
                            ,_message

							,Acres					
							,AssigneeInterest		
							,AssigneeName			
							,AssignmentEffectiveDate
							,AssignmentVolumePage	
							,BLMLease				
							,Bonus					
							,Country				
							,County					
							,CountyCode				
							,DeletedDate			
							,DepthSeveranceType		
							,DocLink				
							,EffectiveDate			
							,ENVBasin				
							,ENVRegion				
							,ENVSubPlay				
							,ExpirationDate			
							,Extension				
							,ExtensionBonus			
							,ExtensionTermMonth		
							,Geom_Poly				
							,GranteeAddress			
							,GranteeAlias			
							,GranteeName			
							,GrantorAddress			
							,GrantorName			
							,HasDepthSeverance		
							,InstrumentDate			
							,InstrumentType			
							,LeaseID				
							,MaximumDepth			
							,MinimumDepth			
							,Nomination				
							,RecordDate				
							,RecordNumber			
							,Royalty				
							,SpatialAssignee		
							,StateCode				
							,StateLease				
							,StateProvince			
							,TermMonths				
							,UpdatedDate			
							,VolumePage				
					
							,ETL_Load_Date
						FROM 
							#LandtracUnit
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