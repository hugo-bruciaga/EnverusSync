/***********************************************************************************

	Procedure Name:		sync.spSaveWell
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
CREATE PROCEDURE sync.spSaveWell (
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

				  -- #Well
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; #Well')
			  
				  DROP TABLE IF EXISTS #Well
				  CREATE TABLE #Well (
					 _row_id								BIGINT IDENTITY(1,1)	NOT NULL	PRIMARY KEY CLUSTERED
					,_error									BIT				NULL
					,_delete								BIT				NULL
					,_duplicate								BIT				NULL
					,_message								VARCHAR			NULL
																		
					,Abstract								VARCHAR(16)	 NULL
					,AcidVolume_BBL							REAL		 NULL
					,AlternativeWellName					VARCHAR(128) NULL
					,API_UWI								VARCHAR(32)	 NULL
					,API_UWI_Unformatted					VARCHAR(32)	 NULL
					,API_UWI_12								VARCHAR(32)	 NULL
					,API_UWI_12_Unformatted					VARCHAR(32)	 NULL
					,API_UWI_14								VARCHAR(32)	 NULL
					,API_UWI_14_Unformatted					VARCHAR(32)	 NULL
					,AverageStageSpacing_FT					REAL		 NULL
					,AvgBreakdownPressure_PSI				INT			 NULL
					,AvgClusterSpacing_FT					INT			 NULL
					,AvgClusterSpacingPerStage_FT			INT			 NULL
					,AvgFluidPerCluster_BBL					INT			 NULL
					,AvgFluidPerShot_BBL					INT			 NULL
					,AvgFluidPerStage_BBL					INT			 NULL
					,AvgFracGradient_PSIPerFT				FLOAT(53)	 NULL
					,AvgISIP_PSI							INT			 NULL
					,AvgMillTime_Min						INT			 NULL
					,AvgPortSleeveOpeningPressure_PSI		INT			 NULL
					,AvgProppantPerCluster_LBS				INT			 NULL
					,AvgProppantPerShot_LBS					INT			 NULL
					,AvgProppantPerStage_LBS				INT			 NULL
					,AvgShotsPerCluster						INT			 NULL
					,AvgShotsPerFT							INT			 NULL
					,AvgTreatmentPressure_PSI				INT			 NULL
					,AvgTreatmentRate_BBLPerMin				FLOAT(53)	 NULL
					,Biocide_LBS							REAL		 NULL
					,Block									VARCHAR(64)	 NULL
					,Bottom_Hole_Temp_DEGF					FLOAT(53)	 NULL
					,BottomHoleAge							VARCHAR(64)	 NULL
					,BottomHoleFormationName				VARCHAR(128) NULL
					,BottomHoleLithology					VARCHAR(64)	 NULL
					,Breaker_LBS							REAL		 NULL
					,Buffer_LBS								REAL		 NULL
					,CasingPressure_PSI						REAL		 NULL
					,ChokeSize_64IN							INT			 NULL
					,ClayControl_LBS						REAL		 NULL
					,ClustersPer1000FT						INT			 NULL
					,ClustersPerStage						INT			 NULL
					,CompletionDate							DATETIME	 NULL
					,CompletionDesign						VARCHAR(64)	 NULL
					,CompletionID							BIGINT		 NOT NULL
					,CompletionNumber						INT			 NULL
					,CompletionTime_DAYS					INT			 NULL
					,Contract								VARCHAR(128) NULL
					,CoordinateQuality						VARCHAR(32)	 NULL
					,CoordinateSource						VARCHAR(64)	 NULL
					,Country								VARCHAR(2)	 NULL
					,County									VARCHAR(32)	 NULL
					,CrossLinker_LBS						REAL		 NULL
					,CumGas_MCF								REAL		 NULL
					,CumGas_MCFPer1000FT					REAL		 NULL
					,CumOil_BBL								REAL		 NULL
					,CumOil_BBLPer1000FT					REAL		 NULL
					,CumProd_BOE							REAL		 NULL
					,CumProd_BOEPer1000FT					REAL		 NULL
					,CumProd_MCFE							REAL		 NULL
					,CumProd_MCFEPer1000FT					REAL		 NULL
					,CumulativeSOR							REAL		 NULL
					,CumWater_BBL							REAL		 NULL
					,DeletedDate							DATETIME	 NULL
					,DevelopmentFlag						INT			 NULL
					,DiscoverMagnitudeComments				VARCHAR(256) NULL
					,DiscoveryType							VARCHAR(32)	 NULL
					,District								VARCHAR(256) NULL
					,Diverter_LBS							REAL		 NULL
					,DrillingEndDate						DATETIME	 NULL
					,DrillingTDDate							DATETIME	 NULL
					,DrillingTDDateQualifier				VARCHAR(64)	 NULL
					,ElevationGL_FT							FLOAT(53)	 NULL
					,ElevationKB_FT							FLOAT(53)	 NULL
					,EndDateQualifier						VARCHAR(64)	 NULL
					,Energizer_LBS							REAL		 NULL
					,ENVBasin								VARCHAR(64)	 NULL
					,ENVCompInsertedDate					DATETIME	 NULL
					,ENVElevationGL_FT						FLOAT(53)	 NULL
					,ENVElevationGLSource					VARCHAR(128) NULL
					,ENVElevationKB_FT						FLOAT(53)	 NULL
					,ENVElevationKBSource					VARCHAR(128) NULL
					,ENVFluidType							VARCHAR(128) NULL
					,ENVFracJobType							VARCHAR(32)	 NULL
					,ENVInterval							VARCHAR(128) NULL
					,ENVIntervalSource						VARCHAR(32)	 NULL
					,Environment							VARCHAR(32)	 NULL
					,ENVOperator							VARCHAR(256) NULL
					,ENVPeerGroup							VARCHAR(64)	 NULL
					,ENVPlay								VARCHAR(128) NULL
					,ENVProducingMethod						VARCHAR(256) NULL
					,ENVProdWellType						VARCHAR(64)	 NULL
					,ENVProppantBrand						VARCHAR(256) NULL
					,ENVProppantType						VARCHAR(32)	 NULL
					,ENVRegion								VARCHAR(32)	 NULL
					,ENVStockExchange						VARCHAR(32)	 NULL
					,ENVSubPlay								VARCHAR(64)	 NULL
					,ENVTicker								VARCHAR(128) NULL
					,ENVWellboreType						VARCHAR(256) NULL
					,ENVWellGrouping						VARCHAR(128) NULL
					,ENVWellServiceProvider					VARCHAR(256) NULL
					,ENVWellStatus							VARCHAR(64)	 NULL
					,ENVWellType							VARCHAR(256) NULL
					,ExplorationFlag						INT			 NULL
					,Field									VARCHAR(256) NULL
					,First3MonthFlaredGas_MCF				REAL		 NULL
					,First3MonthGas_MCF						REAL		 NULL
					,First3MonthGas_MCFPer1000FT			REAL		 NULL
					,First3MonthOil_BBL						REAL		 NULL
					,First3MonthOil_BBLPer1000FT			REAL		 NULL
					,First3MonthProd_BOE					REAL		 NULL
					,First3MonthProd_BOEPer1000FT			REAL		 NULL
					,First3MonthProd_MCFE					REAL		 NULL
					,First3MonthProd_MCFEPer1000FT			REAL		 NULL
					,First3MonthWater_BBL					REAL		 NULL
					,First6MonthFlaredGas_MCF				REAL		 NULL
					,First6MonthGas_MCF						REAL		 NULL
					,First6MonthGas_MCFPer1000FT			REAL		 NULL
					,First6MonthOil_BBL						REAL		 NULL
					,First6MonthOil_BBLPer1000FT			REAL		 NULL
					,First6MonthProd_BOE					REAL		 NULL
					,First6MonthProd_BOEPer1000FT			REAL		 NULL
					,First6MonthProd_MCFE					REAL		 NULL
					,First6MonthProd_MCFEPer1000FT			REAL		 NULL
					,First6MonthWater_BBL					REAL		 NULL
					,First9MonthFlaredGas_MCF				REAL		 NULL
					,First9MonthGas_MCF						REAL		 NULL
					,First9MonthGas_MCFPer1000FT			REAL		 NULL
					,First9MonthOil_BBL						REAL		 NULL
					,First9MonthOil_BBLPer1000FT			REAL		 NULL
					,First9MonthProd_BOE					REAL		 NULL
					,First9MonthProd_BOEPer1000FT			REAL		 NULL
					,First9MonthProd_MCFE					REAL		 NULL
					,First9MonthProd_MCFEPer1000FT			REAL		 NULL
					,First9MonthWater_BBL					REAL		 NULL
					,First12MonthFlaredGas_MCF				REAL		 NULL
					,First12MonthGas_MCF					REAL		 NULL
					,First12MonthGas_MCFPer1000FT			REAL		 NULL
					,First12MonthOil_BBL					REAL		 NULL
					,First12MonthOil_BBLPer1000FT			REAL		 NULL
					,First12MonthProd_BOE					REAL		 NULL
					,First12MonthProd_BOEPer1000FT			REAL		 NULL
					,First12MonthProd_MCFE					REAL		 NULL
					,First12MonthProd_MCFEPer1000FT			REAL		 NULL
					,First12MonthWater_BBL					REAL		 NULL
					,First36MonthGas_MCF					FLOAT(53)	 NULL
					,First36MonthGas_MCFPer1000FT			FLOAT(53)	 NULL
					,First36MonthOil_BBL					FLOAT(53)	 NULL
					,First36MonthOil_BBLPer1000FT			FLOAT(53)	 NULL
					,First36MonthProd_BOE					FLOAT(53)	 NULL
					,First36MonthProd_BOEPer1000FT			FLOAT(53)	 NULL
					,First36MonthProd_MCFE					FLOAT(53)	 NULL
					,First36MonthProd_MCFEPer1000FT			FLOAT(53)	 NULL
					,First36MonthWater_BBL					FLOAT(53)	 NULL
					,First36MonthWaterProductionBBLPer1000Ft FLOAT(53)	 NULL
					,FirstDay								DATETIME	 NULL
					,FirstProdDate							DATETIME	 NULL
					,FirstProdMonth							VARCHAR(256) NULL
					,FirstProdQuarter						VARCHAR(16)	 NULL
					,FirstProdYear							VARCHAR(16)	 NULL
					,FlaredGasRatio							REAL		 NULL
					,FlowingTubingPressure_PSI				REAL		 NULL
					,FluidIntensity_BBLPerFT				REAL		 NULL
					,Formation								VARCHAR(256) NULL
					,FracRigOnsiteDate						DATETIME	 NULL
					,FracRigReleaseDate						DATETIME	 NULL
					,FracStages								INT			 NULL
					,FrictionReducer_LBS					REAL		 NULL
					,GasGravity_SG							FLOAT(53)	 NULL
					,GasTestRate_MCFPerDAY					REAL		 NULL
					,GasTestRate_MCFPerDAYPer1000FT			REAL		 NULL
					,GellingAgent_LBS						REAL		 NULL
					,GeneralComments						VARCHAR(256) NULL
					,GeomBHL_Point							sys.GEOMETRY NULL
					,GeomSHL_Point							sys.GEOMETRY NULL
					,GOR_ScfPerBbl							REAL		 NULL
					,GovernmentWellId						VARCHAR(64)	 NULL
					,InitialOperator						VARCHAR(256) NULL
					,IronControl_LBS						REAL		 NULL
					,Last3MonthISOR							REAL		 NULL
					,Last12MonthGasProduction_MCF			REAL		 NULL
					,Last12MonthOilProduction_BBL			REAL		 NULL
					,Last12MonthProduction_BOE				REAL		 NULL
					,Last12MonthWaterProduction_BBL			REAL		 NULL
					,LastMonthFlaredGas_MCF					REAL		 NULL
					,LastMonthGasProduction_MCF				FLOAT(53)	 NULL
					,LastMonthLiquidsProduction_BBL			FLOAT(53)	 NULL
					,LastMonthWaterProduction_BBL			FLOAT(53)	 NULL
					,LastProducingMonth						DATETIME	 NULL
					,LateralLength_FT						REAL		 NULL
					,LateralLine							sys.GEOMETRY NULL
					,Latitude								FLOAT(53)	 NULL
					,Latitude_BH							FLOAT(53)	 NULL
					,Lease									VARCHAR(64)	 NULL
					,LeaseName								VARCHAR(256) NULL
					,Longitude								FLOAT(53)	 NULL
					,Longitude_BH							FLOAT(53)	 NULL
					,LowerPerf_FT							INT			 NULL
					,MD_FT									FLOAT(53)	 NULL
					,MonthsToPeakProduction					BIGINT		 NULL
					,NumberOfStrings						INT			 NULL
					,ObjectiveAge							VARCHAR(128) NULL
					,ObjectiveLithology						VARCHAR(64)	 NULL
					,OffConfidentialDate					DATETIME	 NULL
					,OilGravity_API							FLOAT(53)	 NULL
					,OilProdPriorTest_BBL					FLOAT(53)	 NULL
					,OilTestMethodName						VARCHAR(256) NULL
					,OilTestRate_BBLPerDAY					REAL		 NULL
					,OilTestRate_BBLPerDAYPer1000FT			REAL		 NULL
					,OnConfidential							VARCHAR(1)	 NULL
					,OnOffshore								VARCHAR(32)	 NULL
					,PeakFlaredGas_MCF						REAL		 NULL
					,PeakGas_MCF							REAL		 NULL
					,PeakGas_MCFPer1000FT					REAL		 NULL
					,PeakOil_BBL							REAL		 NULL
					,PeakOil_BBLPer1000FT					REAL		 NULL
					,PeakProd_BOE							REAL		 NULL
					,PeakProd_BOEPer1000FT					REAL		 NULL
					,PeakProd_MCFE							REAL		 NULL
					,PeakProd_MCFEPer1000FT					REAL		 NULL
					,PeakProductionDate						DATETIME	 NULL
					,PeakWater_BBL							REAL		 NULL
					,PerfInterval_FT						INT			 NULL
					,PermitApprovedDate						DATETIME	 NULL
					,PermitSubmittedDate					DATETIME	 NULL
					,PermitToSpud_DAYS						BIGINT		 NULL
					,Platform								VARCHAR(256) NULL
					,PlugbackMeasuredDepth_FT				INT			 NULL
					,PlugbackTrueVerticalDepth_FT			INT			 NULL
					,PlugDate								DATETIME	 NULL
					,Proppant_LBS							FLOAT(53)	 NULL
					,ProppantIntensity_LBSPerFT				REAL		 NULL
					,ProppantLoading_LBSPerGAL				REAL		 NULL
					,Range									VARCHAR(32)	 NULL
					,RawOperator							VARCHAR(256) NULL
					,RawVintage								INT			 NULL
					,ResourceMagnitude						VARCHAR(32)	 NULL
					,ResourceMagnitudeReviewDate			DATETIME	 NULL
					,ResourceSourceQualifier				VARCHAR(64)	 NULL
					,ResourceVolumeGasBcf					VARCHAR(32)	 NULL
					,ResourceVolumeLiquidsMMb				VARCHAR(32)	 NULL
					,RigReleaseDate							DATETIME	 NULL
					,ScaleInhibitor_LBS						REAL		 NULL
					,Section								VARCHAR(32)	 NULL
					,Section_Township_Range					VARCHAR(128) NULL
					,ShotsPer1000FT							INT			 NULL
					,ShotsPerStage							INT			 NULL
					,ShutInPressure_PSI						REAL		 NULL
					,SoakTime_DAYS							BIGINT		 NULL
					,SpudDate								DATETIME	 NULL
					,SpudDateQualifier						VARCHAR(64)	 NULL
					,SpudDateSource							VARCHAR(8)	 NULL
					,SpudToCompletion_DAYS					BIGINT		 NULL
					,SpudToRigRelease_DAYS					BIGINT		 NULL
					,SpudToSales_DAYS						BIGINT		 NULL
					,StateFileNumber						VARCHAR(256) NULL
					,StateProvince							VARCHAR(64)	 NULL
					,StateWellType							VARCHAR(256) NULL
					,StimulatedStages						INT			 NULL
					,SurfaceLatLongSource					VARCHAR(256) NULL
					,Surfactant_LBS							REAL		 NULL
					,TestComments							VARCHAR(256) NULL
					,TestDate								DATETIME	 NULL
					,TestRate_BOEPerDAY						REAL		 NULL
					,TestRate_BOEPerDAYPer1000FT			REAL		 NULL
					,TestRate_MCFEPerDAY					REAL		 NULL
					,TestRate_MCFEPerDAYPer1000FT			REAL		 NULL
					,TestWHLiquids_PCT						REAL		 NULL
					,TotalClusters							INT			 NULL
					,TotalFluidPumped_BBL					FLOAT(53)	 NULL
					,TotalProducingMonths					BIGINT		 NULL
					,TotalShots								INT			 NULL
					,TotalWaterPumped_GAL					REAL		 NULL
					,Township								VARCHAR(32)	 NULL
					,Trajectory								VARCHAR(64)	 NULL
					,TVD_FT									FLOAT(53)	 NULL
					,UnconventionalFlag						INT			 NULL
					,UnconventionalType						VARCHAR(32)	 NULL
					,Unit_Name								VARCHAR(128) NULL
					,UpdatedDate							DATETIME	 NULL
					,UpperPerf_FT							INT			 NULL
					,Vintage								VARCHAR(4)	 NULL
					,WaterDepth								FLOAT(53)	 NULL
					,WaterIntensity_GALPerFT				REAL		 NULL
					,WaterSaturation_PCT					FLOAT(53)	 NULL
					,WaterTestRate_BBLPerDAY				REAL		 NULL
					,WaterTestRate_BBLPerDAYPer1000FT		REAL		 NULL
					,WellboreID								BIGINT		 NULL
					,WellID									BIGINT		 NOT NULL
					,WellName								VARCHAR(256) NULL
					,WellNumber								VARCHAR(256) NULL
					,WellPadDirection						VARCHAR(32)	 NULL
					,WellPadID								VARCHAR(128) NULL
					,WellSymbols							VARCHAR(256) NULL
					,WHLiquids_PCT							REAL		 NULL
					
					,ETL_Load_Date							DATETIME	NULL
				  
					,INDEX idx_tempdb_Well_CompletionID_WellID
						NONCLUSTERED (
							CompletionID, WellID
						)
				  )

			------------------------------------------------------------------------
			-- Save Well data
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Save Well data')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				--------------------------------------------------------------------
				-- Unpack Well JSON
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Unpack Well JSON')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					INSERT INTO #Well (
						 _duplicate
						,_error
						,_delete

						,Abstract								
						,AcidVolume_BBL							
						,AlternativeWellName					
						,API_UWI								
						,API_UWI_Unformatted					
						,API_UWI_12								
						,API_UWI_12_Unformatted					
						,API_UWI_14								
						,API_UWI_14_Unformatted					
						,AverageStageSpacing_FT					
						,AvgBreakdownPressure_PSI				
						,AvgClusterSpacing_FT					
						,AvgClusterSpacingPerStage_FT			
						,AvgFluidPerCluster_BBL					
						,AvgFluidPerShot_BBL					
						,AvgFluidPerStage_BBL					
						,AvgFracGradient_PSIPerFT				
						,AvgISIP_PSI							
						,AvgMillTime_Min						
						,AvgPortSleeveOpeningPressure_PSI		
						,AvgProppantPerCluster_LBS				
						,AvgProppantPerShot_LBS					
						,AvgProppantPerStage_LBS				
						,AvgShotsPerCluster						
						,AvgShotsPerFT							
						,AvgTreatmentPressure_PSI				
						,AvgTreatmentRate_BBLPerMin				
						,Biocide_LBS							
						,Block									
						,Bottom_Hole_Temp_DEGF					
						,BottomHoleAge							
						,BottomHoleFormationName				
						,BottomHoleLithology					
						,Breaker_LBS							
						,Buffer_LBS								
						,CasingPressure_PSI						
						,ChokeSize_64IN							
						,ClayControl_LBS						
						,ClustersPer1000FT						
						,ClustersPerStage						
						,CompletionDate							
						,CompletionDesign						
						,CompletionID							
						,CompletionNumber						
						,CompletionTime_DAYS					
						,Contract								
						,CoordinateQuality						
						,CoordinateSource						
						,Country								
						,County									
						,CrossLinker_LBS						
						,CumGas_MCF								
						,CumGas_MCFPer1000FT					
						,CumOil_BBL								
						,CumOil_BBLPer1000FT					
						,CumProd_BOE							
						,CumProd_BOEPer1000FT					
						,CumProd_MCFE							
						,CumProd_MCFEPer1000FT					
						,CumulativeSOR							
						,CumWater_BBL							
						,DeletedDate							
						,DevelopmentFlag						
						,DiscoverMagnitudeComments				
						,DiscoveryType							
						,District								
						,Diverter_LBS							
						,DrillingEndDate						
						,DrillingTDDate							
						,DrillingTDDateQualifier				
						,ElevationGL_FT							
						,ElevationKB_FT							
						,EndDateQualifier						
						,Energizer_LBS							
						,ENVBasin								
						,ENVCompInsertedDate					
						,ENVElevationGL_FT						
						,ENVElevationGLSource					
						,ENVElevationKB_FT						
						,ENVElevationKBSource					
						,ENVFluidType							
						,ENVFracJobType							
						,ENVInterval							
						,ENVIntervalSource						
						,Environment							
						,ENVOperator							
						,ENVPeerGroup							
						,ENVPlay								
						,ENVProducingMethod						
						,ENVProdWellType						
						,ENVProppantBrand						
						,ENVProppantType						
						,ENVRegion								
						,ENVStockExchange						
						,ENVSubPlay								
						,ENVTicker								
						,ENVWellboreType						
						,ENVWellGrouping						
						,ENVWellServiceProvider					
						,ENVWellStatus							
						,ENVWellType							
						,ExplorationFlag						
						,Field									
						,First3MonthFlaredGas_MCF				
						,First3MonthGas_MCF						
						,First3MonthGas_MCFPer1000FT			
						,First3MonthOil_BBL						
						,First3MonthOil_BBLPer1000FT			
						,First3MonthProd_BOE					
						,First3MonthProd_BOEPer1000FT			
						,First3MonthProd_MCFE					
						,First3MonthProd_MCFEPer1000FT			
						,First3MonthWater_BBL					
						,First6MonthFlaredGas_MCF				
						,First6MonthGas_MCF						
						,First6MonthGas_MCFPer1000FT			
						,First6MonthOil_BBL						
						,First6MonthOil_BBLPer1000FT			
						,First6MonthProd_BOE					
						,First6MonthProd_BOEPer1000FT			
						,First6MonthProd_MCFE					
						,First6MonthProd_MCFEPer1000FT			
						,First6MonthWater_BBL					
						,First9MonthFlaredGas_MCF				
						,First9MonthGas_MCF						
						,First9MonthGas_MCFPer1000FT			
						,First9MonthOil_BBL						
						,First9MonthOil_BBLPer1000FT			
						,First9MonthProd_BOE					
						,First9MonthProd_BOEPer1000FT			
						,First9MonthProd_MCFE					
						,First9MonthProd_MCFEPer1000FT			
						,First9MonthWater_BBL					
						,First12MonthFlaredGas_MCF				
						,First12MonthGas_MCF					
						,First12MonthGas_MCFPer1000FT			
						,First12MonthOil_BBL					
						,First12MonthOil_BBLPer1000FT			
						,First12MonthProd_BOE					
						,First12MonthProd_BOEPer1000FT			
						,First12MonthProd_MCFE					
						,First12MonthProd_MCFEPer1000FT			
						,First12MonthWater_BBL					
						,First36MonthGas_MCF					
						,First36MonthGas_MCFPer1000FT			
						,First36MonthOil_BBL					
						,First36MonthOil_BBLPer1000FT			
						,First36MonthProd_BOE					
						,First36MonthProd_BOEPer1000FT			
						,First36MonthProd_MCFE					
						,First36MonthProd_MCFEPer1000FT			
						,First36MonthWater_BBL					
						,First36MonthWaterProductionBBLPer1000Ft
						,FirstDay								
						,FirstProdDate							
						,FirstProdMonth							
						,FirstProdQuarter						
						,FirstProdYear							
						,FlaredGasRatio							
						,FlowingTubingPressure_PSI				
						,FluidIntensity_BBLPerFT				
						,Formation								
						,FracRigOnsiteDate						
						,FracRigReleaseDate						
						,FracStages								
						,FrictionReducer_LBS					
						,GasGravity_SG							
						,GasTestRate_MCFPerDAY					
						,GasTestRate_MCFPerDAYPer1000FT			
						,GellingAgent_LBS						
						,GeneralComments	
						,GOR_ScfPerBbl							
						,GovernmentWellId						
						,InitialOperator						
						,IronControl_LBS						
						,Last3MonthISOR							
						,Last12MonthGasProduction_MCF			
						,Last12MonthOilProduction_BBL			
						,Last12MonthProduction_BOE				
						,Last12MonthWaterProduction_BBL			
						,LastMonthFlaredGas_MCF					
						,LastMonthGasProduction_MCF				
						,LastMonthLiquidsProduction_BBL			
						,LastMonthWaterProduction_BBL			
						,LastProducingMonth						
						,LateralLength_FT						
						,Latitude								
						,Latitude_BH							
						,Lease									
						,LeaseName								
						,Longitude								
						,Longitude_BH							
						,LowerPerf_FT							
						,MD_FT									
						,MonthsToPeakProduction					
						,NumberOfStrings						
						,ObjectiveAge							
						,ObjectiveLithology						
						,OffConfidentialDate					
						,OilGravity_API							
						,OilProdPriorTest_BBL					
						,OilTestMethodName						
						,OilTestRate_BBLPerDAY					
						,OilTestRate_BBLPerDAYPer1000FT			
						,OnConfidential							
						,OnOffshore								
						,PeakFlaredGas_MCF						
						,PeakGas_MCF							
						,PeakGas_MCFPer1000FT					
						,PeakOil_BBL							
						,PeakOil_BBLPer1000FT					
						,PeakProd_BOE							
						,PeakProd_BOEPer1000FT					
						,PeakProd_MCFE							
						,PeakProd_MCFEPer1000FT					
						,PeakProductionDate						
						,PeakWater_BBL							
						,PerfInterval_FT						
						,PermitApprovedDate						
						,PermitSubmittedDate					
						,PermitToSpud_DAYS						
						,Platform								
						,PlugbackMeasuredDepth_FT				
						,PlugbackTrueVerticalDepth_FT			
						,PlugDate								
						,Proppant_LBS							
						,ProppantIntensity_LBSPerFT				
						,ProppantLoading_LBSPerGAL				
						,Range									
						,RawOperator							
						,RawVintage								
						,ResourceMagnitude						
						,ResourceMagnitudeReviewDate			
						,ResourceSourceQualifier				
						,ResourceVolumeGasBcf					
						,ResourceVolumeLiquidsMMb				
						,RigReleaseDate							
						,ScaleInhibitor_LBS						
						,Section								
						,Section_Township_Range					
						,ShotsPer1000FT							
						,ShotsPerStage							
						,ShutInPressure_PSI						
						,SoakTime_DAYS							
						,SpudDate								
						,SpudDateQualifier						
						,SpudDateSource							
						,SpudToCompletion_DAYS					
						,SpudToRigRelease_DAYS					
						,SpudToSales_DAYS						
						,StateFileNumber						
						,StateProvince							
						,StateWellType							
						,StimulatedStages						
						,SurfaceLatLongSource					
						,Surfactant_LBS							
						,TestComments							
						,TestDate								
						,TestRate_BOEPerDAY						
						,TestRate_BOEPerDAYPer1000FT			
						,TestRate_MCFEPerDAY					
						,TestRate_MCFEPerDAYPer1000FT			
						,TestWHLiquids_PCT						
						,TotalClusters							
						,TotalFluidPumped_BBL					
						,TotalProducingMonths					
						,TotalShots								
						,TotalWaterPumped_GAL					
						,Township								
						,Trajectory								
						,TVD_FT									
						,UnconventionalFlag						
						,UnconventionalType						
						,Unit_Name								
						,UpdatedDate							
						,UpperPerf_FT							
						,Vintage								
						,WaterDepth								
						,WaterIntensity_GALPerFT				
						,WaterSaturation_PCT					
						,WaterTestRate_BBLPerDAY				
						,WaterTestRate_BBLPerDAYPer1000FT		
						,WellboreID								
						,WellID									
						,WellName								
						,WellNumber								
						,WellPadDirection						
						,WellPadID								
						,WellSymbols							
						,WHLiquids_PCT							
						,GeomBHL_Point
						,GeomSHL_Point
						,LateralLine

						,ETL_Load_Date
						)
					SELECT
						 _duplicate = count(*) OVER (PARTITION BY t0.CompletionID, t0.WellID)-1
						,_error		= 0
						,_delete							BIT

						,Abstract								
						,AcidVolume_BBL							
						,AlternativeWellName					
						,API_UWI								
						,API_UWI_Unformatted					
						,API_UWI_12								
						,API_UWI_12_Unformatted					
						,API_UWI_14								
						,API_UWI_14_Unformatted					
						,AverageStageSpacing_FT					
						,AvgBreakdownPressure_PSI				
						,AvgClusterSpacing_FT					
						,AvgClusterSpacingPerStage_FT			
						,AvgFluidPerCluster_BBL					
						,AvgFluidPerShot_BBL					
						,AvgFluidPerStage_BBL					
						,AvgFracGradient_PSIPerFT				
						,AvgISIP_PSI							
						,AvgMillTime_Min						
						,AvgPortSleeveOpeningPressure_PSI		
						,AvgProppantPerCluster_LBS				
						,AvgProppantPerShot_LBS					
						,AvgProppantPerStage_LBS				
						,AvgShotsPerCluster						
						,AvgShotsPerFT							
						,AvgTreatmentPressure_PSI				
						,AvgTreatmentRate_BBLPerMin				
						,Biocide_LBS							
						,Block									
						,Bottom_Hole_Temp_DEGF					
						,BottomHoleAge							
						,BottomHoleFormationName				
						,BottomHoleLithology					
						,Breaker_LBS							
						,Buffer_LBS								
						,CasingPressure_PSI						
						,ChokeSize_64IN							
						,ClayControl_LBS						
						,ClustersPer1000FT						
						,ClustersPerStage						
						,CompletionDate							
						,CompletionDesign						
						,CompletionID							
						,CompletionNumber						
						,CompletionTime_DAYS					
						,Contract								
						,CoordinateQuality						
						,CoordinateSource						
						,Country								
						,County									
						,CrossLinker_LBS						
						,CumGas_MCF								
						,CumGas_MCFPer1000FT					
						,CumOil_BBL								
						,CumOil_BBLPer1000FT					
						,CumProd_BOE							
						,CumProd_BOEPer1000FT					
						,CumProd_MCFE							
						,CumProd_MCFEPer1000FT					
						,CumulativeSOR							
						,CumWater_BBL							
						,DeletedDate							
						,DevelopmentFlag						
						,DiscoverMagnitudeComments				
						,DiscoveryType							
						,District								
						,Diverter_LBS							
						,DrillingEndDate						
						,DrillingTDDate							
						,DrillingTDDateQualifier				
						,ElevationGL_FT							
						,ElevationKB_FT							
						,EndDateQualifier						
						,Energizer_LBS							
						,ENVBasin								
						,ENVCompInsertedDate					
						,ENVElevationGL_FT						
						,ENVElevationGLSource					
						,ENVElevationKB_FT						
						,ENVElevationKBSource					
						,ENVFluidType							
						,ENVFracJobType							
						,ENVInterval							
						,ENVIntervalSource						
						,Environment							
						,ENVOperator							
						,ENVPeerGroup							
						,ENVPlay								
						,ENVProducingMethod						
						,ENVProdWellType						
						,ENVProppantBrand						
						,ENVProppantType						
						,ENVRegion								
						,ENVStockExchange						
						,ENVSubPlay								
						,ENVTicker								
						,ENVWellboreType						
						,ENVWellGrouping						
						,ENVWellServiceProvider					
						,ENVWellStatus							
						,ENVWellType							
						,ExplorationFlag						
						,Field									
						,First3MonthFlaredGas_MCF				
						,First3MonthGas_MCF						
						,First3MonthGas_MCFPer1000FT			
						,First3MonthOil_BBL						
						,First3MonthOil_BBLPer1000FT			
						,First3MonthProd_BOE					
						,First3MonthProd_BOEPer1000FT			
						,First3MonthProd_MCFE					
						,First3MonthProd_MCFEPer1000FT			
						,First3MonthWater_BBL					
						,First6MonthFlaredGas_MCF				
						,First6MonthGas_MCF						
						,First6MonthGas_MCFPer1000FT			
						,First6MonthOil_BBL						
						,First6MonthOil_BBLPer1000FT			
						,First6MonthProd_BOE					
						,First6MonthProd_BOEPer1000FT			
						,First6MonthProd_MCFE					
						,First6MonthProd_MCFEPer1000FT			
						,First6MonthWater_BBL					
						,First9MonthFlaredGas_MCF				
						,First9MonthGas_MCF						
						,First9MonthGas_MCFPer1000FT			
						,First9MonthOil_BBL						
						,First9MonthOil_BBLPer1000FT			
						,First9MonthProd_BOE					
						,First9MonthProd_BOEPer1000FT			
						,First9MonthProd_MCFE					
						,First9MonthProd_MCFEPer1000FT			
						,First9MonthWater_BBL					
						,First12MonthFlaredGas_MCF				
						,First12MonthGas_MCF					
						,First12MonthGas_MCFPer1000FT			
						,First12MonthOil_BBL					
						,First12MonthOil_BBLPer1000FT			
						,First12MonthProd_BOE					
						,First12MonthProd_BOEPer1000FT			
						,First12MonthProd_MCFE					
						,First12MonthProd_MCFEPer1000FT			
						,First12MonthWater_BBL					
						,First36MonthGas_MCF					
						,First36MonthGas_MCFPer1000FT			
						,First36MonthOil_BBL					
						,First36MonthOil_BBLPer1000FT			
						,First36MonthProd_BOE					
						,First36MonthProd_BOEPer1000FT			
						,First36MonthProd_MCFE					
						,First36MonthProd_MCFEPer1000FT			
						,First36MonthWater_BBL					
						,First36MonthWaterProductionBBLPer1000Ft
						,FirstDay								
						,FirstProdDate							
						,FirstProdMonth							
						,FirstProdQuarter						
						,FirstProdYear							
						,FlaredGasRatio							
						,FlowingTubingPressure_PSI				
						,FluidIntensity_BBLPerFT				
						,Formation								
						,FracRigOnsiteDate						
						,FracRigReleaseDate						
						,FracStages								
						,FrictionReducer_LBS					
						,GasGravity_SG							
						,GasTestRate_MCFPerDAY					
						,GasTestRate_MCFPerDAYPer1000FT			
						,GellingAgent_LBS						
						,GeneralComments											
						,GOR_ScfPerBbl							
						,GovernmentWellId						
						,InitialOperator						
						,IronControl_LBS						
						,Last3MonthISOR							
						,Last12MonthGasProduction_MCF			
						,Last12MonthOilProduction_BBL			
						,Last12MonthProduction_BOE				
						,Last12MonthWaterProduction_BBL			
						,LastMonthFlaredGas_MCF					
						,LastMonthGasProduction_MCF				
						,LastMonthLiquidsProduction_BBL			
						,LastMonthWaterProduction_BBL			
						,LastProducingMonth						
						,LateralLength_FT													
						,Latitude								
						,Latitude_BH							
						,Lease									
						,LeaseName								
						,Longitude								
						,Longitude_BH							
						,LowerPerf_FT							
						,MD_FT									
						,MonthsToPeakProduction					
						,NumberOfStrings						
						,ObjectiveAge							
						,ObjectiveLithology						
						,OffConfidentialDate					
						,OilGravity_API							
						,OilProdPriorTest_BBL					
						,OilTestMethodName						
						,OilTestRate_BBLPerDAY					
						,OilTestRate_BBLPerDAYPer1000FT			
						,OnConfidential							
						,OnOffshore								
						,PeakFlaredGas_MCF						
						,PeakGas_MCF							
						,PeakGas_MCFPer1000FT					
						,PeakOil_BBL							
						,PeakOil_BBLPer1000FT					
						,PeakProd_BOE							
						,PeakProd_BOEPer1000FT					
						,PeakProd_MCFE							
						,PeakProd_MCFEPer1000FT					
						,PeakProductionDate						
						,PeakWater_BBL							
						,PerfInterval_FT						
						,PermitApprovedDate						
						,PermitSubmittedDate					
						,PermitToSpud_DAYS						
						,Platform								
						,PlugbackMeasuredDepth_FT				
						,PlugbackTrueVerticalDepth_FT			
						,PlugDate								
						,Proppant_LBS							
						,ProppantIntensity_LBSPerFT				
						,ProppantLoading_LBSPerGAL				
						,Range									
						,RawOperator							
						,RawVintage								
						,ResourceMagnitude						
						,ResourceMagnitudeReviewDate			
						,ResourceSourceQualifier				
						,ResourceVolumeGasBcf					
						,ResourceVolumeLiquidsMMb				
						,RigReleaseDate							
						,ScaleInhibitor_LBS						
						,Section								
						,Section_Township_Range					
						,ShotsPer1000FT							
						,ShotsPerStage							
						,ShutInPressure_PSI						
						,SoakTime_DAYS							
						,SpudDate								
						,SpudDateQualifier						
						,SpudDateSource							
						,SpudToCompletion_DAYS					
						,SpudToRigRelease_DAYS					
						,SpudToSales_DAYS						
						,StateFileNumber						
						,StateProvince							
						,StateWellType							
						,StimulatedStages						
						,SurfaceLatLongSource					
						,Surfactant_LBS							
						,TestComments							
						,TestDate								
						,TestRate_BOEPerDAY						
						,TestRate_BOEPerDAYPer1000FT			
						,TestRate_MCFEPerDAY					
						,TestRate_MCFEPerDAYPer1000FT			
						,TestWHLiquids_PCT						
						,TotalClusters							
						,TotalFluidPumped_BBL					
						,TotalProducingMonths					
						,TotalShots								
						,TotalWaterPumped_GAL					
						,Township								
						,Trajectory								
						,TVD_FT									
						,UnconventionalFlag						
						,UnconventionalType						
						,Unit_Name								
						,UpdatedDate							
						,UpperPerf_FT							
						,Vintage								
						,WaterDepth								
						,WaterIntensity_GALPerFT				
						,WaterSaturation_PCT					
						,WaterTestRate_BBLPerDAY				
						,WaterTestRate_BBLPerDAYPer1000FT		
						,WellboreID								
						,WellID									
						,WellName								
						,WellNumber								
						,WellPadDirection						
						,WellPadID								
						,WellSymbols							
						,WHLiquids_PCT

						,t1.GeoData	GeomBHL_Point
						,t2.GeoData	GeomSHL_Point
						,t3.GeoData	LateralLine
						,sysdatetime()
					FROM
						OPENJSON(@data)
						WITH (
							 _delete							BIT

							,Abstract								VARCHAR(16)	 
							,AcidVolume_BBL							REAL		 
							,AlternativeWellName					VARCHAR(128) 
							,API_UWI								VARCHAR(32)	 
							,API_UWI_Unformatted					VARCHAR(32)	 
							,API_UWI_12								VARCHAR(32)	 
							,API_UWI_12_Unformatted					VARCHAR(32)	 
							,API_UWI_14								VARCHAR(32)	 
							,API_UWI_14_Unformatted					VARCHAR(32)	 
							,AverageStageSpacing_FT					REAL		 
							,AvgBreakdownPressure_PSI				INT			 
							,AvgClusterSpacing_FT					INT			 
							,AvgClusterSpacingPerStage_FT			INT			 
							,AvgFluidPerCluster_BBL					INT			 
							,AvgFluidPerShot_BBL					INT			 
							,AvgFluidPerStage_BBL					INT			 
							,AvgFracGradient_PSIPerFT				FLOAT(53)	 
							,AvgISIP_PSI							INT			 
							,AvgMillTime_Min						INT			 
							,AvgPortSleeveOpeningPressure_PSI		INT			 
							,AvgProppantPerCluster_LBS				INT			 
							,AvgProppantPerShot_LBS					INT			 
							,AvgProppantPerStage_LBS				INT			 
							,AvgShotsPerCluster						INT			 
							,AvgShotsPerFT							INT			 
							,AvgTreatmentPressure_PSI				INT			 
							,AvgTreatmentRate_BBLPerMin				FLOAT(53)	 
							,Biocide_LBS							REAL		 
							,Block									VARCHAR(64)	 
							,Bottom_Hole_Temp_DEGF					FLOAT(53)	 
							,BottomHoleAge							VARCHAR(64)	 
							,BottomHoleFormationName				VARCHAR(128) 
							,BottomHoleLithology					VARCHAR(64)	 
							,Breaker_LBS							REAL		 
							,Buffer_LBS								REAL		 
							,CasingPressure_PSI						REAL		 
							,ChokeSize_64IN							INT			 
							,ClayControl_LBS						REAL		 
							,ClustersPer1000FT						INT			 
							,ClustersPerStage						INT			 
							,CompletionDate							DATETIME	 
							,CompletionDesign						VARCHAR(64)	 
							,CompletionID							BIGINT		 
							,CompletionNumber						INT			 
							,CompletionTime_DAYS					INT			 
							,Contract								VARCHAR(128) 
							,CoordinateQuality						VARCHAR(32)	 
							,CoordinateSource						VARCHAR(64)	 
							,Country								VARCHAR(2)	 
							,County									VARCHAR(32)	 
							,CrossLinker_LBS						REAL		 
							,CumGas_MCF								REAL		 
							,CumGas_MCFPer1000FT					REAL		 
							,CumOil_BBL								REAL		 
							,CumOil_BBLPer1000FT					REAL		 
							,CumProd_BOE							REAL		 
							,CumProd_BOEPer1000FT					REAL		 
							,CumProd_MCFE							REAL		 
							,CumProd_MCFEPer1000FT					REAL		 
							,CumulativeSOR							REAL		 
							,CumWater_BBL							REAL		 
							,DeletedDate							DATETIME	 
							,DevelopmentFlag						INT			 
							,DiscoverMagnitudeComments				VARCHAR(256) 
							,DiscoveryType							VARCHAR(32)	 
							,District								VARCHAR(256) 
							,Diverter_LBS							REAL		 
							,DrillingEndDate						DATETIME	 
							,DrillingTDDate							DATETIME	 
							,DrillingTDDateQualifier				VARCHAR(64)	 
							,ElevationGL_FT							FLOAT(53)	 
							,ElevationKB_FT							FLOAT(53)	 
							,EndDateQualifier						VARCHAR(64)	 
							,Energizer_LBS							REAL		 
							,ENVBasin								VARCHAR(64)	 
							,ENVCompInsertedDate					DATETIME	 
							,ENVElevationGL_FT						FLOAT(53)	 
							,ENVElevationGLSource					VARCHAR(128) 
							,ENVElevationKB_FT						FLOAT(53)	 
							,ENVElevationKBSource					VARCHAR(128) 
							,ENVFluidType							VARCHAR(128) 
							,ENVFracJobType							VARCHAR(32)	 
							,ENVInterval							VARCHAR(128) 
							,ENVIntervalSource						VARCHAR(32)	 
							,Environment							VARCHAR(32)	 
							,ENVOperator							VARCHAR(256) 
							,ENVPeerGroup							VARCHAR(64)	 
							,ENVPlay								VARCHAR(128) 
							,ENVProducingMethod						VARCHAR(256) 
							,ENVProdWellType						VARCHAR(64)	 
							,ENVProppantBrand						VARCHAR(256) 
							,ENVProppantType						VARCHAR(32)	 
							,ENVRegion								VARCHAR(32)	 
							,ENVStockExchange						VARCHAR(32)	 
							,ENVSubPlay								VARCHAR(64)	 
							,ENVTicker								VARCHAR(128) 
							,ENVWellboreType						VARCHAR(256) 
							,ENVWellGrouping						VARCHAR(128) 
							,ENVWellServiceProvider					VARCHAR(256) 
							,ENVWellStatus							VARCHAR(64)	 
							,ENVWellType							VARCHAR(256) 
							,ExplorationFlag						INT			 
							,Field									VARCHAR(256) 
							,First3MonthFlaredGas_MCF				REAL		 
							,First3MonthGas_MCF						REAL		 
							,First3MonthGas_MCFPer1000FT			REAL		 
							,First3MonthOil_BBL						REAL		 
							,First3MonthOil_BBLPer1000FT			REAL		 
							,First3MonthProd_BOE					REAL		 
							,First3MonthProd_BOEPer1000FT			REAL		 
							,First3MonthProd_MCFE					REAL		 
							,First3MonthProd_MCFEPer1000FT			REAL		 
							,First3MonthWater_BBL					REAL		 
							,First6MonthFlaredGas_MCF				REAL		 
							,First6MonthGas_MCF						REAL		 
							,First6MonthGas_MCFPer1000FT			REAL		 
							,First6MonthOil_BBL						REAL		 
							,First6MonthOil_BBLPer1000FT			REAL		 
							,First6MonthProd_BOE					REAL		 
							,First6MonthProd_BOEPer1000FT			REAL		 
							,First6MonthProd_MCFE					REAL		 
							,First6MonthProd_MCFEPer1000FT			REAL		 
							,First6MonthWater_BBL					REAL		 
							,First9MonthFlaredGas_MCF				REAL		 
							,First9MonthGas_MCF						REAL		 
							,First9MonthGas_MCFPer1000FT			REAL		 
							,First9MonthOil_BBL						REAL		 
							,First9MonthOil_BBLPer1000FT			REAL		 
							,First9MonthProd_BOE					REAL		 
							,First9MonthProd_BOEPer1000FT			REAL		 
							,First9MonthProd_MCFE					REAL		 
							,First9MonthProd_MCFEPer1000FT			REAL		 
							,First9MonthWater_BBL					REAL		 
							,First12MonthFlaredGas_MCF				REAL		 
							,First12MonthGas_MCF					REAL		 
							,First12MonthGas_MCFPer1000FT			REAL		 
							,First12MonthOil_BBL					REAL		 
							,First12MonthOil_BBLPer1000FT			REAL		 
							,First12MonthProd_BOE					REAL		 
							,First12MonthProd_BOEPer1000FT			REAL		 
							,First12MonthProd_MCFE					REAL		 
							,First12MonthProd_MCFEPer1000FT			REAL		 
							,First12MonthWater_BBL					REAL		 
							,First36MonthGas_MCF					FLOAT(53)	 
							,First36MonthGas_MCFPer1000FT			FLOAT(53)	 
							,First36MonthOil_BBL					FLOAT(53)	 
							,First36MonthOil_BBLPer1000FT			FLOAT(53)	 
							,First36MonthProd_BOE					FLOAT(53)	 
							,First36MonthProd_BOEPer1000FT			FLOAT(53)	 
							,First36MonthProd_MCFE					FLOAT(53)	 
							,First36MonthProd_MCFEPer1000FT			FLOAT(53)	 
							,First36MonthWater_BBL					FLOAT(53)	 
							,First36MonthWaterProductionBBLPer1000Ft FLOAT(53)	 
							,FirstDay								DATETIME	 
							,FirstProdDate							DATETIME	 
							,FirstProdMonth							VARCHAR(256) 
							,FirstProdQuarter						VARCHAR(16)	 
							,FirstProdYear							VARCHAR(16)	 
							,FlaredGasRatio							REAL		 
							,FlowingTubingPressure_PSI				REAL		 
							,FluidIntensity_BBLPerFT				REAL		 
							,Formation								VARCHAR(256) 
							,FracRigOnsiteDate						DATETIME	 
							,FracRigReleaseDate						DATETIME	 
							,FracStages								INT			 
							,FrictionReducer_LBS					REAL		 
							,GasGravity_SG							FLOAT(53)	 
							,GasTestRate_MCFPerDAY					REAL		 
							,GasTestRate_MCFPerDAYPer1000FT			REAL		 
							,GellingAgent_LBS						REAL		 
							,GeneralComments						VARCHAR(256) 
							,GeomBHL_Point						VARCHAR(MAX)
							,GeomSHL_Point							VARCHAR(MAX) 
							,GOR_ScfPerBbl							REAL		 
							,GovernmentWellId						VARCHAR(64)	 
							,InitialOperator						VARCHAR(256) 
							,IronControl_LBS						REAL		 
							,Last3MonthISOR							REAL		 
							,Last12MonthGasProduction_MCF			REAL		 
							,Last12MonthOilProduction_BBL			REAL		 
							,Last12MonthProduction_BOE				REAL		 
							,Last12MonthWaterProduction_BBL			REAL		 
							,LastMonthFlaredGas_MCF					REAL		 
							,LastMonthGasProduction_MCF				FLOAT(53)	 
							,LastMonthLiquidsProduction_BBL			FLOAT(53)	 
							,LastMonthWaterProduction_BBL			FLOAT(53)	 
							,LastProducingMonth						DATETIME	 
							,LateralLength_FT						REAL		 
							,LateralLine							VARCHAR(MAX) 
							,Latitude								FLOAT(53)	 
							,Latitude_BH							FLOAT(53)	 
							,Lease									VARCHAR(64)	 
							,LeaseName								VARCHAR(256) 
							,Longitude								FLOAT(53)	 
							,Longitude_BH							FLOAT(53)	 
							,LowerPerf_FT							INT			 
							,MD_FT									FLOAT(53)	 
							,MonthsToPeakProduction					BIGINT		 
							,NumberOfStrings						INT			 
							,ObjectiveAge							VARCHAR(128) 
							,ObjectiveLithology						VARCHAR(64)	 
							,OffConfidentialDate					DATETIME	 
							,OilGravity_API							FLOAT(53)	 
							,OilProdPriorTest_BBL					FLOAT(53)	 
							,OilTestMethodName						VARCHAR(256) 
							,OilTestRate_BBLPerDAY					REAL		 
							,OilTestRate_BBLPerDAYPer1000FT			REAL		 
							,OnConfidential							VARCHAR(1)	 
							,OnOffshore								VARCHAR(32)	 
							,PeakFlaredGas_MCF						REAL		 
							,PeakGas_MCF							REAL		 
							,PeakGas_MCFPer1000FT					REAL		 
							,PeakOil_BBL							REAL		 
							,PeakOil_BBLPer1000FT					REAL		 
							,PeakProd_BOE							REAL		 
							,PeakProd_BOEPer1000FT					REAL		 
							,PeakProd_MCFE							REAL		 
							,PeakProd_MCFEPer1000FT					REAL		 
							,PeakProductionDate						DATETIME	 
							,PeakWater_BBL							REAL		 
							,PerfInterval_FT						INT			 
							,PermitApprovedDate						DATETIME	 
							,PermitSubmittedDate					DATETIME	 
							,PermitToSpud_DAYS						BIGINT		 
							,Platform								VARCHAR(256) 
							,PlugbackMeasuredDepth_FT				INT			 
							,PlugbackTrueVerticalDepth_FT			INT			 
							,PlugDate								DATETIME	 
							,Proppant_LBS							FLOAT(53)	 
							,ProppantIntensity_LBSPerFT				REAL		 
							,ProppantLoading_LBSPerGAL				REAL		 
							,Range									VARCHAR(32)	 
							,RawOperator							VARCHAR(256) 
							,RawVintage								INT			 
							,ResourceMagnitude						VARCHAR(32)	 
							,ResourceMagnitudeReviewDate			DATETIME	 
							,ResourceSourceQualifier				VARCHAR(64)	 
							,ResourceVolumeGasBcf					VARCHAR(32)	 
							,ResourceVolumeLiquidsMMb				VARCHAR(32)	 
							,RigReleaseDate							DATETIME	 
							,ScaleInhibitor_LBS						REAL		 
							,Section								VARCHAR(32)	 
							,Section_Township_Range					VARCHAR(128) 
							,ShotsPer1000FT							INT			 
							,ShotsPerStage							INT			 
							,ShutInPressure_PSI						REAL		 
							,SoakTime_DAYS							BIGINT		 
							,SpudDate								DATETIME	 
							,SpudDateQualifier						VARCHAR(64)	 
							,SpudDateSource							VARCHAR(8)	 
							,SpudToCompletion_DAYS					BIGINT		 
							,SpudToRigRelease_DAYS					BIGINT		 
							,SpudToSales_DAYS						BIGINT		 
							,StateFileNumber						VARCHAR(256) 
							,StateProvince							VARCHAR(64)	 
							,StateWellType							VARCHAR(256) 
							,StimulatedStages						INT			 
							,SurfaceLatLongSource					VARCHAR(256) 
							,Surfactant_LBS							REAL		 
							,TestComments							VARCHAR(256) 
							,TestDate								DATETIME	 
							,TestRate_BOEPerDAY						REAL		 
							,TestRate_BOEPerDAYPer1000FT			REAL		 
							,TestRate_MCFEPerDAY					REAL		 
							,TestRate_MCFEPerDAYPer1000FT			REAL		 
							,TestWHLiquids_PCT						REAL		 
							,TotalClusters							INT			 
							,TotalFluidPumped_BBL					FLOAT(53)	 
							,TotalProducingMonths					BIGINT		 
							,TotalShots								INT			 
							,TotalWaterPumped_GAL					REAL		 
							,Township								VARCHAR(32)	 
							,Trajectory								VARCHAR(64)	 
							,TVD_FT									FLOAT(53)	 
							,UnconventionalFlag						INT			 
							,UnconventionalType						VARCHAR(32)	 
							,Unit_Name								VARCHAR(128) 
							,UpdatedDate							DATETIME	 
							,UpperPerf_FT							INT			 
							,Vintage								VARCHAR(4)	 
							,WaterDepth								FLOAT(53)	 
							,WaterIntensity_GALPerFT				REAL		 
							,WaterSaturation_PCT					FLOAT(53)	 
							,WaterTestRate_BBLPerDAY				REAL		 
							,WaterTestRate_BBLPerDAYPer1000FT		REAL		 
							,WellboreID								BIGINT		 
							,WellID									BIGINT		 
							,WellName								VARCHAR(256) 
							,WellNumber								VARCHAR(256) 
							,WellPadDirection						VARCHAR(32)	 
							,WellPadID								VARCHAR(128) 
							,WellSymbols							VARCHAR(256) 
							,WHLiquids_PCT							REAL		 							 


							--,ETL_Load_Date		DATETIME
						) t0
						--CROSS APPLY [sync].[fnGetGeometryFromStr](t0.GeomBHL_Point,t0.GeomSHL_Point,t0.LateralLine) t1
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.GeomBHL_Point) t1
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.GeomSHL_Point) t2
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.LateralLine) t3


					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Validate Well data
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Validate Well data')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					UPDATE #Well SET 
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
				-- Save data to data.Well
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Save data to data.Well')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					----------------------------------------------------------------
					-- Process Deletes
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Well; Process Deletes')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						DELETE t0
						FROM
							data.Well t0

							INNER JOIN #Well t1
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
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Well; Process Updates')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						UPDATE t0 SET
								 Abstract								= t1.Abstract								
								,AcidVolume_BBL							= t1.AcidVolume_BBL							
								,AlternativeWellName					= t1.AlternativeWellName					
								,API_UWI								= t1.API_UWI								
								,API_UWI_Unformatted					= t1.API_UWI_Unformatted					
								,API_UWI_12								= t1.API_UWI_12								
								,API_UWI_12_Unformatted					= t1.API_UWI_12_Unformatted					
								,API_UWI_14								= t1.API_UWI_14								
								,API_UWI_14_Unformatted					= t1.API_UWI_14_Unformatted					
								,AverageStageSpacing_FT					= t1.AverageStageSpacing_FT					
								,AvgBreakdownPressure_PSI				= t1.AvgBreakdownPressure_PSI				
								,AvgClusterSpacing_FT					= t1.AvgClusterSpacing_FT					
								,AvgClusterSpacingPerStage_FT			= t1.AvgClusterSpacingPerStage_FT			
								,AvgFluidPerCluster_BBL					= t1.AvgFluidPerCluster_BBL					
								,AvgFluidPerShot_BBL					= t1.AvgFluidPerShot_BBL					
								,AvgFluidPerStage_BBL					= t1.AvgFluidPerStage_BBL					
								,AvgFracGradient_PSIPerFT				= t1.AvgFracGradient_PSIPerFT				
								,AvgISIP_PSI							= t1.AvgISIP_PSI							
								,AvgMillTime_Min						= t1.AvgMillTime_Min						
								,AvgPortSleeveOpeningPressure_PSI		= t1.AvgPortSleeveOpeningPressure_PSI		
								,AvgProppantPerCluster_LBS				= t1.AvgProppantPerCluster_LBS				
								,AvgProppantPerShot_LBS					= t1.AvgProppantPerShot_LBS					
								,AvgProppantPerStage_LBS				= t1.AvgProppantPerStage_LBS				
								,AvgShotsPerCluster						= t1.AvgShotsPerCluster						
								,AvgShotsPerFT							= t1.AvgShotsPerFT							
								,AvgTreatmentPressure_PSI				= t1.AvgTreatmentPressure_PSI				
								,AvgTreatmentRate_BBLPerMin				= t1.AvgTreatmentRate_BBLPerMin				
								,Biocide_LBS							= t1.Biocide_LBS							
								,Block									= t1.Block									
								,Bottom_Hole_Temp_DEGF					= t1.Bottom_Hole_Temp_DEGF					
								,BottomHoleAge							= t1.BottomHoleAge							
								,BottomHoleFormationName				= t1.BottomHoleFormationName				
								,BottomHoleLithology					= t1.BottomHoleLithology					
								,Breaker_LBS							= t1.Breaker_LBS							
								,Buffer_LBS								= t1.Buffer_LBS								
								,CasingPressure_PSI						= t1.CasingPressure_PSI						
								,ChokeSize_64IN							= t1.ChokeSize_64IN							
								,ClayControl_LBS						= t1.ClayControl_LBS						
								,ClustersPer1000FT						= t1.ClustersPer1000FT						
								,ClustersPerStage						= t1.ClustersPerStage						
								,CompletionDate							= t1.CompletionDate							
								,CompletionDesign						= t1.CompletionDesign						
								,CompletionID							= t1.CompletionID							
								,CompletionNumber						= t1.CompletionNumber						
								,CompletionTime_DAYS					= t1.CompletionTime_DAYS					
								,Contract								= t1.Contract								
								,CoordinateQuality						= t1.CoordinateQuality						
								,CoordinateSource						= t1.CoordinateSource						
								,Country								= t1.Country								
								,County									= t1.County									
								,CrossLinker_LBS						= t1.CrossLinker_LBS						
								,CumGas_MCF								= t1.CumGas_MCF								
								,CumGas_MCFPer1000FT					= t1.CumGas_MCFPer1000FT					
								,CumOil_BBL								= t1.CumOil_BBL								
								,CumOil_BBLPer1000FT					= t1.CumOil_BBLPer1000FT					
								,CumProd_BOE							= t1.CumProd_BOE							
								,CumProd_BOEPer1000FT					= t1.CumProd_BOEPer1000FT					
								,CumProd_MCFE							= t1.CumProd_MCFE							
								,CumProd_MCFEPer1000FT					= t1.CumProd_MCFEPer1000FT					
								,CumulativeSOR							= t1.CumulativeSOR							
								,CumWater_BBL							= t1.CumWater_BBL							
								,DeletedDate							= t1.DeletedDate							
								,DevelopmentFlag						= t1.DevelopmentFlag						
								,DiscoverMagnitudeComments				= t1.DiscoverMagnitudeComments				
								,DiscoveryType							= t1.DiscoveryType							
								,District								= t1.District								
								,Diverter_LBS							= t1.Diverter_LBS							
								,DrillingEndDate						= t1.DrillingEndDate						
								,DrillingTDDate							= t1.DrillingTDDate							
								,DrillingTDDateQualifier				= t1.DrillingTDDateQualifier				
								,ElevationGL_FT							= t1.ElevationGL_FT							
								,ElevationKB_FT							= t1.ElevationKB_FT							
								,EndDateQualifier						= t1.EndDateQualifier						
								,Energizer_LBS							= t1.Energizer_LBS							
								,ENVBasin								= t1.ENVBasin								
								,ENVCompInsertedDate					= t1.ENVCompInsertedDate					
								,ENVElevationGL_FT						= t1.ENVElevationGL_FT						
								,ENVElevationGLSource					= t1.ENVElevationGLSource					
								,ENVElevationKB_FT						= t1.ENVElevationKB_FT						
								,ENVElevationKBSource					= t1.ENVElevationKBSource					
								,ENVFluidType							= t1.ENVFluidType							
								,ENVFracJobType							= t1.ENVFracJobType							
								,ENVInterval							= t1.ENVInterval							
								,ENVIntervalSource						= t1.ENVIntervalSource						
								,Environment							= t1.Environment							
								,ENVOperator							= t1.ENVOperator							
								,ENVPeerGroup							= t1.ENVPeerGroup							
								,ENVPlay								= t1.ENVPlay								
								,ENVProducingMethod						= t1.ENVProducingMethod						
								,ENVProdWellType						= t1.ENVProdWellType						
								,ENVProppantBrand						= t1.ENVProppantBrand						
								,ENVProppantType						= t1.ENVProppantType						
								,ENVRegion								= t1.ENVRegion								
								,ENVStockExchange						= t1.ENVStockExchange						
								,ENVSubPlay								= t1.ENVSubPlay								
								,ENVTicker								= t1.ENVTicker								
								,ENVWellboreType						= t1.ENVWellboreType						
								,ENVWellGrouping						= t1.ENVWellGrouping						
								,ENVWellServiceProvider					= t1.ENVWellServiceProvider					
								,ENVWellStatus							= t1.ENVWellStatus							
								,ENVWellType							= t1.ENVWellType							
								,ExplorationFlag						= t1.ExplorationFlag						
								,Field									= t1.Field									
								,First3MonthFlaredGas_MCF				= t1.First3MonthFlaredGas_MCF				
								,First3MonthGas_MCF						= t1.First3MonthGas_MCF						
								,First3MonthGas_MCFPer1000FT			= t1.First3MonthGas_MCFPer1000FT			
								,First3MonthOil_BBL						= t1.First3MonthOil_BBL						
								,First3MonthOil_BBLPer1000FT			= t1.First3MonthOil_BBLPer1000FT			
								,First3MonthProd_BOE					= t1.First3MonthProd_BOE					
								,First3MonthProd_BOEPer1000FT			= t1.First3MonthProd_BOEPer1000FT			
								,First3MonthProd_MCFE					= t1.First3MonthProd_MCFE					
								,First3MonthProd_MCFEPer1000FT			= t1.First3MonthProd_MCFEPer1000FT			
								,First3MonthWater_BBL					= t1.First3MonthWater_BBL					
								,First6MonthFlaredGas_MCF				= t1.First6MonthFlaredGas_MCF				
								,First6MonthGas_MCF						= t1.First6MonthGas_MCF						
								,First6MonthGas_MCFPer1000FT			= t1.First6MonthGas_MCFPer1000FT			
								,First6MonthOil_BBL						= t1.First6MonthOil_BBL						
								,First6MonthOil_BBLPer1000FT			= t1.First6MonthOil_BBLPer1000FT			
								,First6MonthProd_BOE					= t1.First6MonthProd_BOE					
								,First6MonthProd_BOEPer1000FT			= t1.First6MonthProd_BOEPer1000FT			
								,First6MonthProd_MCFE					= t1.First6MonthProd_MCFE					
								,First6MonthProd_MCFEPer1000FT			= t1.First6MonthProd_MCFEPer1000FT			
								,First6MonthWater_BBL					= t1.First6MonthWater_BBL					
								,First9MonthFlaredGas_MCF				= t1.First9MonthFlaredGas_MCF				
								,First9MonthGas_MCF						= t1.First9MonthGas_MCF						
								,First9MonthGas_MCFPer1000FT			= t1.First9MonthGas_MCFPer1000FT			
								,First9MonthOil_BBL						= t1.First9MonthOil_BBL						
								,First9MonthOil_BBLPer1000FT			= t1.First9MonthOil_BBLPer1000FT			
								,First9MonthProd_BOE					= t1.First9MonthProd_BOE					
								,First9MonthProd_BOEPer1000FT			= t1.First9MonthProd_BOEPer1000FT			
								,First9MonthProd_MCFE					= t1.First9MonthProd_MCFE					
								,First9MonthProd_MCFEPer1000FT			= t1.First9MonthProd_MCFEPer1000FT			
								,First9MonthWater_BBL					= t1.First9MonthWater_BBL					
								,First12MonthFlaredGas_MCF				= t1.First12MonthFlaredGas_MCF				
								,First12MonthGas_MCF					= t1.First12MonthGas_MCF					
								,First12MonthGas_MCFPer1000FT			= t1.First12MonthGas_MCFPer1000FT			
								,First12MonthOil_BBL					= t1.First12MonthOil_BBL					
								,First12MonthOil_BBLPer1000FT			= t1.First12MonthOil_BBLPer1000FT			
								,First12MonthProd_BOE					= t1.First12MonthProd_BOE					
								,First12MonthProd_BOEPer1000FT			= t1.First12MonthProd_BOEPer1000FT			
								,First12MonthProd_MCFE					= t1.First12MonthProd_MCFE					
								,First12MonthProd_MCFEPer1000FT			= t1.First12MonthProd_MCFEPer1000FT			
								,First12MonthWater_BBL					= t1.First12MonthWater_BBL					
								,First36MonthGas_MCF					= t1.First36MonthGas_MCF					
								,First36MonthGas_MCFPer1000FT			= t1.First36MonthGas_MCFPer1000FT			
								,First36MonthOil_BBL					= t1.First36MonthOil_BBL					
								,First36MonthOil_BBLPer1000FT			= t1.First36MonthOil_BBLPer1000FT			
								,First36MonthProd_BOE					= t1.First36MonthProd_BOE					
								,First36MonthProd_BOEPer1000FT			= t1.First36MonthProd_BOEPer1000FT			
								,First36MonthProd_MCFE					= t1.First36MonthProd_MCFE					
								,First36MonthProd_MCFEPer1000FT			= t1.First36MonthProd_MCFEPer1000FT			
								,First36MonthWater_BBL					= t1.First36MonthWater_BBL					
								,First36MonthWaterProductionBBLPer1000Ft= t1.First36MonthWaterProductionBBLPer1000Ft
								,FirstDay								= t1.FirstDay								
								,FirstProdDate							= t1.FirstProdDate							
								,FirstProdMonth							= t1.FirstProdMonth							
								,FirstProdQuarter						= t1.FirstProdQuarter						
								,FirstProdYear							= t1.FirstProdYear							
								,FlaredGasRatio							= t1.FlaredGasRatio							
								,FlowingTubingPressure_PSI				= t1.FlowingTubingPressure_PSI				
								,FluidIntensity_BBLPerFT				= t1.FluidIntensity_BBLPerFT				
								,Formation								= t1.Formation								
								,FracRigOnsiteDate						= t1.FracRigOnsiteDate						
								,FracRigReleaseDate						= t1.FracRigReleaseDate						
								,FracStages								= t1.FracStages								
								,FrictionReducer_LBS					= t1.FrictionReducer_LBS					
								,GasGravity_SG							= t1.GasGravity_SG							
								,GasTestRate_MCFPerDAY					= t1.GasTestRate_MCFPerDAY					
								,GasTestRate_MCFPerDAYPer1000FT			= t1.GasTestRate_MCFPerDAYPer1000FT			
								,GellingAgent_LBS						= t1.GellingAgent_LBS						
								,GeneralComments						= t1.GeneralComments						
								,GeomBHL_Point							= t1.GeomBHL_Point							
								,GeomSHL_Point							= t1.GeomSHL_Point		
								,GOR_ScfPerBbl							= t1.GOR_ScfPerBbl							
								,GovernmentWellId						= t1.GovernmentWellId						
								,InitialOperator						= t1.InitialOperator						
								,IronControl_LBS						= t1.IronControl_LBS						
								,Last3MonthISOR							= t1.Last3MonthISOR							
								,Last12MonthGasProduction_MCF			= t1.Last12MonthGasProduction_MCF			
								,Last12MonthOilProduction_BBL			= t1.Last12MonthOilProduction_BBL			
								,Last12MonthProduction_BOE				= t1.Last12MonthProduction_BOE				
								,Last12MonthWaterProduction_BBL			= t1.Last12MonthWaterProduction_BBL			
								,LastMonthFlaredGas_MCF					= t1.LastMonthFlaredGas_MCF					
								,LastMonthGasProduction_MCF				= t1.LastMonthGasProduction_MCF				
								,LastMonthLiquidsProduction_BBL			= t1.LastMonthLiquidsProduction_BBL			
								,LastMonthWaterProduction_BBL			= t1.LastMonthWaterProduction_BBL			
								,LastProducingMonth						= t1.LastProducingMonth						
								,LateralLength_FT						= t1.LateralLength_FT						
								,LateralLine							= t1.LateralLine
								,Latitude								= t1.Latitude								
								,Latitude_BH							= t1.Latitude_BH							
								,Lease									= t1.Lease									
								,LeaseName								= t1.LeaseName								
								,Longitude								= t1.Longitude								
								,Longitude_BH							= t1.Longitude_BH							
								,LowerPerf_FT							= t1.LowerPerf_FT							
								,MD_FT									= t1.MD_FT									
								,MonthsToPeakProduction					= t1.MonthsToPeakProduction					
								,NumberOfStrings						= t1.NumberOfStrings						
								,ObjectiveAge							= t1.ObjectiveAge							
								,ObjectiveLithology						= t1.ObjectiveLithology						
								,OffConfidentialDate					= t1.OffConfidentialDate					
								,OilGravity_API							= t1.OilGravity_API							
								,OilProdPriorTest_BBL					= t1.OilProdPriorTest_BBL					
								,OilTestMethodName						= t1.OilTestMethodName						
								,OilTestRate_BBLPerDAY					= t1.OilTestRate_BBLPerDAY					
								,OilTestRate_BBLPerDAYPer1000FT			= t1.OilTestRate_BBLPerDAYPer1000FT			
								,OnConfidential							= t1.OnConfidential							
								,OnOffshore								= t1.OnOffshore								
								,PeakFlaredGas_MCF						= t1.PeakFlaredGas_MCF						
								,PeakGas_MCF							= t1.PeakGas_MCF							
								,PeakGas_MCFPer1000FT					= t1.PeakGas_MCFPer1000FT					
								,PeakOil_BBL							= t1.PeakOil_BBL							
								,PeakOil_BBLPer1000FT					= t1.PeakOil_BBLPer1000FT					
								,PeakProd_BOE							= t1.PeakProd_BOE							
								,PeakProd_BOEPer1000FT					= t1.PeakProd_BOEPer1000FT					
								,PeakProd_MCFE							= t1.PeakProd_MCFE							
								,PeakProd_MCFEPer1000FT					= t1.PeakProd_MCFEPer1000FT					
								,PeakProductionDate						= t1.PeakProductionDate						
								,PeakWater_BBL							= t1.PeakWater_BBL							
								,PerfInterval_FT						= t1.PerfInterval_FT						
								,PermitApprovedDate						= t1.PermitApprovedDate						
								,PermitSubmittedDate					= t1.PermitSubmittedDate					
								,PermitToSpud_DAYS						= t1.PermitToSpud_DAYS						
								,Platform								= t1.Platform								
								,PlugbackMeasuredDepth_FT				= t1.PlugbackMeasuredDepth_FT				
								,PlugbackTrueVerticalDepth_FT			= t1.PlugbackTrueVerticalDepth_FT			
								,PlugDate								= t1.PlugDate								
								,Proppant_LBS							= t1.Proppant_LBS							
								,ProppantIntensity_LBSPerFT				= t1.ProppantIntensity_LBSPerFT				
								,ProppantLoading_LBSPerGAL				= t1.ProppantLoading_LBSPerGAL				
								,Range									= t1.Range									
								,RawOperator							= t1.RawOperator							
								,RawVintage								= t1.RawVintage								
								,ResourceMagnitude						= t1.ResourceMagnitude						
								,ResourceMagnitudeReviewDate			= t1.ResourceMagnitudeReviewDate			
								,ResourceSourceQualifier				= t1.ResourceSourceQualifier				
								,ResourceVolumeGasBcf					= t1.ResourceVolumeGasBcf					
								,ResourceVolumeLiquidsMMb				= t1.ResourceVolumeLiquidsMMb				
								,RigReleaseDate							= t1.RigReleaseDate							
								,ScaleInhibitor_LBS						= t1.ScaleInhibitor_LBS						
								,Section								= t1.Section								
								,Section_Township_Range					= t1.Section_Township_Range					
								,ShotsPer1000FT							= t1.ShotsPer1000FT							
								,ShotsPerStage							= t1.ShotsPerStage							
								,ShutInPressure_PSI						= t1.ShutInPressure_PSI						
								,SoakTime_DAYS							= t1.SoakTime_DAYS							
								,SpudDate								= t1.SpudDate								
								,SpudDateQualifier						= t1.SpudDateQualifier						
								,SpudDateSource							= t1.SpudDateSource							
								,SpudToCompletion_DAYS					= t1.SpudToCompletion_DAYS					
								,SpudToRigRelease_DAYS					= t1.SpudToRigRelease_DAYS					
								,SpudToSales_DAYS						= t1.SpudToSales_DAYS						
								,StateFileNumber						= t1.StateFileNumber						
								,StateProvince							= t1.StateProvince							
								,StateWellType							= t1.StateWellType							
								,StimulatedStages						= t1.StimulatedStages						
								,SurfaceLatLongSource					= t1.SurfaceLatLongSource					
								,Surfactant_LBS							= t1.Surfactant_LBS							
								,TestComments							= t1.TestComments							
								,TestDate								= t1.TestDate								
								,TestRate_BOEPerDAY						= t1.TestRate_BOEPerDAY						
								,TestRate_BOEPerDAYPer1000FT			= t1.TestRate_BOEPerDAYPer1000FT			
								,TestRate_MCFEPerDAY					= t1.TestRate_MCFEPerDAY					
								,TestRate_MCFEPerDAYPer1000FT			= t1.TestRate_MCFEPerDAYPer1000FT			
								,TestWHLiquids_PCT						= t1.TestWHLiquids_PCT						
								,TotalClusters							= t1.TotalClusters							
								,TotalFluidPumped_BBL					= t1.TotalFluidPumped_BBL					
								,TotalProducingMonths					= t1.TotalProducingMonths					
								,TotalShots								= t1.TotalShots								
								,TotalWaterPumped_GAL					= t1.TotalWaterPumped_GAL					
								,Township								= t1.Township								
								,Trajectory								= t1.Trajectory								
								,TVD_FT									= t1.TVD_FT									
								,UnconventionalFlag						= t1.UnconventionalFlag						
								,UnconventionalType						= t1.UnconventionalType						
								,Unit_Name								= t1.Unit_Name								
								,UpdatedDate							= t1.UpdatedDate							
								,UpperPerf_FT							= t1.UpperPerf_FT							
								,Vintage								= t1.Vintage								
								,WaterDepth								= t1.WaterDepth								
								,WaterIntensity_GALPerFT				= t1.WaterIntensity_GALPerFT				
								,WaterSaturation_PCT					= t1.WaterSaturation_PCT					
								,WaterTestRate_BBLPerDAY				= t1.WaterTestRate_BBLPerDAY				
								,WaterTestRate_BBLPerDAYPer1000FT		= t1.WaterTestRate_BBLPerDAYPer1000FT		
								,WellboreID								= t1.WellboreID								
								,WellID									= t1.WellID									
								,WellName								= t1.WellName								
								,WellNumber								= t1.WellNumber								
								,WellPadDirection						= t1.WellPadDirection						
								,WellPadID								= t1.WellPadID								
								,WellSymbols							= t1.WellSymbols							
								,WHLiquids_PCT							= t1.WHLiquids_PCT							        

								--,ETL_Load_Date						= t1.ETL_Load_Date

						FROM
							data.Well t0

							INNER JOIN #Well t1
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
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Well; Process Inserts')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						INSERT INTO data.Well ( 
							  Abstract								
							 ,AcidVolume_BBL							
							 ,AlternativeWellName					
							 ,API_UWI								
							 ,API_UWI_Unformatted					
							 ,API_UWI_12								
							 ,API_UWI_12_Unformatted					
							 ,API_UWI_14								
							 ,API_UWI_14_Unformatted					
							 ,AverageStageSpacing_FT					
							 ,AvgBreakdownPressure_PSI				
							 ,AvgClusterSpacing_FT					
							 ,AvgClusterSpacingPerStage_FT			
							 ,AvgFluidPerCluster_BBL					
							 ,AvgFluidPerShot_BBL					
							 ,AvgFluidPerStage_BBL					
							 ,AvgFracGradient_PSIPerFT				
							 ,AvgISIP_PSI							
							 ,AvgMillTime_Min						
							 ,AvgPortSleeveOpeningPressure_PSI		
							 ,AvgProppantPerCluster_LBS				
							 ,AvgProppantPerShot_LBS					
							 ,AvgProppantPerStage_LBS				
							 ,AvgShotsPerCluster						
							 ,AvgShotsPerFT							
							 ,AvgTreatmentPressure_PSI				
							 ,AvgTreatmentRate_BBLPerMin				
							 ,Biocide_LBS							
							 ,Block									
							 ,Bottom_Hole_Temp_DEGF					
							 ,BottomHoleAge							
							 ,BottomHoleFormationName				
							 ,BottomHoleLithology					
							 ,Breaker_LBS							
							 ,Buffer_LBS								
							 ,CasingPressure_PSI						
							 ,ChokeSize_64IN							
							 ,ClayControl_LBS						
							 ,ClustersPer1000FT						
							 ,ClustersPerStage						
							 ,CompletionDate							
							 ,CompletionDesign						
							 ,CompletionID							
							 ,CompletionNumber						
							 ,CompletionTime_DAYS					
							 ,Contract								
							 ,CoordinateQuality						
							 ,CoordinateSource						
							 ,Country								
							 ,County									
							 ,CrossLinker_LBS						
							 ,CumGas_MCF								
							 ,CumGas_MCFPer1000FT					
							 ,CumOil_BBL								
							 ,CumOil_BBLPer1000FT					
							 ,CumProd_BOE							
							 ,CumProd_BOEPer1000FT					
							 ,CumProd_MCFE							
							 ,CumProd_MCFEPer1000FT					
							 ,CumulativeSOR							
							 ,CumWater_BBL							
							 ,DeletedDate							
							 ,DevelopmentFlag						
							 ,DiscoverMagnitudeComments				
							 ,DiscoveryType							
							 ,District								
							 ,Diverter_LBS							
							 ,DrillingEndDate						
							 ,DrillingTDDate							
							 ,DrillingTDDateQualifier				
							 ,ElevationGL_FT							
							 ,ElevationKB_FT							
							 ,EndDateQualifier						
							 ,Energizer_LBS							
							 ,ENVBasin								
							 ,ENVCompInsertedDate					
							 ,ENVElevationGL_FT						
							 ,ENVElevationGLSource					
							 ,ENVElevationKB_FT						
							 ,ENVElevationKBSource					
							 ,ENVFluidType							
							 ,ENVFracJobType							
							 ,ENVInterval							
							 ,ENVIntervalSource						
							 ,Environment							
							 ,ENVOperator							
							 ,ENVPeerGroup							
							 ,ENVPlay								
							 ,ENVProducingMethod						
							 ,ENVProdWellType						
							 ,ENVProppantBrand						
							 ,ENVProppantType						
							 ,ENVRegion								
							 ,ENVStockExchange						
							 ,ENVSubPlay								
							 ,ENVTicker								
							 ,ENVWellboreType						
							 ,ENVWellGrouping						
							 ,ENVWellServiceProvider					
							 ,ENVWellStatus							
							 ,ENVWellType							
							 ,ExplorationFlag						
							 ,Field									
							 ,First3MonthFlaredGas_MCF				
							 ,First3MonthGas_MCF						
							 ,First3MonthGas_MCFPer1000FT			
							 ,First3MonthOil_BBL						
							 ,First3MonthOil_BBLPer1000FT			
							 ,First3MonthProd_BOE					
							 ,First3MonthProd_BOEPer1000FT			
							 ,First3MonthProd_MCFE					
							 ,First3MonthProd_MCFEPer1000FT			
							 ,First3MonthWater_BBL					
							 ,First6MonthFlaredGas_MCF				
							 ,First6MonthGas_MCF						
							 ,First6MonthGas_MCFPer1000FT			
							 ,First6MonthOil_BBL						
							 ,First6MonthOil_BBLPer1000FT			
							 ,First6MonthProd_BOE					
							 ,First6MonthProd_BOEPer1000FT			
							 ,First6MonthProd_MCFE					
							 ,First6MonthProd_MCFEPer1000FT			
							 ,First6MonthWater_BBL					
							 ,First9MonthFlaredGas_MCF				
							 ,First9MonthGas_MCF						
							 ,First9MonthGas_MCFPer1000FT			
							 ,First9MonthOil_BBL						
							 ,First9MonthOil_BBLPer1000FT			
							 ,First9MonthProd_BOE					
							 ,First9MonthProd_BOEPer1000FT			
							 ,First9MonthProd_MCFE					
							 ,First9MonthProd_MCFEPer1000FT			
							 ,First9MonthWater_BBL					
							 ,First12MonthFlaredGas_MCF				
							 ,First12MonthGas_MCF					
							 ,First12MonthGas_MCFPer1000FT			
							 ,First12MonthOil_BBL					
							 ,First12MonthOil_BBLPer1000FT			
							 ,First12MonthProd_BOE					
							 ,First12MonthProd_BOEPer1000FT			
							 ,First12MonthProd_MCFE					
							 ,First12MonthProd_MCFEPer1000FT			
							 ,First12MonthWater_BBL					
							 ,First36MonthGas_MCF					
							 ,First36MonthGas_MCFPer1000FT			
							 ,First36MonthOil_BBL					
							 ,First36MonthOil_BBLPer1000FT			
							 ,First36MonthProd_BOE					
							 ,First36MonthProd_BOEPer1000FT			
							 ,First36MonthProd_MCFE					
							 ,First36MonthProd_MCFEPer1000FT			
							 ,First36MonthWater_BBL					
							 ,First36MonthWaterProductionBBLPer1000Ft
							 ,FirstDay								
							 ,FirstProdDate							
							 ,FirstProdMonth							
							 ,FirstProdQuarter						
							 ,FirstProdYear							
							 ,FlaredGasRatio							
							 ,FlowingTubingPressure_PSI				
							 ,FluidIntensity_BBLPerFT				
							 ,Formation								
							 ,FracRigOnsiteDate						
							 ,FracRigReleaseDate						
							 ,FracStages								
							 ,FrictionReducer_LBS					
							 ,GasGravity_SG							
							 ,GasTestRate_MCFPerDAY					
							 ,GasTestRate_MCFPerDAYPer1000FT			
							 ,GellingAgent_LBS						
							 ,GeneralComments						
							 ,GeomBHL_Point							
							 ,GeomSHL_Point
							 ,GOR_ScfPerBbl							
							 ,GovernmentWellId						
							 ,InitialOperator						
							 ,IronControl_LBS						
							 ,Last3MonthISOR							
							 ,Last12MonthGasProduction_MCF			
							 ,Last12MonthOilProduction_BBL			
							 ,Last12MonthProduction_BOE				
							 ,Last12MonthWaterProduction_BBL			
							 ,LastMonthFlaredGas_MCF					
							 ,LastMonthGasProduction_MCF				
							 ,LastMonthLiquidsProduction_BBL			
							 ,LastMonthWaterProduction_BBL			
							 ,LastProducingMonth						
							 ,LateralLength_FT						
							 ,LateralLine
							 ,Latitude								
							 ,Latitude_BH							
							 ,Lease									
							 ,LeaseName								
							 ,Longitude								
							 ,Longitude_BH							
							 ,LowerPerf_FT							
							 ,MD_FT									
							 ,MonthsToPeakProduction					
							 ,NumberOfStrings						
							 ,ObjectiveAge							
							 ,ObjectiveLithology						
							 ,OffConfidentialDate					
							 ,OilGravity_API							
							 ,OilProdPriorTest_BBL					
							 ,OilTestMethodName						
							 ,OilTestRate_BBLPerDAY					
							 ,OilTestRate_BBLPerDAYPer1000FT			
							 ,OnConfidential							
							 ,OnOffshore								
							 ,PeakFlaredGas_MCF						
							 ,PeakGas_MCF							
							 ,PeakGas_MCFPer1000FT					
							 ,PeakOil_BBL							
							 ,PeakOil_BBLPer1000FT					
							 ,PeakProd_BOE							
							 ,PeakProd_BOEPer1000FT					
							 ,PeakProd_MCFE							
							 ,PeakProd_MCFEPer1000FT					
							 ,PeakProductionDate						
							 ,PeakWater_BBL							
							 ,PerfInterval_FT						
							 ,PermitApprovedDate						
							 ,PermitSubmittedDate					
							 ,PermitToSpud_DAYS						
							 ,Platform								
							 ,PlugbackMeasuredDepth_FT				
							 ,PlugbackTrueVerticalDepth_FT			
							 ,PlugDate								
							 ,Proppant_LBS							
							 ,ProppantIntensity_LBSPerFT				
							 ,ProppantLoading_LBSPerGAL				
							 ,Range									
							 ,RawOperator							
							 ,RawVintage								
							 ,ResourceMagnitude						
							 ,ResourceMagnitudeReviewDate			
							 ,ResourceSourceQualifier				
							 ,ResourceVolumeGasBcf					
							 ,ResourceVolumeLiquidsMMb				
							 ,RigReleaseDate							
							 ,ScaleInhibitor_LBS						
							 ,Section								
							 ,Section_Township_Range					
							 ,ShotsPer1000FT							
							 ,ShotsPerStage							
							 ,ShutInPressure_PSI						
							 ,SoakTime_DAYS							
							 ,SpudDate								
							 ,SpudDateQualifier						
							 ,SpudDateSource							
							 ,SpudToCompletion_DAYS					
							 ,SpudToRigRelease_DAYS					
							 ,SpudToSales_DAYS						
							 ,StateFileNumber						
							 ,StateProvince							
							 ,StateWellType							
							 ,StimulatedStages						
							 ,SurfaceLatLongSource					
							 ,Surfactant_LBS							
							 ,TestComments							
							 ,TestDate								
							 ,TestRate_BOEPerDAY						
							 ,TestRate_BOEPerDAYPer1000FT			
							 ,TestRate_MCFEPerDAY					
							 ,TestRate_MCFEPerDAYPer1000FT			
							 ,TestWHLiquids_PCT						
							 ,TotalClusters							
							 ,TotalFluidPumped_BBL					
							 ,TotalProducingMonths					
							 ,TotalShots								
							 ,TotalWaterPumped_GAL					
							 ,Township								
							 ,Trajectory								
							 ,TVD_FT									
							 ,UnconventionalFlag						
							 ,UnconventionalType						
							 ,Unit_Name								
							 ,UpdatedDate							
							 ,UpperPerf_FT							
							 ,Vintage								
							 ,WaterDepth								
							 ,WaterIntensity_GALPerFT				
							 ,WaterSaturation_PCT					
							 ,WaterTestRate_BBLPerDAY				
							 ,WaterTestRate_BBLPerDAYPer1000FT		
							 ,WellboreID								
							 ,WellID									
							 ,WellName								
							 ,WellNumber								
							 ,WellPadDirection						
							 ,WellPadID								
							 ,WellSymbols							
							 ,WHLiquids_PCT							  
					
							,ETL_Load_Date
							)
						SELECT					
							 Abstract								 = t0.Abstract								
							,AcidVolume_BBL							 = t0.AcidVolume_BBL							
							,AlternativeWellName					 = t0.AlternativeWellName					
							,API_UWI								 = t0.API_UWI								
							,API_UWI_Unformatted					 = t0.API_UWI_Unformatted					
							,API_UWI_12								 = t0.API_UWI_12								
							,API_UWI_12_Unformatted					 = t0.API_UWI_12_Unformatted					
							,API_UWI_14								 = t0.API_UWI_14								
							,API_UWI_14_Unformatted					 = t0.API_UWI_14_Unformatted					
							,AverageStageSpacing_FT					 = t0.AverageStageSpacing_FT					
							,AvgBreakdownPressure_PSI				 = t0.AvgBreakdownPressure_PSI				
							,AvgClusterSpacing_FT					 = t0.AvgClusterSpacing_FT					
							,AvgClusterSpacingPerStage_FT			 = t0.AvgClusterSpacingPerStage_FT			
							,AvgFluidPerCluster_BBL					 = t0.AvgFluidPerCluster_BBL					
							,AvgFluidPerShot_BBL					 = t0.AvgFluidPerShot_BBL					
							,AvgFluidPerStage_BBL					 = t0.AvgFluidPerStage_BBL					
							,AvgFracGradient_PSIPerFT				 = t0.AvgFracGradient_PSIPerFT				
							,AvgISIP_PSI							 = t0.AvgISIP_PSI							
							,AvgMillTime_Min						 = t0.AvgMillTime_Min						
							,AvgPortSleeveOpeningPressure_PSI		 = t0.AvgPortSleeveOpeningPressure_PSI		
							,AvgProppantPerCluster_LBS				 = t0.AvgProppantPerCluster_LBS				
							,AvgProppantPerShot_LBS					 = t0.AvgProppantPerShot_LBS					
							,AvgProppantPerStage_LBS				 = t0.AvgProppantPerStage_LBS				
							,AvgShotsPerCluster						 = t0.AvgShotsPerCluster						
							,AvgShotsPerFT							 = t0.AvgShotsPerFT							
							,AvgTreatmentPressure_PSI				 = t0.AvgTreatmentPressure_PSI				
							,AvgTreatmentRate_BBLPerMin				 = t0.AvgTreatmentRate_BBLPerMin				
							,Biocide_LBS							 = t0.Biocide_LBS							
							,Block									 = t0.Block									
							,Bottom_Hole_Temp_DEGF					 = t0.Bottom_Hole_Temp_DEGF					
							,BottomHoleAge							 = t0.BottomHoleAge							
							,BottomHoleFormationName				 = t0.BottomHoleFormationName				
							,BottomHoleLithology					 = t0.BottomHoleLithology					
							,Breaker_LBS							 = t0.Breaker_LBS							
							,Buffer_LBS								 = t0.Buffer_LBS								
							,CasingPressure_PSI						 = t0.CasingPressure_PSI						
							,ChokeSize_64IN							 = t0.ChokeSize_64IN							
							,ClayControl_LBS						 = t0.ClayControl_LBS						
							,ClustersPer1000FT						 = t0.ClustersPer1000FT						
							,ClustersPerStage						 = t0.ClustersPerStage						
							,CompletionDate							 = t0.CompletionDate							
							,CompletionDesign						 = t0.CompletionDesign						
							,CompletionID							 = t0.CompletionID							
							,CompletionNumber						 = t0.CompletionNumber						
							,CompletionTime_DAYS					 = t0.CompletionTime_DAYS					
							,Contract								 = t0.Contract								
							,CoordinateQuality						 = t0.CoordinateQuality						
							,CoordinateSource						 = t0.CoordinateSource						
							,Country								 = t0.Country								
							,County									 = t0.County									
							,CrossLinker_LBS						 = t0.CrossLinker_LBS						
							,CumGas_MCF								 = t0.CumGas_MCF								
							,CumGas_MCFPer1000FT					 = t0.CumGas_MCFPer1000FT					
							,CumOil_BBL								 = t0.CumOil_BBL								
							,CumOil_BBLPer1000FT					 = t0.CumOil_BBLPer1000FT					
							,CumProd_BOE							 = t0.CumProd_BOE							
							,CumProd_BOEPer1000FT					 = t0.CumProd_BOEPer1000FT					
							,CumProd_MCFE							 = t0.CumProd_MCFE							
							,CumProd_MCFEPer1000FT					 = t0.CumProd_MCFEPer1000FT					
							,CumulativeSOR							 = t0.CumulativeSOR							
							,CumWater_BBL							 = t0.CumWater_BBL							
							,DeletedDate							 = t0.DeletedDate							
							,DevelopmentFlag						 = t0.DevelopmentFlag						
							,DiscoverMagnitudeComments				 = t0.DiscoverMagnitudeComments				
							,DiscoveryType							 = t0.DiscoveryType							
							,District								 = t0.District								
							,Diverter_LBS							 = t0.Diverter_LBS							
							,DrillingEndDate						 = t0.DrillingEndDate						
							,DrillingTDDate							 = t0.DrillingTDDate							
							,DrillingTDDateQualifier				 = t0.DrillingTDDateQualifier				
							,ElevationGL_FT							 = t0.ElevationGL_FT							
							,ElevationKB_FT							 = t0.ElevationKB_FT							
							,EndDateQualifier						 = t0.EndDateQualifier						
							,Energizer_LBS							 = t0.Energizer_LBS							
							,ENVBasin								 = t0.ENVBasin								
							,ENVCompInsertedDate					 = t0.ENVCompInsertedDate					
							,ENVElevationGL_FT						 = t0.ENVElevationGL_FT						
							,ENVElevationGLSource					 = t0.ENVElevationGLSource					
							,ENVElevationKB_FT						 = t0.ENVElevationKB_FT						
							,ENVElevationKBSource					 = t0.ENVElevationKBSource					
							,ENVFluidType							 = t0.ENVFluidType							
							,ENVFracJobType							 = t0.ENVFracJobType							
							,ENVInterval							 = t0.ENVInterval							
							,ENVIntervalSource						 = t0.ENVIntervalSource						
							,Environment							 = t0.Environment							
							,ENVOperator							 = t0.ENVOperator							
							,ENVPeerGroup							 = t0.ENVPeerGroup							
							,ENVPlay								 = t0.ENVPlay								
							,ENVProducingMethod						 = t0.ENVProducingMethod						
							,ENVProdWellType						 = t0.ENVProdWellType						
							,ENVProppantBrand						 = t0.ENVProppantBrand						
							,ENVProppantType						 = t0.ENVProppantType						
							,ENVRegion								 = t0.ENVRegion								
							,ENVStockExchange						 = t0.ENVStockExchange						
							,ENVSubPlay								 = t0.ENVSubPlay								
							,ENVTicker								 = t0.ENVTicker								
							,ENVWellboreType						 = t0.ENVWellboreType						
							,ENVWellGrouping						 = t0.ENVWellGrouping						
							,ENVWellServiceProvider					 = t0.ENVWellServiceProvider					
							,ENVWellStatus							 = t0.ENVWellStatus							
							,ENVWellType							 = t0.ENVWellType							
							,ExplorationFlag						 = t0.ExplorationFlag						
							,Field									 = t0.Field									
							,First3MonthFlaredGas_MCF				 = t0.First3MonthFlaredGas_MCF				
							,First3MonthGas_MCF						 = t0.First3MonthGas_MCF						
							,First3MonthGas_MCFPer1000FT			 = t0.First3MonthGas_MCFPer1000FT			
							,First3MonthOil_BBL						 = t0.First3MonthOil_BBL						
							,First3MonthOil_BBLPer1000FT			 = t0.First3MonthOil_BBLPer1000FT			
							,First3MonthProd_BOE					 = t0.First3MonthProd_BOE					
							,First3MonthProd_BOEPer1000FT			 = t0.First3MonthProd_BOEPer1000FT			
							,First3MonthProd_MCFE					 = t0.First3MonthProd_MCFE					
							,First3MonthProd_MCFEPer1000FT			 = t0.First3MonthProd_MCFEPer1000FT			
							,First3MonthWater_BBL					 = t0.First3MonthWater_BBL					
							,First6MonthFlaredGas_MCF				 = t0.First6MonthFlaredGas_MCF				
							,First6MonthGas_MCF						 = t0.First6MonthGas_MCF						
							,First6MonthGas_MCFPer1000FT			 = t0.First6MonthGas_MCFPer1000FT			
							,First6MonthOil_BBL						 = t0.First6MonthOil_BBL						
							,First6MonthOil_BBLPer1000FT			 = t0.First6MonthOil_BBLPer1000FT			
							,First6MonthProd_BOE					 = t0.First6MonthProd_BOE					
							,First6MonthProd_BOEPer1000FT			 = t0.First6MonthProd_BOEPer1000FT			
							,First6MonthProd_MCFE					 = t0.First6MonthProd_MCFE					
							,First6MonthProd_MCFEPer1000FT			 = t0.First6MonthProd_MCFEPer1000FT			
							,First6MonthWater_BBL					 = t0.First6MonthWater_BBL					
							,First9MonthFlaredGas_MCF				 = t0.First9MonthFlaredGas_MCF				
							,First9MonthGas_MCF						 = t0.First9MonthGas_MCF						
							,First9MonthGas_MCFPer1000FT			 = t0.First9MonthGas_MCFPer1000FT			
							,First9MonthOil_BBL						 = t0.First9MonthOil_BBL						
							,First9MonthOil_BBLPer1000FT			 = t0.First9MonthOil_BBLPer1000FT			
							,First9MonthProd_BOE					 = t0.First9MonthProd_BOE					
							,First9MonthProd_BOEPer1000FT			 = t0.First9MonthProd_BOEPer1000FT			
							,First9MonthProd_MCFE					 = t0.First9MonthProd_MCFE					
							,First9MonthProd_MCFEPer1000FT			 = t0.First9MonthProd_MCFEPer1000FT			
							,First9MonthWater_BBL					 = t0.First9MonthWater_BBL					
							,First12MonthFlaredGas_MCF				 = t0.First12MonthFlaredGas_MCF				
							,First12MonthGas_MCF					 = t0.First12MonthGas_MCF					
							,First12MonthGas_MCFPer1000FT			 = t0.First12MonthGas_MCFPer1000FT			
							,First12MonthOil_BBL					 = t0.First12MonthOil_BBL					
							,First12MonthOil_BBLPer1000FT			 = t0.First12MonthOil_BBLPer1000FT			
							,First12MonthProd_BOE					 = t0.First12MonthProd_BOE					
							,First12MonthProd_BOEPer1000FT			 = t0.First12MonthProd_BOEPer1000FT			
							,First12MonthProd_MCFE					 = t0.First12MonthProd_MCFE					
							,First12MonthProd_MCFEPer1000FT			 = t0.First12MonthProd_MCFEPer1000FT			
							,First12MonthWater_BBL					 = t0.First12MonthWater_BBL					
							,First36MonthGas_MCF					 = t0.First36MonthGas_MCF					
							,First36MonthGas_MCFPer1000FT			 = t0.First36MonthGas_MCFPer1000FT			
							,First36MonthOil_BBL					 = t0.First36MonthOil_BBL					
							,First36MonthOil_BBLPer1000FT			 = t0.First36MonthOil_BBLPer1000FT			
							,First36MonthProd_BOE					 = t0.First36MonthProd_BOE					
							,First36MonthProd_BOEPer1000FT			 = t0.First36MonthProd_BOEPer1000FT			
							,First36MonthProd_MCFE					 = t0.First36MonthProd_MCFE					
							,First36MonthProd_MCFEPer1000FT			 = t0.First36MonthProd_MCFEPer1000FT			
							,First36MonthWater_BBL					 = t0.First36MonthWater_BBL					
							,First36MonthWaterProductionBBLPer1000Ft = t0.First36MonthWaterProductionBBLPer1000Ft
							,FirstDay								 = t0.FirstDay								
							,FirstProdDate							 = t0.FirstProdDate							
							,FirstProdMonth							 = t0.FirstProdMonth							
							,FirstProdQuarter						 = t0.FirstProdQuarter						
							,FirstProdYear							 = t0.FirstProdYear							
							,FlaredGasRatio							 = t0.FlaredGasRatio							
							,FlowingTubingPressure_PSI				 = t0.FlowingTubingPressure_PSI				
							,FluidIntensity_BBLPerFT				 = t0.FluidIntensity_BBLPerFT				
							,Formation								 = t0.Formation								
							,FracRigOnsiteDate						 = t0.FracRigOnsiteDate						
							,FracRigReleaseDate						 = t0.FracRigReleaseDate						
							,FracStages								 = t0.FracStages								
							,FrictionReducer_LBS					 = t0.FrictionReducer_LBS					
							,GasGravity_SG							 = t0.GasGravity_SG							
							,GasTestRate_MCFPerDAY					 = t0.GasTestRate_MCFPerDAY					
							,GasTestRate_MCFPerDAYPer1000FT			 = t0.GasTestRate_MCFPerDAYPer1000FT			
							,GellingAgent_LBS						 = t0.GellingAgent_LBS						
							,GeneralComments						 = t0.GeneralComments						
							,GeomBHL_Point							 = t0.GeomBHL_Point							
							,GeomSHL_Point							 = t0.GeomSHL_Point
							,GOR_ScfPerBbl							 = t0.GOR_ScfPerBbl							
							,GovernmentWellId						 = t0.GovernmentWellId						
							,InitialOperator						 = t0.InitialOperator						
							,IronControl_LBS						 = t0.IronControl_LBS						
							,Last3MonthISOR							 = t0.Last3MonthISOR							
							,Last12MonthGasProduction_MCF			 = t0.Last12MonthGasProduction_MCF			
							,Last12MonthOilProduction_BBL			 = t0.Last12MonthOilProduction_BBL			
							,Last12MonthProduction_BOE				 = t0.Last12MonthProduction_BOE				
							,Last12MonthWaterProduction_BBL			 = t0.Last12MonthWaterProduction_BBL			
							,LastMonthFlaredGas_MCF					 = t0.LastMonthFlaredGas_MCF					
							,LastMonthGasProduction_MCF				 = t0.LastMonthGasProduction_MCF				
							,LastMonthLiquidsProduction_BBL			 = t0.LastMonthLiquidsProduction_BBL			
							,LastMonthWaterProduction_BBL			 = t0.LastMonthWaterProduction_BBL			
							,LastProducingMonth						 = t0.LastProducingMonth						
							,LateralLength_FT						 = t0.LateralLength_FT						
							,LateralLine							 = t0.LateralLine		
							,Latitude								 = t0.Latitude								
							,Latitude_BH							 = t0.Latitude_BH							
							,Lease									 = t0.Lease									
							,LeaseName								 = t0.LeaseName								
							,Longitude								 = t0.Longitude								
							,Longitude_BH							 = t0.Longitude_BH							
							,LowerPerf_FT							 = t0.LowerPerf_FT							
							,MD_FT									 = t0.MD_FT									
							,MonthsToPeakProduction					 = t0.MonthsToPeakProduction					
							,NumberOfStrings						 = t0.NumberOfStrings						
							,ObjectiveAge							 = t0.ObjectiveAge							
							,ObjectiveLithology						 = t0.ObjectiveLithology						
							,OffConfidentialDate					 = t0.OffConfidentialDate					
							,OilGravity_API							 = t0.OilGravity_API							
							,OilProdPriorTest_BBL					 = t0.OilProdPriorTest_BBL					
							,OilTestMethodName						 = t0.OilTestMethodName						
							,OilTestRate_BBLPerDAY					 = t0.OilTestRate_BBLPerDAY					
							,OilTestRate_BBLPerDAYPer1000FT			 = t0.OilTestRate_BBLPerDAYPer1000FT			
							,OnConfidential							 = t0.OnConfidential							
							,OnOffshore								 = t0.OnOffshore								
							,PeakFlaredGas_MCF						 = t0.PeakFlaredGas_MCF						
							,PeakGas_MCF							 = t0.PeakGas_MCF							
							,PeakGas_MCFPer1000FT					 = t0.PeakGas_MCFPer1000FT					
							,PeakOil_BBL							 = t0.PeakOil_BBL							
							,PeakOil_BBLPer1000FT					 = t0.PeakOil_BBLPer1000FT					
							,PeakProd_BOE							 = t0.PeakProd_BOE							
							,PeakProd_BOEPer1000FT					 = t0.PeakProd_BOEPer1000FT					
							,PeakProd_MCFE							 = t0.PeakProd_MCFE							
							,PeakProd_MCFEPer1000FT					 = t0.PeakProd_MCFEPer1000FT					
							,PeakProductionDate						 = t0.PeakProductionDate						
							,PeakWater_BBL							 = t0.PeakWater_BBL							
							,PerfInterval_FT						 = t0.PerfInterval_FT						
							,PermitApprovedDate						 = t0.PermitApprovedDate						
							,PermitSubmittedDate					 = t0.PermitSubmittedDate					
							,PermitToSpud_DAYS						 = t0.PermitToSpud_DAYS						
							,Platform								 = t0.Platform								
							,PlugbackMeasuredDepth_FT				 = t0.PlugbackMeasuredDepth_FT				
							,PlugbackTrueVerticalDepth_FT			 = t0.PlugbackTrueVerticalDepth_FT			
							,PlugDate								 = t0.PlugDate								
							,Proppant_LBS							 = t0.Proppant_LBS							
							,ProppantIntensity_LBSPerFT				 = t0.ProppantIntensity_LBSPerFT				
							,ProppantLoading_LBSPerGAL				 = t0.ProppantLoading_LBSPerGAL				
							,Range									 = t0.Range									
							,RawOperator							 = t0.RawOperator							
							,RawVintage								 = t0.RawVintage								
							,ResourceMagnitude						 = t0.ResourceMagnitude						
							,ResourceMagnitudeReviewDate			 = t0.ResourceMagnitudeReviewDate			
							,ResourceSourceQualifier				 = t0.ResourceSourceQualifier				
							,ResourceVolumeGasBcf					 = t0.ResourceVolumeGasBcf					
							,ResourceVolumeLiquidsMMb				 = t0.ResourceVolumeLiquidsMMb				
							,RigReleaseDate							 = t0.RigReleaseDate							
							,ScaleInhibitor_LBS						 = t0.ScaleInhibitor_LBS						
							,Section								 = t0.Section								
							,Section_Township_Range					 = t0.Section_Township_Range					
							,ShotsPer1000FT							 = t0.ShotsPer1000FT							
							,ShotsPerStage							 = t0.ShotsPerStage							
							,ShutInPressure_PSI						 = t0.ShutInPressure_PSI						
							,SoakTime_DAYS							 = t0.SoakTime_DAYS							
							,SpudDate								 = t0.SpudDate								
							,SpudDateQualifier						 = t0.SpudDateQualifier						
							,SpudDateSource							 = t0.SpudDateSource							
							,SpudToCompletion_DAYS					 = t0.SpudToCompletion_DAYS					
							,SpudToRigRelease_DAYS					 = t0.SpudToRigRelease_DAYS					
							,SpudToSales_DAYS						 = t0.SpudToSales_DAYS						
							,StateFileNumber						 = t0.StateFileNumber						
							,StateProvince							 = t0.StateProvince							
							,StateWellType							 = t0.StateWellType							
							,StimulatedStages						 = t0.StimulatedStages						
							,SurfaceLatLongSource					 = t0.SurfaceLatLongSource					
							,Surfactant_LBS							 = t0.Surfactant_LBS							
							,TestComments							 = t0.TestComments							
							,TestDate								 = t0.TestDate								
							,TestRate_BOEPerDAY						 = t0.TestRate_BOEPerDAY						
							,TestRate_BOEPerDAYPer1000FT			 = t0.TestRate_BOEPerDAYPer1000FT			
							,TestRate_MCFEPerDAY					 = t0.TestRate_MCFEPerDAY					
							,TestRate_MCFEPerDAYPer1000FT			 = t0.TestRate_MCFEPerDAYPer1000FT			
							,TestWHLiquids_PCT						 = t0.TestWHLiquids_PCT						
							,TotalClusters							 = t0.TotalClusters							
							,TotalFluidPumped_BBL					 = t0.TotalFluidPumped_BBL					
							,TotalProducingMonths					 = t0.TotalProducingMonths					
							,TotalShots								 = t0.TotalShots								
							,TotalWaterPumped_GAL					 = t0.TotalWaterPumped_GAL					
							,Township								 = t0.Township								
							,Trajectory								 = t0.Trajectory								
							,TVD_FT									 = t0.TVD_FT									
							,UnconventionalFlag						 = t0.UnconventionalFlag						
							,UnconventionalType						 = t0.UnconventionalType						
							,Unit_Name								 = t0.Unit_Name								
							,UpdatedDate							 = t0.UpdatedDate							
							,UpperPerf_FT							 = t0.UpperPerf_FT							
							,Vintage								 = t0.Vintage								
							,WaterDepth								 = t0.WaterDepth								
							,WaterIntensity_GALPerFT				 = t0.WaterIntensity_GALPerFT				
							,WaterSaturation_PCT					 = t0.WaterSaturation_PCT					
							,WaterTestRate_BBLPerDAY				 = t0.WaterTestRate_BBLPerDAY				
							,WaterTestRate_BBLPerDAYPer1000FT		 = t0.WaterTestRate_BBLPerDAYPer1000FT		
							,WellboreID								 = t0.WellboreID								
							,WellID									 = t0.WellID									
							,WellName								 = t0.WellName								
							,WellNumber								 = t0.WellNumber								
							,WellPadDirection						 = t0.WellPadDirection						
							,WellPadID								 = t0.WellPadID								
							,WellSymbols							 = t0.WellSymbols							
							,WHLiquids_PCT							 = t0.WHLiquids_PCT								   			

							,ETL_Load_Date							 = t0.ETL_Load_Date				
						FROM
							#Well t0

							LEFT OUTER JOIN data.Well t1
	
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
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.Well')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						SELECT 
							 _row_id
                            ,_delete
                            ,_error
                            ,_message

							,Abstract								
							,AcidVolume_BBL							
							,AlternativeWellName					
							,API_UWI								
							,API_UWI_Unformatted					
							,API_UWI_12								
							,API_UWI_12_Unformatted					
							,API_UWI_14								
							,API_UWI_14_Unformatted					
							,AverageStageSpacing_FT					
							,AvgBreakdownPressure_PSI				
							,AvgClusterSpacing_FT					
							,AvgClusterSpacingPerStage_FT			
							,AvgFluidPerCluster_BBL					
							,AvgFluidPerShot_BBL					
							,AvgFluidPerStage_BBL					
							,AvgFracGradient_PSIPerFT				
							,AvgISIP_PSI							
							,AvgMillTime_Min						
							,AvgPortSleeveOpeningPressure_PSI		
							,AvgProppantPerCluster_LBS				
							,AvgProppantPerShot_LBS					
							,AvgProppantPerStage_LBS				
							,AvgShotsPerCluster						
							,AvgShotsPerFT							
							,AvgTreatmentPressure_PSI				
							,AvgTreatmentRate_BBLPerMin				
							,Biocide_LBS							
							,Block									
							,Bottom_Hole_Temp_DEGF					
							,BottomHoleAge							
							,BottomHoleFormationName				
							,BottomHoleLithology					
							,Breaker_LBS							
							,Buffer_LBS								
							,CasingPressure_PSI						
							,ChokeSize_64IN							
							,ClayControl_LBS						
							,ClustersPer1000FT						
							,ClustersPerStage						
							,CompletionDate							
							,CompletionDesign						
							,CompletionID							
							,CompletionNumber						
							,CompletionTime_DAYS					
							,Contract								
							,CoordinateQuality						
							,CoordinateSource						
							,Country								
							,County									
							,CrossLinker_LBS						
							,CumGas_MCF								
							,CumGas_MCFPer1000FT					
							,CumOil_BBL								
							,CumOil_BBLPer1000FT					
							,CumProd_BOE							
							,CumProd_BOEPer1000FT					
							,CumProd_MCFE							
							,CumProd_MCFEPer1000FT					
							,CumulativeSOR							
							,CumWater_BBL							
							,DeletedDate							
							,DevelopmentFlag						
							,DiscoverMagnitudeComments				
							,DiscoveryType							
							,District								
							,Diverter_LBS							
							,DrillingEndDate						
							,DrillingTDDate							
							,DrillingTDDateQualifier				
							,ElevationGL_FT							
							,ElevationKB_FT							
							,EndDateQualifier						
							,Energizer_LBS							
							,ENVBasin								
							,ENVCompInsertedDate					
							,ENVElevationGL_FT						
							,ENVElevationGLSource					
							,ENVElevationKB_FT						
							,ENVElevationKBSource					
							,ENVFluidType							
							,ENVFracJobType							
							,ENVInterval							
							,ENVIntervalSource						
							,Environment							
							,ENVOperator							
							,ENVPeerGroup							
							,ENVPlay								
							,ENVProducingMethod						
							,ENVProdWellType						
							,ENVProppantBrand						
							,ENVProppantType						
							,ENVRegion								
							,ENVStockExchange						
							,ENVSubPlay								
							,ENVTicker								
							,ENVWellboreType						
							,ENVWellGrouping						
							,ENVWellServiceProvider					
							,ENVWellStatus							
							,ENVWellType							
							,ExplorationFlag						
							,Field									
							,First3MonthFlaredGas_MCF				
							,First3MonthGas_MCF						
							,First3MonthGas_MCFPer1000FT			
							,First3MonthOil_BBL						
							,First3MonthOil_BBLPer1000FT			
							,First3MonthProd_BOE					
							,First3MonthProd_BOEPer1000FT			
							,First3MonthProd_MCFE					
							,First3MonthProd_MCFEPer1000FT			
							,First3MonthWater_BBL					
							,First6MonthFlaredGas_MCF				
							,First6MonthGas_MCF						
							,First6MonthGas_MCFPer1000FT			
							,First6MonthOil_BBL						
							,First6MonthOil_BBLPer1000FT			
							,First6MonthProd_BOE					
							,First6MonthProd_BOEPer1000FT			
							,First6MonthProd_MCFE					
							,First6MonthProd_MCFEPer1000FT			
							,First6MonthWater_BBL					
							,First9MonthFlaredGas_MCF				
							,First9MonthGas_MCF						
							,First9MonthGas_MCFPer1000FT			
							,First9MonthOil_BBL						
							,First9MonthOil_BBLPer1000FT			
							,First9MonthProd_BOE					
							,First9MonthProd_BOEPer1000FT			
							,First9MonthProd_MCFE					
							,First9MonthProd_MCFEPer1000FT			
							,First9MonthWater_BBL					
							,First12MonthFlaredGas_MCF				
							,First12MonthGas_MCF					
							,First12MonthGas_MCFPer1000FT			
							,First12MonthOil_BBL					
							,First12MonthOil_BBLPer1000FT			
							,First12MonthProd_BOE					
							,First12MonthProd_BOEPer1000FT			
							,First12MonthProd_MCFE					
							,First12MonthProd_MCFEPer1000FT			
							,First12MonthWater_BBL					
							,First36MonthGas_MCF					
							,First36MonthGas_MCFPer1000FT			
							,First36MonthOil_BBL					
							,First36MonthOil_BBLPer1000FT			
							,First36MonthProd_BOE					
							,First36MonthProd_BOEPer1000FT			
							,First36MonthProd_MCFE					
							,First36MonthProd_MCFEPer1000FT			
							,First36MonthWater_BBL					
							,First36MonthWaterProductionBBLPer1000Ft
							,FirstDay								
							,FirstProdDate							
							,FirstProdMonth							
							,FirstProdQuarter						
							,FirstProdYear							
							,FlaredGasRatio							
							,FlowingTubingPressure_PSI				
							,FluidIntensity_BBLPerFT				
							,Formation								
							,FracRigOnsiteDate						
							,FracRigReleaseDate						
							,FracStages								
							,FrictionReducer_LBS					
							,GasGravity_SG							
							,GasTestRate_MCFPerDAY					
							,GasTestRate_MCFPerDAYPer1000FT			
							,GellingAgent_LBS						
							,GeneralComments						
							,GeomBHL_Point							
							,GeomSHL_Point	
							,GOR_ScfPerBbl							
							,GovernmentWellId						
							,InitialOperator						
							,IronControl_LBS						
							,Last3MonthISOR							
							,Last12MonthGasProduction_MCF			
							,Last12MonthOilProduction_BBL			
							,Last12MonthProduction_BOE				
							,Last12MonthWaterProduction_BBL			
							,LastMonthFlaredGas_MCF					
							,LastMonthGasProduction_MCF				
							,LastMonthLiquidsProduction_BBL			
							,LastMonthWaterProduction_BBL			
							,LastProducingMonth						
							,LateralLength_FT						
							,LateralLine
							,Latitude								
							,Latitude_BH							
							,Lease									
							,LeaseName								
							,Longitude								
							,Longitude_BH							
							,LowerPerf_FT							
							,MD_FT									
							,MonthsToPeakProduction					
							,NumberOfStrings						
							,ObjectiveAge							
							,ObjectiveLithology						
							,OffConfidentialDate					
							,OilGravity_API							
							,OilProdPriorTest_BBL					
							,OilTestMethodName						
							,OilTestRate_BBLPerDAY					
							,OilTestRate_BBLPerDAYPer1000FT			
							,OnConfidential							
							,OnOffshore								
							,PeakFlaredGas_MCF						
							,PeakGas_MCF							
							,PeakGas_MCFPer1000FT					
							,PeakOil_BBL							
							,PeakOil_BBLPer1000FT					
							,PeakProd_BOE							
							,PeakProd_BOEPer1000FT					
							,PeakProd_MCFE							
							,PeakProd_MCFEPer1000FT					
							,PeakProductionDate						
							,PeakWater_BBL							
							,PerfInterval_FT						
							,PermitApprovedDate						
							,PermitSubmittedDate					
							,PermitToSpud_DAYS						
							,Platform								
							,PlugbackMeasuredDepth_FT				
							,PlugbackTrueVerticalDepth_FT			
							,PlugDate								
							,Proppant_LBS							
							,ProppantIntensity_LBSPerFT				
							,ProppantLoading_LBSPerGAL				
							,Range									
							,RawOperator							
							,RawVintage								
							,ResourceMagnitude						
							,ResourceMagnitudeReviewDate			
							,ResourceSourceQualifier				
							,ResourceVolumeGasBcf					
							,ResourceVolumeLiquidsMMb				
							,RigReleaseDate							
							,ScaleInhibitor_LBS						
							,Section								
							,Section_Township_Range					
							,ShotsPer1000FT							
							,ShotsPerStage							
							,ShutInPressure_PSI						
							,SoakTime_DAYS							
							,SpudDate								
							,SpudDateQualifier						
							,SpudDateSource							
							,SpudToCompletion_DAYS					
							,SpudToRigRelease_DAYS					
							,SpudToSales_DAYS						
							,StateFileNumber						
							,StateProvince							
							,StateWellType							
							,StimulatedStages						
							,SurfaceLatLongSource					
							,Surfactant_LBS							
							,TestComments							
							,TestDate								
							,TestRate_BOEPerDAY						
							,TestRate_BOEPerDAYPer1000FT			
							,TestRate_MCFEPerDAY					
							,TestRate_MCFEPerDAYPer1000FT			
							,TestWHLiquids_PCT						
							,TotalClusters							
							,TotalFluidPumped_BBL					
							,TotalProducingMonths					
							,TotalShots								
							,TotalWaterPumped_GAL					
							,Township								
							,Trajectory								
							,TVD_FT									
							,UnconventionalFlag						
							,UnconventionalType						
							,Unit_Name								
							,UpdatedDate							
							,UpperPerf_FT							
							,Vintage								
							,WaterDepth								
							,WaterIntensity_GALPerFT				
							,WaterSaturation_PCT					
							,WaterTestRate_BBLPerDAY				
							,WaterTestRate_BBLPerDAYPer1000FT		
							,WellboreID								
							,WellID									
							,WellName								
							,WellNumber								
							,WellPadDirection						
							,WellPadID								
							,WellSymbols							
							,WHLiquids_PCT									   
												
							,ETL_Load_Date
						FROM 
							#Well
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