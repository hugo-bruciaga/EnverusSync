/***********************************************************************************

	Procedure Name:		sync.spSaveWellHeader
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
CREATE PROCEDURE sync.spSaveWellHeader (
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
				      SET @ErrMsg = 'The @data must be a WellHeader formed JSON structure';
					  THROW 2147483647,@ErrMsg,1;
				  END
				  
			------------------------------------------------------------------------
			-- Initialize procedure resources
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Initialize procedure resources')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				  -- #WellHeader
				  PRINT concat(sysdatetime(),' | INFO | ',@ErrPos,'; #WellHeader')
			  
				  DROP TABLE IF EXISTS #WellHeader
				  CREATE TABLE #WellHeader (
					 _row_id								BIGINT IDENTITY(1,1)	NOT NULL	PRIMARY KEY CLUSTERED
					,_error									BIT				NULL
					,_delete								BIT				NULL
					,_duplicate								BIT				NULL
					,_message								VARCHAR			NULL
																		
					,Abstract								VARCHAR(16)		NULL
					,API_UWI								VARCHAR(32)		NULL
					,API_UWI_Unformatted					VARCHAR(32)		NULL
					,Block									VARCHAR(64)		NULL
					,Country								VARCHAR(2)		NULL
					,County									VARCHAR(32)		NULL
					,DeletedDate							DATETIME		NULL
					,District								VARCHAR(256)	NULL
					,ENVBasin								VARCHAR(64)		NULL
					,ENVElevationGL_FT						FLOAT			NULL
					,ENVElevationGLSource					VARCHAR(128)	NULL
					,ENVElevationKB_FT						FLOAT			NULL
					,ENVElevationKBSource					VARCHAR(128)	NULL
					,ENVInterval							VARCHAR(128)	NULL
					,ENVIntervalSource						VARCHAR(32)		NULL
					,ENVOperator							VARCHAR(256)	NULL
					,ENVPeerGroup							VARCHAR(64)		NULL
					,ENVPlay								VARCHAR(128)	NULL
					,ENVProducingMethod						VARCHAR(256)	NULL
					,ENVProdWellType						VARCHAR(64)		NULL
					,ENVRegion								VARCHAR(32)		NULL
					,ENVStockExchange						VARCHAR(32)		NULL
					,ENVSubPlay								VARCHAR(64)		NULL
					,ENVTicker								VARCHAR(128)	NULL
					,ENVWellGrouping						VARCHAR(128)	NULL
					,ENVWellStatus							VARCHAR(64)		NULL
					,ENVWellType							VARCHAR(256)	NULL
					,Field									VARCHAR(256)	NULL
					,FirstProdDate							DATETIME		NULL
					,Formation								VARCHAR(256)	NULL
					,GeomSHL_Point							GEOMETRY		NULL
					,InitialOperator						VARCHAR(256)	NULL
					,Latitude								FLOAT			NULL
					,Lease									VARCHAR(64)		NULL
					,LeaseName								VARCHAR(256)	NULL
					,Longitude								FLOAT			NULL
					,PermitApprovedDate						DATETIME		NULL
					,PlugDate								DATETIME		NULL
					,Range									VARCHAR(32)		NULL
					,RigReleaseDate							DATETIME		NULL
					,Section								VARCHAR(32)		NULL
					,SpudDate								DATETIME		NULL
					,SpudDateSource							VARCHAR(8)		NULL
					,StateProvince							VARCHAR(64)		NULL
					,SurfaceLatLongSource					VARCHAR(256)	NULL
					,Township								VARCHAR(32)		NULL
					,UpdatedDate							DATETIME		NULL
					,WaterDepth								FLOAT			NULL
					,WellID									BIGINT			NOT NULL
					,WellName								VARCHAR(256)	NULL
					,WellNumber								VARCHAR(256)	NULL
					,WellSymbols							VARCHAR(256)	NULL

					,ETL_Load_Date							DATETIME		NULL
				  
					,INDEX idx_tempdb_WellHeader_WellID
						NONCLUSTERED (
							WellID
						)
				  )

			------------------------------------------------------------------------
			-- Save WellHeader data
			------------------------------------------------------------------------
				SET @ErrPos = concat(@MsgTitle, '; Save WellHeader data')
				PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

				--------------------------------------------------------------------
				-- Unpack WellHeader JSON
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Unpack WellHeader JSON')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					INSERT INTO #WellHeader (
						 _duplicate
						,_error
						,_delete

						,Abstract							
						,API_UWI							
						,API_UWI_Unformatted				
						,Block								
						,Country							
						,County								
						,DeletedDate						
						,District							
						,ENVBasin							
						,ENVElevationGL_FT					
						,ENVElevationGLSource				
						,ENVElevationKB_FT					
						,ENVElevationKBSource				
						,ENVInterval						
						,ENVIntervalSource					
						,ENVOperator						
						,ENVPeerGroup						
						,ENVPlay							
						,ENVProducingMethod					
						,ENVProdWellType					
						,ENVRegion							
						,ENVStockExchange					
						,ENVSubPlay							
						,ENVTicker							
						,ENVWellGrouping					
						,ENVWellStatus						
						,ENVWellType						
						,Field								
						,FirstProdDate						
						,Formation							
						,InitialOperator					
						,Latitude							
						,Lease								
						,LeaseName							
						,Longitude							
						,PermitApprovedDate					
						,PlugDate							
						,Range								
						,RigReleaseDate						
						,Section							
						,SpudDate							
						,SpudDateSource						
						,StateProvince						
						,SurfaceLatLongSource				
						,Township							
						,UpdatedDate						
						,WaterDepth							
						,WellID								
						,WellName							
						,WellNumber							
						,WellSymbols						
						,GeomSHL_Point						

						,ETL_Load_Date
						)
					SELECT
						 _duplicate = count(*) OVER (PARTITION BY t0.WellID)-1
						,_error		= 0
						,_delete							BIT

						,Abstract							
						,API_UWI							
						,API_UWI_Unformatted				
						,Block								
						,Country							
						,County								
						,DeletedDate						
						,District							
						,ENVBasin							
						,ENVElevationGL_FT					
						,ENVElevationGLSource				
						,ENVElevationKB_FT					
						,ENVElevationKBSource				
						,ENVInterval						
						,ENVIntervalSource					
						,ENVOperator						
						,ENVPeerGroup						
						,ENVPlay							
						,ENVProducingMethod					
						,ENVProdWellType					
						,ENVRegion							
						,ENVStockExchange					
						,ENVSubPlay							
						,ENVTicker							
						,ENVWellGrouping					
						,ENVWellStatus						
						,ENVWellType						
						,Field								
						,FirstProdDate						
						,Formation													
						,InitialOperator					
						,Latitude							
						,Lease								
						,LeaseName							
						,Longitude							
						,PermitApprovedDate					
						,PlugDate							
						,Range								
						,RigReleaseDate						
						,Section							
						,SpudDate							
						,SpudDateSource						
						,StateProvince						
						,SurfaceLatLongSource				
						,Township							
						,UpdatedDate						
						,WaterDepth							
						,WellID								
						,WellName							
						,WellNumber							
						,WellSymbols						

						,t1.GeoData	GeomSHL_Point
						,sysdatetime()
					FROM
						openjson(@data)
						WITH (
							 _delete								BIT

							,Abstract								VARCHAR(16)
							,API_UWI								VARCHAR(32)	
							,API_UWI_Unformatted					VARCHAR(32)	
							,Block									VARCHAR(64)	
							,Country								VARCHAR(2)	
							,County									VARCHAR(32)	
							,DeletedDate							DATETIME	
							,District								VARCHAR(256)
							,ENVBasin								VARCHAR(64)	
							,ENVElevationGL_FT						FLOAT		
							,ENVElevationGLSource					VARCHAR(128)
							,ENVElevationKB_FT						FLOAT		
							,ENVElevationKBSource					VARCHAR(128)
							,ENVInterval							VARCHAR(128)
							,ENVIntervalSource						VARCHAR(32)	
							,ENVOperator							VARCHAR(256)
							,ENVPeerGroup							VARCHAR(64)	
							,ENVPlay								VARCHAR(128)
							,ENVProducingMethod						VARCHAR(256)
							,ENVProdWellType						VARCHAR(64)	
							,ENVRegion								VARCHAR(32)	
							,ENVStockExchange						VARCHAR(32)	
							,ENVSubPlay								VARCHAR(64)	
							,ENVTicker								VARCHAR(128)
							,ENVWellGrouping						VARCHAR(128)
							,ENVWellStatus							VARCHAR(64)	
							,ENVWellType							VARCHAR(256)
							,Field									VARCHAR(256)
							,FirstProdDate							DATETIME	
							,Formation								VARCHAR(256)
							,GeomSHL_Point							VARCHAR(MAX)	
							,InitialOperator						VARCHAR(256)
							,Latitude								FLOAT		
							,Lease									VARCHAR(64)	
							,LeaseName								VARCHAR(256)
							,Longitude								FLOAT		
							,PermitApprovedDate						DATETIME	
							,PlugDate								DATETIME	
							,Range									VARCHAR(32)	
							,RigReleaseDate							DATETIME	
							,Section								VARCHAR(32)	
							,SpudDate								DATETIME	
							,SpudDateSource							VARCHAR(8)	
							,StateProvince							VARCHAR(64)	
							,SurfaceLatLongSource					VARCHAR(256)
							,Township								VARCHAR(32)	
							,UpdatedDate							DATETIME	
							,WaterDepth								FLOAT		
							,WellID									BIGINT		
							,WellName								VARCHAR(256)
							,WellNumber								VARCHAR(256)
							,WellSymbols							VARCHAR(256)


							--,ETL_Load_Date		DATETIME
						) t0
						CROSS APPLY [sync].[fnGetGeometryFromStr](t0.GeomSHL_Point) t1


					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Validate WellHeader data
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Validate WellHeader data')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					UPDATE #WellHeader SET 
						 _delete	= coalesce(_delete, 0)
						,_error		= CASE 
										-- Set error true if duplicate detected
										WHEN _duplicate = 1 THEN 1
										
										-- Set error true if WellID is null or empty string
										WHEN WellID IS NULL OR WellID = '' THEN 1
										ELSE 0
									  END
						,_message	=   -- Add error message duplicate detected
									+ CASE WHEN _duplicate = 1 THEN '[ERROR: There were one or more records with the same WellID this record will be ignored ( '+WellID+')];' ELSE '' END
									+ CASE WHEN WellID IS NULL OR WellID  = '' THEN '[ERROR: WellID cannot be null or empty string)];' ELSE '' END
					
					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

				--------------------------------------------------------------------
				-- Save data to data.WellHeader
				--------------------------------------------------------------------
					SET @ErrPos = concat(@MsgTitle, '; Save data to data.WellHeader')
					PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

					----------------------------------------------------------------
					-- Process Deletes
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.WellHeader; Process Deletes')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						DELETE t0
						FROM
							data.WellHeader t0

							INNER JOIN #WellHeader t1
								ON t0.WellID = t1.WellID

						
						WHERE 1=1
							AND t1.DeletedDate is null
							AND t1._delete = 1
							AND t1._error = 0

						SET @ErrPos += concat(' [ ',@@rowcount,' ]')
						PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Updates
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.WellHeader; Process Updates')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						UPDATE t0 SET
								 Abstract								= t1.Abstract										
								,API_UWI								= t1.API_UWI							
								,API_UWI_Unformatted					= t1.API_UWI_Unformatted				
								,Block									= t1.Block								
								,Country								= t1.Country							
								,County									= t1.County								
								,DeletedDate							= t1.DeletedDate						
								,District								= t1.District							
								,ENVBasin								= t1.ENVBasin							
								,ENVElevationGL_FT						= t1.ENVElevationGL_FT					
								,ENVElevationGLSource					= t1.ENVElevationGLSource				
								,ENVElevationKB_FT						= t1.ENVElevationKB_FT					
								,ENVElevationKBSource					= t1.ENVElevationKBSource				
								,ENVInterval							= t1.ENVInterval						
								,ENVIntervalSource						= t1.ENVIntervalSource					
								,ENVOperator							= t1.ENVOperator						
								,ENVPeerGroup							= t1.ENVPeerGroup						
								,ENVPlay								= t1.ENVPlay							
								,ENVProducingMethod						= t1.ENVProducingMethod					
								,ENVProdWellType						= t1.ENVProdWellType					
								,ENVRegion								= t1.ENVRegion							
								,ENVStockExchange						= t1.ENVStockExchange					
								,ENVSubPlay								= t1.ENVSubPlay							
								,ENVTicker								= t1.ENVTicker							
								,ENVWellGrouping						= t1.ENVWellGrouping					
								,ENVWellStatus							= t1.ENVWellStatus						
								,ENVWellType							= t1.ENVWellType						
								,Field									= t1.Field								
								,FirstProdDate							= t1.FirstProdDate						
								,Formation								= t1.Formation							
								,GeomSHL_Point							= t1.GeomSHL_Point						
								,InitialOperator						= t1.InitialOperator					
								,Latitude								= t1.Latitude							
								,Lease									= t1.Lease								
								,LeaseName								= t1.LeaseName							
								,Longitude								= t1.Longitude							
								,PermitApprovedDate						= t1.PermitApprovedDate					
								,PlugDate								= t1.PlugDate							
								,Range									= t1.Range								
								,RigReleaseDate							= t1.RigReleaseDate						
								,Section								= t1.Section							
								,SpudDate								= t1.SpudDate							
								,SpudDateSource							= t1.SpudDateSource						
								,StateProvince							= t1.StateProvince						
								,SurfaceLatLongSource					= t1.SurfaceLatLongSource				
								,Township								= t1.Township							
								,UpdatedDate							= t1.UpdatedDate						
								,WaterDepth								= t1.WaterDepth							
								,WellID									= t1.WellID								
								,WellName								= t1.WellName							
								,WellNumber								= t1.WellNumber							
								,WellSymbols							= t1.WellSymbols						


								--,ETL_Load_Date						= t1.ETL_Load_Date

						FROM
							data.WellHeader t0

							INNER JOIN #WellHeader t1
								ON t0.WellID = t1.WellID
								
						WHERE 1=1
							AND t1._delete = 0
							AND t1._error = 0

					SET @ErrPos += concat(' [ ',@@rowcount,' ]')
					PRINT concat(sysdatetime(),' | INFO | '+@ErrPos)

					----------------------------------------------------------------
					-- Process Inserts
					----------------------------------------------------------------
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.WellHeader; Process Inserts')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						INSERT INTO data.WellHeader ( 
							  Abstract						
							 ,API_UWI						
							 ,API_UWI_Unformatted			
							 ,Block							
							 ,Country						
							 ,County							
							 ,DeletedDate					
							 ,District						
							 ,ENVBasin						
							 ,ENVElevationGL_FT				
							 ,ENVElevationGLSource			
							 ,ENVElevationKB_FT				
							 ,ENVElevationKBSource			
							 ,ENVInterval					
							 ,ENVIntervalSource				
							 ,ENVOperator					
							 ,ENVPeerGroup					
							 ,ENVPlay						
							 ,ENVProducingMethod				
							 ,ENVProdWellType				
							 ,ENVRegion						
							 ,ENVStockExchange				
							 ,ENVSubPlay						
							 ,ENVTicker						
							 ,ENVWellGrouping				
							 ,ENVWellStatus					
							 ,ENVWellType					
							 ,Field							
							 ,FirstProdDate					
							 ,Formation						
							 ,GeomSHL_Point					
							 ,InitialOperator				
							 ,Latitude						
							 ,Lease							
							 ,LeaseName						
							 ,Longitude						
							 ,PermitApprovedDate				
							 ,PlugDate						
							 ,Range							
							 ,RigReleaseDate					
							 ,Section						
							 ,SpudDate						
							 ,SpudDateSource					
							 ,StateProvince					
							 ,SurfaceLatLongSource			
							 ,Township						
							 ,UpdatedDate					
							 ,WaterDepth						
							 ,WellID							
							 ,WellName						
							 ,WellNumber						
							 ,WellSymbols					

					
							,ETL_Load_Date
							)
						SELECT					
							 Abstract								= t0.Abstract				
							,API_UWI								= t0.API_UWI				
							,API_UWI_Unformatted					= t0.API_UWI_Unformatted	
							,Block									= t0.Block					
							,Country								= t0.Country				
							,County									= t0.County					
							,DeletedDate							= t0.DeletedDate			
							,District								= t0.District				
							,ENVBasin								= t0.ENVBasin				
							,ENVElevationGL_FT						= t0.ENVElevationGL_FT		
							,ENVElevationGLSource					= t0.ENVElevationGLSource	
							,ENVElevationKB_FT						= t0.ENVElevationKB_FT		
							,ENVElevationKBSource					= t0.ENVElevationKBSource	
							,ENVInterval							= t0.ENVInterval			
							,ENVIntervalSource						= t0.ENVIntervalSource		
							,ENVOperator							= t0.ENVOperator			
							,ENVPeerGroup							= t0.ENVPeerGroup			
							,ENVPlay								= t0.ENVPlay				
							,ENVProducingMethod						= t0.ENVProducingMethod		
							,ENVProdWellType						= t0.ENVProdWellType		
							,ENVRegion								= t0.ENVRegion				
							,ENVStockExchange						= t0.ENVStockExchange		
							,ENVSubPlay								= t0.ENVSubPlay				
							,ENVTicker								= t0.ENVTicker				
							,ENVWellGrouping						= t0.ENVWellGrouping		
							,ENVWellStatus							= t0.ENVWellStatus			
							,ENVWellType							= t0.ENVWellType			
							,Field									= t0.Field					
							,FirstProdDate							= t0.FirstProdDate			
							,Formation								= t0.Formation				
							,GeomSHL_Point							= t0.GeomSHL_Point			
							,InitialOperator						= t0.InitialOperator		
							,Latitude								= t0.Latitude				
							,Lease									= t0.Lease					
							,LeaseName								= t0.LeaseName				
							,Longitude								= t0.Longitude				
							,PermitApprovedDate						= t0.PermitApprovedDate		
							,PlugDate								= t0.PlugDate				
							,Range									= t0.Range					
							,RigReleaseDate							= t0.RigReleaseDate			
							,Section								= t0.Section				
							,SpudDate								= t0.SpudDate				
							,SpudDateSource							= t0.SpudDateSource			
							,StateProvince							= t0.StateProvince			
							,SurfaceLatLongSource					= t0.SurfaceLatLongSource	
							,Township								= t0.Township				
							,UpdatedDate							= t0.UpdatedDate			
							,WaterDepth								= t0.WaterDepth				
							,WellID									= t0.WellID					
							,WellName								= t0.WellName				
							,WellNumber								= t0.WellNumber				
							,WellSymbols							= t0.WellSymbols					
							

							,ETL_Load_Date							 = t0.ETL_Load_Date				
						FROM
							#WellHeader t0

							LEFT OUTER JOIN data.WellHeader t1
	
								ON t0.WellID	= t1.WellID

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
						SET @ErrPos = concat(@MsgTitle, '; Save data to data.WellHeader')
						PRINT concat(sysdatetime(),' | INFO | ',@ErrPos)

						SELECT 
							 _row_id
                            ,_delete
                            ,_error
                            ,_message

					 
							,API_UWI					
							,API_UWI_Unformatted		
							,Block						
							,Country					
							,County						
							,DeletedDate				
							,District					
							,ENVBasin					
							,ENVElevationGL_FT			
							,ENVElevationGLSource		
							,ENVElevationKB_FT			
							,ENVElevationKBSource		
							,ENVInterval				
							,ENVIntervalSource			
							,ENVOperator				
							,ENVPeerGroup				
							,ENVPlay					
							,ENVProducingMethod			
							,ENVProdWellType			
							,ENVRegion					
							,ENVStockExchange			
							,ENVSubPlay					
							,ENVTicker					
							,ENVWellGrouping			
							,ENVWellStatus				
							,ENVWellType				
							,Field						
							,FirstProdDate				
							,Formation					
							,GeomSHL_Point				
							,InitialOperator			
							,Latitude					
							,Lease						
							,LeaseName					
							,Longitude					
							,PermitApprovedDate			
							,PlugDate					
							,Range						
							,RigReleaseDate				
							,Section					
							,SpudDate					
							,SpudDateSource				
							,StateProvince				
							,SurfaceLatLongSource		
							,Township					
							,UpdatedDate				
							,WaterDepth					
							,WellID						
							,WellName					
							,WellNumber					
							,WellSymbols				
									   
												
							,ETL_Load_Date
						FROM 
							#WellHeader
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