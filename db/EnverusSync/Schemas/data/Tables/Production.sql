CREATE TABLE data.[Production] (
    [API_UWI]                      VARCHAR (32)  NULL,
    [API_UWI_Unformatted]          VARCHAR (32)  NULL,
    [API_UWI_14]                   VARCHAR (32)  NULL,
    [API_UWI_14_Unformatted]       VARCHAR (32)  NULL,
    [CDFlaredGas_MCFPerDAY]        REAL          NULL,
    [CDGas_MCFPerDAY]              FLOAT (53)    NULL,
    [CDInjectionGas_MCFPerDAY]     FLOAT (53)    NULL,
    [CDInjectionOther_BBLPerDAY]   FLOAT (53)    NULL,
    [CDInjectionSolvent_BBLPerDAY] FLOAT (53)    NULL,
    [CDInjectionSteam_BBLPerDAY]   FLOAT (53)    NULL,
    [CDInjectionWater_BBLPerDAY]   FLOAT (53)    NULL,
    [CDLiquids_BBLPerDAY]          FLOAT (53)    NULL,
    [CDProd_BOEPerDAY]             FLOAT (53)    NULL,
    [CDProd_MCFEPerDAY]            FLOAT (53)    NULL,
    [CDRepGas_MCFPerDAY]           REAL          NULL,
    [CDWater_BBLPerDAY]            FLOAT (53)    NULL,
    [CompletionID]                 BIGINT        NULL,
    [Country]                      VARCHAR (2)   NULL,
    [County]                       VARCHAR (32)  NULL,
    [CumFlaredGas_MCF]             REAL          NULL,
    [CumGas_MCF]                   REAL          NULL,
    [CumLiquids_BBL]               REAL          NULL,
    [CumProd_BOE]                  REAL          NULL,
    [CumProd_MCFE]                 REAL          NULL,
    [CumRepGas_MCF]                REAL          NULL,
    [CumWater_BBL]                 REAL          NULL,
    [DeletedDate]                  DATETIME      NULL,
    [ENVBasin]                     VARCHAR (64)  NULL,
    [ENVInterval]                  VARCHAR (128) NULL,
    [ENVPlay]                      VARCHAR (128) NULL,
    [ENVProdID]                    TINYINT       NULL,
    [ENVRegion]                    VARCHAR (32)  NULL,
    [FlaredGasProd_MCF]            REAL          NULL,
    [GasProd_MCF]                  FLOAT (53)    NULL,
    [InjectionGas_MCF]             FLOAT (53)    NULL,
    [InjectionOther_BBL]           FLOAT (53)    NULL,
    [InjectionSolvent_BBL]         FLOAT (53)    NULL,
    [InjectionSteam_BBL]           FLOAT (53)    NULL,
    [InjectionWater_BBL]           FLOAT (53)    NULL,
    [LiquidsProd_BBL]              FLOAT (53)    NULL,
    [PDFlaredGas_MCFPerDAY]        FLOAT (53)    NULL,
    [PDGas_MCFPerDAY]              FLOAT (53)    NULL,
    [PDLiquids_BBLPerDAY]          FLOAT (53)    NULL,
    [PDProd_BOEPerDAY]             FLOAT (53)    NULL,
    [PDProd_MCFEPerDAY]            FLOAT (53)    NULL,
    [PDRepGas_MCFPerDAY]           FLOAT (53)    NULL,
    [PDWater_BBLPerDAY]            FLOAT (53)    NULL,
    [Prod_BOE]                     FLOAT (53)    NULL,
    [Prod_CondensateBBL]           REAL          NULL,
    [Prod_MCFE]                    FLOAT (53)    NULL,
    [Prod_OilBBL]                  FLOAT (53)    NULL,
    [ProducingDays]                FLOAT (53)    NULL,
    [ProducingMonth]               DATETIME      NULL,
    [ProducingOperator]            VARCHAR (256) NULL,
    [ProductionID]                 BIGINT        NOT NULL,
    [ProductionReportedMethod]     VARCHAR (16)  NULL,
    [RepGasProd_MCF]               REAL          NULL,
    [StateProvince]                VARCHAR (64)  NULL,
    [TotalCompletionMonths]        INT           NULL,
    [TotalProdMonths]              INT           NULL,
    [UpdatedDate]                  DATETIME      NULL,
    [WaterProd_BBL]                FLOAT (53)    NULL,
    [WellID]                       BIGINT        NULL,
    [ETL_Load_Date]                DATETIME      NULL,
    constraint pk_Stage_Persistant_Enverus_Foundations_Production_ProductionID primary key clustered (ProductionID)
);


GO
CREATE NONCLUSTERED INDEX [idx_data_production_ProductionID]
    ON data.[Production]([ProductionID] ASC);
GO

/*
CREATE NONCLUSTERED INDEX [idx_zs_enverus_foundations_production_ENVRegion_ENVBasin_StateProvince]
    ON data.[Production](ENVRegion, ENVBasin, StateProvince);
GO
*/