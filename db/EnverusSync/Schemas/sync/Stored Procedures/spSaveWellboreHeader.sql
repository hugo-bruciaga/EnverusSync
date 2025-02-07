/***********************************************************************************

	Procedure Name:		sync.spSaveWellboreHeader
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
CREATE PROCEDURE sync.spSaveWellboreHeader (
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
				      SET @ErrMsg = 'The @data must be a WellboreHeader formed JSON structure';
					  THROW 2147483647,@ErrMsg,1;
				  END
				  
			------------------------------------------------------------------------
			-- Initialize procedure resources
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Initialize procedure resources')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				  -- #WellboreHeader
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; #WellboreHeader')
			  
				  DROP TABLE IF EXISTS #WellboreHeader
				  CREATE TABLE #WellboreHeader (
					 _row_id								BIGINT IDENTITY(1,1)	NOT NULL	PRIMARY KEY CLUSTERED
					,_error									BIT				NULL
					,_delete								BIT				NULL
					,_duplicate								BIT				NULL
					,_message								VARCHAR			NULL
																		
					,API_UWI								VARCHAR(32)		NULL
					,API_UWI_Unformatted					VARCHAR(32)		NULL
					,API_UWI_12								VARCHAR(32)		NULL
					,API_UWI_12_Unformatted					VARCHAR(32)		NULL
					,Country								VARCHAR(2)		NULL
					,County									VARCHAR(32)		NULL
					,DeletedDate							DATETIME		NULL
					,ENVBasin								VARCHAR(64)		NULL
					,ENVInterval							VARCHAR(128)	NULL
					,ENVOperator							VARCHAR(256)	NULL
					,ENVPlay								VARCHAR(128)	NULL
					,ENVRegion								VARCHAR(32)		NULL
					,ENVWellboreType						VARCHAR(256)	NULL
					,GeomBHL_Point							GEOMETRY		NULL
					,GeomSHL_Point							GEOMETRY		NULL
					,LateralLine							GEOMETRY		NULL
					,Latitude								FLOAT			NULL
					,Latitude_BH							FLOAT			NULL
					,Longitude								FLOAT			NULL
					,Longitude_BH							FLOAT			NULL
					,MD_FT									FLOAT			NULL
					,PlugbackMeasuredDepth_FT				INT				NULL
					,PlugbackTrueVerticalDepth_FT			INT				NULL
					,StateProvince							VARCHAR(64)		NULL
					,Trajectory								VARCHAR(64)		NULL
					,TVD_FT									FLOAT			NULL
					,UpdatedDate							DATETIME		NULL
					,WellboreID								BIGINT			NOT NULL
					,WellID									BIGINT			NULL
					,WellSymbols							VARCHAR(256)	NULL

					,ETL_Load_Date							DATETIME		NULL
				  
					,INDEX idx_tempdb_WellboreHeader_WellboreID
						NONCLUSTERED (
							WellboreID
						)
				  )

			------------------------------------------------------------------------
			-- Save WellboreHeader data
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Save WellboreHeader data')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				--------------------------------------------------------------------
				-- Unpack WellboreHeader JSON
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Unpack WellboreHeader JSON')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					INSERT INTO #WellboreHeader (
						 _duplicate
						,_error
						,_delete

						,API_UWI								
						,API_UWI_Unformatted					
						,API_UWI_12								
						,API_UWI_12_Unformatted					
						,Country								
						,County									
						,DeletedDate							
						,ENVBasin								
						,ENVInterval							
						,ENVOperator							
						,ENVPlay								
						,ENVRegion								
						,ENVWellboreType						
						,Latitude								
						,Latitude_BH							
						,Longitude								
						,Longitude_BH							
						,MD_FT									
						,PlugbackMeasuredDepth_FT				
						,PlugbackTrueVerticalDepth_FT			
						,StateProvince							
						,Trajectory								
						,TVD_FT									
						,UpdatedDate							
						,WellboreID								
						,WellID									
						,WellSymbols	
						,GeomBHL_Point							
						,GeomSHL_Point							
						,LateralLine							

						,ETL_Load_Date
						)
					SELECT
						 _duplicate = count(*) OVER (PARTITION BY t0.WellboreID)-1
						,_error		= 0
						,_delete							BIT

						,API_UWI								
						,API_UWI_Unformatted					
						,API_UWI_12								
						,API_UWI_12_Unformatted					
						,Country								
						,County									
						,DeletedDate							
						,ENVBasin								
						,ENVInterval							
						,ENVOperator							
						,ENVPlay								
						,ENVRegion								
						,ENVWellboreType						
						,Latitude								
						,Latitude_BH							
						,Longitude								
						,Longitude_BH							
						,MD_FT									
						,PlugbackMeasuredDepth_FT				
						,PlugbackTrueVerticalDepth_FT			
						,StateProvince							
						,Trajectory								
						,TVD_FT									
						,UpdatedDate							
						,WellboreID								
						,WellID									
						,WellSymbols	

						,t1.GeoData	GeomBHL_Point
						,t2.GeoData	GeomSHL_Point
						,t3.GeoData	LateralLine
						,sysdatetime()
					FROM
						OPENJSON(@data)
						WITH (
							 _delete								BIT

							,API_UWI								VARCHAR(32)		
							,API_UWI_Unformatted					VARCHAR(32)		
							,API_UWI_12								VARCHAR(32)		
							,API_UWI_12_Unformatted					VARCHAR(32)		
							,Country								VARCHAR(2)		
							,County									VARCHAR(32)		
							,DeletedDate							DATETIME		
							,ENVBasin								VARCHAR(64)		
							,ENVInterval							VARCHAR(128)	
							,ENVOperator							VARCHAR(256)	
							,ENVPlay								VARCHAR(128)	
							,ENVRegion								VARCHAR(32)		
							,ENVWellboreType						VARCHAR(256)	
							,GeomBHL_Point							VARCHAR(MAX)		
							,GeomSHL_Point							VARCHAR(MAX)		
							,LateralLine							VARCHAR(MAX)		
							,Latitude								FLOAT			
							,Latitude_BH							FLOAT			
							,Longitude								FLOAT			
							,Longitude_BH							FLOAT			
							,MD_FT									FLOAT			
							,PlugbackMeasuredDepth_FT				INT				
							,PlugbackTrueVerticalDepth_FT			INT				
							,StateProvince							VARCHAR(64)		
							,Trajectory								VARCHAR(64)		
							,TVD_FT									FLOAT			
							,UpdatedDate							DATETIME		
							,WellboreID								BIGINT			
							,WellID									BIGINT			
							,WellSymbols							VARCHAR(256)	


							--,ETL_Load_Date		DATETIME
						) t0
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.GeomBHL_Point) t1
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.GeomSHL_Point) t2
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.LateralLine) t3


					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Validate WellboreHeader data
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Validate WellboreHeader data')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					UPDATE #WellboreHeader SET 
						 _delete	= coalesce(_delete, 0)
						,_error		= CASE 
										-- Set error true if duplicate detected
										WHEN _duplicate = 1 THEN 1
										
										-- Set error true if CompletionID is null or empty string
										WHEN WellboreID IS NULL OR WellboreID = '' THEN 1
										ELSE 0
									  END
						,_message	=   -- Add error message duplicate detected
									+ CASE WHEN _duplicate = 1 THEN '[ERROR: There were one or more records with the same WellboreID this record will be ignored ( '+WellboreID+')];' ELSE '' END
									+ CASE WHEN WellboreID IS NULL OR WellboreID  = '' THEN '[ERROR: WellboreID cannot be null or empty string)];' ELSE '' END
					
					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Save data to data.WellboreHeader
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Save data to data.WellboreHeader')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					----------------------------------------------------------------
					-- Process Deletes
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.WellboreHeader; Process Deletes')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						DELETE t0
						FROM
							data.WellboreHeader t0

							INNER JOIN #WellboreHeader t1
								ON t0.WellboreID = t1.WellboreID

						
						WHERE 1=1
							AND t1.DeletedDate is null
							AND t1._delete = 1
							AND t1._error = 0

						SET @ErrPos += concat(' [ ',@@rowcount,' ]')
						PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Updates
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.WellboreHeader; Process Updates')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						UPDATE t0 SET
								 
								 API_UWI								= t1.API_UWI												
								,API_UWI_Unformatted					= t1.API_UWI_Unformatted			
								,API_UWI_12								= t1.API_UWI_12						
								,API_UWI_12_Unformatted					= t1.API_UWI_12_Unformatted			
								,Country								= t1.Country						
								,County									= t1.County							
								,DeletedDate							= t1.DeletedDate					
								,ENVBasin								= t1.ENVBasin						
								,ENVInterval							= t1.ENVInterval					
								,ENVOperator							= t1.ENVOperator					
								,ENVPlay								= t1.ENVPlay						
								,ENVRegion								= t1.ENVRegion						
								,ENVWellboreType						= t1.ENVWellboreType				
								,GeomBHL_Point							= t1.GeomBHL_Point					
								,GeomSHL_Point							= t1.GeomSHL_Point					
								,LateralLine							= t1.LateralLine					
								,Latitude								= t1.Latitude						
								,Latitude_BH							= t1.Latitude_BH					
								,Longitude								= t1.Longitude						
								,Longitude_BH							= t1.Longitude_BH					
								,MD_FT									= t1.MD_FT							
								,PlugbackMeasuredDepth_FT				= t1.PlugbackMeasuredDepth_FT		
								,PlugbackTrueVerticalDepth_FT			= t1.PlugbackTrueVerticalDepth_FT	
								,StateProvince							= t1.StateProvince					
								,Trajectory								= t1.Trajectory						
								,TVD_FT									= t1.TVD_FT							
								,UpdatedDate							= t1.UpdatedDate					
								,WellboreID								= t1.WellboreID						
								,WellID									= t1.WellID							
								,WellSymbols							= t1.WellSymbols					
					        

								--,ETL_Load_Date						= t1.ETL_Load_Date

						FROM
							data.WellboreHeader t0

							INNER JOIN #WellboreHeader t1
								ON t0.WellboreID = t1.WellboreID
								
						WHERE 1=1
							AND t1._delete = 0
							AND t1._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Inserts
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.WellboreHeader; Process Inserts')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						INSERT INTO data.WellboreHeader ( 
							 API_UWI						
							,API_UWI_Unformatted			
							,API_UWI_12						
							,API_UWI_12_Unformatted			
							,Country						
							,County							
							,DeletedDate					
							,ENVBasin						
							,ENVInterval					
							,ENVOperator					
							,ENVPlay						
							,ENVRegion						
							,ENVWellboreType				
							,GeomBHL_Point					
							,GeomSHL_Point					
							,LateralLine					
							,Latitude						
							,Latitude_BH					
							,Longitude						
							,Longitude_BH					
							,MD_FT							
							,PlugbackMeasuredDepth_FT		
							,PlugbackTrueVerticalDepth_FT	
							,StateProvince					
							,Trajectory						
							,TVD_FT							
							,UpdatedDate					
							,WellboreID						
							,WellID							
							,WellSymbols					
					  
					
							,ETL_Load_Date
							)
						SELECT					
							 API_UWI								= t0.API_UWI						
							,API_UWI_Unformatted					= t0.API_UWI_Unformatted			
							,API_UWI_12								= t0.API_UWI_12						
							,API_UWI_12_Unformatted					= t0.API_UWI_12_Unformatted			
							,Country								= t0.Country						
							,County									= t0.County							
							,DeletedDate							= t0.DeletedDate					
							,ENVBasin								= t0.ENVBasin						
							,ENVInterval							= t0.ENVInterval					
							,ENVOperator							= t0.ENVOperator					
							,ENVPlay								= t0.ENVPlay						
							,ENVRegion								= t0.ENVRegion						
							,ENVWellboreType						= t0.ENVWellboreType				
							,GeomBHL_Point							= t0.GeomBHL_Point					
							,GeomSHL_Point							= t0.GeomSHL_Point					
							,LateralLine							= t0.LateralLine					
							,Latitude								= t0.Latitude						
							,Latitude_BH							= t0.Latitude_BH					
							,Longitude								= t0.Longitude						
							,Longitude_BH							= t0.Longitude_BH					
							,MD_FT									= t0.MD_FT							
							,PlugbackMeasuredDepth_FT				= t0.PlugbackMeasuredDepth_FT		
							,PlugbackTrueVerticalDepth_FT			= t0.PlugbackTrueVerticalDepth_FT	
							,StateProvince							= t0.StateProvince					
							,Trajectory								= t0.Trajectory						
							,TVD_FT									= t0.TVD_FT							
							,UpdatedDate							= t0.UpdatedDate					
							,WellboreID								= t0.WellboreID						
							,WellID									= t0.WellID							
							,WellSymbols							= t0.WellSymbols					
							

							,ETL_Load_Date							 = t0.ETL_Load_Date				
						FROM
							#WellboreHeader t0

							LEFT OUTER JOIN data.WellboreHeader t1
	
								ON t0.WellboreID	= t1.WellboreID

						WHERE 1=1
							AND t1.WellboreID		IS NULL

							AND t0._delete = 0
							AND t0._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Error Output
				--------------------------------------------------------------------
					IF @NoOutput = 0
					BEGIN
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.WellboreHeader')
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
							,Country						
							,County							
							,DeletedDate					
							,ENVBasin						
							,ENVInterval					
							,ENVOperator					
							,ENVPlay						
							,ENVRegion						
							,ENVWellboreType				
							,GeomBHL_Point					
							,GeomSHL_Point					
							,LateralLine					
							,Latitude						
							,Latitude_BH					
							,Longitude						
							,Longitude_BH					
							,MD_FT							
							,PlugbackMeasuredDepth_FT		
							,PlugbackTrueVerticalDepth_FT	
							,StateProvince					
							,Trajectory						
							,TVD_FT							
							,UpdatedDate					
							,WellboreID						
							,WellID							
							,WellSymbols					
							   
												
							,ETL_Load_Date
						FROM 
							#WellboreHeader
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