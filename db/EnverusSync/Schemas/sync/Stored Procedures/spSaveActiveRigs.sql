/***********************************************************************************

	Procedure Name:		sync.spSaveActiveRigs
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
CREATE PROCEDURE sync.spSaveActiveRig (
	 @data			VARCHAR(MAX)
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
			  	  IF isjson(@data) = 0
				  BEGIN
				      SET @ErrMsg = 'The @data must be a well formed JSON structure';
					  THROW 2147483647,@ErrMsg,1;
				  END
				  
			------------------------------------------------------------------------
			-- Initialize procedure resources
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Initialize procedure resources')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				  -- #ActiveRig
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; #ActiveRig')
			  
				  DROP TABLE IF EXISTS #ActiveRig
				  CREATE TABLE #ActiveRig (
					 _row_id						BIGINT IDENTITY(1,1)	NOT NULL	PRIMARY KEY CLUSTERED
					,_delete						BIT				NULL
					,_duplicate						BIT				NULL
					,_error							BIT				NULL
					,_message						VARCHAR			NULL

					,API_UWI						VARCHAR(32)		NULL
					,DeletedDate					DATETIME		NULL
					,UpdatedDate					DATETIME		NULL
					,WellID							BIGINT			NULL
					,Abstract						VARCHAR(16)		NULL
					,AmendedDate					DATETIME		NULL
					,API_UWI_Unformatted			VARCHAR(32)		NULL
					,ApprovedDate					DATETIME		NULL
					,Block							VARCHAR(256)	NULL
					,BottomHoleLatitude				FLOAT(53)		NULL
					,BottomHoleLongitude			FLOAT(53)		NULL
					,ContractorAddress				VARCHAR(256)	NULL
					,ContractorCity					VARCHAR(256)	NULL
					,ContractorContact				VARCHAR(256)	NULL
					,ContractorEmail				VARCHAR(256)	NULL
					,ContractorName					VARCHAR(256)	NULL
					,ContractorPhone				VARCHAR(256)	NULL
					,ContractorState				VARCHAR(256)	NULL
					,ContractorWebsite				VARCHAR(256)	NULL
					,ContractorZip					VARCHAR(256)	NULL
					,Country						VARCHAR(2)		NULL
					,County							VARCHAR(32)		NULL
					,DirectionsToLocation			VARCHAR(MAX)	NULL
					,District						VARCHAR(256)	NULL
					,DrawWorks						VARCHAR(256)	NULL
					,ENVBasin						VARCHAR(64)		NULL
					,ENVGasGatherer					VARCHAR(256)	NULL
					,ENVGasGatheringSystem			VARCHAR(256)	NULL
					,ENVInterval					VARCHAR(128)	NULL
					,ENVOilGatherer					VARCHAR(256)	NULL
					,ENVOilGatheringSystem			VARCHAR(256)	NULL
					,ENVOperator					VARCHAR(256)	NULL
					,ENVPeerGroup					VARCHAR(256)	NULL
					,ENVPlay						VARCHAR(128)	NULL
					,ENVRegion						VARCHAR(32)		NULL
					,ENVRigID						INT				NULL
					,ENVSubPlay						VARCHAR(64)		NULL
					,ENVTicker						VARCHAR(128)	NULL
					,ExpiredDate					DATETIME		NULL
					,Field							VARCHAR(56)		NULL
					,H2SArea						BIT				NULL
					,LandOffshore					VARCHAR(8)		NULL
					,LeaseName						VARCHAR(256)	NULL
					,Mobility						VARCHAR(256)	NULL
					,OperatorAddress				VARCHAR(256)	NULL
					,OperatorCity					VARCHAR(256)	NULL
					,OperatorCity30_MI				VARCHAR(256)	NULL
					,OperatorContact				VARCHAR(256)	NULL
					,OperatorPhone					VARCHAR(256)	NULL
					,OperatorState					VARCHAR(256)	NULL
					,OperatorZip					VARCHAR(256)	NULL
					,PermitNumber					VARCHAR(256)	NULL
					,PermittedMeasuredDepth_FT		INT				NULL
					,PermittedOperator				VARCHAR(256)	NULL
					,PermittedTrueVerticalDepth_FT	INT				NULL
					,PermittedWaterDepth_FT			INT				NULL
					,PermitType						VARCHAR(256)	NULL
					,PowerType						VARCHAR(256)	NULL
					,Range							VARCHAR(32)		NULL
					,RatedHorsePower				INT				NULL
					,RatedWaterDepth_FT				INT				NULL
					,RigClass						VARCHAR(256)	NULL
					,RigJobStartDate				DATETIME		NULL
					,RigLatitude					FLOAT(53)		NULL
					,RigLongitude					FLOAT(53)		NULL
					,RigNameNumber					VARCHAR(256)	NULL
					,RigType						VARCHAR(256)	NULL
					,Section						VARCHAR(32)		NULL
					,SpudDate						DATETIME		NULL
					,StateProvince					VARCHAR(64)		NULL
					,STR							VARCHAR(128)	NULL
					,SubmittedDate					DATETIME		NULL
					,SurfaceLocationSource			VARCHAR(256)	NULL
					,Survey							VARCHAR(256)	NULL
					,TargetFormation				VARCHAR(256)	NULL
					,Township						VARCHAR(32)		NULL
					,Trajectory						VARCHAR(256)	NULL
					,WellNumber						VARCHAR(256)	NULL
					,WellType						VARCHAR(256)	NULL
					,ETL_Load_Date					DATETIME		NULL
				  
					,INDEX idx_tempdb_ActiveRig_ENVRigID
						NONCLUSTERED (
							ENVRigID
						)
				  )

			------------------------------------------------------------------------
			-- Save ActiveRig data
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Save ActiveRig data')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				--------------------------------------------------------------------
				-- Unpack ActiveRig JSON
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Unpack ActiveRig JSON')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					INSERT INTO #ActiveRig (
						 _duplicate
						,_error
						,_delete
						,API_UWI
						,DeletedDate
						,UpdatedDate
						,WellID
						,Abstract
						,AmendedDate
						,API_UWI_Unformatted
						,ApprovedDate
						,Block
						,BottomHoleLatitude
						,BottomHoleLongitude
						,ContractorAddress
						,ContractorCity
						,ContractorContact
						,ContractorEmail
						,ContractorName
						,ContractorPhone
						,ContractorState
						,ContractorWebsite
						,ContractorZip
						,Country
						,County
						,DirectionsToLocation
						,District
						,DrawWorks
						,ENVBasin
						,ENVGasGatherer
						,ENVGasGatheringSystem
						,ENVInterval
						,ENVOilGatherer
						,ENVOilGatheringSystem
						,ENVOperator
						,ENVPeerGroup
						,ENVPlay
						,ENVRegion
						,ENVRigID
						,ENVSubPlay
						,ENVTicker
						,ExpiredDate
						,Field
						,H2SArea
						,LandOffshore
						,LeaseName
						,Mobility
						,OperatorAddress
						,OperatorCity
						,OperatorCity30_MI
						,OperatorContact
						,OperatorPhone
						,OperatorState
						,OperatorZip
						,PermitNumber
						,PermittedMeasuredDepth_FT
						,PermittedOperator
						,PermittedTrueVerticalDepth_FT
						,PermittedWaterDepth_FT
						,PermitType
						,PowerType
						,Range
						,RatedHorsePower
						,RatedWaterDepth_FT
						,RigClass
						,RigJobStartDate
						,RigLatitude
						,RigLongitude
						,RigNameNumber
						,RigType
						,Section
						,SpudDate
						,StateProvince
						,STR
						,SubmittedDate
						,SurfaceLocationSource
						,Survey
						,TargetFormation
						,Township
						,Trajectory
						,WellNumber
						,WellType
						,ETL_Load_Date
					)
					SELECT
						 _duplicate = count(*) OVER (PARTITION BY ENVRigID)-1
						,_error		= 0
						,*
						,sysdatetime()
					FROM
						OPENJSON(@data)
						WITH (
							 _delete						BIT
							,API_UWI						VARCHAR(32)
							,DeletedDate					DATETIME
							,UpdatedDate					DATETIME
							,WellID							BIGINT
							,Abstract						VARCHAR(16)
							,AmendedDate					DATETIME
							,API_UWI_Unformatted			VARCHAR(32)
							,ApprovedDate					DATETIME
							,Block							VARCHAR(256)
							,BottomHoleLatitude				FLOAT(53)
							,BottomHoleLongitude			FLOAT(53)
							,ContractorAddress				VARCHAR(256)
							,ContractorCity					VARCHAR(256)
							,ContractorContact				VARCHAR(256)
							,ContractorEmail				VARCHAR(256)
							,ContractorName					VARCHAR(256)
							,ContractorPhone				VARCHAR(256)
							,ContractorState				VARCHAR(256)
							,ContractorWebsite				VARCHAR(256)
							,ContractorZip					VARCHAR(256)
							,Country						VARCHAR(2)
							,County							VARCHAR(32)
							,DirectionsToLocation			VARCHAR(MAX)
							,District						VARCHAR(256)
							,DrawWorks						VARCHAR(256)
							,ENVBasin						VARCHAR(64)
							,ENVGasGatherer					VARCHAR(256)
							,ENVGasGatheringSystem			VARCHAR(256)
							,ENVInterval					VARCHAR(128)
							,ENVOilGatherer					VARCHAR(256)
							,ENVOilGatheringSystem			VARCHAR(256)
							,ENVOperator					VARCHAR(256)
							,ENVPeerGroup					VARCHAR(256)
							,ENVPlay						VARCHAR(128)
							,ENVRegion						VARCHAR(32)
							,ENVRigID						INT
							,ENVSubPlay						VARCHAR(64)
							,ENVTicker						VARCHAR(128)
							,ExpiredDate					DATETIME
							,Field							VARCHAR(56)
							,H2SArea						BIT
							,LandOffshore					VARCHAR(8)
							,LeaseName						VARCHAR(256)
							,Mobility						VARCHAR(256)
							,OperatorAddress				VARCHAR(256)
							,OperatorCity					VARCHAR(256)
							,OperatorCity30_MI				VARCHAR(256)
							,OperatorContact				VARCHAR(256)
							,OperatorPhone					VARCHAR(256)
							,OperatorState					VARCHAR(256)
							,OperatorZip					VARCHAR(256)
							,PermitNumber					VARCHAR(256)
							,PermittedMeasuredDepth_FT		INT
							,PermittedOperator				VARCHAR(256)
							,PermittedTrueVerticalDepth_FT	INT
							,PermittedWaterDepth_FT			INT
							,PermitType						VARCHAR(256)
							,PowerType						VARCHAR(256)
							,Range							VARCHAR(32)
							,RatedHorsePower				INT
							,RatedWaterDepth_FT				INT
							,RigClass						VARCHAR(256)
							,RigJobStartDate				DATETIME
							,RigLatitude					FLOAT(53)
							,RigLongitude					FLOAT(53)
							,RigNameNumber					VARCHAR(256)
							,RigType						VARCHAR(256)
							,Section						VARCHAR(32)
							,SpudDate						DATETIME
							,StateProvince					VARCHAR(64)
							,STR							VARCHAR(128)
							,SubmittedDate					DATETIME
							,SurfaceLocationSource			VARCHAR(256)
							,Survey							VARCHAR(256)
							,TargetFormation				VARCHAR(256)
							,Township						VARCHAR(32)
							,Trajectory						VARCHAR(256)
							,WellNumber						VARCHAR(256)
							,WellType						VARCHAR(256)
							--,ETL_Load_Date					DATETIME
						) t0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Validate ActiveRig data
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Validate ActiveRig data')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					UPDATE #ActiveRig SET 
						 _delete	= coalesce(_delete, 0)
						,_error		= CASE 
										-- Set error true if duplicate detected
										WHEN _duplicate = 1 THEN 1
										
										-- Set error true if ENVRigID is null or empty string
										WHEN ENVRigID IS NULL OR ENVRigID = '' THEN 1

										ELSE 0
									  END
						,_message	=   -- Add error message duplicate detected
									+ CASE WHEN _duplicate = 1 THEN '[ERROR: There were one or more records with the same ENVRigID, this record will be ignored ( '+ENVRigID+')];' ELSE '' END
									+ CASE WHEN ENVRigID IS NULL OR ENVRigID = '' THEN '[ERROR: ENVRigID cannot be null or empty string)];' ELSE '' END
					
					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Save data to data.ActiveRigs
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Save data to data.ActiveRig')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					----------------------------------------------------------------
					-- Process Deletes
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.ActiveRig; Process Deletes')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						DELETE t0
						FROM
							data.ActiveRig t0

							INNER JOIN #ActiveRig t1
								ON t0.ENVRigID = t1.ENVRigID
						
						WHERE 1=1
							AND t1.DeletedDate is null
							AND t1._delete = 1
							AND t1._error = 0

						SET @ErrPos += concat(' [ ',@@rowcount,' ]')
						PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Updates
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.ActiveRig; Process Updates')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						UPDATE t0 SET
							 API_UWI						= t1.API_UWI						
							,DeletedDate					= t1.DeletedDate					
							,UpdatedDate					= t1.UpdatedDate					
							,WellID							= t1.WellID							
							,Abstract						= t1.Abstract						
							,AmendedDate					= t1.AmendedDate					
							,API_UWI_Unformatted			= t1.API_UWI_Unformatted			
							,ApprovedDate					= t1.ApprovedDate					
							,Block							= t1.Block							
							,BottomHoleLatitude				= t1.BottomHoleLatitude				
							,BottomHoleLongitude			= t1.BottomHoleLongitude			
							,ContractorAddress				= t1.ContractorAddress				
							,ContractorCity					= t1.ContractorCity					
							,ContractorContact				= t1.ContractorContact				
							,ContractorEmail				= t1.ContractorEmail				
							,ContractorName					= t1.ContractorName					
							,ContractorPhone				= t1.ContractorPhone				
							,ContractorState				= t1.ContractorState				
							,ContractorWebsite				= t1.ContractorWebsite				
							,ContractorZip					= t1.ContractorZip					
							,Country						= t1.Country						
							,County							= t1.County							
							,DirectionsToLocation			= t1.DirectionsToLocation			
							,District						= t1.District						
							,DrawWorks						= t1.DrawWorks						
							,ENVBasin						= t1.ENVBasin						
							,ENVGasGatherer					= t1.ENVGasGatherer					
							,ENVGasGatheringSystem			= t1.ENVGasGatheringSystem			
							,ENVInterval					= t1.ENVInterval					
							,ENVOilGatherer					= t1.ENVOilGatherer					
							,ENVOilGatheringSystem			= t1.ENVOilGatheringSystem			
							,ENVOperator					= t1.ENVOperator					
							,ENVPeerGroup					= t1.ENVPeerGroup					
							,ENVPlay						= t1.ENVPlay						
							,ENVRegion						= t1.ENVRegion						
							,ENVSubPlay						= t1.ENVSubPlay						
							,ENVTicker						= t1.ENVTicker						
							,ExpiredDate					= t1.ExpiredDate					
							,Field							= t1.Field							
							,H2SArea						= t1.H2SArea						
							,LandOffshore					= t1.LandOffshore					
							,LeaseName						= t1.LeaseName						
							,Mobility						= t1.Mobility						
							,OperatorAddress				= t1.OperatorAddress				
							,OperatorCity					= t1.OperatorCity					
							,OperatorCity30_MI				= t1.OperatorCity30_MI				
							,OperatorContact				= t1.OperatorContact				
							,OperatorPhone					= t1.OperatorPhone					
							,OperatorState					= t1.OperatorState					
							,OperatorZip					= t1.OperatorZip					
							,PermitNumber					= t1.PermitNumber					
							,PermittedMeasuredDepth_FT		= t1.PermittedMeasuredDepth_FT		
							,PermittedOperator				= t1.PermittedOperator				
							,PermittedTrueVerticalDepth_FT	= t1.PermittedTrueVerticalDepth_FT	
							,PermittedWaterDepth_FT			= t1.PermittedWaterDepth_FT			
							,PermitType						= t1.PermitType						
							,PowerType						= t1.PowerType						
							,Range							= t1.Range							
							,RatedHorsePower				= t1.RatedHorsePower				
							,RatedWaterDepth_FT				= t1.RatedWaterDepth_FT				
							,RigClass						= t1.RigClass						
							,RigJobStartDate				= t1.RigJobStartDate				
							,RigLatitude					= t1.RigLatitude					
							,RigLongitude					= t1.RigLongitude					
							,RigNameNumber					= t1.RigNameNumber					
							,RigType						= t1.RigType						
							,Section						= t1.Section						
							,SpudDate						= t1.SpudDate						
							,StateProvince					= t1.StateProvince					
							,STR							= t1.STR							
							,SubmittedDate					= t1.SubmittedDate					
							,SurfaceLocationSource			= t1.SurfaceLocationSource			
							,Survey							= t1.Survey							
							,TargetFormation				= t1.TargetFormation				
							,Township						= t1.Township						
							,Trajectory						= t1.Trajectory						
							,WellNumber						= t1.WellNumber						
							,WellType						= t1.WellType						
							,ETL_Load_Date					= t1.ETL_Load_Date
						FROM
							data.ActiveRig t0

							INNER JOIN #ActiveRig t1
								ON t0.ENVRigID = t1.ENVRigID

						WHERE 1=1
							AND t1._delete = 0
							AND t1._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Inserts
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.ActiveRig; Process Inserts')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						INSERT INTO data.ActiveRig (
							 API_UWI						
							,DeletedDate					
							,UpdatedDate					
							,WellID							
							,Abstract						
							,AmendedDate					
							,API_UWI_Unformatted			
							,ApprovedDate					
							,Block							
							,BottomHoleLatitude				
							,BottomHoleLongitude			
							,ContractorAddress				
							,ContractorCity					
							,ContractorContact				
							,ContractorEmail				
							,ContractorName					
							,ContractorPhone				
							,ContractorState				
							,ContractorWebsite				
							,ContractorZip					
							,Country						
							,County							
							,DirectionsToLocation			
							,District						
							,DrawWorks						
							,ENVBasin						
							,ENVGasGatherer					
							,ENVGasGatheringSystem			
							,ENVInterval					
							,ENVOilGatherer					
							,ENVOilGatheringSystem			
							,ENVOperator					
							,ENVPeerGroup					
							,ENVPlay						
							,ENVRegion						
							,ENVRigID						
							,ENVSubPlay						
							,ENVTicker						
							,ExpiredDate					
							,Field							
							,H2SArea						
							,LandOffshore					
							,LeaseName						
							,Mobility						
							,OperatorAddress				
							,OperatorCity					
							,OperatorCity30_MI				
							,OperatorContact				
							,OperatorPhone					
							,OperatorState					
							,OperatorZip					
							,PermitNumber					
							,PermittedMeasuredDepth_FT		
							,PermittedOperator				
							,PermittedTrueVerticalDepth_FT	
							,PermittedWaterDepth_FT			
							,PermitType						
							,PowerType						
							,Range							
							,RatedHorsePower				
							,RatedWaterDepth_FT				
							,RigClass						
							,RigJobStartDate				
							,RigLatitude					
							,RigLongitude					
							,RigNameNumber					
							,RigType						
							,Section						
							,SpudDate						
							,StateProvince					
							,STR							
							,SubmittedDate					
							,SurfaceLocationSource			
							,Survey							
							,TargetFormation				
							,Township						
							,Trajectory						
							,WellNumber						
							,WellType						
							,ETL_Load_Date											
						)
						SELECT
							 API_UWI							= t0.API_UWI						
							,DeletedDate						= t0.DeletedDate					
							,UpdatedDate						= t0.UpdatedDate					
							,WellID								= t0.WellID							
							,Abstract							= t0.Abstract						
							,AmendedDate						= t0.AmendedDate					
							,API_UWI_Unformatted				= t0.API_UWI_Unformatted			
							,ApprovedDate						= t0.ApprovedDate					
							,Block								= t0.Block							
							,BottomHoleLatitude					= t0.BottomHoleLatitude				
							,BottomHoleLongitude				= t0.BottomHoleLongitude			
							,ContractorAddress					= t0.ContractorAddress				
							,ContractorCity						= t0.ContractorCity					
							,ContractorContact					= t0.ContractorContact				
							,ContractorEmail					= t0.ContractorEmail				
							,ContractorName						= t0.ContractorName					
							,ContractorPhone					= t0.ContractorPhone				
							,ContractorState					= t0.ContractorState				
							,ContractorWebsite					= t0.ContractorWebsite				
							,ContractorZip						= t0.ContractorZip					
							,Country							= t0.Country						
							,County								= t0.County							
							,DirectionsToLocation				= t0.DirectionsToLocation			
							,District							= t0.District						
							,DrawWorks							= t0.DrawWorks						
							,ENVBasin							= t0.ENVBasin						
							,ENVGasGatherer						= t0.ENVGasGatherer					
							,ENVGasGatheringSystem				= t0.ENVGasGatheringSystem			
							,ENVInterval						= t0.ENVInterval					
							,ENVOilGatherer						= t0.ENVOilGatherer					
							,ENVOilGatheringSystem				= t0.ENVOilGatheringSystem			
							,ENVOperator						= t0.ENVOperator					
							,ENVPeerGroup						= t0.ENVPeerGroup					
							,ENVPlay							= t0.ENVPlay						
							,ENVRegion							= t0.ENVRegion						
							,ENVRigID							= t0.ENVRigID						
							,ENVSubPlay							= t0.ENVSubPlay						
							,ENVTicker							= t0.ENVTicker						
							,ExpiredDate						= t0.ExpiredDate					
							,Field								= t0.Field							
							,H2SArea							= t0.H2SArea						
							,LandOffshore						= t0.LandOffshore					
							,LeaseName							= t0.LeaseName						
							,Mobility							= t0.Mobility						
							,OperatorAddress					= t0.OperatorAddress				
							,OperatorCity						= t0.OperatorCity					
							,OperatorCity30_MI					= t0.OperatorCity30_MI				
							,OperatorContact					= t0.OperatorContact				
							,OperatorPhone						= t0.OperatorPhone					
							,OperatorState						= t0.OperatorState					
							,OperatorZip						= t0.OperatorZip					
							,PermitNumber						= t0.PermitNumber					
							,PermittedMeasuredDepth_FT			= t0.PermittedMeasuredDepth_FT		
							,PermittedOperator					= t0.PermittedOperator				
							,PermittedTrueVerticalDepth_FT		= t0.PermittedTrueVerticalDepth_FT	
							,PermittedWaterDepth_FT				= t0.PermittedWaterDepth_FT			
							,PermitType							= t0.PermitType						
							,PowerType							= t0.PowerType						
							,Range								= t0.Range							
							,RatedHorsePower					= t0.RatedHorsePower				
							,RatedWaterDepth_FT					= t0.RatedWaterDepth_FT				
							,RigClass							= t0.RigClass						
							,RigJobStartDate					= t0.RigJobStartDate				
							,RigLatitude						= t0.RigLatitude					
							,RigLongitude						= t0.RigLongitude					
							,RigNameNumber						= t0.RigNameNumber					
							,RigType							= t0.RigType						
							,Section							= t0.Section						
							,SpudDate							= t0.SpudDate						
							,StateProvince						= t0.StateProvince					
							,STR								= t0.STR							
							,SubmittedDate						= t0.SubmittedDate					
							,SurfaceLocationSource				= t0.SurfaceLocationSource			
							,Survey								= t0.Survey							
							,TargetFormation					= t0.TargetFormation				
							,Township							= t0.Township						
							,Trajectory							= t0.Trajectory						
							,WellNumber							= t0.WellNumber						
							,WellType							= t0.WellType						
							,ETL_Load_Date						= t0.ETL_Load_Date					
						FROM
							#ActiveRig t0

							LEFT OUTER JOIN data.ActiveRig t1
								ON t0.ENVRigID = t1.ENVRigID

						WHERE 1=1
							AND t1.ENVRigID IS NULL
							AND t0._delete = 0
							AND t0._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Error Output
				--------------------------------------------------------------------
					IF @NoOutput = 0
					BEGIN
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.ActiveRig')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						SELECT 
							 _row_id
                            ,_delete
                            ,_error
                            ,_message
                            ,API_UWI
                            ,DeletedDate
                            ,UpdatedDate
                            ,WellID
                            ,Abstract
                            ,AmendedDate
                            ,API_UWI_Unformatted
                            ,ApprovedDate
                            ,Block
                            ,BottomHoleLatitude
                            ,BottomHoleLongitude
                            ,ContractorAddress
                            ,ContractorCity
                            ,ContractorContact
                            ,ContractorEmail
                            ,ContractorName
                            ,ContractorPhone
                            ,ContractorState
                            ,ContractorWebsite
                            ,ContractorZip
                            ,Country
                            ,County
                            ,DirectionsToLocation
                            ,District
                            ,DrawWorks
                            ,ENVBasin
                            ,ENVGasGatherer
                            ,ENVGasGatheringSystem
                            ,ENVInterval
                            ,ENVOilGatherer
                            ,ENVOilGatheringSystem
                            ,ENVOperator
                            ,ENVPeerGroup
                            ,ENVPlay
                            ,ENVRegion
                            ,ENVRigID
                            ,ENVSubPlay
                            ,ENVTicker
                            ,ExpiredDate
                            ,Field
                            ,H2SArea
                            ,LandOffshore
                            ,LeaseName
                            ,Mobility
                            ,OperatorAddress
                            ,OperatorCity
                            ,OperatorCity30_MI
                            ,OperatorContact
                            ,OperatorPhone
                            ,OperatorState
                            ,OperatorZip
                            ,PermitNumber
                            ,PermittedMeasuredDepth_FT
                            ,PermittedOperator
                            ,PermittedTrueVerticalDepth_FT
                            ,PermittedWaterDepth_FT
                            ,PermitType
                            ,PowerType
                            ,Range
                            ,RatedHorsePower
                            ,RatedWaterDepth_FT
                            ,RigClass
                            ,RigJobStartDate
                            ,RigLatitude
                            ,RigLongitude
                            ,RigNameNumber
                            ,RigType
                            ,Section
                            ,SpudDate
                            ,StateProvince
                            ,STR
                            ,SubmittedDate
                            ,SurfaceLocationSource
                            ,Survey
                            ,TargetFormation
                            ,Township
                            ,Trajectory
                            ,WellNumber
                            ,WellType
                            ,ETL_Load_Date
						FROM 
							#ActiveRig
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