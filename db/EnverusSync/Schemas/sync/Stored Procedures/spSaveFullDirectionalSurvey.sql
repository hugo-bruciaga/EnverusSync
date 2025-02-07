/***********************************************************************************

	Procedure Name:		sync.spFullDirectionalSurvey
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
CREATE PROCEDURE sync.spSaveFullDirectionalSurvey (
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

				  -- #FullDirectionalSurvey
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; #FullDirectionalSurvey')
			  
				  DROP TABLE IF EXISTS #FullDirectionalSurvey
				  CREATE TABLE #FullDirectionalSurvey (
					 _row_id						BIGINT IDENTITY(1,1)	NOT NULL	PRIMARY KEY CLUSTERED
					,_delete						BIT			NULL
					,_duplicate						BIT			NULL
					,_error							BIT			NULL
					,_message						VARCHAR		NULL

					,API_UWI					  	VARCHAR(32)	NULL
					,API_UWI_Unformatted			VARCHAR(32)	NULL
					,API_UWI_12						VARCHAR(32)	NULL
					,API_UWI_12_Unformatted	   		VARCHAR(32)	NOT NULL
					,Azimuth_DEG				   	FLOAT		NULL
					,Closure_FT				   		TINYINT		NULL
					,CoordinateSource				VARCHAR(64)	NULL
					,Country						VARCHAR(2)	NULL
					,County							VARCHAR(32)	NULL
					,Course_FT						FLOAT		NULL
					,DeletedDate					DATETIME	NULL
					,DogLegSeverity_DEGPer100FT		FLOAT		NULL
					,E_W							FLOAT		NULL
					,ENVBasin						VARCHAR(64)	NULL
					,ENVInterval					VARCHAR(128) NULL
					,ENVPlay						VARCHAR(128) NULL
					,ENVRegion						VARCHAR(32)	NULL
					,GeomXYZ_Point					sys.GEOMETRY NULL
					,GridX_FT						FLOAT		NULL
					,GridY_FT						FLOAT		NULL
					,Inclination_DEG				FLOAT		NULL
					,Latitude						FLOAT		NULL
					,Longitude						FLOAT		NULL
					,MeasuredDepth_FT				FLOAT		NULL
					,N_S							FLOAT		NULL
					,StateProvince					VARCHAR(64)	NULL
					,StationNumber					BIGINT		NOT NULL
					,SubseaElevation_FT				FLOAT		NULL
					,TVD_FT							FLOAT		NULL
					,UpdatedDate					DATETIME	NULL
					,VerticalSection_FT				TINYINT		NULL
					,WellId							BIGINT		NULL
					,X_ECEF							FLOAT		NULL
					,Y_ECEF							FLOAT		NULL
					,Z_ECEF							FLOAT		NULL
					,ETL_Load_Date					DATETIME	NULL
				  
					,INDEX idx_tempdb_FullDirectionalSurvey_API_UWI_12_StationNumber
						NONCLUSTERED (
							API_UWI_12, StationNumber
						)
				  )

			------------------------------------------------------------------------
			-- Save FullDirectionalSurvey data
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Save FullDirectionalSurvey data')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				--------------------------------------------------------------------
				-- Unpack FullDirectionalSurvey JSON
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Unpack FullDirectionalSurvey JSON')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					INSERT INTO #FullDirectionalSurvey (
						 _duplicate
						,_error
						,_delete

						,API_UWI					  
						,API_UWI_Unformatted		  
						,API_UWI_12				  
						,API_UWI_12_Unformatted	  
						,Azimuth_DEG				  
						,Closure_FT				  
						,CoordinateSource		  
						,Country					  
						,County					  
						,Course_FT				  
						,DeletedDate				  
						,DogLegSeverity_DEGPer100FT
						,E_W						  
						,ENVBasin				  
						,ENVInterval				  
						,ENVPlay					  
						,ENVRegion				  
						,GridX_FT				  
						,GridY_FT				  
						,Inclination_DEG			  
						,Latitude				  
						,Longitude				  
						,MeasuredDepth_FT		  
						,N_S						  
						,StateProvince			  
						,StationNumber			  
						,SubseaElevation_FT		  
						,TVD_FT					  
						,UpdatedDate				  
						,VerticalSection_FT		  
						,WellId					  
						,X_ECEF					  
						,Y_ECEF					  
						,Z_ECEF			
						,GeomXYZ_Point			  						

						,ETL_Load_Date			  
					
						)
					SELECT
						 _duplicate = count(*) OVER (PARTITION BY t0.API_UWI_12, t0.StationNumber)-1
						,_error		= 0
						,_delete							BIT

						,API_UWI					  
						,API_UWI_Unformatted		  
						,API_UWI_12				  
						,API_UWI_12_Unformatted	  
						,Azimuth_DEG				  
						,Closure_FT				  
						,CoordinateSource		  
						,Country					  
						,County					  
						,Course_FT				  
						,DeletedDate				  
						,DogLegSeverity_DEGPer100FT
						,E_W						  
						,ENVBasin				  
						,ENVInterval				  
						,ENVPlay					  
						,ENVRegion				  
						,GridX_FT				  
						,GridY_FT				  
						,Inclination_DEG			  
						,Latitude				  
						,Longitude				  
						,MeasuredDepth_FT		  
						,N_S						  
						,StateProvince			  
						,StationNumber			  
						,SubseaElevation_FT		  
						,TVD_FT					  
						,UpdatedDate				  
						,VerticalSection_FT		  
						,WellId					  
						,X_ECEF					  
						,Y_ECEF					  
						,Z_ECEF			
						,t1.GeoData GeomXYZ_Point

						,sysdatetime()
					FROM
						OPENJSON(@data)
						WITH (
							 _delete						BIT

							,API_UWI					  	VARCHAR(32)	
							,API_UWI_Unformatted			VARCHAR(32)	
							,API_UWI_12						VARCHAR(32)	
							,API_UWI_12_Unformatted	   		VARCHAR(32)	
							,Azimuth_DEG				   	FLOAT		
							,Closure_FT				   		TINYINT		
							,CoordinateSource				VARCHAR(64)	
							,Country						VARCHAR(2)	
							,County							VARCHAR(32)	
							,Course_FT						FLOAT		
							,DeletedDate					DATETIME	
							,DogLegSeverity_DEGPer100FT		FLOAT		
							,E_W							FLOAT		
							,ENVBasin						VARCHAR(64)	
							,ENVInterval					VARCHAR(128)
							,ENVPlay						VARCHAR(128)
							,ENVRegion						VARCHAR(32)	
							,GeomXYZ_Point					VARCHAR(MAX)
							,GridX_FT						FLOAT		
							,GridY_FT						FLOAT		
							,Inclination_DEG				FLOAT		
							,Latitude						FLOAT		
							,Longitude						FLOAT		
							,MeasuredDepth_FT				FLOAT		
							,N_S							FLOAT		
							,StateProvince					VARCHAR(64)	
							,StationNumber					BIGINT		
							,SubseaElevation_FT				FLOAT		
							,TVD_FT							FLOAT		
							,UpdatedDate					DATETIME	
							,VerticalSection_FT				TINYINT		
							,WellId							BIGINT		
							,X_ECEF							FLOAT		
							,Y_ECEF							FLOAT		
							,Z_ECEF							FLOAT		
							--,ETL_Load_Date				DATETIME
						) t0
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.GeomXYZ_Point) t1

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Validate FullDirectionalSurvey data
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Validate FullDirectionalSurvey data')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					UPDATE #FullDirectionalSurvey SET 
						 _delete	= coalesce(_delete, 0)
						,_error		= CASE 
										-- Set error true if duplicate detected
										WHEN _duplicate = 1 THEN 1
										
										-- Set error true if API_UWI_12, StationNumber is null
										
										--WHEN API_UWI_12 IS NULL OR API_UWI_12 = '' THEN 1
										WHEN API_UWI_12 IS NULL THEN 1
										--WHEN StationNumber IS NULL OR StationNumber = '' THEN 1
										WHEN StationNumber IS NULL THEN 1
										ELSE 0
									  END
						,_message	=   -- Add error message duplicate detected
									+ CASE WHEN _duplicate = 1 THEN '[ERROR: There were one or more records with the same API_UWI_12,StationNumber this record will be ignored ( '+[API_UWI_12]+','+[StationNumber]+')];' ELSE '' END
									+ CASE WHEN API_UWI_12 IS NULL THEN '[ERROR: API_UWI_12 cannot be null)];' ELSE '' END
									+ CASE WHEN StationNumber IS NULL  THEN '[ERROR: StationNumber cannot be null)];' ELSE '' END
								
					
					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Save data to data.FullDirectionalSurveys
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Save data to data.FullDirectionalSurvey')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					----------------------------------------------------------------
					-- Process Deletes
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.FullDirectionalSurvey; Process Deletes')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						DELETE t0
						FROM
							data.FullDirectionalSurvey t0

							INNER JOIN #FullDirectionalSurvey t1
							   ON t0.API_UWI_12 = t1.API_UWI_12
							  AND t0.StationNumber = t1.StationNumber
							  
						WHERE 1=1
							AND t1.DeletedDate IS NULL
							AND t1._delete = 1
							AND t1._error = 0

						SET @ErrPos += concat(' [ ',@@rowcount,' ]')
						PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Updates
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.FullDirectionalSurvey; Process Updates')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						UPDATE t0 SET	
							 API_UWI					  	= t1.API_UWI					  	
							,API_UWI_Unformatted			= t1.API_UWI_Unformatted			
							,API_UWI_12						= t1.API_UWI_12						
							,API_UWI_12_Unformatted	   		= t1.API_UWI_12_Unformatted	   		
							,Azimuth_DEG				   	= t1.Azimuth_DEG				   	
							,Closure_FT				   		= t1.Closure_FT				   		
							,CoordinateSource				= t1.CoordinateSource				
							,Country						= t1.Country						
							,County							= t1.County							
							,Course_FT						= t1.Course_FT						
							,DeletedDate					= t1.DeletedDate					
							,DogLegSeverity_DEGPer100FT		= t1.DogLegSeverity_DEGPer100FT		
							,E_W							= t1.E_W							
							,ENVBasin						= t1.ENVBasin						
							,ENVInterval					= t1.ENVInterval					
							,ENVPlay						= t1.ENVPlay						
							,ENVRegion						= t1.ENVRegion						
							,GeomXYZ_Point					= t1.GeomXYZ_Point					
							,GridX_FT						= t1.GridX_FT						
							,GridY_FT						= t1.GridY_FT						
							,Inclination_DEG				= t1.Inclination_DEG				
							,Latitude						= t1.Latitude						
							,Longitude						= t1.Longitude						
							,MeasuredDepth_FT				= t1.MeasuredDepth_FT				
							,N_S							= t1.N_S							
							,StateProvince					= t1.StateProvince					
							,StationNumber					= t1.StationNumber					
							,SubseaElevation_FT				= t1.SubseaElevation_FT				
							,TVD_FT							= t1.TVD_FT							
							,UpdatedDate					= t1.UpdatedDate					
							,VerticalSection_FT				= t1.VerticalSection_FT				
							,WellId							= t1.WellId							
							,X_ECEF							= t1.X_ECEF							
							,Y_ECEF							= t1.Y_ECEF							
							,Z_ECEF							= t1.Z_ECEF							
							,ETL_Load_Date					= t1.ETL_Load_Date
						FROM
							data.FullDirectionalSurvey t0

							INNER JOIN #FullDirectionalSurvey t1
								ON t0.API_UWI_12 = t1.API_UWI_12
							   AND t0.StationNumber = t1.StationNumber


						WHERE 1=1
							AND t1._delete = 0
							AND t1._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Inserts
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.FullDirectionalSurvey; Process Inserts')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						INSERT INTO data.FullDirectionalSurvey (					
							 API_UWI					  
							,API_UWI_Unformatted		  
							,API_UWI_12				  
							,API_UWI_12_Unformatted	  
							,Azimuth_DEG				  
							,Closure_FT				  
							,CoordinateSource		  
							,Country					  
							,County					  
							,Course_FT				  
							,DeletedDate				  
							,DogLegSeverity_DEGPer100FT
							,E_W						  
							,ENVBasin				  
							,ENVInterval				  
							,ENVPlay					  
							,ENVRegion				  
							,GeomXYZ_Point			  
							,GridX_FT				  
							,GridY_FT				  
							,Inclination_DEG			  
							,Latitude				  
							,Longitude				  
							,MeasuredDepth_FT		  
							,N_S						  
							,StateProvince			  
							,StationNumber			  
							,SubseaElevation_FT		  
							,TVD_FT					  
							,UpdatedDate				  
							,VerticalSection_FT		  
							,WellId					  
							,X_ECEF					  
							,Y_ECEF					  
							,Z_ECEF					  
							,ETL_Load_Date
							)
						SELECT					
							 API_UWI					  	= t0.API_UWI					  	
							,API_UWI_Unformatted			= t0.API_UWI_Unformatted			
							,API_UWI_12						= t0.API_UWI_12						
							,API_UWI_12_Unformatted	   		= t0.API_UWI_12_Unformatted	   		
							,Azimuth_DEG				   	= t0.Azimuth_DEG				   	
							,Closure_FT				   		= t0.Closure_FT				   		
							,CoordinateSource				= t0.CoordinateSource				
							,Country						= t0.Country						
							,County							= t0.County							
							,Course_FT						= t0.Course_FT						
							,DeletedDate					= t0.DeletedDate					
							,DogLegSeverity_DEGPer100FT		= t0.DogLegSeverity_DEGPer100FT		
							,E_W							= t0.E_W							
							,ENVBasin						= t0.ENVBasin						
							,ENVInterval					= t0.ENVInterval					
							,ENVPlay						= t0.ENVPlay						
							,ENVRegion						= t0.ENVRegion						
							,GeomXYZ_Point					= t0.GeomXYZ_Point					
							,GridX_FT						= t0.GridX_FT						
							,GridY_FT						= t0.GridY_FT						
							,Inclination_DEG				= t0.Inclination_DEG				
							,Latitude						= t0.Latitude						
							,Longitude						= t0.Longitude						
							,MeasuredDepth_FT				= t0.MeasuredDepth_FT				
							,N_S							= t0.N_S							
							,StateProvince					= t0.StateProvince					
							,StationNumber					= t0.StationNumber					
							,SubseaElevation_FT				= t0.SubseaElevation_FT				
							,TVD_FT							= t0.TVD_FT							
							,UpdatedDate					= t0.UpdatedDate					
							,VerticalSection_FT				= t0.VerticalSection_FT				
							,WellId							= t0.WellId							
							,X_ECEF							= t0.X_ECEF							
							,Y_ECEF							= t0.Y_ECEF							
							,Z_ECEF							= t0.Z_ECEF							
							,ETL_Load_Date					= t0.ETL_Load_Date				
						FROM
							#FullDirectionalSurvey t0

							LEFT OUTER JOIN data.FullDirectionalSurvey t1
								ON t0.API_UWI_12 = t1.API_UWI_12
							   AND t0.StationNumber = t1.StationNumber


						WHERE 1=1
							AND t1.API_UWI_12		IS NULL

							AND t0._delete = 0
							AND t0._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Error Output
				--------------------------------------------------------------------
					IF @NoOutput = 0
					BEGIN
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.FullDirectionalSurvey')
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
							,Azimuth_DEG				   	
							,Closure_FT				   		
							,CoordinateSource				
							,Country						
							,County							
							,Course_FT						
							,DeletedDate					
							,DogLegSeverity_DEGPer100FT		
							,E_W							
							,ENVBasin						
							,ENVInterval					
							,ENVPlay						
							,ENVRegion						
							,GeomXYZ_Point					
							,GridX_FT						
							,GridY_FT						
							,Inclination_DEG				
							,Latitude						
							,Longitude						
							,MeasuredDepth_FT				
							,N_S							
							,StateProvince					
							,StationNumber					
							,SubseaElevation_FT				
							,TVD_FT							
							,UpdatedDate					
							,VerticalSection_FT				
							,WellId							
							,X_ECEF							
							,Y_ECEF							
							,Z_ECEF							


							,ETL_Load_Date
						FROM 
							#FullDirectionalSurvey
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