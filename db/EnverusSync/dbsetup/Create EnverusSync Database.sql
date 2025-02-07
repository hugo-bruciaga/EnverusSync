/***********************************************************************************

	Script Name:		Create database EnverusSync
	Author:				Enterprise Database Development Team
	______________________________________________________________________________

	Purpose:			
	  Creates the EnverusSync database at 1024MB/512MB data and log files.
	______________________________________________________________________________

***********************************************************************************/
:SETVAR database_name "EnverusSync"
:SETVAR database_owner "NULL"
:SETVAR datafile_path "NULL"
:SETVAR tranfile_path "NULL"

	USE master
	SET NOCOUNT ON
	SET XACT_ABORT ON

	PRINT '------------------------------------------------------------------------------------'
	PRINT convert(VARCHAR,sysdatetime(),121) + ' | INFO | Create database EnverusSync'
	PRINT '------------------------------------------------------------------------------------'

	--------------------------------------------------------------------------------
	-- Variable Declaration
	--------------------------------------------------------------------------------
		DECLARE
			@datafile_path VARCHAR(255)
		   ,@tranfile_path VARCHAR(255)
		   ,@database_owner VARCHAR(128)

		DECLARE	
			@SQL VARCHAR(MAX)
		
		DECLARE
			 @ErrCount			INT				= 0
			,@ErrPos			VARCHAR(512)
			,@ErrMsg			VARCHAR(2048)

	--------------------------------------------------------------------------------
	-- Set process variables
	--------------------------------------------------------------------------------
		SET @ErrPos = 'Create database EnverusSync - Set process variables'
		PRINT convert(VARCHAR,sysdatetime(),121) + ' | INFO | ' + @ErrPos

		SET @database_owner = nullif('$(database_owner)','NULL')
		SET @datafile_path = nullif('$(datafile_path)','NULL')
		SET @tranfile_path = nullif('$(tranfile_path)','NULL')

	--------------------------------------------------------------------------------
	-- Populate process variables
	--------------------------------------------------------------------------------
		SET @ErrPos = 'Create database EnverusSync - Populate process variables'
		PRINT convert(VARCHAR,sysdatetime(),121) + ' | INFO | ' + @ErrPos

		----------------------------------------------------------------------------
		-- @database_owner
		----------------------------------------------------------------------------
			PRINT convert(varchar,sysdatetime(),121)+' | INFO | '+@ErrPos+'; @database_owner'

			SELECT
				@database_owner = coalesce(@database_owner,service_account)
			FROM
				sys.dm_server_services
			WHERE
				servicename = 'SQL Server (' + coalesce(cast(serverproperty('InstanceName') AS VARCHAR),'MSSQLSERVER') + ')'

		----------------------------------------------------------------------------
		-- @datafile_path
		----------------------------------------------------------------------------
			PRINT convert(varchar,sysdatetime(),121)+' | INFO | '+@ErrPos+'; @datafile_path'

			SELECT
				@datafile_path = coalesce(@datafile_path,left(physical_name,len(physical_name) - charindex('\',reverse(physical_name),1))) + '\$(database_name)_data.mdf'
			FROM
				model.sys.database_files
			WHERE
				type = 0
			ORDER BY
				file_id DESC

		----------------------------------------------------------------------------
		-- @tranfile_path
		----------------------------------------------------------------------------
			PRINT convert(varchar,sysdatetime(),121)+' | INFO | '+@ErrPos+'; @tranfile_path'
		
			SELECT
				@tranfile_path = coalesce(@tranfile_path,left(physical_name,len(physical_name) - charindex('\',reverse(physical_name),1))) + '\$(database_name)_log.ldf'
			FROM
				model.sys.database_files
			WHERE
				type = 1
			ORDER BY
				file_id DESC

	--------------------------------------------------------------------------------
	-- Check if database already exists
	--------------------------------------------------------------------------------
		IF EXISTS (
			SELECT
				NULL
			FROM
				sys.databases
			WHERE
				name = '$(database_name)' 
		)
		BEGIN
			SET @ErrPos = 'Create database EnverusSync - Drop existing database'
			PRINT convert(varchar,sysdatetime(),121)+' | INFO | '+@ErrPos
			
			ALTER DATABASE $(database_name) SET SINGLE_USER WITH ROLLBACK IMMEDIATE
			DROP DATABASE $(database_name)
		END
		
	--------------------------------------------------------------------------------
	-- Build create database command
	--------------------------------------------------------------------------------
		SET @ErrPos = 'Create database EnverusSync - Build create database command'
		PRINT convert(varchar,sysdatetime(),121)+' | INFO | '+@ErrPos
	
		SET @SQL = 'CREATE DATABASE $(database_name)'
				 + '	ON PRIMARY (' 
				 + '		 NAME = N''$(database_name)_data'''
				 + '		,FILENAME = N'''+@datafile_path+''''
				 + '		,SIZE = 1024MB'
				 + '		,MAXSIZE = UNLIMITED'
				 + '		,FILEGROWTH = 1024MB'
				 + '	)'
				 + '	LOG ON (' 
				 + '		 NAME = N''$(database_name)_log'''
				 + '		,FILENAME = N'''+@tranfile_path+''''
				 + '		,SIZE = 512MB'
				 + '		,MAXSIZE = UNLIMITED'
				 + '		,FILEGROWTH = 1024MB'
				 + '	)'

		PRINT convert(varchar,sysdatetime(),121)+' | INFO | '+@ErrPos+'; DDL='+@SQL
		EXEC (@SQL)

	--------------------------------------------------------------------------------
	-- Set Database Owner
	--------------------------------------------------------------------------------
		IF @database_owner <> suser_sname()
		BEGIN
			SET @ErrPos = 'Create database EnverusSync - Set database owner'
			PRINT convert(VARCHAR,sysdatetime(),121) + ' | INFO | ' + @ErrPos

			SET @SQL = 'ALTER AUTHORIZATION ON DATABASE::$(database_name) TO ' + quotename(@database_owner) + ''
			EXEC (@SQL)
		END

	--------------------------------------------------------------------------------
	-- Set Recovery SIMPLE
	--------------------------------------------------------------------------------
		SET @ErrPos = 'Create database EnverusSync - Set recovery SIMPLE'
		PRINT convert(VARCHAR,sysdatetime(),121) + ' | INFO | ' + @ErrPos
	
		ALTER DATABASE $(database_name) SET RECOVERY SIMPLE
	
	PRINT convert(VARCHAR,sysdatetime(),121)+' | INFO | Create database EnverusSync; *** Complete ***'
	SET NOCOUNT OFF

