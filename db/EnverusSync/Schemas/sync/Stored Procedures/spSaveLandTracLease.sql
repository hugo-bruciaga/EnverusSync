/***********************************************************************************

	Procedure Name:		sync.spLandtracLease
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
CREATE PROCEDURE sync.spSaveLandtracLease (
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

				  -- #LandtracLease
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; #LandtracLease')
			  
				  DROP TABLE IF EXISTS #LandtracLease
				  CREATE TABLE #LandtracLease (
					 _row_id						BIGINT IDENTITY(1,1)	NOT NULL	PRIMARY KEY CLUSTERED
					,_delete						BIT			NULL
					,_duplicate						BIT			NULL
					,_error							BIT			NULL
					,_message						VARCHAR		NULL

					,Acres							FLOAT(53)	 NULL
					,AssigneeInterest				FLOAT(53)	 NULL
					,AssigneeName					VARCHAR(128) NULL
					,AssignmentEffectiveDate		DATETIME	 NULL
					,AssignmentVolumePage			VARCHAR(32)	 NULL
					,BLMLease						BIGINT		 NULL
					,Bonus							FLOAT(53)	 NULL
					,Country						VARCHAR(8)	 NULL
					,County							VARCHAR(32)	 NULL
					,CountyCode						VARCHAR(8)	 NULL
					,DeletedDate					DATETIME	 NULL
					,DepthSeveranceType				VARCHAR(16)	 NULL
					,DocLink						VARCHAR(256) NULL
					,EffectiveDate					DATETIME	 NULL
					,ENVBasin						VARCHAR(32)	 NULL
					,ENVRegion						VARCHAR(32)	 NULL
					,ENVSubPlay						VARCHAR(128) NULL
					,ExpirationDate					DATETIME	 NULL
					,Extension						BIGINT		 NULL
					,ExtensionBonus					FLOAT(53)	 NULL
					,ExtensionTermMonth				FLOAT(53)	 NULL
					,Geom_Poly						sys.GEOMETRY NULL
					,GranteeAddress					VARCHAR(128) NULL
					,GranteeAlias					VARCHAR(128) NULL
					,GranteeName					VARCHAR(256) NULL
					,GrantorAddress					VARCHAR(128) NULL
					,GrantorName					VARCHAR(256) NULL
					,HasDepthSeverance				VARCHAR(8)	 NULL
					,InstrumentDate					DATETIME	 NULL
					,InstrumentType					VARCHAR(32)	 NULL
					,LeaseID						BIGINT		 NOT NULL
					,MaximumDepth					BIGINT		 NULL
					,MinimumDepth					BIGINT		 NULL
					,Nomination						BIGINT		 NULL
					,RecordDate						DATETIME	 NULL
					,RecordNumber					VARCHAR(32)	 NULL
					,Royalty						FLOAT(53)	 NULL
					,SpatialAssignee				VARCHAR(64)	 NULL
					,StateCode						VARCHAR(8)	 NULL
					,StateLease						BIGINT		 NULL
					,StateProvince					VARCHAR(8)	 NULL
					,TermMonths						BIGINT		 NULL
					,UpdatedDate					DATETIME	 NULL
					,VolumePage						VARCHAR(32)	 NULL
					,ETL_Load_Date					DATETIME	 NULL
				  
					,INDEX idx_tempdb_LandtracLease_LeaseID
						NONCLUSTERED (
							LeaseID
						)
				  )

			------------------------------------------------------------------------
			-- Save LandtracLease data
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Save LandtracLease data')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				--------------------------------------------------------------------
				-- Unpack LandtracLease JSON
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Unpack LandtracLease JSON')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					INSERT INTO #LandtracLease (
						 _duplicate
						,_error
						,_delete

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
						,Geom_Poly						

						,ETL_Load_Date
						)
					SELECT
						 _duplicate = count(*) OVER (PARTITION BY t0.LeaseID)-1
						,_error		= 0
						,_delete		BIT

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
						,t1.GeoData Geom_Poly						
						,sysdatetime()
					FROM
						OPENJSON(@data)
						WITH (
							 _delete				BIT

							,Acres					FLOAT(53)	 
							,AssigneeInterest		FLOAT(53)	 
							,AssigneeName			VARCHAR(128) 
							,AssignmentEffectiveDate DATETIME	 
							,AssignmentVolumePage	VARCHAR(32)	 
							,BLMLease				BIGINT		 
							,Bonus					FLOAT(53)	 
							,Country				VARCHAR(8)	 
							,County					VARCHAR(32)	 
							,CountyCode				VARCHAR(8)	 
							,DeletedDate			DATETIME	 
							,DepthSeveranceType		VARCHAR(16)	 
							,DocLink				VARCHAR(256) 
							,EffectiveDate			DATETIME	 
							,ENVBasin				VARCHAR(32)	 
							,ENVRegion				VARCHAR(32)	 
							,ENVSubPlay				VARCHAR(128) 
							,ExpirationDate			DATETIME	 
							,Extension				BIGINT		 
							,ExtensionBonus			FLOAT(53)	 
							,ExtensionTermMonth		FLOAT(53)	 
							,Geom_Poly				Varchar(max) 
							,GranteeAddress			VARCHAR(128) 
							,GranteeAlias			VARCHAR(128) 
							,GranteeName			VARCHAR(256) 
							,GrantorAddress			VARCHAR(128) 
							,GrantorName			VARCHAR(256) 
							,HasDepthSeverance		VARCHAR(8)	 
							,InstrumentDate			DATETIME	 
							,InstrumentType			VARCHAR(32)	 
							,LeaseID				BIGINT		 
							,MaximumDepth			BIGINT		 
							,MinimumDepth			BIGINT		 
							,Nomination				BIGINT		 
							,RecordDate				DATETIME	 
							,RecordNumber			VARCHAR(32)	 
							,Royalty				FLOAT(53)	 
							,SpatialAssignee		VARCHAR(64)	 
							,StateCode				VARCHAR(8)	 
							,StateLease				BIGINT		 
							,StateProvince			VARCHAR(8)	 
							,TermMonths				BIGINT		 
							,UpdatedDate			DATETIME	 
							,VolumePage				VARCHAR(32)	 
							--,ETL_Load_Date		DATETIME
						) t0
						CROSS APPLY [sync].[fnGetGeometryFromStr](Geom_Poly) t1

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Validate LandtracLease data
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Validate LandtracLease data')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					UPDATE #LandtracLease SET 
						 _delete	= coalesce(_delete, 0)
						,_error		= CASE 
										-- Set error true if duplicate detected
										WHEN _duplicate = 1 THEN 1
										
										-- Set error true if WellID is null or empty string
										WHEN LeaseID IS NULL OR LeaseID = '' THEN 1
										ELSE 0
									  END
						,_message	=   -- Add error message duplicate detected
									+ CASE WHEN _duplicate = 1 THEN '[ERROR: There were one or more records with the same LeaseID this record will be ignored ( '+LeaseID+')];' ELSE '' END
									+ CASE WHEN LeaseID IS NULL OR LeaseID = '' THEN '[ERROR: LeaseID cannot be null or empty string)];' ELSE '' END
								
					
					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Save data to data.LandtracLease
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Save data to data.LandtracLease')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					----------------------------------------------------------------
					-- Process Deletes
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.LandtracLease; Process Deletes')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						DELETE t0
						FROM
							data.LandtracLease t0

							INNER JOIN #LandtracLease t1
							   ON t0.LeaseID = t1.LeaseID

						WHERE 1=1
							AND t1.DeletedDate is null
							AND t1._delete = 1
							AND t1._error = 0

						SET @ErrPos += concat(' [ ',@@rowcount,' ]')
						PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Updates
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.LandtracLease; Process Updates')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						UPDATE t0 SET	
							 Acres					=t1.Acres					
							,AssigneeInterest		=t1.AssigneeInterest		
							,AssigneeName			=t1.AssigneeName			
							,AssignmentEffectiveDate=t1.AssignmentEffectiveDate
							,AssignmentVolumePage	=t1.AssignmentVolumePage	
							,BLMLease				=t1.BLMLease				
							,Bonus					=t1.Bonus					
							,Country				=t1.Country				
							,County					=t1.County					
							,CountyCode				=t1.CountyCode				
							,DeletedDate			=t1.DeletedDate			
							,DepthSeveranceType		=t1.DepthSeveranceType		
							,DocLink				=t1.DocLink				
							,EffectiveDate			=t1.EffectiveDate			
							,ENVBasin				=t1.ENVBasin				
							,ENVRegion				=t1.ENVRegion				
							,ENVSubPlay				=t1.ENVSubPlay				
							,ExpirationDate			=t1.ExpirationDate			
							,Extension				=t1.Extension				
							,ExtensionBonus			=t1.ExtensionBonus			
							,ExtensionTermMonth		=t1.ExtensionTermMonth		
							,Geom_Poly				=t1.Geom_Poly				
							,GranteeAddress			=t1.GranteeAddress			
							,GranteeAlias			=t1.GranteeAlias			
							,GranteeName			=t1.GranteeName			
							,GrantorAddress			=t1.GrantorAddress			
							,GrantorName			=t1.GrantorName			
							,HasDepthSeverance		=t1.HasDepthSeverance		
							,InstrumentDate			=t1.InstrumentDate			
							,InstrumentType			=t1.InstrumentType			
							,LeaseID				=t1.LeaseID				
							,MaximumDepth			=t1.MaximumDepth			
							,MinimumDepth			=t1.MinimumDepth			
							,Nomination				=t1.Nomination				
							,RecordDate				=t1.RecordDate				
							,RecordNumber			=t1.RecordNumber			
							,Royalty				=t1.Royalty				
							,SpatialAssignee		=t1.SpatialAssignee		
							,StateCode				=t1.StateCode				
							,StateLease				=t1.StateLease				
							,StateProvince			=t1.StateProvince			
							,TermMonths				=t1.TermMonths				
							,UpdatedDate			=t1.UpdatedDate			
							,VolumePage				=t1.VolumePage				
							--,ETL_Load_Date					= t1.ETL_Load_Date

						FROM
							data.LandtracLease t0

							INNER JOIN #LandtracLease t1
								ON t0.LeaseID = t1.LeaseID

						WHERE 1=1
							AND t1._delete = 0
							AND t1._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Inserts
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.LandtracLease; Process Inserts')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						INSERT INTO data.LandtracLease (					
							 Acres					
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
							)
						SELECT					
							 Acres					= t0.Acres					
							,AssigneeInterest		= t0.AssigneeInterest		
							,AssigneeName			= t0.AssigneeName			
							,AssignmentEffectiveDate= t0.AssignmentEffectiveDate	
							,AssignmentVolumePage	= t0.AssignmentVolumePage	
							,BLMLease				= t0.BLMLease				
							,Bonus					= t0.Bonus					
							,Country				= t0.Country				
							,County					= t0.County					
							,CountyCode				= t0.CountyCode				
							,DeletedDate			= t0.DeletedDate			
							,DepthSeveranceType		= t0.DepthSeveranceType			
							,DocLink				= t0.DocLink				
							,EffectiveDate			= t0.EffectiveDate			
							,ENVBasin				= t0.ENVBasin				
							,ENVRegion				= t0.ENVRegion				
							,ENVSubPlay				= t0.ENVSubPlay				
							,ExpirationDate			= t0.ExpirationDate			
							,Extension				= t0.Extension				
							,ExtensionBonus			= t0.ExtensionBonus			
							,ExtensionTermMonth		= t0.ExtensionTermMonth		
							,Geom_Poly				= t0.Geom_Poly				
							,GranteeAddress			= t0.GranteeAddress			
							,GranteeAlias			= t0.GranteeAlias			
							,GranteeName			= t0.GranteeName			
							,GrantorAddress			= t0.GrantorAddress			
							,GrantorName			= t0.GrantorName			
							,HasDepthSeverance		= t0.HasDepthSeverance		
							,InstrumentDate			= t0.InstrumentDate			
							,InstrumentType			= t0.InstrumentType			
							,LeaseID				= t0.LeaseID				
							,MaximumDepth			= t0.MaximumDepth			
							,MinimumDepth			= t0.MinimumDepth			
							,Nomination				= t0.Nomination				
							,RecordDate				= t0.RecordDate				
							,RecordNumber			= t0.RecordNumber			
							,Royalty				= t0.Royalty				
							,SpatialAssignee		= t0.SpatialAssignee		
							,StateCode				= t0.StateCode				
							,StateLease				= t0.StateLease				
							,StateProvince			= t0.StateProvince			
							,TermMonths				= t0.TermMonths				
							,UpdatedDate			= t0.UpdatedDate			
							,VolumePage				= t0.VolumePage				
							,ETL_Load_Date			= t0.ETL_Load_Date				
						FROM
							#LandtracLease t0

							LEFT OUTER JOIN data.LandtracLease t1
								ON t0.LeaseID = t1.LeaseID

						WHERE 1=1
							AND t1.LeaseID		IS NULL

							AND t0._delete = 0
							AND t0._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Error Output
				--------------------------------------------------------------------
					IF @NoOutput = 0
					BEGIN
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.LandtracLease')
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
							#LandtracLease
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