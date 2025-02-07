/***********************************************************************************

	Procedure Name:		sync.spDrillStemTest
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
CREATE PROCEDURE sync.spSaveDrillStemTest (
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

				  -- #DrillStemTest
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; #DrillStemTest')
			  
				  DROP TABLE IF EXISTS #DrillStemTest
				  CREATE TABLE #DrillStemTest (
					 _row_id						BIGINT IDENTITY(1,1)	NOT NULL	PRIMARY KEY CLUSTERED
					,_delete						BIT				NULL
					,_duplicate						BIT				NULL
					,_error							BIT				NULL
					,_message						VARCHAR			NULL

					,API_UWI						VARCHAR(32)		NULL
					,API_UWI_Unformatted			VARCHAR(32)		NULL
					,API_UWI_12						VARCHAR(32)		NULL
					,API_UWI_12_Unformatted			VARCHAR(32)		NULL
					,ChokeSize						FLOAT			NULL
					,Cushion						FLOAT			NULL
					,Cushion_UOM					VARCHAR(256) 	NULL
					,CushionType					VARCHAR(256) 	NULL
					,DeletedDate					DATETIME		NULL
					,DepthReference					VARCHAR(256) 	NULL
					,DSTID							INT				NOT NULL
					,DSTIndex						BIGINT			NULL
					,EndDepth_FT					FLOAT			NULL
					,FinalFlowPressure_PSI			FLOAT			NULL
					,FinalHydrostaticPressure_PSI	FLOAT			NULL
					,FinalShutInPressure_PSI		FLOAT			NULL
					,FlowComments					VARCHAR(MAX)	NULL
					,FlowID							INT				NOT NULL
					,FlowIndex						BIGINT			NULL
					,FlowPressure_UOM				VARCHAR(256) 	NULL
					,Formation						VARCHAR(256) 	NULL
					,HeaderComments					VARCHAR(256) 	NULL
					,InitialFlowPressure_PSI		FLOAT			NULL
					,InitialHydrostaticPressure_PSI FLOAT			NULL
					,InitialShutInPressure_PSI		FLOAT			NULL
					,Misrun							VARCHAR(256) 	NULL
					,Narrative						VARCHAR(MAX) 	NULL
					,OilGravity_DEG					FLOAT			NULL
					,OilTemperature_F				FLOAT			NULL
					,PressureBH_PSI					FLOAT			NULL
					,RecoveredAmount				FLOAT			NULL
					,RecoveredAmount_UOM			VARCHAR(256) 	NULL
					,RecoveredType					VARCHAR(256) 	NULL
					,RecoveryComments				VARCHAR(MAX) 	NULL
					,RecoveryID						INT				NOT NULL
					,RecoveryIndex					BIGINT			NULL
					,RecoveryPositionCode			VARCHAR(256)	NULL
					,StartDepth_FT					FLOAT			NULL
					,TemperatureBH_F				FLOAT			NULL
					,TestType						VARCHAR(256) 	NULL
					,TimeOpen_MIN					FLOAT			NULL
					,TimeShutIn_MIN					FLOAT			NULL
					,TimeToSurface_MIN				FLOAT			NULL
					,UpdatedDate					DATETIME		NULL
					,WellID							BIGINT			NOT NULL
					,ETL_Load_Date					DATETIME		NULL
				  
					,INDEX idx_tempdb_DrillStemTest_WellID_DSTID_FlowID_RecoveryID
						NONCLUSTERED (
							WellID,DSTID,FlowID,RecoveryID
						)
				  )

			------------------------------------------------------------------------
			-- Save DrillStemTest data
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Save DrillStemTest data')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				--------------------------------------------------------------------
				-- Unpack DrillStemTest JSON
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Unpack DrillStemTest JSON')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					INSERT INTO #DrillStemTest (
						 _duplicate
						,_error
						,_delete

						,API_UWI						
						,API_UWI_Unformatted			
						,API_UWI_12						
						,API_UWI_12_Unformatted			
						,ChokeSize						
						,Cushion						
						,Cushion_UOM					
						,CushionType					
						,DeletedDate					
						,DepthReference					
						,DSTID							
						,DSTIndex						
						,EndDepth_FT					
						,FinalFlowPressure_PSI			
						,FinalHydrostaticPressure_PSI	
						,FinalShutInPressure_PSI		
						,FlowComments					
						,FlowID							
						,FlowIndex						
						,FlowPressure_UOM				
						,Formation						
						,HeaderComments					
						,InitialFlowPressure_PSI		
						,InitialHydrostaticPressure_PSI 
						,InitialShutInPressure_PSI		
						,Misrun							
						,Narrative						
						,OilGravity_DEG					
						,OilTemperature_F				
						,PressureBH_PSI					
						,RecoveredAmount				
						,RecoveredAmount_UOM			
						,RecoveredType					
						,RecoveryComments				
						,RecoveryID						
						,RecoveryIndex					
						,RecoveryPositionCode			
						,StartDepth_FT					
						,TemperatureBH_F				
						,TestType						
						,TimeOpen_MIN					
						,TimeShutIn_MIN					
						,TimeToSurface_MIN				
						,UpdatedDate					
						,WellID							
						,ETL_Load_Date					
						)
					SELECT
						 _duplicate = count(*) OVER (PARTITION BY t0.WellID,t0.DSTID,t0.FlowID,t0.RecoveryID)-1
						,_error		= 0
						,*
						,sysdatetime()
					FROM
						OPENJSON(@data)
						WITH (
							 _delete						BIT

							,API_UWI						VARCHAR(32)		
							,API_UWI_Unformatted			VARCHAR(32)		
							,API_UWI_12						VARCHAR(32)		
							,API_UWI_12_Unformatted			VARCHAR(32)		
							,ChokeSize						FLOAT			
							,Cushion						FLOAT			
							,Cushion_UOM					VARCHAR(256)	
							,CushionType					VARCHAR(256)	
							,DeletedDate					DATETIME		
							,DepthReference					VARCHAR(256)	
							,DSTID							INT				
							,DSTIndex						BIGINT			
							,EndDepth_FT					FLOAT			
							,FinalFlowPressure_PSI			FLOAT			
							,FinalHydrostaticPressure_PSI   FLOAT		
							,FinalShutInPressure_PSI		FLOAT		
							,FlowComments					VARCHAR(MAX)
							,FlowID							INT			
							,FlowIndex						BIGINT		
							,FlowPressure_UOM				VARCHAR(256)
							,Formation						VARCHAR(256)
							,HeaderComments					VARCHAR(256)
							,InitialFlowPressure_PSI		FLOAT		
							,InitialHydrostaticPressure_PSI FLOAT		
							,InitialShutInPressure_PSI		FLOAT		
							,Misrun							VARCHAR(256)
							,Narrative						VARCHAR(MAX)
							,OilGravity_DEG					FLOAT		
							,OilTemperature_F				FLOAT		
							,PressureBH_PSI					FLOAT		
							,RecoveredAmount				FLOAT		
							,RecoveredAmount_UOM			VARCHAR(256)
							,RecoveredType					VARCHAR(256)
							,RecoveryComments				VARCHAR(MAX)
							,RecoveryID						INT			
							,RecoveryIndex					BIGINT		
							,RecoveryPositionCode			VARCHAR(256)
							,StartDepth_FT					FLOAT		
							,TemperatureBH_F				FLOAT		
							,TestType						VARCHAR(256)
							,TimeOpen_MIN					FLOAT		
							,TimeShutIn_MIN					FLOAT		
							,TimeToSurface_MIN				FLOAT		
							,UpdatedDate					DATETIME	
							,WellID							BIGINT		
							--,ETL_Load_Date					DATETIME
						) t0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Validate DrillStemTest data
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Validate DrillStemTest data')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					UPDATE #DrillStemTest SET 
						 _delete	= coalesce(_delete, 0)
						,_error		= CASE 
										-- Set error true if duplicate detected
										WHEN _duplicate = 1 THEN 1
										
										-- Set error true if WellID is null or empty string
										WHEN WellID IS NULL OR WellID = '' THEN 1
										WHEN DSTID IS NULL OR DSTID = '' THEN 1
										WHEN FlowID IS NULL OR FlowID = '' THEN 1
										WHEN RecoveryID IS NULL OR RecoveryID = '' THEN 1
										ELSE 0
									  END
						,_message	=   -- Add error message duplicate detected
									+ CASE WHEN _duplicate = 1 THEN '[ERROR: There were one or more records with the same WellID,DSTID,FlowID,RecoveryID this record will be ignored ( '+[WellID]+','+[DSTID]+','+[FlowID]+','+[RecoveryID]+')];' ELSE '' END
									+ CASE WHEN WellID IS NULL OR WellID = '' THEN '[ERROR: WellID cannot be null or empty string)];' ELSE '' END
									+ CASE WHEN DSTID IS NULL OR DSTID = '' THEN '[ERROR: DSTID cannot be null or empty string)];' ELSE '' END
									+ CASE WHEN FlowID IS NULL OR FlowID = '' THEN '[ERROR: FlowID cannot be null or empty string)];' ELSE '' END
									+ CASE WHEN RecoveryID IS NULL OR RecoveryID = '' THEN '[ERROR: RecoveryID cannot be null or empty string)];' ELSE '' END
									
					
					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Save data to data.DrillStemTests
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Save data to data.DrillStemTest')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					----------------------------------------------------------------
					-- Process Deletes
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.DrillStemTest; Process Deletes')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						DELETE t0
						FROM
							data.DrillStemTest t0

							INNER JOIN #DrillStemTest t1
							   ON t0.WellID = t1.WellID
							  AND t0.DSTID = t1.DSTID
							  AND t0.FlowID = t1.FlowID
							  AND t0.RecoveryID = t1.RecoveryID
						
						WHERE 1=1
							AND t1.DeletedDate is null
							AND t1._delete = 1
							AND t1._error = 0

						SET @ErrPos += concat(' [ ',@@rowcount,' ]')
						PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Updates
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.DrillStemTest; Process Updates')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						UPDATE t0 SET					
							 API_UWI						= t1.API_UWI						
							,API_UWI_Unformatted			= t1.API_UWI_Unformatted			
							,API_UWI_12						= t1.API_UWI_12						
							,API_UWI_12_Unformatted			= t1.API_UWI_12_Unformatted			
							,ChokeSize						= t1.ChokeSize						
							,Cushion						= t1.Cushion						
							,Cushion_UOM					= t1.Cushion_UOM					
							,CushionType					= t1.CushionType					
							,DeletedDate					= t1.DeletedDate
							,DepthReference					= t1.DepthReference					
							,DSTID							= t1.DSTID							
							,DSTIndex						= t1.DSTIndex						
							,EndDepth_FT					= t1.EndDepth_FT					
							,FinalFlowPressure_PSI			= t1.FinalFlowPressure_PSI			
							,FinalHydrostaticPressure_PSI   = t1.FinalHydrostaticPressure_PSI   
							,FinalShutInPressure_PSI		= t1.FinalShutInPressure_PSI		
							,FlowComments					= t1.FlowComments					
							,FlowID							= t1.FlowID							
							,FlowIndex						= t1.FlowIndex						
							,FlowPressure_UOM				= t1.FlowPressure_UOM				
							,Formation						= t1.Formation						
							,HeaderComments					= t1.HeaderComments					
							,InitialFlowPressure_PSI		= t1.InitialFlowPressure_PSI		
							,InitialHydrostaticPressure_PSI = t1.InitialHydrostaticPressure_PSI 
							,InitialShutInPressure_PSI		= t1.InitialShutInPressure_PSI		
							,Misrun							= t1.Misrun							
							,Narrative						= t1.Narrative						
							,OilGravity_DEG					= t1.OilGravity_DEG					
							,OilTemperature_F				= t1.OilTemperature_F				
							,PressureBH_PSI					= t1.PressureBH_PSI					
							,RecoveredAmount				= t1.RecoveredAmount				
							,RecoveredAmount_UOM			= t1.RecoveredAmount_UOM			
							,RecoveredType					= t1.RecoveredType					
							,RecoveryComments				= t1.RecoveryComments				
							,RecoveryID						= t1.RecoveryID						
							,RecoveryIndex					= t1.RecoveryIndex					
							,RecoveryPositionCode			= t1.RecoveryPositionCode			
							,StartDepth_FT					= t1.StartDepth_FT					
							,TemperatureBH_F				= t1.TemperatureBH_F				
							,TestType						= t1.TestType						
							,TimeOpen_MIN					= t1.TimeOpen_MIN					
							,TimeShutIn_MIN					= t1.TimeShutIn_MIN					
							,TimeToSurface_MIN				= t1.TimeToSurface_MIN	
							,UpdatedDate					= t1.UpdatedDate
							,WellID							= t1.WellID
							,ETL_Load_Date					= t1.ETL_Load_Date
						FROM
							data.DrillStemTest t0

							INNER JOIN #DrillStemTest t1
								ON t0.WellID = t1.WellID
							   AND t0.DSTID = t1.DSTID
							   AND t0.FlowID = t1.FlowID
							   AND t0.RecoveryID = t1.RecoveryID

						WHERE 1=1
							AND t1._delete = 0
							AND t1._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Inserts
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.DrillStemTest; Process Inserts')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						INSERT INTO data.DrillStemTest (					
							 API_UWI						
							,API_UWI_Unformatted			
							,API_UWI_12						
							,API_UWI_12_Unformatted			
							,ChokeSize						
							,Cushion						
							,Cushion_UOM					
							,CushionType
							,DeletedDate
							,DepthReference					
							,DSTID							
							,DSTIndex						
							,EndDepth_FT					
							,FinalFlowPressure_PSI			
							,FinalHydrostaticPressure_PSI   
							,FinalShutInPressure_PSI		
							,FlowComments					
							,FlowID							
							,FlowIndex						
							,FlowPressure_UOM				
							,Formation						
							,HeaderComments					
							,InitialFlowPressure_PSI		
							,InitialHydrostaticPressure_PSI 
							,InitialShutInPressure_PSI		
							,Misrun							
							,Narrative						
							,OilGravity_DEG					
							,OilTemperature_F				
							,PressureBH_PSI					
							,RecoveredAmount				
							,RecoveredAmount_UOM			
							,RecoveredType					
							,RecoveryComments				
							,RecoveryID						
							,RecoveryIndex					
							,RecoveryPositionCode			
							,StartDepth_FT					
							,TemperatureBH_F				
							,TestType						
							,TimeOpen_MIN					
							,TimeShutIn_MIN					
							,TimeToSurface_MIN					
							,UpdatedDate	
							,WellID							
							,ETL_Load_Date					
						)
						SELECT					
							 API_UWI						= t0.API_UWI						
							,API_UWI_Unformatted			= t0.API_UWI_Unformatted			
							,API_UWI_12						= t0.API_UWI_12						
							,API_UWI_12_Unformatted			= t0.API_UWI_12_Unformatted			
							,ChokeSize						= t0.ChokeSize						
							,Cushion						= t0.Cushion						
							,Cushion_UOM					= t0.Cushion_UOM					
							,CushionType					= t0.CushionType
							,DeletedDate					= t0.DeletedDate
							,DepthReference					= t0.DepthReference					
							,DSTID							= t0.DSTID							
							,DSTIndex						= t0.DSTIndex						
							,EndDepth_FT					= t0.EndDepth_FT					
							,FinalFlowPressure_PSI			= t0.FinalFlowPressure_PSI			
							,FinalHydrostaticPressure_PSI   = t0.FinalHydrostaticPressure_PSI   
							,FinalShutInPressure_PSI		= t0.FinalShutInPressure_PSI		
							,FlowComments					= t0.FlowComments					
							,FlowID							= t0.FlowID							
							,FlowIndex						= t0.FlowIndex						
							,FlowPressure_UOM				= t0.FlowPressure_UOM				
							,Formation						= t0.Formation						
							,HeaderComments					= t0.HeaderComments					
							,InitialFlowPressure_PSI		= t0.InitialFlowPressure_PSI		
							,InitialHydrostaticPressure_PSI = t0.InitialHydrostaticPressure_PSI 
							,InitialShutInPressure_PSI		= t0.InitialShutInPressure_PSI		
							,Misrun							= t0.Misrun							
							,Narrative						= t0.Narrative						
							,OilGravity_DEG					= t0.OilGravity_DEG					
							,OilTemperature_F				= t0.OilTemperature_F				
							,PressureBH_PSI					= t0.PressureBH_PSI					
							,RecoveredAmount				= t0.RecoveredAmount				
							,RecoveredAmount_UOM			= t0.RecoveredAmount_UOM			
							,RecoveredType					= t0.RecoveredType					
							,RecoveryComments				= t0.RecoveryComments				
							,RecoveryID						= t0.RecoveryID						
							,RecoveryIndex					= t0.RecoveryIndex					
							,RecoveryPositionCode			= t0.RecoveryPositionCode			
							,StartDepth_FT					= t0.StartDepth_FT					
							,TemperatureBH_F				= t0.TemperatureBH_F				
							,TestType						= t0.TestType						
							,TimeOpen_MIN					= t0.TimeOpen_MIN					
							,TimeShutIn_MIN					= t0.TimeShutIn_MIN					
							,TimeToSurface_MIN				= t0.TimeToSurface_MIN
							,UpdatedDate					= t0.UpdatedDate							
							,WellID							= t0.WellID		
							,ETL_Load_Date					= t0.ETL_Load_Date					
						FROM
							#DrillStemTest t0

							LEFT OUTER JOIN data.DrillStemTest t1
								ON t0.WellID = t1.WellID
							   AND t0.DSTID = t1.DSTID
							   AND t0.FlowID = t1.FlowID
							   AND t0.RecoveryID = t1.RecoveryID

						WHERE 1=1
							AND t1.WellID		IS NULL

							AND t0._delete = 0
							AND t0._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Error Output
				--------------------------------------------------------------------
					IF @NoOutput = 0
					BEGIN
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.DrillStemTest')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						SELECT 
							 _row_id
                            ,_delete
                            ,_error
                            ,_message
                            ,API_UWI						
                            ,API_UWI_Unformatted			
                            ,API_UWI_12						
                            ,API_UWI_12_Unformatted			
                            ,ChokeSize						
                            ,Cushion						
                            ,Cushion_UOM					
                            ,CushionType					
                            ,DeletedDate					
                            ,DepthReference					
                            ,DSTID							
                            ,DSTIndex						
                            ,EndDepth_FT					
                            ,FinalFlowPressure_PSI			
                            ,FinalHydrostaticPressure_PSI   
                            ,FinalShutInPressure_PSI		
                            ,FlowComments					
                            ,FlowID							
                            ,FlowIndex						
                            ,FlowPressure_UOM				
                            ,Formation						
                            ,HeaderComments					
                            ,InitialFlowPressure_PSI		
                            ,InitialHydrostaticPressure_PSI 
                            ,InitialShutInPressure_PSI		
                            ,Misrun							
                            ,Narrative						
                            ,OilGravity_DEG					
                            ,OilTemperature_F				
                            ,PressureBH_PSI					
                            ,RecoveredAmount				
                            ,RecoveredAmount_UOM			
                            ,RecoveredType					
                            ,RecoveryComments				
                            ,RecoveryID						
                            ,RecoveryIndex					
                            ,RecoveryPositionCode			
                            ,StartDepth_FT					
                            ,TemperatureBH_F				
                            ,TestType						
                            ,TimeOpen_MIN					
                            ,TimeShutIn_MIN					
                            ,TimeToSurface_MIN				
                            ,UpdatedDate					
                            ,WellID
							,ETL_Load_Date
						FROM 
							#DrillStemTest
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