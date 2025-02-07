CREATE TABLE data.ActiveRig
(
     API_UWI						VARCHAR(32)  NULL
    ,DeletedDate					DATETIME	   NULL
    ,UpdatedDate					DATETIME	   NULL
    ,WellID							BIGINT	   NULL
    ,Abstract						VARCHAR(16)  NULL
    ,AmendedDate					DATETIME	   NULL
    ,API_UWI_Unformatted			VARCHAR(32)  NULL
    ,ApprovedDate					DATETIME	   NULL
    ,Block							VARCHAR(256) NULL
    ,BottomHoleLatitude				FLOAT(53)	   NULL
    ,BottomHoleLongitude			FLOAT(53)	   NULL
    ,ContractorAddress				VARCHAR(256) NULL
    ,ContractorCity					VARCHAR(256) NULL
    ,ContractorContact				VARCHAR(256) NULL
    ,ContractorEmail				VARCHAR(256) NULL
    ,ContractorName					VARCHAR(256) NULL
    ,ContractorPhone				VARCHAR(256) NULL
    ,ContractorState				VARCHAR(256) NULL
    ,ContractorWebsite				VARCHAR(256) NULL
    ,ContractorZip					VARCHAR(256) NULL
    ,Country						VARCHAR(2)   NULL
    ,County							VARCHAR(32)  NULL
    ,DirectionsToLocation			VARCHAR(MAX) NULL
    ,District						VARCHAR(256) NULL
    ,DrawWorks						VARCHAR(256) NULL
    ,ENVBasin						VARCHAR(64)  NULL
    ,ENVGasGatherer					VARCHAR(256) NULL
    ,ENVGasGatheringSystem			VARCHAR(256) NULL
    ,ENVInterval					VARCHAR(128) NULL
    ,ENVOilGatherer					VARCHAR(256) NULL
    ,ENVOilGatheringSystem			VARCHAR(256) NULL
    ,ENVOperator					VARCHAR(256) NULL
    ,ENVPeerGroup					VARCHAR(256) NULL
    ,ENVPlay						VARCHAR(128) NULL
    ,ENVRegion						VARCHAR(32)  NULL
    ,ENVRigID						INT		   NOT NULL
    ,ENVSubPlay					  VARCHAR(64)  NULL
    ,ENVTicker					  VARCHAR(128) NULL
    ,ExpiredDate					  DATETIME	   NULL
    ,Field						  VARCHAR(256) NULL
    ,H2SArea						  BIT	   NULL
    ,LandOffshore				  VARCHAR(8)   NULL
    ,LeaseName					  VARCHAR(256) NULL
    ,Mobility					  VARCHAR(256) NULL
    ,OperatorAddress				  VARCHAR(256) NULL
    ,OperatorCity				  VARCHAR(256) NULL
    ,OperatorCity30_MI			  VARCHAR(256) NULL
    ,OperatorContact				  VARCHAR(256) NULL
    ,OperatorPhone				  VARCHAR(256) NULL
    ,OperatorState				  VARCHAR(256) NULL
    ,OperatorZip					  VARCHAR(256) NULL
    ,PermitNumber				  VARCHAR(256) NULL
    ,PermittedMeasuredDepth_FT	  INT		   NULL
    ,PermittedOperator			  VARCHAR(256) NULL
    ,PermittedTrueVerticalDepth_FT INT		   NULL
    ,PermittedWaterDepth_FT		  INT		   NULL
    ,PermitType					  VARCHAR(256) NULL
    ,PowerType					  VARCHAR(256) NULL
    ,Range						  VARCHAR(32)  NULL
    ,RatedHorsePower				  INT		   NULL
    ,RatedWaterDepth_FT			  INT		   NULL
    ,RigClass					  VARCHAR(256) NULL
    ,RigJobStartDate				  DATETIME	   NULL
    ,RigLatitude					  FLOAT(53)	   NULL
    ,RigLongitude				  FLOAT(53)	   NULL
    ,RigNameNumber				  VARCHAR(256) NULL
    ,RigType						  VARCHAR(256) NULL
    ,Section						  VARCHAR(32)  NULL
    ,SpudDate					  DATETIME	   NULL
    ,StateProvince				  VARCHAR(64)  NULL
    ,STR							  VARCHAR(128) NULL
    ,SubmittedDate				  DATETIME	   NULL
    ,SurfaceLocationSource		  VARCHAR(256) NULL
    ,Survey						  VARCHAR(256) NULL
    ,TargetFormation				  VARCHAR(256) NULL
    ,Township					  VARCHAR(32)  NULL
    ,Trajectory					  VARCHAR(256) NULL
    ,WellNumber					  VARCHAR(256) NULL
    ,WellType					  VARCHAR(256) NULL
    ,ETL_Load_Date				  DATETIME	   NULL
    CONSTRAINT pk_data_ActiveRigs_ENVRigID
        PRIMARY KEY CLUSTERED (ENVRigID)
)

GO


CREATE NONCLUSTERED INDEX idx_data_ActiveRig_WellID_ENVRigID
    ON data.ActiveRig (
        WellID,
        ENVRigID
)

