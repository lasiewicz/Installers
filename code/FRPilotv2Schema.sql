USE [FRPilot]

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'FRPAdmin')
CREATE LOGIN [FRPAdmin] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [FRPAdmin] FOR LOGIN [FRPAdmin] WITH DEFAULT_SCHEMA=[dbo]
GRANT CONNECT TO [FRPAdmin]
GO
REVOKE CONNECT FROM [FRPAdmin]
GO
BEGIN TRANSACTION
GO
PRINT N'Creating [dbo].[SystemUserSettingsBase]'
GO
CREATE TABLE [dbo].[SystemUserSettingsBase]
(
[SettingID] [uniqueidentifier] NOT NULL,
[SystemUserID] [uniqueidentifier] NULL,
[SettingKey] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SettingValue] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_SystemUserSettingsBase] on [dbo].[SystemUserSettingsBase]'
GO
ALTER TABLE [dbo].[SystemUserSettingsBase] ADD CONSTRAINT [PK_SystemUserSettingsBase] PRIMARY KEY CLUSTERED  ([SettingID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserSettingsBase_SelectSettingsByUserID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_SystemUserSettingsBase_SelectSettingsByUserID]
	(
	@SystemUserID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT * FROM SystemUserSettingsBase WHERE SystemUserID = @SystemUserID	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PurchaseOrderBase]'
GO
CREATE TABLE [dbo].[PurchaseOrderBase]
(
[PurchaseOrderID] [uniqueidentifier] NOT NULL,
[PONumber] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReceivedOn] [datetime] NULL,
[OwningUser] [uniqueidentifier] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[Status] [int] NULL,
[Stage] [int] NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletionStateCode] [int] NULL,
[QBPOID] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PurchaseOrderBase] on [dbo].[PurchaseOrderBase]'
GO
ALTER TABLE [dbo].[PurchaseOrderBase] ADD CONSTRAINT [PK_PurchaseOrderBase] PRIMARY KEY CLUSTERED  ([PurchaseOrderID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[WarehouseBase]'
GO
CREATE TABLE [dbo].[WarehouseBase]
(
[WarehouseID] [uniqueidentifier] NOT NULL ROWGUIDCOL,
[WarehouseIDName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryContact] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_WarehouseBase] on [dbo].[WarehouseBase]'
GO
ALTER TABLE [dbo].[WarehouseBase] ADD CONSTRAINT [PK_WarehouseBase] PRIMARY KEY CLUSTERED  ([WarehouseID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_WarehouseBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_WarehouseBase_Update]
(
	@WarehouseID uniqueidentifier,
	@WarehouseIDName nvarchar(50),
	@PrimaryContact nvarchar(200),
	@Description ntext,
	@ZipCode nvarchar(20),
	@City nvarchar(50),
	@Street1 nvarchar(50),
	@Street2 nvarchar(50),
	@BusinessPhone nvarchar(50),
	@State nvarchar(50),
	@Original_WarehouseID uniqueidentifier,
	@Original_BusinessPhone nvarchar(50),
	@Original_City nvarchar(50),
	@Original_PrimaryContact nvarchar(200),
	@Original_State nvarchar(50),
	@Original_Street1 nvarchar(50),
	@Original_Street2 nvarchar(50),
	@Original_WarehouseIDName nvarchar(50),
	@Original_ZipCode nvarchar(20)
)
AS
	SET NOCOUNT OFF;
UPDATE WarehouseBase SET WarehouseID = @WarehouseID, WarehouseIDName = @WarehouseIDName, PrimaryContact = @PrimaryContact, Description = @Description, ZipCode = @ZipCode, City = @City, Street1 = @Street1, Street2 = @Street2, BusinessPhone = @BusinessPhone, State = @State WHERE (WarehouseID = @Original_WarehouseID);
	SELECT WarehouseID, WarehouseIDName, PrimaryContact, Description, ZipCode, City, Street1, Street2, BusinessPhone, State FROM WarehouseBase WHERE (WarehouseID = @WarehouseID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PurchaseOrderDetailBase]'
GO
CREATE TABLE [dbo].[PurchaseOrderDetailBase]
(
[PurchaseOrderDetailID] [uniqueidentifier] NOT NULL,
[PurchaseOrderID] [uniqueidentifier] NOT NULL,
[ProductClassID] [uniqueidentifier] NULL,
[ProductID] [uniqueidentifier] NULL,
[ProductNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductDescription] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuantityOrdered] [decimal] (18, 0) NULL,
[QuantityReceived] [decimal] (18, 0) NULL,
[BasePrice] [money] NULL,
[ExtendedPrice] [money] NULL,
[UofMSchedule] [uniqueidentifier] NULL,
[UofM] [uniqueidentifier] NULL,
[QtyBSUofM] [decimal] (18, 0) NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[DeletionStateCode] [int] NULL,
[QBPOLineID] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PurchaseOrderDetailBase] on [dbo].[PurchaseOrderDetailBase]'
GO
ALTER TABLE [dbo].[PurchaseOrderDetailBase] ADD CONSTRAINT [PK_PurchaseOrderDetailBase] PRIMARY KEY CLUSTERED  ([PurchaseOrderDetailID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_PurchaseOrderBase_DeletionStateCode]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_PurchaseOrderBase_DeletionStateCode] 
	(
	@PurchaseOrderID uniqueidentifier
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Update PurchaseOrderBase Set DeletionStateCode = 1 Where PurchaseOrderID = @PurchaseOrderID
Update PurchaseOrderDetailBase Set DeletionStateCode = 1 Where PurchaseOrderID = @PurchaseOrderID 

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[InventoryAdjustmentBase]'
GO
CREATE TABLE [dbo].[InventoryAdjustmentBase]
(
[InventoryAdjustmentID] [uniqueidentifier] NOT NULL,
[InventoryAdjNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NULL,
[OwningUser] [uniqueidentifier] NULL,
[StatusReasonCode] [int] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[Status] [int] NULL,
[Stage] [int] NULL,
[DeletionStateCode] [int] NULL,
[Description] [ntext] COLLATE Latin1_General_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_InventoryAdjustmentBase] on [dbo].[InventoryAdjustmentBase]'
GO
ALTER TABLE [dbo].[InventoryAdjustmentBase] ADD CONSTRAINT [PK_InventoryAdjustmentBase] PRIMARY KEY CLUSTERED  ([InventoryAdjustmentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentBase_Insert]
(
	@InventoryAdjustmentID uniqueidentifier,
	@InventoryAdjNumber nvarchar(50),
	@StartDate datetime,
	@OwningUser uniqueidentifier,
	@StatusReasonCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO InventoryAdjustmentBase(InventoryAdjustmentID, InventoryAdjNumber, StartDate, OwningUser, StatusReasonCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@InventoryAdjustmentID, @InventoryAdjNumber, @StartDate, @OwningUser, @StatusReasonCode, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT InventoryAdjustmentID, InventoryAdjNumber, StartDate, OwningUser, StatusReasonCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM InventoryAdjustmentBase WHERE (InventoryAdjustmentID = @InventoryAdjustmentID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ActivityBase]'
GO
CREATE TABLE [dbo].[ActivityBase]
(
[ActivityId] [uniqueidentifier] NOT NULL ROWGUIDCOL,
[GroupId] [uniqueidentifier] NULL,
[ContactId] [uniqueidentifier] NULL,
[FundraiserId] [uniqueidentifier] NULL,
[ParentTypeCode] [int] NULL,
[AllDayEvent] [bit] NULL,
[PercentComplete] [int] NULL,
[ActivityTypeCode] [int] NOT NULL,
[DeletionStateCode] [int] NULL,
[DirectionCode] [int] NULL,
[ScheduledDuration] [int] NULL,
[PriorityCode] [int] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ScheduledStartDate] [datetime] NULL,
[ScheduledEndDate] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[Message] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[OwningUser] [uniqueidentifier] NULL,
[Location] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteOrOrderNumber] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusCode] [int] NULL,
[SenderId] [uniqueidentifier] NULL,
[SenderTypeCode] [int] NULL,
[RecipientId] [uniqueidentifier] NULL,
[RecipientTypeCode] [int] NULL,
[RegardingId] [uniqueidentifier] NULL,
[RegardingTypeCode] [int] NULL,
[PhoneNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumberExt] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DurationFormatCode] [int] NULL,
[DeliveryOn] [datetime] NULL,
[DeliveryStart] [datetime] NULL,
[DeliveryEnd] [datetime] NULL,
[AddressName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Latitude] [float] NULL,
[Longitude] [float] NULL,
[Recurrence] [bit] NULL,
[Reminder] [bit] NULL,
[ReminderInterval] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReminderTime] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalUnits] [int] NULL,
[DeliveryVehicle] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllProperties] [varbinary] (8000) NULL,
[MapGridId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MapLink] [ntext] COLLATE Latin1_General_CI_AS NULL,
[AddressNotes] [ntext] COLLATE Latin1_General_CI_AS NULL,
[Label] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[BarColor] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EmailAddress] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DocID] [uniqueidentifier] NULL,
[DocType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AddressType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PrimaryDelivery] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ActivityBase] on [dbo].[ActivityBase]'
GO
ALTER TABLE [dbo].[ActivityBase] ADD CONSTRAINT [PK_ActivityBase] PRIMARY KEY CLUSTERED  ([ActivityId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_CheckForRelatedInvoices]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_CheckForRelatedInvoices] 
 (
	@InvoiceID uniqueidentifier,
	@ActivityID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;

     	SELECT * FROM ActivityBase
WHERE ActivityBase.DocID = @InvoiceID AND ActivityBase.ActivityTypeCode = 2 AND ActivityBase.ActivityID <> @ActivityID AND ActivityBase.StatusCode = 0
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[InventoryAdjustmentDetailBase]'
GO
CREATE TABLE [dbo].[InventoryAdjustmentDetailBase]
(
[InventoryAdjustmentDetailID] [uniqueidentifier] NOT NULL,
[InventoryAdjustmentID] [uniqueidentifier] NULL,
[ProductID] [uniqueidentifier] NOT NULL,
[ProductNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductDescription] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountedQuantity] [int] NULL,
[OriginalQuantity] [int] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[DeletionStateCode] [int] NULL,
[QtyBsUofM] [decimal] (18, 0) NULL,
[ProductClassID] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_InventoryAdjustmentDetailBase] on [dbo].[InventoryAdjustmentDetailBase]'
GO
ALTER TABLE [dbo].[InventoryAdjustmentDetailBase] ADD CONSTRAINT [PK_InventoryAdjustmentDetailBase] PRIMARY KEY CLUSTERED  ([InventoryAdjustmentDetailID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentBase_DeletionStateCode]'
GO

CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentBase_DeletionStateCode] 
		(
	@InventoryAdjustmentID uniqueidentifier
)
AS
BEGIN
	
	SET NOCOUNT ON;

Update InventoryAdjustmentBase Set DeletionStateCode = 1 Where InventoryAdjustmentID = @InventoryAdjustmentID
Update InventoryAdjustmentDetailBase Set DeletionStateCode = 1 Where InventoryAdjustmentID= @InventoryAdjustmentID 

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentDetailBase_GridInsert]'
GO

CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentDetailBase_GridInsert]
(
	@InventoryAdjustmentDetailID uniqueidentifier,
	@InventoryAdjustmentID uniqueidentifier,
	@ProductID uniqueidentifier,
	@ProductNumber nvarchar(50),
	@ProductDescription ntext,
	@CountedQuantity int,
	@OriginalQuantity int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO InventoryAdjustmentDetailBase(InventoryAdjustmentDetailID, InventoryAdjustmentID, ProductID, ProductNumber, ProductDescription, CountedQuantity, OriginalQuantity, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@InventoryAdjustmentDetailID, @InventoryAdjustmentID, @ProductID, @ProductNumber, @ProductDescription, @CountedQuantity, @OriginalQuantity, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT InventoryAdjustmentDetailID, InventoryAdjustmentID, ProductID, ProductNumber AS [Product Number], ProductDescription AS [Product Description], CountedQuantity AS [Actual Quantity], OriginalQuantity AS [Original Quantity],  nullif(CountedQuantity - OriginalQuantity,0) as [Difference], CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM InventoryAdjustmentDetailBase WHERE (InventoryAdjustmentDetailID = @InventoryAdjustmentDetailID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[VendorBase]'
GO
CREATE TABLE [dbo].[VendorBase]
(
[VendorID] [uniqueidentifier] NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WebSiteURL1] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WebSiteURL2] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WebSiteURL3] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_VendorBase] on [dbo].[VendorBase]'
GO
ALTER TABLE [dbo].[VendorBase] ADD CONSTRAINT [PK_VendorBase] PRIMARY KEY CLUSTERED  ([VendorID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_SetPrimaryDeliveryToFalse]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_SetPrimaryDeliveryToFalse] 
	(
@FundraiserID uniqueidentifier,
@ActivityID uniqueidentifier
)

AS
BEGIN
	SET NOCOUNT ON;

	UPDATE ActivityBase SET PrimaryDelivery = 'False' WHERE ActivityBase.FundraiserID = @FundraiserID AND ActivityBase.PrimaryDelivery = 'True' AND ActivityBase.ActivityTypeCode = 2 AND ActivityBase.ActivityID <> @ActivityID AND ActivityBase.StatusCode =0
END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ExceptionLog]'
GO
CREATE TABLE [dbo].[ExceptionLog]
(
[ErrorItemID] [uniqueidentifier] NOT NULL,
[ErrorDate] [datetime] NULL,
[SessionInfo] [nvarchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additionalnfo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorInfo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StackTraceInfo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCode] [int] NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ExceptionLog] on [dbo].[ExceptionLog]'
GO
ALTER TABLE [dbo].[ExceptionLog] ADD CONSTRAINT [PK_ExceptionLog] PRIMARY KEY CLUSTERED  ([ErrorItemID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ExceptionLog_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_ExceptionLog_Select]
AS
	SET NOCOUNT ON;
SELECT ErrorItemID, ErrorDate, SessionInfo, Additionalnfo, ErrorInfo, StackTraceInfo, ErrorCode FROM ExceptionLog


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_UpdateRelatedDeliveryStatus]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_InvoiceBase_UpdateRelatedDeliveryStatus]
(
	@InvoiceID uniqueidentifier,
	@NewDelStatus int
)
AS
BEGIN
	SET NOCOUNT ON;

UPDATE ActivityBase SET ActivityBase.StatusCode = @NewDelStatus WHERE ActivityBase.DocID = @InvoiceID AND ActivityBase.StatusCode <> 2

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_PurchaseOrderDetailBase_SelectByPurchaseOrderID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_PurchaseOrderDetailBase_SelectByPurchaseOrderID]
	(
	@PurchaseOrderID uniqueidentifier
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	*
FROM	PurchaseOrderDetailBase p 
	--Left Outer Join ProductBase p	On i.ProductID = p.ProductID
Where PurchaseOrderID = @PurchaseOrderID
ORDER BY p.ProductNumber
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DatabaseDetail]'
GO
CREATE TABLE [dbo].[DatabaseDetail]
(
[DatabaseDetailID] [uniqueidentifier] NOT NULL,
[DetailName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DetailValue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_DatabaseDetail] on [dbo].[DatabaseDetail]'
GO
ALTER TABLE [dbo].[DatabaseDetail] ADD CONSTRAINT [PK_DatabaseDetail] PRIMARY KEY CLUSTERED  ([DatabaseDetailID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_DatabaseDetail_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_DatabaseDetail_Select]
(
		@DetailName as nvarchar(50)
)
AS
	SET NOCOUNT ON;
IF @DetailName IS NULL
BEGIN
	SELECT DetailValue FROM DatabaseDetail	
END
ELSE
BEGIN
	SELECT DetailValue FROM DatabaseDetail
	Where DetailName = @DetailName		
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[AutoNumbers]'
GO
CREATE TABLE [dbo].[AutoNumbers]
(
[AutoNumberID] [bigint] NOT NULL IDENTITY(1, 1),
[AutoNumberType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AutoNumber] [bigint] NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_AutoNumbers] on [dbo].[AutoNumbers]'
GO
ALTER TABLE [dbo].[AutoNumbers] ADD CONSTRAINT [PK_AutoNumbers] PRIMARY KEY CLUSTERED  ([AutoNumberID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_NextInvoiceNumberSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceBase_NextInvoiceNumberSelect]
AS
	SET NOCOUNT ON;
	
Declare @Autonumber as bigint
Select @Autonumber = (select Autonumber From AutoNumbers Where AutoNumberType = 'Invoice')
Set @Autonumber = @Autonumber + 1
Update AutoNumbers Set Autonumber = @Autonumber 
Where AutoNumberType = 'Invoice'
select Autonumber From AutoNumbers Where AutoNumberType = 'Invoice'



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentBase_Select]
(
	@InventoryAdjustmentID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT InventoryAdjustmentID, InventoryAdjNumber, StartDate, OwningUser, StatusReasonCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM InventoryAdjustmentBase WHERE (InventoryAdjustmentID = @InventoryAdjustmentID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[fnIsColumnPrimaryKey]'
GO

CREATE   FUNCTION dbo.fnIsColumnPrimaryKey(@sTableName varchar(128), @nColumnName varchar(128))
RETURNS bit
AS
BEGIN
	DECLARE @nTableID int,
		@nIndexID int,
		@i int
	
	SET 	@nTableID = OBJECT_ID(@sTableName)
	
	SELECT 	@nIndexID = indid
	FROM 	sysindexes
	WHERE 	id = @nTableID
	 AND 	indid BETWEEN 1 And 254 
	 AND 	(status & 2048) = 2048
	
	IF @nIndexID Is Null
		RETURN 0
	
	IF @nColumnName IN
		(SELECT sc.[name]
		FROM 	sysindexkeys sik
			INNER JOIN syscolumns sc ON sik.id = sc.id AND sik.colid = sc.colid
		WHERE 	sik.id = @nTableID
		 AND 	sik.indid = @nIndexID)
	 BEGIN
		RETURN 1
	 END
	RETURN 0
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityBase_Update]
(
	@ActivityId uniqueidentifier,
	@GroupId uniqueidentifier,
	@AllDayEvent bit,
	@PercentComplete int,
	@ActivityTypeCode int,
	@DeletionStateCode int,
	@DirectionCode int,
	@ScheduledDuration int,
	@PriorityCode int,
	@CreatedBy uniqueidentifier,
	@ScheduledStartDate datetime,
	@ScheduledEndDate datetime,
	@ModifiedBy uniqueidentifier,
	@Message ntext,
	@Subject nvarchar(200),
	@CreatedOn datetime,
	@ModifiedOn datetime,
	@OwningUser uniqueidentifier,
	@Location nvarchar(200),
	@QuoteOrOrderNumber nvarchar(100),
	@StatusCode int,
	@SenderId uniqueidentifier,
	@SenderTypeCode int,
	@RecipientId uniqueidentifier,
	@RecipientTypeCode int,
	@RegardingId uniqueidentifier,
	@RegardingTypeCode int,
	@PhoneNumber nvarchar(50),
	@PhoneNumberExt nvarchar(20),
	@DurationFormatCode int,
	@Original_ActivityId uniqueidentifier,
	@Original_ActivityTypeCode int,
	@Original_AllDayEvent bit,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_DirectionCode int,
	@Original_DurationFormatCode int,
	@Original_Location nvarchar(200),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_OwningUser uniqueidentifier,
	@Original_GroupId uniqueidentifier,
	@Original_PercentComplete int,
	@Original_PhoneNumber nvarchar(50),
	@Original_PhoneNumberExt nvarchar(20),
	@Original_PriorityCode int,
	@Original_QuoteOrOrderNumber nvarchar(100),
	@Original_RecipientId uniqueidentifier,
	@Original_RecipientTypeCode int,
	@Original_RegardingId uniqueidentifier,
	@Original_RegardingTypeCode int,
	@Original_ScheduledDuration int,
	@Original_ScheduledEndDate datetime,
	@Original_ScheduledStartDate datetime,
	@Original_SenderId uniqueidentifier,
	@Original_SenderTypeCode int,
	@Original_StatusCode int,
	@Original_Subject nvarchar(200)
)
AS
	SET NOCOUNT OFF;
UPDATE ActivityBase SET ActivityId = @ActivityId, GroupId = @GroupId, AllDayEvent = @AllDayEvent, PercentComplete = @PercentComplete, ActivityTypeCode = @ActivityTypeCode, DeletionStateCode = @DeletionStateCode, DirectionCode = @DirectionCode, ScheduledDuration = @ScheduledDuration, PriorityCode = @PriorityCode, CreatedBy = @CreatedBy, ScheduledStartDate = @ScheduledStartDate, ScheduledEndDate = @ScheduledEndDate, ModifiedBy = @ModifiedBy, Message = @Message, Subject = @Subject, CreatedOn = @CreatedOn, ModifiedOn = @ModifiedOn, OwningUser = @OwningUser, Location = @Location, QuoteOrOrderNumber = @QuoteOrOrderNumber, StatusCode = @StatusCode, SenderId = @SenderId, SenderTypeCode = @SenderTypeCode, RecipientId = @RecipientId, RecipientTypeCode = @RecipientTypeCode, RegardingId = @RegardingId, RegardingTypeCode = @RegardingTypeCode, PhoneNumber = @PhoneNumber, PhoneNumberExt = @PhoneNumberExt, DurationFormatCode = @DurationFormatCode WHERE (ActivityId = @Original_ActivityId);
	SELECT ActivityId, GroupId, AllDayEvent, PercentComplete, ActivityTypeCode, DeletionStateCode, DirectionCode, ScheduledDuration, PriorityCode, CreatedBy, ScheduledStartDate, ScheduledEndDate, ModifiedBy, Message, Subject, CreatedOn, ModifiedOn, OwningUser, Location, QuoteOrOrderNumber, StatusCode, SenderId, SenderTypeCode, RecipientId, RecipientTypeCode, RegardingId, RegardingTypeCode, PhoneNumber, PhoneNumberExt, DurationFormatCode FROM ActivityBase WHERE (ActivityId = @ActivityId)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_PurchaseOrderDetailBase_DeleteFromGrid]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_PurchaseOrderDetailBase_DeleteFromGrid]
	(
	@Original_PurchaseOrderDetailID uniqueidentifier
)
AS
BEGIN
	
	SET NOCOUNT ON;
DELETE FROM PurchaseOrderDetailBase WHERE PurchaseOrderDetailID = @Original_PurchaseOrderDetailID
   
END




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_AutoNumbers_GetNext]'
GO

CREATE PROCEDURE [dbo].[FRP_AutoNumbers_GetNext]
(
	@Type as nvarchar(50)
)
AS
Declare @Autonumber as bigint
Select @Autonumber = (select Autonumber From AutoNumbers Where AutoNumberType = @Type)
Update AutoNumbers Set Autonumber = (@Autonumber + 1), ModifiedOn = GETDATE()
Where AutoNumberType = @Type
Select @Autonumber




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserSettingsBase_Update]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_SystemUserSettingsBase_Update] 
	(
	@SystemUserID uniqueidentifier, 
	@SettingKey varchar(50),
	@SettingValue varchar(MAX)
)
AS
BEGIN
	
	SET NOCOUNT ON;

 -- Insert statements for procedure here
IF (SELECT Count(SettingKey) FROM SystemUserSettingsBase WHERE SystemUserID = @SystemUserID AND SettingKey = @SettingKey) > 0
		BEGIN
			UPDATE SystemUserSettingsBase SET SettingValue = @SettingValue WHERE SystemUserID = @SystemUserID AND SettingKey = @SettingKey
		END
	ELSE
		BEGIN
			INSERT INTO SystemUserSettingsBase(SystemUserID, SettingKey, SettingValue) VALUES(@SystemUserID, @SettingKey, @SettingValue)
		END
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentBase_Update]
(
	@InventoryAdjustmentID uniqueidentifier,
	@InventoryAdjNumber nvarchar(50),
	@StartDate datetime,
	@OwningUser uniqueidentifier,
	@StatusReasonCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_InventoryAdjustmentID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_InventoryAdjNumber nvarchar(50),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_OwningUser uniqueidentifier,
	@Original_StartDate datetime,
	@Original_StatusReasonCode int
)
AS
	SET NOCOUNT OFF;
UPDATE InventoryAdjustmentBase SET InventoryAdjustmentID = @InventoryAdjustmentID, InventoryAdjNumber = @InventoryAdjNumber, StartDate = @StartDate, OwningUser = @OwningUser, StatusReasonCode = @StatusReasonCode, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (InventoryAdjustmentID = @Original_InventoryAdjustmentID);
	SELECT InventoryAdjustmentID, InventoryAdjNumber, StartDate, OwningUser, StatusReasonCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM InventoryAdjustmentBase WHERE (InventoryAdjustmentID = @InventoryAdjustmentID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_PaperworkWizDelByOwningUserID]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityBase_PaperworkWizDelByOwningUserID]  
	(
@OwningUserID uniqueidentifier,
@UseDates bit,
@StartDate datetime,
@EndDate datetime
)
AS
BEGIN
	SET NOCOUNT ON;

IF @UseDates = 0
BEGIN	
  SELECT *
FROM ActivityBase 
WHERE ActivityBase.OwningUser = @OwningUserID AND ActivityBase.ActivityTypeCode = 2 AND ActivityBase.StatusCode = 0
END

ELSE IF @UseDates = 1
BEGIN
	SELECT *
	FROM ActivityBase
	WHERE ActivityBase.OwningUser = @OwningUserID AND ActivityBase.ActivityTypeCode = 2 AND ActivityBase.StatusCode = 0 AND ActivityBase.ScheduledStartDate  >= @StartDate AND ActivityBase.ScheduledEndDate <= @EndDate
END
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentDetailBase_DeleteFromGrid]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentDetailBase_DeleteFromGrid]
(
	@Original_InventoryAdjustmentDetailID uniqueidentifier
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;

    DELETE FROM InventoryAdjustmentDetailBase WHERE (InventoryAdjustmentDetailID = @Original_InventoryAdjustmentDetailID)
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityBase_Delete]
(
	@Original_ActivityId uniqueidentifier,
	@Original_ActivityTypeCode int,
	@Original_AllDayEvent bit,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_DirectionCode int,
	@Original_DurationFormatCode int,
	@Original_Location nvarchar(200),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_OwningUser uniqueidentifier,
	@Original_GroupId uniqueidentifier,
	@Original_PercentComplete int,
	@Original_PhoneNumber nvarchar(50),
	@Original_PhoneNumberExt nvarchar(20),
	@Original_PriorityCode int,
	@Original_QuoteOrOrderNumber nvarchar(100),
	@Original_RecipientId uniqueidentifier,
	@Original_RecipientTypeCode int,
	@Original_RegardingId uniqueidentifier,
	@Original_RegardingTypeCode int,
	@Original_ScheduledDuration int,
	@Original_ScheduledEndDate datetime,
	@Original_ScheduledStartDate datetime,
	@Original_SenderId uniqueidentifier,
	@Original_SenderTypeCode int,
	@Original_StatusCode int,
	@Original_Subject nvarchar(200)
)
AS
SET NOCOUNT OFF;
DELETE FROM ActivityBase WHERE (ActivityId = @Original_ActivityId)




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_WarehouseBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_WarehouseBase_Delete]
(
	@Original_WarehouseID uniqueidentifier,
	@Original_BusinessPhone nvarchar(50),
	@Original_City nvarchar(50),
	@Original_PrimaryContact nvarchar(200),
	@Original_State nvarchar(50),
	@Original_Street1 nvarchar(50),
	@Original_Street2 nvarchar(50),
	@Original_WarehouseIDName nvarchar(50),
	@Original_ZipCode nvarchar(20)
)
AS
	SET NOCOUNT OFF;
DELETE FROM WarehouseBase WHERE (WarehouseID = @Original_WarehouseID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_WarehouseBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_WarehouseBase_Insert]
(
	@WarehouseID uniqueidentifier,
	@WarehouseIDName nvarchar(50),
	@PrimaryContact nvarchar(200),
	@Description ntext,
	@ZipCode nvarchar(20),
	@City nvarchar(50),
	@Street1 nvarchar(50),
	@Street2 nvarchar(50),
	@BusinessPhone nvarchar(50),
	@State nvarchar(50)
)
AS
	SET NOCOUNT OFF;
INSERT INTO WarehouseBase(WarehouseID, WarehouseIDName, PrimaryContact, Description, ZipCode, City, Street1, Street2, BusinessPhone, State) VALUES (@WarehouseID, @WarehouseIDName, @PrimaryContact, @Description, @ZipCode, @City, @Street1, @Street2, @BusinessPhone, @State);
	SELECT WarehouseID, WarehouseIDName, PrimaryContact, Description, ZipCode, City, Street1, Street2, BusinessPhone, State FROM WarehouseBase WHERE (WarehouseID = @WarehouseID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_VendorBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_VendorBase_Select]
AS
	SET NOCOUNT ON;
SELECT VendorID, Name, Description, Email, WebSiteURL1, WebSiteURL2, WebSiteURL3, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM VendorBase


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentDetailBase_GridSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentDetailBase_GridSelect]
(
	@InventoryAdjustmentID uniqueidentifier
)
AS
	SET NOCOUNT ON;	
	
SELECT InventoryAdjustmentDetailID, InventoryAdjustmentID, ProductID, ProductNumber AS [Product Number], ProductDescription AS [Product Description], CountedQuantity AS [Actual Quantity], OriginalQuantity AS [Original Quantity], nullif(CountedQuantity - OriginalQuantity,0) as [Difference], CreatedOn, CreatedBy, ModifiedOn, ModifiedBy 
FROM InventoryAdjustmentDetailBase WHERE (InventoryAdjustmentID = @InventoryAdjustmentID)
ORDER BY ProductNumber


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentDetailBase_GridUpdate]'
GO

CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentDetailBase_GridUpdate]
(
	@InventoryAdjustmentDetailID uniqueidentifier,
	@InventoryAdjustmentID uniqueidentifier,
	@ProductID uniqueidentifier,
	@ProductNumber nvarchar(50),
	@ProductDescription ntext,
	@CountedQuantity int,
	@OriginalQuantity int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_InventoryAdjustmentDetailID uniqueidentifier,
	@Original_InventoryAdjustmentID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Original_Quantity int,
	@Original_ProductID uniqueidentifier,
	@Original_Product_Number nvarchar(50),
	@Original_Actual_Quantity int
)
AS
	SET NOCOUNT OFF;
UPDATE InventoryAdjustmentDetailBase SET InventoryAdjustmentDetailID = @InventoryAdjustmentDetailID, InventoryAdjustmentID = @InventoryAdjustmentID, ProductID = @ProductID, ProductNumber = @ProductNumber, ProductDescription = @ProductDescription, CountedQuantity = @CountedQuantity, OriginalQuantity = @OriginalQuantity, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (InventoryAdjustmentDetailID = @Original_InventoryAdjustmentDetailID)
	SELECT InventoryAdjustmentDetailID, InventoryAdjustmentID, ProductID, ProductNumber AS [Product Number], ProductDescription AS [Product Description], CountedQuantity AS [Actual Quantity], OriginalQuantity AS [Original Quantity],  nullif(CountedQuantity - OriginalQuantity,0) as [Difference], CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM InventoryAdjustmentDetailBase WHERE (InventoryAdjustmentDetailID = @InventoryAdjustmentDetailID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentBase_SelectByInventoryAdjID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentBase_SelectByInventoryAdjID]
	(
	@InventoryAdjustmentId uniqueidentifier
)
AS
BEGIN
	
	SET NOCOUNT ON;

   SELECT *
FROM InventoryAdjustmentBase WHERE (InventoryAdjustmentId = @InventoryAdjustmentId)
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[fnCleanDefaultValue]'
GO

CREATE FUNCTION dbo.fnCleanDefaultValue(@sDefaultValue varchar(4000))
RETURNS varchar(4000)
AS
BEGIN
	RETURN SubString(@sDefaultValue, 2, DataLength(@sDefaultValue)-2)
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_PurchaseOrderBase_SelectByPurchaseOrderID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_PurchaseOrderBase_SelectByPurchaseOrderID]
	(
	@PurchaseOrderID uniqueidentifier
)
AS
BEGIN

	SET NOCOUNT ON;

   	SELECT *
FROM PurchaseOrderBase WHERE (PurchaseOrderId = @PurchaseOrderId)
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentDetailBase_SelectByInvAdjID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[FRP_InventoryAdjustmentDetailBase_SelectByInvAdjID]
	(
	@InventoryAdjustmentID uniqueidentifier
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT *
FROM InventoryAdjustmentDetailBase WHERE (InventoryAdjustmentID = @InventoryAdjustmentID)
ORDER BY ProductNumber
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SystemRolesBase]'
GO
CREATE TABLE [dbo].[SystemRolesBase]
(
[SystemRoleID] [uniqueidentifier] NOT NULL,
[RoleName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_SystemRolesBase] on [dbo].[SystemRolesBase]'
GO
ALTER TABLE [dbo].[SystemRolesBase] ADD CONSTRAINT [PK_SystemRolesBase] PRIMARY KEY CLUSTERED  ([SystemRoleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemRolesBase_GetAllRoles]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_SystemRolesBase_GetAllRoles]
	
AS
BEGIN
	SET NOCOUNT ON;

    SELECT RoleName, SystemRoleID
FROM SystemRolesBase

RETURN

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_FADeliveriesByInvoiceID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_FADeliveriesByInvoiceID] 
		(
	@InvoiceID uniqueidentifier
)
AS
BEGIN
SET NOCOUNT ON;
	SELECT ActivityBase.Activityid, ActivityBase.Subject, ActivityBase.ScheduledStartDate,  ActivityBase.AddressName, ActivityBase.Street1, ActivityBase.Street2, ActivityBase.City, ActivityBase.State, ActivityBase.ZipCode, ActivityBase.PrimaryDelivery
	FROM ActivityBase  
WHERE ActivityBase.DocID = @InvoiceID AND ActivityBase.ActivityTypeCode =2
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_CancelRelatedDeliveries]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_CancelRelatedDeliveries]  
	(
	@InvoiceID uniqueidentifier,
	@ActivityID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;
UPDATE ActivityBase SET StatusCode = 2 WHERE ActivityBase.DocID = @InvoiceID AND ActivityBase.ActivityTypeCode = 2 AND ActivityBase.ActivityID <> @ActivityID AND ActivityBase.StatusCode =0
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityBase_Select]
(
	@ActivityID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT * FROM ActivityBase WHERE (ActivityId = @ActivityID)





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_WarehouseBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_WarehouseBase_Select]
AS
	SET NOCOUNT ON;
SELECT WarehouseID, WarehouseIDName, PrimaryContact, Description, ZipCode, City, Street1, Street2, BusinessPhone, State FROM WarehouseBase


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_DeleteFromTable]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityBase_DeleteFromTable]
	(
	@Original_ActivityId uniqueidentifier
)
AS
BEGIN
	
	SET NOCOUNT ON;
DELETE FROM ActivityBase WHERE (ActivityId = @Original_ActivityId)
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_CalendarActivitySelect]'
GO
CREATE PROCEDURE [dbo].[FRP_ActivityBase_CalendarActivitySelect]
(
	@SUMOFACTIVITYVALUES as int
)
AS
	SET NOCOUNT ON;
Select * FROM ActivityBase
WHERE (@SUMOFACTIVITYVALUES & ActivityTypeCode) >0 AND StatusCode = 0




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_GetPrimaryDeliveryDate]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_FundraiserBase_GetPrimaryDeliveryDate] 
	(
	@DeliveryID uniqueidentifier
)
AS
BEGIN
	
	SET NOCOUNT ON;
   SELECT	ActivityID,
	ScheduledStartDate as [DeliveryDate]
FROM ActivityBase
WHERE ActivityID = @DeliveryID

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_FADeliveriesByGroupID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_FADeliveriesByGroupID] 
	(
	@GroupID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;
SELECT ActivityBase.Activityid, ActivityBase.Subject, ActivityBase.ScheduledStartDate,  ActivityBase.AddressName, ActivityBase.Street1, ActivityBase.Street2, ActivityBase.City, ActivityBase.State, ActivityBase.ZipCode, ActivityBase.PrimaryDelivery
FROM ActivityBase 
WHERE ActivityBase.GroupID = @GroupID AND ActivityBase.ActivityTypeCode = 2
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentBase_Delete]
(
	@Original_InventoryAdjustmentID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_InventoryAdjNumber nvarchar(50),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_OwningUser uniqueidentifier,
	@Original_StartDate datetime,
	@Original_StatusReasonCode int
)
AS
	SET NOCOUNT OFF;
DELETE FROM InventoryAdjustmentBase WHERE (InventoryAdjustmentID = @Original_InventoryAdjustmentID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_SelectByActivityID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_SelectByActivityID]
	(
@ActivityID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * 
	FROM ActivityBase 
	WHERE ActivityID = @ActivityID
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_FADeliveriesByFundraiserID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_FADeliveriesByFundraiserID] 
	(
	@FundraiserID uniqueidentifier
)
AS
BEGIN
	SELECT ActivityBase.Activityid, ActivityBase.Subject, ActivityBase.ScheduledStartDate,  ActivityBase.AddressName, ActivityBase.Street1, ActivityBase.Street2, ActivityBase.City, ActivityBase.State, ActivityBase.ZipCode, ActivityBase.PrimaryDelivery
FROM ActivityBase 
WHERE ActivityBase.FundraiserID = @FundraiserID AND ActivityBase.ActivityTypeCode =2
END




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_CheckForMultiplePrimaryDeliveries]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_CheckForMultiplePrimaryDeliveries] 
(
	@FundraiserID uniqueidentifier,
	@ActivityID uniqueidentifier
)
AS
BEGIN
		SET NOCOUNT ON;

   	SELECT * FROM ActivityBase
WHERE ActivityBase.FundraiserID = @FundraiserID AND ActivityBase.ActivityTypeCode = 2 AND ActivityBase.PrimaryDelivery = 'True' AND ActivityBase.ActivityID <> @ActivityID AND ActivityBase.StatusCode = 0
END




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ExceptionLog_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_ExceptionLog_Insert]
(
	@ErrorItemID uniqueidentifier,
	@ErrorDate datetime,
	@SessionInfo nvarchar(70),
	@Additionalnfo text,
	@ErrorInfo text,
	@StackTraceInfo text,
	@ErrorCode int
)
AS
	SET NOCOUNT OFF;
INSERT INTO ExceptionLog(ErrorDate, ErrorItemID, SessionInfo, Additionalnfo, ErrorInfo, StackTraceInfo, ErrorCode) VALUES (getdate(), @ErrorItemID, @SessionInfo, @Additionalnfo, @ErrorInfo, @StackTraceInfo, @ErrorCode);
	SELECT ErrorDate, ErrorItemID, SessionInfo, Additionalnfo, ErrorInfo, StackTraceInfo, ErrorCode FROM ExceptionLog WHERE (ErrorItemID = @ErrorItemID)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityBase_Insert]
(
	@ActivityId uniqueidentifier,
	@GroupId uniqueidentifier,
	@AllDayEvent bit,
	@PercentComplete int,
	@ActivityTypeCode int,
	@DeletionStateCode int,
	@DirectionCode int,
	@ScheduledDuration int,
	@PriorityCode int,
	@CreatedBy uniqueidentifier,
	@ScheduledStartDate datetime,
	@ScheduledEndDate datetime,
	@ModifiedBy uniqueidentifier,
	@Message ntext,
	@Subject nvarchar(200),
	@CreatedOn datetime,
	@ModifiedOn datetime,
	@OwningUser uniqueidentifier,
	@Location nvarchar(200),
	@QuoteOrOrderNumber nvarchar(100),
	@StatusCode int,
	@SenderId uniqueidentifier,
	@SenderTypeCode int,
	@RecipientId uniqueidentifier,
	@RecipientTypeCode int,
	@RegardingId uniqueidentifier,
	@RegardingTypeCode int,
	@PhoneNumber nvarchar(50),
	@PhoneNumberExt nvarchar(20),
	@DurationFormatCode int
)
AS
	SET NOCOUNT OFF;
INSERT INTO ActivityBase(ActivityId, GroupId, AllDayEvent, PercentComplete, ActivityTypeCode, DeletionStateCode, DirectionCode, ScheduledDuration, PriorityCode, CreatedBy, ScheduledStartDate, ScheduledEndDate, ModifiedBy, Message, Subject, CreatedOn, ModifiedOn, OwningUser, Location, QuoteOrOrderNumber, StatusCode, SenderId, SenderTypeCode, RecipientId, RecipientTypeCode, RegardingId, RegardingTypeCode, PhoneNumber, PhoneNumberExt, DurationFormatCode) VALUES (@ActivityId, @GroupId, @AllDayEvent, @PercentComplete, @ActivityTypeCode, @DeletionStateCode, @DirectionCode, @ScheduledDuration, @PriorityCode, @CreatedBy, @ScheduledStartDate, @ScheduledEndDate, @ModifiedBy, @Message, @Subject, @CreatedOn, @ModifiedOn, @OwningUser, @Location, @QuoteOrOrderNumber, @StatusCode, @SenderId, @SenderTypeCode, @RecipientId, @RecipientTypeCode, @RegardingId, @RegardingTypeCode, @PhoneNumber, @PhoneNumberExt, @DurationFormatCode);
	SELECT ActivityId, GroupId, AllDayEvent, PercentComplete, ActivityTypeCode, DeletionStateCode, DirectionCode, ScheduledDuration, PriorityCode, CreatedBy, ScheduledStartDate, ScheduledEndDate, ModifiedBy, Message, Subject, CreatedOn, ModifiedOn, OwningUser, Location, QuoteOrOrderNumber, StatusCode, SenderId, SenderTypeCode, RecipientId, RecipientTypeCode, RegardingId, RegardingTypeCode, PhoneNumber, PhoneNumberExt, DurationFormatCode FROM ActivityBase WHERE (ActivityId = @ActivityId)




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SystemUserBase]'
GO
CREATE TABLE [dbo].[SystemUserBase]
(
[SystemUserId] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_SystemUserBase_SystemUserId] DEFAULT (newid()),
[DeletionStateCode] [int] NULL,
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityCode] [int] NULL,
[CompanyID] [uniqueidentifier] NULL,
[Salutation] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullName] [nvarchar] (160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayName] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NickName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobTitle] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredEmailCode] [int] NULL,
[BusinessPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessPhoneExt] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhoneExt] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredPhoneCode] [int] NULL,
[PreferredAddressCode] [int] NULL,
[EmployeeId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryRepresentativeCode] [bit] NULL,
[SalesRepresentativeCode] [bit] NULL,
[Street1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherStreet2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherState] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherZipCode] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[Visible] [bit] NULL CONSTRAINT [DF_SystemUserBase_Visible] DEFAULT ((1)),
[Color] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SystemRoleID] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_SystemUserBase] on [dbo].[SystemUserBase]'
GO
ALTER TABLE [dbo].[SystemUserBase] ADD CONSTRAINT [PK_SystemUserBase] PRIMARY KEY CLUSTERED  ([SystemUserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_SelectByUserID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_SystemUserBase_SelectByUserID]
	(
	@UserID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;
SELECT *
FROM SystemUserBase 
WHERE SystemUserBase.SystemUserID = @UserID
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CustomerAddressBase]'
GO
CREATE TABLE [dbo].[CustomerAddressBase]
(
[AddressID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_CustomerAddressBase_AddressID] DEFAULT (newid()),
[AddressTypeCode] [int] NOT NULL,
[ParentID] [uniqueidentifier] NULL,
[AddressName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PrimaryContactName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street3] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FreightTermsCode] [int] NULL,
[Latitude] [float] NULL,
[Longitude] [float] NULL,
[ShippingMethod] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MainPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MainPhoneExt] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhoneExt] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressCode] [int] NULL,
[DeletionStateCode] [int] NULL,
[Notes] [ntext] COLLATE Latin1_General_CI_AS NULL,
[MapLink] [ntext] COLLATE Latin1_General_CI_AS NULL,
[MapGridID] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ContactAddressBase] on [dbo].[CustomerAddressBase]'
GO
ALTER TABLE [dbo].[CustomerAddressBase] ADD CONSTRAINT [PK_ContactAddressBase] PRIMARY KEY CLUSTERED  ([AddressID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ProductBase]'
GO
CREATE TABLE [dbo].[ProductBase]
(
[ProductId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProductBase_ProductId] DEFAULT (newid()),
[ProductNumber] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductTypeCode] [int] NULL,
[DefaultUoMScheduleID] [uniqueidentifier] NULL,
[ProductClassID] [uniqueidentifier] NULL,
[DefaultUoMId] [uniqueidentifier] NULL,
[RetailPrice] [money] NULL,
[GroupRetailPrice] [money] NULL,
[ConsumerRetailPrice] [money] NULL,
[DealerPrice] [money] NULL,
[QuantityOnHand] [decimal] (18, 0) NULL,
[QuantityAllocated] [decimal] (18, 0) NULL,
[DeletionStateCode] [int] NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[StatusCode] [int] NULL,
[ProductSalesPercentage] [decimal] (18, 5) NULL,
[FlierOrder] [int] NULL,
[ReorderPoint] [decimal] (18, 0) NULL,
[MinimumQty] [decimal] (18, 0) NULL,
[QuantityOrdered] [decimal] (18, 0) NULL,
[ReorderPointDate] [datetime] NULL,
[MinimumQtyDate] [datetime] NULL,
[QuantityPOPending] [decimal] (18, 0) NULL,
[QuantityFundForecasted] [decimal] (18, 0) NULL,
[QuantitySold] [decimal] (18, 0) NULL,
[QtyLeftToBuy] [decimal] (18, 0) NULL,
[Carried] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ProductBase] on [dbo].[ProductBase]'
GO
ALTER TABLE [dbo].[ProductBase] ADD CONSTRAINT [PK_ProductBase] PRIMARY KEY CLUSTERED  ([ProductId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ContactBase]'
GO
CREATE TABLE [dbo].[ContactBase]
(
[ContactId] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_ContactBase_ContactId] DEFAULT (newid()),
[ParentGroupID] [uniqueidentifier] NULL,
[Anniversary] [datetime] NULL,
[AssistantName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssistantPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssistantPhoneExt] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BestTimeToCall] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BirthDate] [datetime] NULL,
[BusinessPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessPhoneExt] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRole] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditOnHold] [bit] NULL,
[DeletionStateCode] [int] NOT NULL,
[Department] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DescriptionInfo] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotBulkEMail] [bit] NULL,
[DoNotBulkPostalMail] [bit] NULL,
[DoNotEMail] [bit] NULL,
[DoNotFax] [bit] NULL,
[DoNotPhone] [bit] NULL,
[DoNotPostalMail] [bit] NULL,
[EMailAddress1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMailAddress2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMailAddress3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FamilyStatusCode] [int] NULL,
[Fax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FreightTermsCode] [int] NULL,
[FullName] [nvarchar] (160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GenderCode] [int] NULL,
[HasChildrenCode] [int] NULL,
[HomePhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobTitle] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ManagerName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ManagerPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ManagerPhoneExt] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaritalStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NickName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfChildren] [int] NULL,
[OtherPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhoneExt] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwningUser] [uniqueidentifier] NULL,
[PaymentTerms] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredContactMethodCode] [int] NULL,
[PreferredPhoneCode] [int] NULL,
[PreferredPhoneNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredPhoneExt] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salutation] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingMethod] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpousesName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusCode] [int] NULL,
[Suffix] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WebSiteUrl] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ContactBase] on [dbo].[ContactBase]'
GO
ALTER TABLE [dbo].[ContactBase] ADD CONSTRAINT [PK_ContactBase] PRIMARY KEY CLUSTERED  ([ContactId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FundraiserBase]'
GO
CREATE TABLE [dbo].[FundraiserBase]
(
[FundraiserID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_OpportunityBase_OpportunityID] DEFAULT (newid()),
[GroupId] [uniqueidentifier] NULL,
[PrimaryContactID] [uniqueidentifier] NULL,
[GroupTypeCode] [int] NULL,
[FundraiserRatingCode] [int] NULL,
[PriorityCode] [int] NULL,
[Topic] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesStageCode] [int] NULL,
[StatusCode] [int] NULL,
[GroupSize] [int] NULL,
[GroupType] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupGoal] [money] NULL,
[FundsFor] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartOn] [datetime] NULL,
[CallinOrderBy] [datetime] NULL,
[ReturnOrderBy] [datetime] NULL,
[StatusReasonCode] [int] NULL,
[FollowUpCode] [int] NULL,
[MakeChecksTo] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GoalInformation] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletionStatusCode] [int] NOT NULL,
[OwningUser] [uniqueidentifier] NULL,
[SalesPersonID] [uniqueidentifier] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[DeliveryMinimum] [int] NULL,
[DeliveryPersonID] [uniqueidentifier] NULL,
[PendingStatusCode] [int] NULL,
[InvoiceCount] [int] NULL,
[DeliveryID] [uniqueidentifier] NULL,
[BookedOn] [datetime] NULL,
[PaidOn] [datetime] NULL,
[OrderedOn] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_FundraisingBase] on [dbo].[FundraiserBase]'
GO
ALTER TABLE [dbo].[FundraiserBase] ADD CONSTRAINT [PK_FundraisingBase] PRIMARY KEY CLUSTERED  ([FundraiserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQuantityPOOrdered]'
GO

CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdateQuantityPOOrdered]
(
@UseDates bit,
@StartDate datetime,
@EndDate datetime
)
AS
SET NOCOUNT ON;
Declare @ProductID uniqueidentifier
Declare @QuantityOrdered integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
	
IF @UseDates = 0
BEGIN
	Set @QuantityOrdered = (Select SUM(podb.QuantityOrdered) as TotalQuantity 
						FROM PurchaseOrderBase po Left Outer Join PurchaseOrderDetailBase podb  On po.PurchaseOrderID= podb.PurchaseOrderID
						WHERE podb.ProductID = @ProductID AND po.Stage = 1 And po.Status = 0 AND po.DeletionStateCode <> 1) 
Update ProductBase Set QuantityOrdered = isNull(@QuantityOrdered,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END
ELSE IF @UseDates = 1
BEGIN
	Set @QuantityOrdered = (Select SUM(podb.QuantityOrdered) as TotalQuantity 
						FROM PurchaseOrderBase po Left Outer Join PurchaseOrderDetailBase podb  On po.PurchaseOrderID= podb.PurchaseOrderID
						WHERE podb.ProductID = @ProductID AND po.ReceivedOn >= @StartDate AND po.ReceivedOn <= @EndDate AND po.Stage = 1 And po.Status = 0 AND po.DeletionStateCode <> 1) 
Update ProductBase Set QuantityOrdered = isNull(@QuantityOrdered,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END
END
CLOSE Product_Cursor 
DEALLOCATE Product_Cursor 













GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PaymentTermsBase]'
GO
CREATE TABLE [dbo].[PaymentTermsBase]
(
[PaymentTermsID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_PaymentTermsBase_PaymentTermsID] DEFAULT (newid()),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeletionStateCode] [int] NOT NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[DefaultItem] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PaymentTermsBase] on [dbo].[PaymentTermsBase]'
GO
ALTER TABLE [dbo].[PaymentTermsBase] ADD CONSTRAINT [PK_PaymentTermsBase] PRIMARY KEY CLUSTERED  ([PaymentTermsID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_PaymentTermsBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_PaymentTermsBase_Delete]
(
	@Original_PaymentTermsID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(200)
)
AS
	SET NOCOUNT OFF;
DELETE FROM PaymentTermsBase WHERE (PaymentTermsID = @Original_PaymentTermsID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[GroupBase]'
GO
CREATE TABLE [dbo].[GroupBase]
(
[GroupCategoryCode] [int] NULL,
[GroupId] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_AccountBase_AccountId] DEFAULT (newid()),
[GroupName] [nvarchar] (160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupNumber] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QBCustomerID] [nchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CreditOnHold] [bit] NULL,
[DeletionStateCode] [int] NULL,
[DescriptionInfo] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotBulkEMail] [bit] NULL,
[DoNotBulkPostalMail] [bit] NULL,
[DoNotEMail] [bit] NULL,
[DoNotFax] [bit] NULL,
[DoNotPhone] [bit] NULL,
[DoNotPostalMail] [bit] NULL,
[EMailAddress1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FreightTermsCode] [int] NULL,
[GroupSize] [int] NULL,
[GroupType] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MainPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MainPhoneExt] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhoneExt] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwningUser] [uniqueidentifier] NULL CONSTRAINT [DF_GroupBase_OwningUser] DEFAULT (newid()),
[PaymentTerms] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredContactMethodCode] [int] NULL,
[PreferredPhoneCode] [int] NULL,
[PrimaryContactId] [uniqueidentifier] NULL,
[ShippingMethod] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusCode] [int] NULL,
[WebSiteURL] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [uniqueidentifier] NULL,
[CreatedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_GroupBase] on [dbo].[GroupBase]'
GO
ALTER TABLE [dbo].[GroupBase] ADD CONSTRAINT [PK_GroupBase] PRIMARY KEY CLUSTERED  ([GroupId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_GridSelect]'
GO

/*
UserId is owning user, if null then ignores
If StatusCode is 0 then all records are returned
SearchText will find firstnames and lastnames beginning with that text
*/
CREATE PROCEDURE [dbo].[FRP_ContactBase_GridSelect]
(
	@UserId as uniqueidentifier,
	@SearchText as nvarchar(50),
	@StatusCode as int
)
AS
	SET NOCOUNT ON;
Declare @StatusCodeEnd as int
if @StatusCode = 0
	set @StatusCodeEnd = 4
else
if @StatusCode = 1
	Begin
		set @StatusCode = 0
		set @StatusCodeEnd = 0
	End
else
if @StatusCode = 2
	Begin
		set @StatusCode = 1
		set @StatusCodeEnd = 1
	End
else
	set @StatusCodeEnd = @StatusCode
if @SearchText = '' 
Begin
	SELECT ContactID,
		c.FullName as [Name],
		a.groupName as [Parent group],
		c.BusinessPhone as [Business Phone],
		c.BusinessPhoneExt as [Ext],
		u.FullName as [Owning User],
		c.FirstName,
		c.LastName,
		c.StatusCode,
		c.CreatedOn,
		c.ModifiedOn
	FROM ContactBase c 
		Left Outer Join groupBase a 	On c.ParentgroupID = a.groupId
		Left Outer Join SystemUserBase u 	On c.OwningUser = u.SystemUserId
	Where (@UserId is NOT NULL AND c.OwningUser = @UserId AND (c.StatusCode >= @StatusCode And c.StatusCode <= @StatusCodeEnd))
		OR (@UserId is NULL AND (c.StatusCode >= @StatusCode And c.StatusCode <= @StatusCodeEnd))
	ORDER BY c.LastName, c.FirstName
end
else
begin
	set @SearchText = '%' + @SearchText + '%'
	SELECT ContactID,
		c.FullName as [Name],
		a.groupName as [Parent group],
		c.BusinessPhone as [Business Phone],
		c.BusinessPhoneExt as [Ext],
		u.FullName as [Owning User],
		c.FirstName,
		c.LastName,
		c.StatusCode,
		c.CreatedOn,
		c.ModifiedOn
	FROM ContactBase c 
		Left Outer Join groupBase a 	On c.ParentgroupID = a.groupId
		Left Outer Join SystemUserBase u 	On c.OwningUser = u.SystemUserId
	Where (@UserId is NOT NULL AND c.OwningUser = @UserId AND (c.StatusCode >= @StatusCode And c.StatusCode <= @StatusCodeEnd) AND ((c.LastName Like @SearchText) OR (c.FirstName Like @SearchText)))
		OR (@UserId is NULL AND (c.StatusCode >= @StatusCode And c.StatusCode <= @StatusCodeEnd) AND ((c.LastName Like @SearchText) OR (c.FirstName Like @SearchText)))
	ORDER BY c.LastName, c.FirstName
end


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[InvoiceDetailBase]'
GO
CREATE TABLE [dbo].[InvoiceDetailBase]
(
[InvoiceDetailID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_InvoiceDetailBase_InvoiceDetailID] DEFAULT (newid()),
[InvoiceID] [uniqueidentifier] NOT NULL,
[QBInvLineID] [nchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DeletionStateCode] [int] NOT NULL,
[SalesRepID] [uniqueidentifier] NULL,
[DeliveryRepID] [uniqueidentifier] NULL,
[LineItemNumber] [int] NULL,
[UofMID] [uniqueidentifier] NULL,
[ProductID] [uniqueidentifier] NOT NULL,
[ProductNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductDescription] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [decimal] (18, 0) NOT NULL,
[PricePerUnit] [money] NOT NULL,
[PriceOverride] [bit] NULL,
[BaseAmount] [money] NULL,
[ExtendedAmount] [money] NOT NULL,
[ManualDiscountAmount] [money] NULL,
[Tax] [money] NULL,
[ProductClassID] [uniqueidentifier] NULL,
[QtyBSUofM] [decimal] (18, 0) NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_InvoiceDetailBase] on [dbo].[InvoiceDetailBase]'
GO
ALTER TABLE [dbo].[InvoiceDetailBase] ADD CONSTRAINT [PK_InvoiceDetailBase] PRIMARY KEY CLUSTERED  ([InvoiceDetailID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceDetailBase_ProductCount]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceDetailBase_ProductCount]
(
	@InvoiceID uniqueidentifier,
	@InvoiceDetailID uniqueidentifier,
	@ProductID uniqueidentifier
)
AS
	
SELECT COUNT(*) FROM InvoiceDetailBase Where InvoiceID = @InvoiceID AND ProductID = @ProductID AND InvoiceDetailID <> @InvoiceDetailID


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[GroupBaseView]'
GO
CREATE VIEW dbo.GroupBaseView
AS
SELECT     TOP (100) PERCENT a.GroupName, u.DisplayName, e.AddressName, 
                      CASE WHEN e.AddressTypeCode = 0 THEN '' WHEN e.AddressTypeCode = 1 THEN 'BillTo' WHEN e.AddressTypeCode = 2 THEN 'ShipTo' ELSE '' END AS
                       AddressType, e.Street1, e.Street2, e.City, e.State, e.ZipCode, c.FullName AS [Primary Contact], a.GroupCategoryCode, a.GroupId, 
                      a.GroupName AS Expr1, a.GroupNumber, a.CreditOnHold, a.DeletionStateCode, a.DescriptionInfo, a.DoNotBulkEMail, a.DoNotBulkPostalMail, 
                      a.DoNotEMail, a.DoNotFax, a.DoNotPhone, a.DoNotPostalMail, a.EMailAddress1, a.Fax, a.FreightTermsCode, a.GroupSize, a.GroupType, a.MainPhone, 
                      a.MainPhoneExt, a.OtherPhone, a.OtherPhoneExt, a.OwningUser, a.PaymentTerms, a.PreferredContactMethodCode, a.PreferredPhoneCode, 
                      a.PrimaryContactId, a.ShippingMethod, a.SourceCode, a.StatusCode, a.WebSiteURL, a.CreatedBy, a.CreatedOn, a.ModifiedBy, a.ModifiedOn, 
                      CASE WHEN a.StatusCode = 0 THEN 'Active' WHEN a.StatusCode = 1 THEN 'Inactive' WHEN a.StatusCode = 2 THEN 'Canceled' ELSE '' END AS GroupStatus,
                       CASE WHEN a.PreferredContactMethodCode = 1 THEN 'Email' WHEN a.PreferredContactMethodCode = 2 THEN 'Fax' WHEN a.PreferredContactMethodCode
                       = 3 THEN 'Phone' WHEN a.PreferredContactMethodCode = 4 THEN 'Mail' ELSE '' END AS PreferredContactMethod
FROM         dbo.GroupBase AS a LEFT OUTER JOIN
                      dbo.SystemUserBase AS u ON a.OwningUser = u.SystemUserId LEFT OUTER JOIN
                      dbo.CustomerAddressBase AS e ON a.GroupId = e.ParentID AND e.PrimaryAddressCode = 1 LEFT OUTER JOIN
                      dbo.ContactBase AS c ON a.PrimaryContactId = c.ContactId
WHERE     (a.DeletionStateCode <> 1)
ORDER BY a.GroupName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_GridSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_GridSelect]
(
	@UserId as uniqueidentifier,
	@SearchText as nvarchar(50),
	@StatusCode as int
)
AS
	SET NOCOUNT ON;
Declare @StatusCodeEnd as int
if @StatusCode = 0 -- ALL
	Begin
		set @StatusCode = 0 --for clarity
		set @StatusCodeEnd = 4
	End
ELSE 
IF @StatusCode = 1 --Active Opportunities
	Begin
		set @StatusCode = 0
		set @StatusCodeEnd = 2
	End
ELSE 
	set @StatusCodeEnd = @StatusCode
	
	
	--Group Name, Sales Stage, Start On, Call in, Return By, Preferred Phone, Owning User
	
if @SearchText = '' 
Begin
	SELECT	FundraiserID,
		customers.Customer as [Group Name],
		SalesStageCode as [Sales Stage],
		StartOn as [Start On],
		CallinOrderBy as [Call in],
		ReturnOrderBy as [Return By],
--		customers.[Preferred Phone],
--		customers.Ext,
		u.Fullname as [Owning User],
		StatusCode,
		o.CreatedOn
	FROM	FundraiserBase as o
		Left Outer Join SystemUserBase u	On o.OwningUser = u.SystemUserId
		Left Outer Join (select contactId as CustomerID,
							FullName as Customer
						From contactbase 
						union 
						select Groupid,
							GroupName
						From GroupBase) as customers	On o.GroupID = customers.CustomerID		

	Where (@UserId is NOT NULL AND o.OwningUser = @UserId AND (o.StatusReasonCode >= @StatusCode And o.StatusReasonCode <= @StatusCodeEnd))
		OR (@UserId is NULL AND (o.StatusReasonCode >= @StatusCode And o.StatusReasonCode <= @StatusCodeEnd))
	ORDER BY customers.Customer
END
ELSE
BEGIN
	set @SearchText = '%' + @SearchText + '%'
	SELECT	FundraiserID,
	customers.Customer as [Group Name],
		SalesStageCode as [Sales Stage],
		StartOn as [Start On],
		CallinOrderBy as [Call in],
		ReturnOrderBy as [Return By],
--		customers.[Preferred Phone],
--		customers.Ext,
		u.Fullname as [Owning User],
		StatusCode,
		o.CreatedOn
	FROM	FundraiserBase as o
		Left Outer Join SystemUserBase u	On o.OwningUser = u.SystemUserId
		Left Outer Join (select contactId as CustomerID,
					FullName as Customer,
					FirstName,
					LastName
					From contactbase 
					union 
					select Groupid,
						GroupName,
						'!',
						'!'
					From GroupBase) as customers	On o.GroupID = customers.CustomerID
	WHERE ((@UserId is NOT NULL AND o.OwningUser = @UserId) AND (o.StatusReasonCode >= @StatusCode And o.StatusReasonCode <= @StatusCodeEnd) AND ((customers.LastName Like @SearchText OR customers.FirstName Like @SearchText) OR (customers.Lastname = '!' AND customers.Customer Like @SearchText)))
			OR ((@UserId is NULL) AND (o.StatusReasonCode >= @StatusCode And o.StatusReasonCode <= @StatusCodeEnd) AND ((customers.LastName Like @SearchText OR customers.FirstName Like @SearchText) OR (customers.Lastname = '!' AND customers.Customer Like @SearchText)))
	ORDER BY customers.Customer	
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_SelectByContactID]'
GO
CREATE PROCEDURE [dbo].[FRP_ActivityBase_SelectByContactID]
(
	@ContactID uniqueidentifier
)
AS
SELECT a.*,
	Case ActivityTypeCode
		WHEN '1' Then 'Appointment'
		WHEN '2' Then 'Delivery'
		WHEN '4' Then 'Phone Call'
		WHEN '8' Then 'Print Fliers'
		WHEN '16' Then 'Scheduled Email'
		WHEN '32' Then 'Task'
		WHEN '64' Then 'Thank You'
	End As [Activity Type],
Case PrimaryDelivery
		WHEN 'True' Then 'True'
		WHEN 'False' Then 'False'
		ELSE 'False'
	End As [Primary Delivery],
	g.GroupName,
	f.Topic,
	c.FullName As [Primary Contact],
    u.DisplayName As [Owning User]
FROM ActivityBase a
		Left Outer Join SystemUserBase u On a.OwningUser = u.SystemUserId
		Left Outer Join GroupBase g On a.GroupId = g.GroupId
 		Left Outer Join ContactBase c On a.ContactId = c.ContactId
		Left Outer Join FundraiserBase f On a.FundraiserId = f.FundraiserId
Where a.ContactId = @ContactID










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ProductClassBase]'
GO
CREATE TABLE [dbo].[ProductClassBase]
(
[ProductClassId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProductClassBase_ProductClassId] DEFAULT (newid()),
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductTypeCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletionStateCode] [int] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[Target] [int] NULL,
[OrderNumber] [int] NULL,
[Carried] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ProductClassBase] on [dbo].[ProductClassBase]'
GO
ALTER TABLE [dbo].[ProductClassBase] ADD CONSTRAINT [PK_ProductClassBase] PRIMARY KEY CLUSTERED  ([ProductClassId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FutureSalesChecklist_PrimaryAddressView]'
GO

CREATE VIEW dbo.FutureSalesChecklist_PrimaryAddressView
AS
SELECT     *
FROM         dbo.CustomerAddressBase
WHERE     (PrimaryAddressCode = 1)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_SelectByGroupID]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_SelectByGroupID]
(
	@GroupID uniqueidentifier
)
AS
SELECT f.*,
 CASE f.SalesStageCode
	WHEN '0' Then 'Pending'
	WHEN '1' Then 'Booked'
	WHEN '2' Then 'Ordered'
	WHEN '3' Then 'Delivered'
	WHEN '4' Then 'Paid'
	WHEN '5' Then 'Delivered'
End As [Sales Stage],
		g.GroupName,
	   u.DisplayName As [Owning User],
	   c.FullName As [Primary Contact],
	   e.City,
	   e.State
	 FROM FundraiserBase as f
		Left Outer Join GroupBase g On f.GroupId = g.GroupId
		Left Outer Join SystemUserBase u On f.OwningUser = u.SystemUserId
        Left Outer Join ContactBase c On f.PrimaryContactId = c.ContactId
		Left Outer Join CustomerAddressBase e On g.GroupId = e.ParentId And e.PrimaryAddressCode = 1
 Where f.GroupID = @GroupID And f.DeletionStatusCode <> 1 And f.StatusCode <> 2--And  (e.PrimaryAddressCode = 1) OR (e.PrimaryAddressCode IS NULL)
Order by f.Topic
























GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[NoteBase]'
GO
CREATE TABLE [dbo].[NoteBase]
(
[NoteID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_NotesBase_NoteID] DEFAULT (newid()),
[ParentID] [uniqueidentifier] NULL,
[Subject] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoteText] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletionStateCode] [int] NOT NULL,
[OwningUser] [uniqueidentifier] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_NotesBase] on [dbo].[NoteBase]'
GO
ALTER TABLE [dbo].[NoteBase] ADD CONSTRAINT [PK_NotesBase] PRIMARY KEY CLUSTERED  ([NoteID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_LastOccuring]'
GO
CREATE PROCEDURE dbo.FRP_FundraiserBase_LastOccuring
(
	@GroupID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT TOP 1 * From FundraiserBase
Where GroupID = @GroupId
ORDER BY StartOn DESC

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[InvoiceBase]'
GO
CREATE TABLE [dbo].[InvoiceBase]
(
[InvoiceId] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_InvoiceBase_InvoiceId] DEFAULT (newid()),
[FundraiserId] [uniqueidentifier] NULL,
[OwningUser] [uniqueidentifier] NULL,
[GroupId] [uniqueidentifier] NULL,
[QBInvoiceID] [nchar] (50) COLLATE Latin1_General_CI_AS NULL,
[GroupTypeCode] [int] NULL,
[InvoiceNumber] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentDate] [datetime] NULL,
[BillToStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillToStreet2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillToCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillToTelephone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToStreet2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToTelephone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiscountAmount] [money] NULL,
[InvoiceDiscount] [money] NULL,
[FreightAmount] [money] NULL,
[TotalAmount] [money] NULL,
[TotalLineItemAmount] [money] NULL,
[TotalLineItemDiscountAmount] [money] NULL,
[TotalAmountLessFreight] [money] NULL,
[TotalDiscountAmount] [money] NULL,
[TotalTax] [money] NULL,
[PaymentTerms] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingMethod] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusCode] [int] NULL,
[StatusReasonCode] [int] NULL,
[Delivered] [int] NULL,
[DeliveredOn] [datetime] NULL,
[QBStatusCode] [int] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[CreatedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ShipToCode] [int] NULL,
[PrimaryContactId] [uniqueidentifier] NULL,
[InvoiceStage] [int] NULL,
[DeletionStatusCode] [int] NULL,
[UseDeliveryDate] [bit] NULL,
[GroupPONumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillToName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillToState] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillToZipCode] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillToTelephoneExt] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillToFax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToState] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToZipCode] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToTelephoneExt] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToFax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToFreightTermsCode] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_InvoiceBase] on [dbo].[InvoiceBase]'
GO
ALTER TABLE [dbo].[InvoiceBase] ADD CONSTRAINT [PK_InvoiceBase] PRIMARY KEY CLUSTERED  ([InvoiceId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_DeletionStateCode]'
GO

CREATE PROCEDURE [dbo].[FRP_ContactBase_DeletionStateCode]
	(
	@ContactID uniqueidentifier
)
AS
BEGIN

	SET NOCOUNT ON;

Update ContactBase Set DeletionStateCode = 1 Where ContactID = @ContactID 

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UofMScheduleBase]'
GO
CREATE TABLE [dbo].[UofMScheduleBase]
(
[UoMScheduleId] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_UofMScheduleBase_UoMScheduleId] DEFAULT (newid()),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BaseUofM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletionStateCode] [int] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_UoMScheduleBase] on [dbo].[UofMScheduleBase]'
GO
ALTER TABLE [dbo].[UofMScheduleBase] ADD CONSTRAINT [PK_UoMScheduleBase] PRIMARY KEY CLUSTERED  ([UoMScheduleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_UofMScheduleBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_UofMScheduleBase_Update]
(
	@UoMScheduleId uniqueidentifier,
	@Name nvarchar(200),
	@Description ntext,
	@BaseUofM uniqueidentifier,
	@DeletionStateCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_UoMScheduleId uniqueidentifier,
	@Original_BaseUofM uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(200)
)
AS
	SET NOCOUNT OFF;
UPDATE UofMScheduleBase SET UoMScheduleId = @UoMScheduleId, Name = @Name, Description = @Description, BaseUofM = @BaseUofM, DeletionStateCode = @DeletionStateCode, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (UoMScheduleId = @Original_UoMScheduleId);
	SELECT UoMScheduleId, Name, Description, BaseUofM, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM UofMScheduleBase WHERE (UoMScheduleId = @UoMScheduleId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_SelectByGroupID]'
GO
CREATE PROCEDURE [dbo].[FRP_InvoiceBase_SelectByGroupID]
(
	@GroupID uniqueidentifier
)
AS
SELECT i.*,
	Case i.InvoiceStage
		WHEN '0' THEN 'Order Received'
		WHEN '1' THEN 'Billed'
		WHEN '2' THEN 'Paid'
	End As [Invoice Stage],
	Case i.StatusCode
		WHEN '0' THEN 'Open'
		WHEN '1' THEN 'Closed'
	    WHEN '2' THEN 'Canceled'
	End As [Invoice Status],
	   u.DisplayName AS [Owning User],
	   f.Topic,
	   g.GroupName,
	   c.FullName As [Primary Contact]		
	FROM InvoiceBase as i
		Left Outer Join SystemUserBase u On i.OwningUser = u.SystemUserId
		Left Outer Join FundraiserBase f On i.FundraiserId = f.FundraiserId
		Left Outer Join GroupBase g On i.GroupId = g.GroupId
		Left Outer Join ContactBase c On i.PrimaryContactId = c.ContactId
Where i.GroupID = @GroupID And i.DeletionStatusCode <> 1




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[GroupTypeBase]'
GO
CREATE TABLE [dbo].[GroupTypeBase]
(
[GroupTypeID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_GroupTypeBase_GroupTypeID] DEFAULT (newid()),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Code] [int] NULL,
[DeletionStateCode] [int] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_GroupTypeBase] on [dbo].[GroupTypeBase]'
GO
ALTER TABLE [dbo].[GroupTypeBase] ADD CONSTRAINT [PK_GroupTypeBase] PRIMARY KEY CLUSTERED  ([GroupTypeID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ShippingMethodBase]'
GO
CREATE TABLE [dbo].[ShippingMethodBase]
(
[ShippingMethodID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_ShippingMethodBase_ShippingMethodID] DEFAULT (newid()),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeletionStateCode] [int] NOT NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[DefaultItem] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ShippingMethodBase] on [dbo].[ShippingMethodBase]'
GO
ALTER TABLE [dbo].[ShippingMethodBase] ADD CONSTRAINT [PK_ShippingMethodBase] PRIMARY KEY CLUSTERED  ([ShippingMethodID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ShippingMethodBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_ShippingMethodBase_Select]
AS
	SET NOCOUNT ON;
SELECT ShippingMethodID, Name, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy 
FROM ShippingMethodBase
Order BY Name


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FundraiserBaseView]'
GO
CREATE VIEW dbo.FundraiserBaseView
AS
SELECT     TOP (100) PERCENT g.GroupName, g.GroupType, u.DisplayName, e.AddressName, 
                      CASE WHEN e.AddressTypeCode = 0 THEN '' WHEN e.AddressTypeCode = 1 THEN 'BillTo' WHEN e.AddressTypeCode = 2 THEN 'ShipTo' ELSE '' END AS AddressType,
                       e.Street1, e.Street2, e.City, e.State, e.ZipCode, o.Topic, o.Description, o.GroupSize, o.FundraiserID, o.GroupGoal, o.FundsFor, o.DeletionStatusCode, o.StartOn, 
                      o.CallinOrderBy, o.ReturnOrderBy, o.MakeChecksTo, o.GoalInformation, o.DeliveryMinimum, o.CreatedOn, o.CreatedBy, o.ModifiedOn, o.ModifiedBy, 
                      c.FullName AS PrimaryContact, a.ScheduledStartDate AS DeliveryDate, a.Label AS DeliveryRoute, 
                      CASE WHEN o.SalesStageCode = 0 THEN 'Pending' WHEN o.SalesStageCode = 1 THEN 'Booked' WHEN o.SalesStageCode = 2 THEN 'Ordered' WHEN o.SalesStageCode
                       = 3 THEN 'Delivered' WHEN o.SalesStageCode = 4 THEN 'Paid' ELSE '' END AS SalesStage, 
                      CASE WHEN o.StatusCode = 0 THEN 'Closed' WHEN o.StatusCode = 1 THEN 'Open' WHEN o.StatusCode = 2 THEN 'Canceled' ELSE '' END AS FundraiserStatus, 
                      o.BookedOn, o.OrderedOn, o.PaidOn
FROM         dbo.FundraiserBase AS o LEFT OUTER JOIN
                      dbo.GroupBase AS g ON o.GroupId = g.GroupId LEFT OUTER JOIN
                      dbo.SystemUserBase AS u ON o.OwningUser = u.SystemUserId LEFT OUTER JOIN
                      dbo.ContactBase AS c ON o.PrimaryContactID = c.ContactId LEFT OUTER JOIN
                      dbo.ActivityBase AS a ON o.DeliveryID = a.ActivityId LEFT OUTER JOIN
                      dbo.CustomerAddressBase AS e ON g.GroupId = e.ParentID AND e.PrimaryAddressCode = 1
WHERE     (o.DeletionStatusCode <> 1)
ORDER BY o.Topic

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_FATopicSelectDelivery]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_FundraiserBase_FATopicSelectDelivery]
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT	FundraiserID, Topic, DeliveryID
FROM	FundraiserBase
WHERE  DeletionStatusCode <> 1 And StatusCode <> 2
ORDER BY Topic
   
   END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQuantityAllocated]'
GO

CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdateQuantityAllocated]
(
@UseDates bit,
@StartDate datetime,
@EndDate datetime
)
AS
	SET NOCOUNT ON;
Declare @ProductID uniqueidentifier
Declare @QuantityAllocated integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
IF @UseDates = 0
BEGIN	
	Set @QuantityAllocated = (Select SUM(idb.Quantity) as TotalQuantity 
						FROM InvoiceBase i Left Outer Join InvoiceDetailBase idb  On i.InvoiceID= idb.InvoiceID
						WHERE idb.ProductID = @ProductID AND i.InvoiceStage = 0 And i.StatusCode = 0 AND i.DeletionStatusCode <> 1) 
Update ProductBase Set QuantityAllocated = isNull(@QuantityAllocated,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END
ELSE IF @UseDates = 1
BEGIN		
Set @QuantityAllocated = (Select SUM(idb.Quantity) as TotalQuantity 
						FROM InvoiceBase i Left Outer Join InvoiceDetailBase idb  On i.InvoiceID= idb.InvoiceID
						WHERE idb.ProductID = @ProductID AND i.DocumentDate >= @StartDate AND i.DocumentDate <=@EndDate AND i.InvoiceStage = 0 And i.StatusCode = 0 AND i.DeletionStatusCode <> 1) 
Update ProductBase Set QuantityAllocated = isNull(@QuantityAllocated,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END
END
CLOSE Product_Cursor 
DEALLOCATE Product_Cursor 








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_PaymentTermsBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_PaymentTermsBase_Insert]
(
	@PaymentTermsID uniqueidentifier,
	@Name nvarchar(200),
	@DeletionStateCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO PaymentTermsBase(PaymentTermsID, Name, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@PaymentTermsID, @Name, @DeletionStateCode, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT PaymentTermsID, Name, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM PaymentTermsBase WHERE (PaymentTermsID = @PaymentTermsID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_NameAndDescriptionSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_ProductBase_NameAndDescriptionSelect]
(
			@ProductID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT ProductId,
	ProductNumber,
	p.Name,
	p.Description,
	u.Name as Unit,
	ProductTypeCode	
 FROM ProductBase p Left Outer Join UofMScheduleBase u on p.DefaultUoMId = u.UoMScheduleId
 Where ProductID = @ProductID


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_SelectByGroupID]'
GO

CREATE PROCEDURE [dbo].[FRP_ContactBase_SelectByGroupID]
(
	@GroupID as uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT ContactBase.*,
		Case PreferredPhoneCode
			When '1' Then BusinessPhone
			When '2' Then HomePhone
			When '3' then MobilePhone
			when '4' then OtherPhone
		end as [Preferred Phone],
		Case PreferredPhoneCode
			When '1' Then BusinessPhoneExt
			When '2' Then ''
			When '3' then ''
			when '4' then OtherPhoneExt
		end as [Ext]
FROM ContactBase 
Where ParentGroupID = @GroupID And DeletionStateCode = 0 And StatusCode = 0
ORDER BY LastName, FirstName





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FundraiserDetailBase]'
GO
CREATE TABLE [dbo].[FundraiserDetailBase]
(
[FundraiserDetailID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_OpportunityDetailBase_OpportunityDetailID] DEFAULT (newid()),
[FundraiserID] [uniqueidentifier] NOT NULL,
[ProductID] [uniqueidentifier] NOT NULL,
[ProductNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductDescription] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [decimal] (18, 0) NULL,
[PricePerUnit] [money] NULL,
[BaseAmount] [money] NULL,
[ExtendedAmount] [money] NULL,
[UofMID] [uniqueidentifier] NULL,
[ManualDiscountAmount] [money] NULL,
[Tax] [money] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[QtyBsUofM] [decimal] (18, 0) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_FundraiserDetailBase] on [dbo].[FundraiserDetailBase]'
GO
ALTER TABLE [dbo].[FundraiserDetailBase] ADD CONSTRAINT [PK_FundraiserDetailBase] PRIMARY KEY CLUSTERED  ([FundraiserDetailID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_UpdateReorderPointAndMinimumQtyDates]'
GO


CREATE PROCEDURE [dbo].[FRP_ProductBase_UpdateReorderPointAndMinimumQtyDates] 
AS
SET NOCOUNT ON;





DECLARE @EmptyGUID uniqueidentifier
SET @EmptyGUID = '00000000-0000-0000-0000-000000000000'


DECLARE @ProductID uniqueidentifier
DECLARE @TrxDate datetime,  @Quantity decimal(18,0)
DECLARE @EstInvLevel int 
DECLARE @ReorderAmount int
DECLARE @MinimumAmount int
DECLARE @ReorderDateSet bit


--Workaround: first null all ReorderPoint and MinimumQty Dates
Update ProductBase Set ReorderPointDate = NULL
Update ProductBase Set MinimumQtyDate = NULL 



DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN

SET @ReorderDateSet = 0
SET @EstInvLevel = (SELECT QuantityOnHand FROM ProductBase Where ProductID = @ProductID)
SET @ReorderAmount = (SELECT ReorderPoint From ProductBase Where ProductID = @ProductID)
SET @MinimumAmount = (SELECT MinimumQty FROM ProductBase Where ProductID = @ProductID)

 

DECLARE Quanity_Cursor CURSOR FOR
-- This should add to the forecasted inv. quantity.
SELECT     dbo.PurchaseOrderBase.ReceivedOn AS TrxDate, dbo.PurchaseOrderDetailBase.QuantityOrdered AS Quantity
FROM         dbo.PurchaseOrderBase INNER JOIN
                      dbo.PurchaseOrderDetailBase ON dbo.PurchaseOrderBase.PurchaseOrderID = dbo.PurchaseOrderDetailBase.PurchaseOrderID LEFT OUTER JOIN
                      dbo.ProductBase ON dbo.PurchaseOrderDetailBase.ProductID = dbo.ProductBase.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase ON dbo.ProductBase.ProductClassID = dbo.ProductClassBase.ProductClassId
WHERE     (dbo.PurchaseOrderBase.Stage = 0) AND (dbo.PurchaseOrderBase.Status = 0) AND (dbo.PurchaseOrderBase.DeletionStateCode <> 1) AND (dbo.PurchaseOrderDetailBase.ProductID = @ProductID) AND (dbo.ProductBase.ProductID = @ProductID)
			AND (dbo.PurchaseOrderDetailBase.QuantityOrdered <> 0) AND (dbo.ProductBase.Carried <> 0)
UNION ALL

-- This should add to the forecasted inv. quantity.
SELECT     PurchaseOrderBase_1.ReceivedOn,  PurchaseOrderDetailBase_1.QuantityOrdered                       
FROM         dbo.PurchaseOrderBase AS PurchaseOrderBase_1 INNER JOIN
                      dbo.PurchaseOrderDetailBase AS PurchaseOrderDetailBase_1 ON 
                      PurchaseOrderBase_1.PurchaseOrderID = PurchaseOrderDetailBase_1.PurchaseOrderID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_4 ON PurchaseOrderDetailBase_1.ProductID = ProductBase_4.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_4 ON ProductBase_4.ProductClassID = ProductClassBase_4.ProductClassId
WHERE     (PurchaseOrderBase_1.Stage = 1) AND (PurchaseOrderBase_1.Status = 0) AND (PurchaseOrderBase_1.DeletionStateCode <> 1) AND (PurchaseOrderDetailBase_1.ProductID = @ProductID) AND (ProductBase_4.ProductID = @ProductID)
			AND (PurchaseOrderDetailBase_1.QuantityOrdered <> 0) AND (ProductBase_4.Carried <> 0)
UNION ALL

-- This should subtract from the forecasted inv. quantity.
SELECT     dbo.InvoiceBase.DocumentDate, dbo.InvoiceDetailBase.Quantity * - 1
FROM         dbo.InvoiceBase INNER JOIN
                      dbo.InvoiceDetailBase ON dbo.InvoiceBase.InvoiceId = dbo.InvoiceDetailBase.InvoiceID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_3 ON dbo.InvoiceDetailBase.ProductID = ProductBase_3.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_3 ON ProductBase_3.ProductClassID = ProductClassBase_3.ProductClassId
WHERE     (dbo.InvoiceBase.InvoiceStage = 0) AND (dbo.InvoiceBase.StatusCode = 0) AND (dbo.InvoiceBase.DeletionStatusCode <> 1) AND (dbo.InvoiceDetailBase.ProductID = @ProductID) AND (ProductBase_3.ProductID = @ProductID)
			AND (dbo.InvoiceDetailBase.Quantity <> 0) AND (ProductBase_3.Carried <> 0)
UNION ALL

-- These have a primary delivery. This should subtract from the forecasted inv. quantity.
SELECT     dbo.ActivityBase.ScheduledStartDate, dbo.FundraiserDetailBase.Quantity * - 1
FROM         dbo.FundraiserBase INNER JOIN
                      dbo.FundraiserDetailBase ON dbo.FundraiserBase.FundraiserID = dbo.FundraiserDetailBase.FundraiserID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_2 ON dbo.FundraiserDetailBase.ProductID = ProductBase_2.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_2 ON ProductBase_2.ProductClassID = ProductClassBase_2.ProductClassId LEFT OUTER JOIN
					  dbo.ActivityBase ON dbo.FundraiserBase.DeliveryID = dbo.ActivityBase.ActivityID
WHERE     (dbo.FundraiserBase.SalesStageCode = 0) AND (dbo.FundraiserBase.StatusCode = 1) AND (dbo.FundraiserBase.DeletionStatusCode <> 1) AND (dbo.FundraiserBase.DeliveryID <> @EmptyGUID) AND (dbo.FundraiserDetailBase.ProductID = @ProductID) AND (ProductBase_2.ProductID = @ProductID)
			AND (dbo.FundraiserDetailBase.Quantity <> 0) AND (ProductBase_2.Carried <> 0)
UNION ALL

-- These DO NOT have a primary delivery. This should subtract from the forecasted inv. quantity.
SELECT     dbo.FundraiserBase.CallinOrderBy, dbo.FundraiserDetailBase.Quantity * - 1  
FROM         dbo.FundraiserBase INNER JOIN
                      dbo.FundraiserDetailBase ON dbo.FundraiserBase.FundraiserID = dbo.FundraiserDetailBase.FundraiserID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_2 ON dbo.FundraiserDetailBase.ProductID = ProductBase_2.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_2 ON ProductBase_2.ProductClassID = ProductClassBase_2.ProductClassId LEFT OUTER JOIN
					  dbo.ActivityBase ON dbo.FundraiserBase.DeliveryID = dbo.ActivityBase.ActivityID
WHERE     (dbo.FundraiserBase.SalesStageCode = 0) AND (dbo.FundraiserBase.StatusCode = 1) AND (dbo.FundraiserBase.DeletionStatusCode <> 1) AND (dbo.FundraiserBase.DeliveryID = @EmptyGUID) AND (dbo.FundraiserDetailBase.ProductID = @ProductID) AND (ProductBase_2.ProductID = @ProductID)
			AND (dbo.FundraiserDetailBase.Quantity <> 0) AND (ProductBase_2.Carried <> 0)
UNION ALL

-- These have a primary delivery. This should subtract from the forecasted inv. quantity.
SELECT     dbo.ActivityBase.ScheduledStartDate, FundraiserDetailBase_1.Quantity * - 1 
FROM         dbo.FundraiserBase AS FundraiserBase_1 INNER JOIN
                      dbo.FundraiserDetailBase AS FundraiserDetailBase_1 ON FundraiserBase_1.FundraiserID = FundraiserDetailBase_1.FundraiserID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_1 ON FundraiserDetailBase_1.ProductID = ProductBase_1.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_1 ON ProductBase_1.ProductClassID = ProductClassBase_1.ProductClassId LEFT OUTER JOIN
				      dbo.ActivityBase ON FundraiserBase_1.DeliveryID = dbo.ActivityBase.ActivityID
WHERE     (FundraiserBase_1.SalesStageCode = 1) AND (FundraiserBase_1.StatusCode = 1) AND (FundraiserBase_1.DeletionStatusCode <> 1) AND (FundraiserBase_1.DeliveryID <> @EmptyGUID) AND (FundraiserDetailBase_1.ProductID = @ProductID) AND (ProductBase_1.ProductID = @ProductID)
			AND (FundraiserDetailBase_1.Quantity <> 0) AND (ProductBase_1.Carried <> 0)
UNION ALL

-- These DO NOT have a primary delivery. This should subtract from the forecasted inv. quantity.
SELECT     FundraiserBase_1.CallInOrderBy, FundraiserDetailBase_1.Quantity * - 1
FROM         dbo.FundraiserBase AS FundraiserBase_1 INNER JOIN
                      dbo.FundraiserDetailBase AS FundraiserDetailBase_1 ON FundraiserBase_1.FundraiserID = FundraiserDetailBase_1.FundraiserID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_1 ON FundraiserDetailBase_1.ProductID = ProductBase_1.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_1 ON ProductBase_1.ProductClassID = ProductClassBase_1.ProductClassId
WHERE     (FundraiserBase_1.SalesStageCode = 1) AND (FundraiserBase_1.StatusCode = 1) AND (FundraiserBase_1.DeletionStatusCode <> 1) AND (FundraiserBase_1.DeliveryID = @EmptyGUID) AND (FundraiserDetailBase_1.ProductID = @ProductID) AND (ProductBase_1.ProductID = @ProductID)
			AND (FundraiserDetailBase_1.Quantity <> 0) AND (ProductBase_1.Carried <> 0)
ORDER BY TrxDate



OPEN Quanity_Cursor 
FETCH NEXT FROM Quanity_Cursor
INTO @TrxDate,@Quantity
WHILE @@FETCH_STATUS = 0
BEGIN

 
Set @EstInvLevel = @EstInvLevel + @Quantity
if @ReorderDateSet = 0 AND @ReorderAmount >= @EstInvLevel
BEGIN
	Update ProductBase Set ReorderPointDate = @TrxDate Where ProductID = @ProductID
	Set @ReorderDateSet = 1
END

if @MinimumAmount >= @EstInvLevel
BEGIN
	Update ProductBase Set MinimumQtyDate = @TrxDate Where ProductID = @ProductID
	Break
END


FETCH NEXT FROM Quanity_Cursor
INTO @TrxDate,  @Quantity
END




CLOSE Quanity_Cursor 
DEALLOCATE Quanity_Cursor 



FETCH NEXT FROM Product_Cursor
INTO @ProductID
END

CLOSE Product_Cursor 
DEALLOCATE Product_Cursor



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PurchaseOrderBaseView]'
GO
CREATE VIEW dbo.PurchaseOrderBaseView
AS
SELECT     TOP (100) PERCENT p.PONumber, u.DisplayName, p.PurchaseOrderID, p.ReceivedOn, p.OwningUser, p.CreatedOn, p.CreatedBy, p.ModifiedOn, 
                      p.ModifiedBy, 
                      CASE WHEN p.Status = 0 THEN 'Open' WHEN p.Status = 1 THEN 'Closed' WHEN p.Status = 2 THEN 'Canceled' ELSE 'Closed' END AS POStatus, 
                      CASE WHEN p.Stage = 0 THEN 'Pending' WHEN p.Stage = 1 THEN 'Ordered' WHEN p.Stage = 2 THEN 'Received' ELSE 'Pending' END AS POStage
FROM         dbo.PurchaseOrderBase AS p LEFT OUTER JOIN
                      dbo.SystemUserBase AS u ON p.OwningUser = u.SystemUserId
WHERE     (p.DeletionStateCode <> 1)
ORDER BY p.PONumber

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ShippingMethodBase_NameSelect]'
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ShippingMethodBase_NameSelect]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT	Name
FROM	ShippingMethodBase
ORDER BY DefaultItem desc, Name

END






GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_FAInvoiceSelect]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_InvoiceBase_FAInvoiceSelect]
AS
BEGIN
	SET NOCOUNT ON;
SELECT InvoiceID, InvoiceNumber, Name, DocumentDate
FROM InvoiceBase
WHERE DeletionStatusCode <> 1 AND StatusCode <> 2
ORDER By InvoiceNumber
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupBase_Select]
(
	@GroupID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT * FROM GroupBase WHERE (GroupId = @GroupID)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_SystemUserBase_Select]
(
	@UserID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT SystemUserId, DeletionStateCode, UserName, Password, SecurityCode, CompanyID, Salutation, FirstName, MiddleName, LastName, FullName, NickName, JobTitle, Email1, Email2, PreferredEmailCode, BusinessPhone, BusinessPhoneExt, HomePhone, MobilePhone, OtherPhone, OtherPhoneExt, PreferredPhoneCode, PreferredAddressCode, EmployeeId, DeliveryRepresentativeCode, SalesRepresentativeCode, Street1, Street2, City, State, ZipCode, OtherStreet1, OtherStreet2, OtherCity, OtherState, OtherZipCode, CreatedOn, ModifiedOn, CreatedBy, ModifiedBy FROM SystemUserBase WHERE (SystemUserId = @UserID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_ContactBase_Delete]
(
	@Original_ContactId uniqueidentifier,
	@Original_Anniversary datetime,
	@Original_AssistantName nvarchar(100),
	@Original_AssistantPhone nvarchar(50),
	@Original_AssistantPhoneExt nvarchar(5),
	@Original_BirthDate datetime,
	@Original_BusinessPhone nvarchar(50),
	@Original_BusinessPhoneExt nvarchar(5),
	@Original_ContactRole nvarchar(50),
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_CreditOnHold bit,
	@Original_DeletionStateCode int,
	@Original_Department nvarchar(100),
	@Original_DoNotBulkEMail bit,
	@Original_DoNotBulkPostalMail bit,
	@Original_DoNotEMail bit,
	@Original_DoNotFax bit,
	@Original_DoNotPhone bit,
	@Original_DoNotPostalMail bit,
	@Original_EMailAddress1 nvarchar(100),
	@Original_EMailAddress2 nvarchar(100),
	@Original_EMailAddress3 nvarchar(100),
	@Original_FamilyStatusCode int,
	@Original_Fax nvarchar(50),
	@Original_FirstName nvarchar(50),
	@Original_FreightTermsCode int,
	@Original_FullName nvarchar(160),
	@Original_GenderCode int,
	@Original_GroupSize int,
	@Original_GroupType nvarchar(200),
	@Original_HasChildrenCode int,
	@Original_HomePhone nvarchar(50),
	@Original_JobTitle nvarchar(100),
	@Original_LastName nvarchar(50),
	@Original_ManagerName nvarchar(100),
	@Original_ManagerPhone nvarchar(50),
	@Original_ManagerPhoneExt nvarchar(10),
	@Original_MaritalStatus nvarchar(50),
	@Original_MiddleName nvarchar(50),
	@Original_MobilePhone nvarchar(50),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_NickName nvarchar(50),
	@Original_NumberOfChildren int,
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(10),
	@Original_OwningUser uniqueidentifier,
	@Original_ParentGroupID uniqueidentifier,
	@Original_PaymentTerms nvarchar(200),
	@Original_PreferredContactMethodCode int,
	@Original_PreferredPhoneCode int,
	@Original_Salutation nvarchar(100),
	@Original_ShippingMethod nvarchar(200),
	@Original_SpousesName nvarchar(100),
	@Original_StatusCode int,
	@Original_Suffix nvarchar(10),
	@Original_WebSiteUrl nvarchar(200)
)
AS
	SET NOCOUNT OFF;
DELETE FROM ContactBase WHERE (ContactId = @Original_ContactId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_CustomerNameSelect]'
GO

CREATE     PROCEDURE [dbo].[FRP_GroupBase_CustomerNameSelect]
(
	@CustomerID as uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT	CustomerID,
	CustomerName,
	RecordType

FROM	(SELECT GroupId as CustomerID, GroupName as CustomerName, '0' as RecordType FROM GroupBase
		UNION
	Select SystemUserID, FullName, '3' FROM SystemUserBase) as Customer
WHERE Customer.CustomerID = @CustomerID
ORDER BY Customer.CustomerName




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_DeleteActivitiesInvoices]'
GO

CREATE PROCEDURE [dbo].[FRP_ContactBase_DeleteActivitiesInvoices]
(
	@ContactID uniqueidentifier
)
AS
SET NOCOUNT ON;
DELETE FROM ContactBase 
WHERE ContactId = @ContactID
Declare @EmptyID nvarchar(40)
set @EmptyID = '00000000-0000-0000-0000-000000000000'
Update GroupBase Set PrimaryContactId = @EmptyID Where PrimaryContactId = @ContactID 
Update ActivityBase Set RecipientId = @EmptyID Where RecipientId = @ContactID 
Update ActivityBase Set RegardingId = @EmptyID Where RegardingId = @ContactID 
Update ActivityBase Set SenderId = @EmptyID Where SenderId = @ContactID 
-- Notes
Delete From NoteBase Where ParentID = @ContactID
--Addresses
Delete From CustomerAddressBase Where ParentID = @ContactID
--Activities
Declare @TempID uniqueidentifier
DECLARE Activity_cursor CURSOR FOR
SELECT ActivityID FROM ActivityBase 
WHERE GroupId = @ContactID
OPEN Activity_cursor
FETCH NEXT FROM Activity_cursor INTO @TempID
WHILE @@FETCH_STATUS = 0
BEGIN
 DELETE FROM ActivityPartyBase WHERE ActivityID = @TempID
 FETCH NEXT FROM Activity_cursor INTO @TempID
END
CLOSE Activity_cursor
DEALLOCATE Activity_cursor
Delete From ActivityBase Where GroupId = @ContactID
Delete From ActivityPartyBase Where PartyId = @ContactID
    

--Invoices
DECLARE Invoice_cursor CURSOR FOR
SELECT InvoiceID FROM InvoiceBase
WHERE GroupID = @ContactID
OPEN Invoice_cursor
FETCH NEXT FROM Invoice_cursor INTO @TempID
WHILE @@FETCH_STATUS = 0
BEGIN
 DELETE FROM InvoiceDetailBase WHERE InvoiceID = @TempID 
 FETCH NEXT FROM Invoice_cursor INTO @TempID
END
CLOSE Invoice_cursor
DEALLOCATE Invoice_cursor
Delete From InvoiceBase Where GroupId = @ContactID




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_ActiveContactsSelectByGroupID]'
GO


CREATE PROCEDURE [dbo].[FRP_ContactBase_ActiveContactsSelectByGroupID]  
(
		@GroupID uniqueidentifier
)
AS
SELECT c.*,
	Case c.PreferredPhoneCode
			When '1' Then c.BusinessPhone
			When '2' Then c.HomePhone
			When '3' then c.MobilePhone
			when '4' then c.OtherPhone
		end as [Preferred Phone],
		Case c.PreferredPhoneCode
			When '1' Then c.BusinessPhoneExt
			When '2' Then ''
			When '3' then ''
			when '4' then c.OtherPhoneExt
		end as [Ext],
		g.GroupName,
		u.DisplayName As [Owning User]	
 FROM ContactBase c
		Left Outer Join SystemUserBase u On c.OwningUser = u.SystemUserId
		Left Outer Join GroupBase g On c.ParentGroupid = g.GroupId
Where c.ParentGroupID = @GroupID AND c.DeletionStateCode = 0 And c.StatusCode =0










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_TopicSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_TopicSelect]
(
	@FundraiserID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT FundraiserID,
		 Topic
FROM FundraiserBase
WHERE FundraiserID = @FundraiserID And DeletionStatusCode <> 1 And StatusCode <> 2



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserDetailBase_GetByFundraiserID]'
GO
CREATE PROCEDURE [dbo].[FRP_FundraiserDetailBase_GetByFundraiserID] 
(
	@FundraiserID uniqueidentifier
)
AS
BEGIN
		SET NOCOUNT ON;
SELECT * FROM FundraiserDetailBase WHERE (FundraiserID = @FundraiserID)
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DefaultBase]'
GO
CREATE TABLE [dbo].[DefaultBase]
(
[DefaultId] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_DefaultBase_DefaultId] DEFAULT (newid()),
[DefaultName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultSubName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [bigint] NULL,
[DefaultText] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ordinal] [bigint] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_DefaultBase] on [dbo].[DefaultBase]'
GO
ALTER TABLE [dbo].[DefaultBase] ADD CONSTRAINT [PK_DefaultBase] PRIMARY KEY CLUSTERED  ([DefaultId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_DefaultBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_DefaultBase_Update]
(
	@DefaultId uniqueidentifier,
	@DefaultName nvarchar(50),
	@DefaultSubName nvarchar(50),
	@Code bigint,
	@DefaultText nvarchar(50),
	@Ordinal bigint,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@Original_DefaultId uniqueidentifier,
	@Original_Code bigint,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DefaultName nvarchar(50),
	@Original_DefaultSubName nvarchar(50),
	@Original_DefaultText nvarchar(50),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Ordinal bigint
)
AS
	SET NOCOUNT OFF;
UPDATE DefaultBase SET DefaultId = @DefaultId, DefaultName = @DefaultName, DefaultSubName = @DefaultSubName, Code = @Code, DefaultText = @DefaultText, Ordinal = @Ordinal, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy WHERE (DefaultId = @Original_DefaultId)
	SELECT DefaultId, DefaultName, DefaultSubName, Code, DefaultText, Ordinal, ModifiedOn, ModifiedBy, CreatedOn, CreatedBy FROM DefaultBase WHERE (DefaultId = @DefaultId)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ActivityBaseView]'
GO
CREATE VIEW dbo.ActivityBaseView
AS
SELECT     a.ActivityId, a.GroupId, a.ContactId, a.FundraiserId, a.ParentTypeCode, a.AllDayEvent, a.PercentComplete, a.ActivityTypeCode, a.DeletionStateCode, 
                      a.DirectionCode, a.ScheduledDuration, a.PriorityCode, a.CreatedBy, a.ScheduledStartDate, a.ScheduledEndDate, a.ModifiedBy, a.Message, a.Subject, 
                      a.CreatedOn, a.ModifiedOn, a.OwningUser, a.Location, a.QuoteOrOrderNumber, a.StatusCode, a.SenderId, a.SenderTypeCode, a.RecipientId, 
                      a.RecipientTypeCode, a.RegardingId, a.RegardingTypeCode, a.PhoneNumber, a.PhoneNumberExt, a.DurationFormatCode, a.DeliveryOn, 
                      a.DeliveryStart, a.DeliveryEnd, a.AddressName, a.Street1, a.Street2, a.City, a.State, a.ZipCode, a.Latitude, a.Longitude, a.Recurrence, a.Reminder, 
                      a.ReminderInterval, a.ReminderTime, a.TotalUnits, a.DeliveryVehicle, a.MapGridId, a.MapLink, a.AddressNotes, a.Label, a.BarColor, g.GroupName, 
                      f.Topic, c.FullName AS ContactPerson, u.DisplayName, a.PrimaryDelivery, 
                      CASE WHEN ActivityTypeCode = '1' THEN 'Appointment' WHEN ActivityTypeCode = '2' THEN 'Delivery' WHEN ActivityTypeCode = '4' THEN 'Phone Call'
                       WHEN ActivityTypeCode = '8' THEN 'Print Fliers' WHEN ActivityTypeCode = '16' THEN 'Scheduled Email' WHEN ActivityTypeCode = '32' THEN 'Task' WHEN
                       ActivityTypeCode = '64' THEN 'Thank You' END AS ActivityType, 
                      CASE WHEN a.StatusCode = '0' THEN 'Open' WHEN a.StatusCode = '1' THEN 'Completed' WHEN a.StatusCode = '2' THEN 'Canceled' END AS Status, 
                      a.EmailAddress
FROM         dbo.ActivityBase AS a LEFT OUTER JOIN
                      dbo.GroupBase AS g ON a.GroupId = g.GroupId LEFT OUTER JOIN
                      dbo.SystemUserBase AS u ON a.OwningUser = u.SystemUserId LEFT OUTER JOIN
                      dbo.ContactBase AS c ON a.ContactId = c.ContactId LEFT OUTER JOIN
                      dbo.FundraiserBase AS f ON a.FundraiserId = f.FundraiserID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_SelectLowestStage]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_InvoiceBase_SelectLowestStage]
(
	@FundraiserID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;
SELECT TOP 1 * From InvoiceBase
	WHERE FundraiserID = @FundraiserID AND DeletionStatusCode <> 1
	ORDER BY StatusCode, InvoiceStage
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[InventoryAdjustmentBaseView]'
GO
CREATE VIEW dbo.InventoryAdjustmentBaseView
AS
SELECT     TOP (100) PERCENT i.InventoryAdjNumber AS [Inv Adj Number], u.DisplayName, i.InventoryAdjustmentID, i.StartDate, i.OwningUser, i.CreatedOn, 
                      i.CreatedBy, i.ModifiedOn, i.ModifiedBy, 
                      CASE WHEN i.Status = 0 THEN 'Open' WHEN i.Status = 1 THEN 'Closed' WHEN i.Status = 2 THEN 'Canceled' ELSE 'Closed' END AS InvAdjStatus, 
                      CASE WHEN i.Stage = 0 THEN 'Pending' WHEN i.Stage = 1 THEN 'Confirmed' ELSE 'Pending' END AS InvAdjStage
FROM         dbo.InventoryAdjustmentBase AS i LEFT OUTER JOIN
                      dbo.SystemUserBase AS u ON i.OwningUser = u.SystemUserId
WHERE     (i.DeletionStateCode <> 1)
ORDER BY [Inv Adj Number]

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_PaperworkWizProdClassTotals]'
GO





CREATE PROCEDURE [dbo].[FRP_ActivityBase_PaperworkWizProdClassTotals]
(
	@OwningUserID uniqueidentifier,
@UseDates bit,
@StartDate datetime,
@EndDate datetime
)
AS
SET NOCOUNT ON;

DECLARE @EmptyGUID uniqueidentifier
SET @EmptyGUID = '00000000-0000-0000-0000-000000000000'

IF @UseDates = 0
BEGIN
SELECT     dbo.ProductClassBase.Name, SUM(dbo.InvoiceDetailBase.Quantity) AS Total
FROM         dbo.ActivityBase LEFT OUTER JOIN
                      dbo.InvoiceBase ON dbo.ActivityBase.DocID = dbo.InvoiceBase.InvoiceId LEFT OUTER JOIN
                      dbo.InvoiceDetailBase ON dbo.InvoiceBase.InvoiceId = dbo.InvoiceDetailBase.InvoiceID LEFT OUTER JOIN
                      dbo.ProductClassBase ON dbo.InvoiceDetailBase.ProductClassID = dbo.ProductClassBase.ProductClassId
Where dbo.ActivityBase.OwningUser = @OwningUserID AND dbo.ActivityBase.DocID <> @EmptyGuid AND dbo.ActivityBase.ActivityTypeCode = 2 AND dbo.ActivityBase.StatusCode = 0
GROUP BY dbo.ProductClassBase.Name, dbo.InvoiceDetailBase.ProductClassID
END
ELSE IF @UseDates = 1
BEGIN
SELECT     dbo.ProductClassBase.Name, SUM(dbo.InvoiceDetailBase.Quantity) AS Total
FROM         dbo.ActivityBase LEFT OUTER JOIN
                      dbo.InvoiceBase ON dbo.ActivityBase.DocID = dbo.InvoiceBase.InvoiceId LEFT OUTER JOIN
                      dbo.InvoiceDetailBase ON dbo.InvoiceBase.InvoiceId = dbo.InvoiceDetailBase.InvoiceID LEFT OUTER JOIN
                      dbo.ProductClassBase ON dbo.InvoiceDetailBase.ProductClassID = dbo.ProductClassBase.ProductClassId
Where dbo.ActivityBase.OwningUser = @OwningUserID AND dbo.ActivityBase.ScheduledStartDate BETWEEN @StartDate AND @EndDate AND dbo.ActivityBase.DocID <> @EmptyGuid AND dbo.ActivityBase.ActivityTypeCode = 2 AND dbo.ActivityBase.StatusCode = 0
GROUP BY dbo.ProductClassBase.Name, dbo.InvoiceDetailBase.ProductClassID
END







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UofMScheduleDetailBase]'
GO
CREATE TABLE [dbo].[UofMScheduleDetailBase]
(
[UoMId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_UofMScheduleDetailBase_UoMId] DEFAULT (newid()),
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [decimal] (18, 0) NULL,
[UoMScheduleId] [uniqueidentifier] NULL,
[IsScheduleBaseUoM] [bit] NULL,
[UofM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Eqivalent] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletionStateCode] [int] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_UofMScheduleDetailBase] on [dbo].[UofMScheduleDetailBase]'
GO
ALTER TABLE [dbo].[UofMScheduleDetailBase] ADD CONSTRAINT [PK_UofMScheduleDetailBase] PRIMARY KEY CLUSTERED  ([UoMId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[InternalAddressBase]'
GO
CREATE TABLE [dbo].[InternalAddressBase]
(
[InternalAddressId] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_InternalAddressBase_InternalAddressId] DEFAULT (newid()),
[ParentId] [uniqueidentifier] NOT NULL,
[DeletionStateCode] [int] NOT NULL,
[AddressNumber] [int] NULL,
[AddressTypeCode] [int] NULL,
[BillCompanyName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillStreet2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillState] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillZipCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillBusinessPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillBusinessPhoneExt] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCompanyName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipStreet2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipState] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipZipCode] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipBusinessPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipBusinessPhoneExt] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingMethodCode] [int] NULL,
[Latitude] [float] NULL,
[Longitude] [float] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[CreatedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_InternalAddressBase] on [dbo].[InternalAddressBase]'
GO
ALTER TABLE [dbo].[InternalAddressBase] ADD CONSTRAINT [PK_InternalAddressBase] PRIMARY KEY CLUSTERED  ([InternalAddressId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InternalAddressBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_InternalAddressBase_Select]
(
	@ParentID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT InternalAddressId, ParentId, DeletionStateCode, AddressNumber, AddressTypeCode, BillCompanyName, BillStreet1, BillStreet2, BillCity, BillState, BillZipCode, BillBusinessPhone, BillBusinessPhoneExt, ShipCompanyName, ShipStreet1, ShipStreet2, ShipCity, ShipState, ShipZipCode, ShipBusinessPhone, ShipBusinessPhoneExt, ShippingMethodCode, Latitude, Longitude, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM InternalAddressBase WHERE (ParentId = @ParentID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_UserLogin]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_SystemUserBase_UserLogin]
(
	@UserName nvarchar(50)
)
AS
BEGIN
	SET NOCOUNT ON;

SELECT *
FROM SystemUserBase 
WHERE UserName = @UserName 

RETURN
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ShippingMethodBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_ShippingMethodBase_Delete]
(
	@Original_ShippingMethodID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(200)
)
AS
	SET NOCOUNT OFF;
DELETE FROM ShippingMethodBase WHERE (ShippingMethodID = @Original_ShippingMethodID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_GridSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityBase_GridSelect]
(
	@GroupId uniqueidentifier,
	@StatusCode as integer
)
AS
	SET NOCOUNT ON;
Declare @StatusCodeEnd as int
if @StatusCode = 3
	Begin
		set @StatusCode = 1
		set @StatusCodeEnd = 2
	End
else
	set @StatusCodeEnd = @StatusCode
SELECT ActivityId, 
	Subject,
	Message as Body,
	ScheduledStartDate as [Due Date], 
	u.FullName as [Owning User],
	a.CreatedOn as [Created On],
	ActivityTypeCode as Type,
	ActivityTypeCode as PictureCode
FROM ActivityBase a Left Outer Join SystemUserBase u On a.OwningUser= u.SystemUserID
WHERE GroupId = @GroupId AND (StatusCode >= @StatusCode And StatusCode <= @StatusCodeEnd)
Order By ScheduledStartDate DESC




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_GridSelectDateRange]'
GO

/*
StartDate & EndDate select records for those dates
If StatusCode is 0 then all records are returned
*/
CREATE PROCEDURE [dbo].[FRP_FundraiserBase_GridSelectDateRange]
(
	@StatusCode  integer,	
	@startdate  datetime,
	@enddate  datetime

)
AS
	SET NOCOUNT ON;
Declare @StatusCodeEnd as int
if @StatusCode = 0 -- ALL
	Begin
		set @StatusCode = 0 --for clarity
		set @StatusCodeEnd = 4
	End
ELSE 
IF @StatusCode = 1 --Active Opportunities
	Begin
		set @StatusCode = 0
		set @StatusCodeEnd = 2
	End
ELSE 
	set @StatusCodeEnd = @StatusCode

	SELECT	o.*,
		customers.Customer as [Group Name],
		customers.[Preferred Phone],
		customers.Ext,
		u.Fullname as [Owning User]
	FROM	FundraiserBase as o
		Left Outer Join SystemUserBase u	On o.OwningUser = u.SystemUserId
		Left Outer Join (select contactid as CustomerID, 
						Fullname as Customer,
						Case PreferredPhoneCode
							When '0' Then BusinessPhone
							When '1' Then HomePhone
							When '2' then MobilePhone
							when '3' then OtherPhone
						end as [Preferred Phone],
						Case PreferredPhoneCode
							When '0' Then BusinessPhoneExt
							When '1' Then ''
							When '2' then ''
							when '3' then OtherPhoneExt
						end as [Ext]
					From contactbase 
					union 
					select Groupid,
						GroupName,
						MainPhone,
						MainPhoneExt
					From GroupBase) as customers	On o.GroupID = customers.CustomerID
	WHERE ((o.StatusCode >= @StatusCode And o.StatusCode <= @StatusCodeEnd) AND (o.CreatedOn >= @startdate AND o.CreatedOn <= @enddate))And DeletionStatusCode <> 1
	ORDER BY customers.Customer



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_NoteBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_NoteBase_Delete]
(
	@Original_NoteID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_OwningUser uniqueidentifier,
	@Original_ParentID uniqueidentifier,
	@Original_Subject nvarchar(500)
)
AS
	SET NOCOUNT OFF;
DELETE FROM NoteBase WHERE (NoteID = @Original_NoteID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_FAInvSelectByGroupID]'
GO
CREATE PROCEDURE [dbo].[FRP_InvoiceBase_FAInvSelectByGroupID]
	(
	@ParentID as uniqueidentifier
)
AS
SELECT	InvoiceId,
	InvoiceNumber as [Invoice Number],
	Name,
	DocumentDate,
	Case InvoiceStage
		WHEN '0' THEN 'Order Received'
		WHEN '1' THEN 'Billed'
		WHEN '2' THEN 'Paid'
	End As [Invoice Stage],
	TotalAmount as [Total Amount]
FROM InvoiceBase
WHERE GroupID = @ParentId And DeletionStatusCode <> 1 And StatusCode = 0
ORDER BY InvoiceNumber DESC






GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FutureSalesChecklist_HomeAddressView]'
GO
CREATE VIEW dbo.FutureSalesChecklist_HomeAddressView
AS
SELECT     AddressID, AddressTypeCode, ParentID, AddressName, PrimaryContactName, Street1, Street2, Street3, City, State, ZipCode, FreightTermsCode, Latitude, Longitude, 
                      ShippingMethod, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, Fax, PrimaryAddressCode, DeletionStateCode, Notes, MapLink, MapGridID
FROM         dbo.CustomerAddressBase
WHERE     (PrimaryAddressCode = 1)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_UofMScheduleDetailBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_UofMScheduleDetailBase_Select]
AS
	SET NOCOUNT ON;
SELECT UoMId,
Name,
Quantity,
UoMScheduleId,
IsScheduleBaseUoM,
UofM,
Eqivalent,
DeletionStateCode,
CreatedOn,
CreatedBy,
ModifiedBy,
ModifiedOn
FROM UofMScheduleDetailBase
ORDER BY Quantity


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_SelectByInvoiceId]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceBase_SelectByInvoiceId]
(
	@InvoiceID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT * FROM InvoiceBase WHERE (InvoiceId = @InvoiceID)




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_GridSelectDateRange]'
GO

/*
If @StatusCode is -1 then all records are returned
If @StatusCode is 0 then Active records are returned
If @StatusCode is 1 then Inactive records are returned
IF @Deliveries is 0 then all record types are returned
IF @Deliveries is 1 then only deliveries are returned
IF @SystemUserID is NULL then all records are returned
*/
CREATE PROCEDURE [dbo].[FRP_ActivityBase_GridSelectDateRange]
(
	@SystemUserID uniqueidentifier,
	@Deliveries as int,
	@StatusCode as int,
	@StartDate as datetime,
	@EndDate as datetime
)
AS
	SET NOCOUNT ON;
Declare @StatusCodeEnd as int
if @StatusCode =-1
	Begin
		set @StatusCode = 0
		set @StatusCodeEnd = 4
	End
else
if @StatusCode = 0
	Begin
		set @StatusCode = 0
		set @StatusCodeEnd = 0
	End
else
if @StatusCode = 1
	Begin
		set @StatusCode = 1
		set @StatusCodeEnd = 1
	End
else
	set @StatusCodeEnd = @StatusCode



If @SystemUserID IS NOT NULL
BEGIN
	SELECT 
		a.*,
		u.FullName as [Owning User]
	FROM ActivityBase a
		Left Outer Join SystemUserBase u 	On a.OwningUser = u.SystemUserId
	Where (@Deliveries <> 0 AND (a.OwningUser = @SystemUserID AND a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd AND a.ScheduledStartDate >= @StartDate And a.ScheduledStartDate <= @EndDate))
		or (@Deliveries = 1 AND (a.OwningUser = @SystemUserID AND a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd AND a.ScheduledStartDate >= @StartDate And a.ScheduledStartDate <= @EndDate AND ActivityTypeCode = 2))
	Order By ScheduledStartDate DESC
END
ELSE
BEGIN
	SELECT 
		a.*,
		u.FullName as [Owning User]
	FROM ActivityBase a
		Left Outer Join SystemUserBase u 	On a.OwningUser = u.SystemUserId
	Where (@Deliveries <> 1 AND (a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd AND a.ScheduledStartDate >= @StartDate And a.ScheduledStartDate <= @EndDate))
		or (@Deliveries = 1 AND (a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd AND a.ScheduledStartDate >= @StartDate And a.ScheduledStartDate <= @EndDate AND ActivityTypeCode = 2))	
	Order By ScheduledStartDate DESC
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_CustomerNameSelectByID]'
GO

CREATE  PROCEDURE [dbo].[FRP_GroupBase_CustomerNameSelectByID]
(
	@CustomerID as uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT	CustomerID,
	CustomerName
FROM	(SELECT GroupId as CustomerID, GroupName as CustomerName FROM GroupBase
	UNION
	Select SystemUserID, FullName FROM SystemUserBase) as Customer
WHERE Customer.CustomerID = @CustomerID




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQuantitySold]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdateQuantitySold] 
	(
@UseDates bit,
@StartDate datetime,
@EndDate datetime
)
AS
BEGIN
		SET NOCOUNT ON;
Declare @ProductID uniqueidentifier
Declare @QuantitySold integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
IF @UseDates = 0
BEGIN	
	Set @QuantitySold = (Select SUM(idb.Quantity) as TotalQuantity 
						FROM InvoiceBase i Left Outer Join InvoiceDetailBase idb  On i.InvoiceID= idb.InvoiceID
						WHERE idb.ProductID = @ProductID AND i.InvoiceStage > 0 And i.StatusCode <> 2 AND i.DeletionStatusCode <> 1) 
Update ProductBase Set QuantitySold = isNull(@QuantitySold,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END
ELSE IF @UseDates = 1
BEGIN		
Set @QuantitySold = (Select SUM(idb.Quantity) as TotalQuantity 
						FROM InvoiceBase i Left Outer Join InvoiceDetailBase idb  On i.InvoiceID= idb.InvoiceID
						WHERE idb.ProductID = @ProductID AND i.DocumentDate >= @StartDate AND i.DocumentDate <=@EndDate AND i.InvoiceStage > 0 And i.StatusCode <> 2 AND i.DeletionStatusCode <> 1) 
Update ProductBase Set QuantitySold = isNull(@QuantitySold,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END
END
CLOSE Product_Cursor 
DEALLOCATE Product_Cursor 
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQOHCanceledInvoice]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdateQOHCanceledInvoice]
(
@InvoiceID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;
Declare @ProductID uniqueidentifier
Declare @DeliveredQuantity integer
Declare @QOHValue integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
ORDER BY ProductNumber
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
Set @QOHValue = (Select SUM(pb.QuantityOnHand) as TotalQOH 
				FROM ProductBase pb
				WHERE pb.ProductID = @ProductID)
Set @DeliveredQuantity = (Select SUM(idb.Quantity) as TotalQuantity 
						FROM InvoiceBase i Left Outer Join InvoiceDetailBase idb  On i.InvoiceID= idb.InvoiceID
						WHERE idb.InvoiceID = @InvoiceID AND idb.ProductID = @ProductID)
Update ProductBase Set QuantityOnHand = @QOHValue + isNull(@DeliveredQuantity,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor
INTO @ProductID
END
CLOSE Product_Cursor
DEALLOCATE Product_Cursor
End


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CompanyBase]'
GO
CREATE TABLE [dbo].[CompanyBase]
(
[CompanyID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_CompanyBase_CompanyID] DEFAULT (newid()),
[Name] [nvarchar] (160) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WebsiteURL] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessPhoneExt] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhoneExt] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_CompanyBase] on [dbo].[CompanyBase]'
GO
ALTER TABLE [dbo].[CompanyBase] ADD CONSTRAINT [PK_CompanyBase] PRIMARY KEY CLUSTERED  ([CompanyID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_SelectByGroupID]'
GO
CREATE PROCEDURE [dbo].[FRP_ActivityBase_SelectByGroupID]
(
	@GroupID uniqueidentifier
)
AS
SELECT a.*,
	Case ActivityTypeCode
		WHEN '1' Then 'Appointment'
		WHEN '2' Then 'Delivery'
		WHEN '4' Then 'Phone Call'
		WHEN '8' Then 'Print Fliers'
		WHEN '16' Then 'Scheduled Email'
		WHEN '32' Then 'Task'
		WHEN '64' Then 'Thank You'
	End As [Activity Type],
	Case PrimaryDelivery
		WHEN 'True' Then 'True'
		WHEN 'False' Then 'False'
		ELSE 'False'
	End As [Primary Delivery],
	g.GroupName,
	f.Topic,
	c.FullName As [Primary Contact],
    u.DisplayName As [Owning User]
FROM ActivityBase a
		Left Outer Join SystemUserBase u On a.OwningUser = u.SystemUserId
		Left Outer Join GroupBase g On a.GroupId = g.GroupId
 		Left Outer Join ContactBase c On a.ContactId = c.ContactId
		Left Outer Join FundraiserBase f On a.FundraiserId = f.FundraiserId
Where a.GroupID = @GroupID













GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_PrimaryAddressDelete]'
GO

CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_PrimaryAddressDelete]
(
	@Original_AddressID uniqueidentifier,
	@Original_AddressName nvarchar(200),
	@Original_AddressTypeCode int,
	@Original_City nvarchar(50),
	@Original_DeletionStateCode int,
	@Original_Fax nvarchar(50),
	@Original_FreightTermsCode int,
	@Original_Latitude float,
	@Original_Longitude float,
	@Original_MainPhone nvarchar(50),
	@Original_MainPhoneExt nvarchar(10),
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(10),
	@Original_ParentID uniqueidentifier,
	@Original_PrimaryAddressCode int,
	@Original_PrimaryContactName nvarchar(150),
	@Original_ShippingMethod nvarchar(200),
	@Original_State nvarchar(50),
	@Original_Street1 nvarchar(50),
	@Original_Street2 nvarchar(50),
	@Original_Street3 nvarchar(50),
	@Original_ZipCode nvarchar(20)
)
AS
	SET NOCOUNT OFF;
DELETE FROM CustomerAddressBase WHERE (AddressID = @Original_AddressID)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_DefaultBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_DefaultBase_Delete]
(
	@Original_DefaultId uniqueidentifier,
	@Original_Code bigint,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DefaultName nvarchar(50),
	@Original_DefaultSubName nvarchar(50),
	@Original_DefaultText nvarchar(50),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Ordinal bigint
)
AS
	SET NOCOUNT OFF;
DELETE FROM DefaultBase WHERE (DefaultId = @Original_DefaultId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FundraiserProductClassBase]'
GO
CREATE TABLE [dbo].[FundraiserProductClassBase]
(
[FundraiserProductClassID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_OpportunityProductClassBase_OpportunityProductClassID] DEFAULT (newid()),
[FundraiserID] [uniqueidentifier] NOT NULL,
[ProductClassID] [uniqueidentifier] NOT NULL,
[Quantity] [decimal] (18, 0) NULL,
[Posters] [int] NULL,
[Fliers] [int] NULL,
[Goal] [int] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[ProductClassName] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_FundraiserProductClassBase] on [dbo].[FundraiserProductClassBase]'
GO
ALTER TABLE [dbo].[FundraiserProductClassBase] ADD CONSTRAINT [PK_FundraiserProductClassBase] PRIMARY KEY CLUSTERED  ([FundraiserProductClassID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserProductClassBase_GetByFundraiserID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_FundraiserProductClassBase_GetByFundraiserID] 
	(
	@FundraiserID uniqueidentifier
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT f.*,
	   p.Name as [Product Class]
FROM FundraiserProductClassBase f
	Left Outer Join ProductClassBase p On f.ProductClassId = p.ProductClassId
Where FundraiserID = @FundraiserID
ORDER BY p.Name
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SampleBase]'
GO
CREATE TABLE [dbo].[SampleBase]
(
[SampleID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_SampleBase_SampleID] DEFAULT (newid()),
[SampleDate] [datetime] NULL,
[GroupID] [uniqueidentifier] NULL,
[GroupTypeCode] [int] NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalQuantity] [int] NULL,
[OwningUser] [uniqueidentifier] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_SampleBase] on [dbo].[SampleBase]'
GO
ALTER TABLE [dbo].[SampleBase] ADD CONSTRAINT [PK_SampleBase] PRIMARY KEY CLUSTERED  ([SampleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_Insert]
(
	@FundraiserID uniqueidentifier,
	@GroupId uniqueidentifier,
	@GroupTypeCode int,
	@FundraiserRatingCode int,
	@PriorityCode int,
	@Topic nvarchar(300),
	@Description ntext,
	@SalesStageCode int,
	@StatusCode int,
	@GroupSize int,
	@GroupType nvarchar(200),
	@GroupGoal money,
	@FundsFor nvarchar(500),
	@StartOn datetime,
	@CallinOrderBy datetime,
	@ReturnOrderBy datetime,
	@StatusReasonCode int,
	@FollowUpCode int,
	@MakeChecksTo nvarchar(75),
	@GoalInformation nvarchar(1000),
	@DeletionStatusCode int,
	@OwningUser uniqueidentifier,
	@SalesPersonID uniqueidentifier,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
	
)
AS
	SET NOCOUNT OFF;
INSERT INTO FundraiserBase(FundraiserID, GroupId, GroupTypeCode, FundraiserRatingCode, PriorityCode, Topic, Description, SalesStageCode, StatusCode, GroupSize, GroupType, GroupGoal, FundsFor, StartOn, CallinOrderBy, ReturnOrderBy, StatusReasonCode, FollowUpCode, MakeChecksTo, GoalInformation, DeletionStatusCode, OwningUser, SalesPersonID, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@FundraiserID, @GroupId, @GroupTypeCode, @FundraiserRatingCode, @PriorityCode, @Topic, @Description, @SalesStageCode, @StatusCode, @GroupSize, @GroupType, @GroupGoal, @FundsFor, @StartOn, @CallinOrderBy, @ReturnOrderBy, @StatusReasonCode, @FollowUpCode, @MakeChecksTo, @GoalInformation, @DeletionStatusCode, @OwningUser, @SalesPersonID, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT FundraiserID, GroupId, GroupTypeCode, FundraiserRatingCode, PriorityCode, Topic, Description, SalesStageCode, StatusCode, GroupSize, GroupType, GroupGoal, FundsFor, StartOn, CallinOrderBy, ReturnOrderBy, StatusReasonCode, FollowUpCode, MakeChecksTo, GoalInformation, DeletionStatusCode, OwningUser, SalesPersonID, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM FundraiserBase WHERE (FundraiserID = @FundraiserID)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[NoteBaseView]'
GO
CREATE VIEW dbo.NoteBaseView
AS
SELECT     dbo.NoteBase.NoteID, dbo.NoteBase.Subject, dbo.NoteBase.NoteText, 
                      CASE WHEN dbo.NoteBase.DeletionStateCode = 0 THEN 'Active' WHEN dbo.NoteBase.DeletionStateCode = 1 THEN 'Inactive' END AS Status, 
                      ParentItem.ParentID, ParentItem.ParentName, ParentItem.ParentType, dbo.SystemUserBase.DisplayName AS OwningUser, dbo.NoteBase.CreatedOn, 
                      dbo.NoteBase.CreatedBy, dbo.NoteBase.ModifiedOn, dbo.NoteBase.ModifiedBy
FROM         (SELECT     ContactId AS ParentID, FullName AS ParentName, '1' AS ParentType
                       FROM          dbo.ContactBase
                       UNION
                       SELECT     GroupId, GroupName, '0' AS Expr1
                       FROM         dbo.GroupBase
                       UNION
                       SELECT     InvoiceId, Name, '5' AS Expr1
                       FROM         dbo.InvoiceBase
                       UNION
                       SELECT     FundraiserID, Topic, '4' AS Expr1
                       FROM         dbo.FundraiserBase) AS ParentItem RIGHT OUTER JOIN
                      dbo.NoteBase LEFT OUTER JOIN
                      dbo.SystemUserBase ON dbo.NoteBase.OwningUser = dbo.SystemUserBase.SystemUserId ON ParentItem.ParentID = dbo.NoteBase.ParentID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceDetailBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceDetailBase_Insert]
(
	@InvoiceDetailID uniqueidentifier,
	@InvoiceID uniqueidentifier,
	@DeletionStateCode int,
	@SalesRepID uniqueidentifier,
	@DeliveryRepID uniqueidentifier,
	@LineItemNumber int,
	@UofMID uniqueidentifier,
	@ProductID uniqueidentifier,
	@ProductNumber nvarchar(50),
	@ProductDescription ntext,
	@Quantity decimal(18),
	@PricePerUnit money,
	@PriceOverride bit,
	@BaseAmount money,
	@ExtendedAmount money,
	@ManualDiscountAmount money,
	@Tax money
)
AS
	SET NOCOUNT OFF;
INSERT INTO InvoiceDetailBase(InvoiceDetailID, InvoiceID, DeletionStateCode, SalesRepID, DeliveryRepID, LineItemNumber, UofMID, ProductID, ProductNumber, ProductDescription, Quantity, PricePerUnit, PriceOverride, BaseAmount, ExtendedAmount, ManualDiscountAmount, Tax) VALUES (@InvoiceDetailID, @InvoiceID, @DeletionStateCode, @SalesRepID, @DeliveryRepID, @LineItemNumber, @UofMID, @ProductID, @ProductNumber, @ProductDescription, @Quantity, @PricePerUnit, @PriceOverride, @BaseAmount, @ExtendedAmount, @ManualDiscountAmount, @Tax);
	SELECT InvoiceDetailID, InvoiceID, DeletionStateCode, SalesRepID, DeliveryRepID, LineItemNumber, UofMID, ProductID, ProductNumber, ProductDescription, Quantity, PricePerUnit, PriceOverride, BaseAmount, ExtendedAmount, ManualDiscountAmount, Tax FROM InvoiceDetailBase WHERE (InvoiceDetailID = @InvoiceDetailID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQuantityLeftToBuy]'
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdateQuantityLeftToBuy]
AS
BEGIN
	SET NOCOUNT ON;
Declare @ProductID uniqueidentifier
Declare @QtyLeftToBuy integer
DECLARE @QtyForecasted integer
DECLARE @QtyAllocated integer
DECLARE @QtyOnHand integer
DECLARE @QtyOrdered integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN

	Set @QtyForecasted = (SELECT  QuantityFundForecasted As QFF FROM ProductBase pb1 WHERE pb1.ProductID = @ProductID)
	Set @QtyAllocated = (SELECT  QuantityAllocated FROM ProductBase pb2 WHERE pb2.ProductID = @ProductID)
	Set @QtyOnHand = (SELECT  QuantityOnHand FROM ProductBase pb3 WHERE pb3.ProductID = @ProductID)
	Set @QtyOrdered = (SELECT  QuantityOrdered FROM ProductBase pb4 WHERE pb4.ProductID = @ProductID)
	UPDATE ProductBase SET QtyLeftToBuy = isNull(isNull(@QtyForecasted,0) + isNull(@QtyAllocated,0) - isNull(@QtyOnHand,0) - isNull(@QtyOrdered,0),0)

Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END

CLOSE Product_Cursor 
DEALLOCATE Product_Cursor 
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceDetailBase_DeleteFromGrid]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_InvoiceDetailBase_DeleteFromGrid]
	(
	@Original_InvoiceDetailID uniqueidentifier
)
AS
BEGIN
	
	SET NOCOUNT OFF;
DELETE FROM InvoiceDetailBase WHERE (InvoiceDetailID = @Original_InvoiceDetailID)

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_GridSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_SystemUserBase_GridSelect]
AS
	SET NOCOUNT ON;
-- Updates the integrety of PreferredPhoneCode so that it doesn't point to a null
--UPDATE SystemUserBase Set PreferredPhoneCode = 1
--Where  PreferredPhoneCode = 0 and HomePhone Is NULL and MobilePhone Is NOT NULL
--UPDATE SystemUserBase Set PreferredPhoneCode = 0
--Where  PreferredPhoneCode = 1 and MobilePhone Is NULL and HomePhone Is NOT NULL
SELECT	SystemUserId
	, FullName as [Name]
	, DeletionStateCode as Status
	, BusinessPhone as [Business Phone]
	, BusinessPhoneExt as Ext
FROM	SystemUserBase
Where DeletionStateCode <> 100
ORDER BY LastName, FirstName


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQOHInventoryAdj]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdateQOHInventoryAdj]
(
@InventoryAdjustmentID uniqueidentifier
)
AS
	SET NOCOUNT ON;
Declare @ProductID uniqueidentifier
Declare @AdjustmentQuantity integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
ORDER BY ProductNumber
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
Set @AdjustmentQuantity = (Select SUM(CountedQuantity) FROM InventoryAdjustmentDetailBase
				WHERE InventoryAdjustmentDetailID IN
					   (Select Top 1 InventoryAdjustmentDetailID From InventoryAdjustmentBase ia 
						Left Outer Join InventoryAdjustmentDetailBase iad On ia.InventoryAdjustmentID = iad.InventoryAdjustmentID
						WHERE iad.InventoryAdjustmentID = @InventoryAdjustmentID AND iad.ProductID = @ProductID And ia.Stage = 1 AND ia.Status = 1 And ia.DeletionStateCode <> 1
						ORDER By  InventoryAdjNumber DESC,StartDate DESC, ia.ModifiedOn DESC))

Update ProductBase Set QuantityOnHand =  isNULL(@AdjustmentQuantity,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor
INTO @ProductID
END
CLOSE Product_Cursor
DEALLOCATE Product_Cursor




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_Update]
(
	@FundraiserID uniqueidentifier,
	@GroupId uniqueidentifier,
	@GroupTypeCode int,
	@FundraiserRatingCode int,
	@PriorityCode int,
	@Topic nvarchar(300),
	@Description ntext,
	@SalesStageCode int,
	@StatusCode int,
	@GroupSize int,
	@GroupType nvarchar(200),
	@GroupGoal money,
	@FundsFor nvarchar(500),
	@StartOn datetime,
	@CallinOrderBy datetime,
	@ReturnOrderBy datetime,
	@StatusReasonCode int,
	@FollowUpCode int,
	@MakeChecksTo nvarchar(75),
	@GoalInformation nvarchar(1000),
	@DeletionStatusCode int,
	@OwningUser uniqueidentifier,
	@SalesPersonID uniqueidentifier,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_FundraiserID uniqueidentifier,
	@Original_CallinOrderBy datetime,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_GroupId uniqueidentifier,
	@Original_GroupTypeCode int,
	@Original_DeletionStatusCode int,
	@Original_FollowUpCode int,
	@Original_FundsFor nvarchar(500),
	@Original_GoalInformation nvarchar(1000),
	@Original_GroupGoal money,
	@Original_GroupSize int,
	@Original_GroupType nvarchar(200),
	@Original_MakeChecksTo nvarchar(75),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_FundraiserRatingCode int,
	@Original_OwningUser uniqueidentifier,
	@Original_PriorityCode int,
	@Original_ReturnOrderBy datetime,
	@Original_SalesPersonID uniqueidentifier,
	@Original_SalesStageCode int,
	@Original_StartOn datetime,
	@Original_StatusCode int,
	@Original_StatusReasonCode int,
	@Original_Topic nvarchar(300)
)
AS
	SET NOCOUNT OFF;
UPDATE FundraiserBase SET FundraiserID = @FundraiserID, GroupId = @GroupId, GroupTypeCode = @GroupTypeCode, FundraiserRatingCode = @FundraiserRatingCode, PriorityCode = @PriorityCode, Topic = @Topic, Description = @Description, SalesStageCode = @SalesStageCode, StatusCode = @StatusCode, GroupSize = @GroupSize, GroupType = @GroupType, GroupGoal = @GroupGoal, FundsFor = @FundsFor, StartOn = @StartOn, CallinOrderBy = @CallinOrderBy, ReturnOrderBy = @ReturnOrderBy, StatusReasonCode = @StatusReasonCode, FollowUpCode = @FollowUpCode, MakeChecksTo = @MakeChecksTo, GoalInformation = @GoalInformation, DeletionStatusCode = @DeletionStatusCode, OwningUser = @OwningUser, SalesPersonID = @SalesPersonID, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (FundraiserID = @Original_FundraiserID);
	SELECT FundraiserID, GroupId, GroupTypeCode, FundraiserRatingCode, PriorityCode, Topic, Description, SalesStageCode, StatusCode, GroupSize, GroupType, GroupGoal, FundsFor, StartOn, CallinOrderBy, ReturnOrderBy, StatusReasonCode, FollowUpCode, MakeChecksTo, GoalInformation, DeletionStatusCode, OwningUser, SalesPersonID, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM FundraiserBase WHERE (FundraiserID = @FundraiserID)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_GridSelectDateRange]'
GO

/*
If StatusCode is 0 then all records are returned
SearchText will find firstnames and lastnames beginning with that text
*/
CREATE PROCEDURE [dbo].[FRP_GroupBase_GridSelectDateRange]
(
	@StatusCode as int,
	@StartDate as datetime,
	@EndDate as datetime	
)
AS
	SET NOCOUNT ON;
Declare @StatusCodeEnd as int
if @StatusCode = 0
	set @StatusCodeEnd = 4
else
if @StatusCode = 1
	BEGIN
		set	@StatusCode = 0
		set @StatusCodeEnd = 0
	END
if @StatusCode = 2
	BEGIN
		set	@StatusCode = 1
		set @StatusCodeEnd = 1
	END	
else
	set @StatusCodeEnd = @StatusCode

	SELECT	a.*,
		c.FullName as [Primary Contact],
		u.Fullname as [Owning User]
	FROM	GroupBase a 
		Left Outer Join SystemUserBase u	On a.OwningUser = u.SystemUserId
		Left Outer Join ContactBase c 		On a.PrimaryContactId = c.ContactId
	Where a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd		
			AND a.CreatedOn >= @StartDate And a.CreatedOn <= @EndDate And a.DeletionStateCode <> 1
	ORDER BY GroupName





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_GridSelect]'
GO

/*
UserId is owning user, if null then ignores
If StatusCode is 0 then all records are returned
SearchText will find firstnames and lastnames beginning with that text
*/
CREATE PROCEDURE [dbo].[FRP_GroupBase_GridSelect]
(
	@UserId as uniqueidentifier,
	@SearchText as nvarchar(50),
	@StatusCode as int
)
AS
	SET NOCOUNT ON;
Declare @StatusCodeEnd as int
if @StatusCode = 0
	set @StatusCodeEnd = 4
else
if @StatusCode = 1
	BEGIN
		set	@StatusCode = 0
		set @StatusCodeEnd = 0
	END
if @StatusCode = 2
	BEGIN
		set	@StatusCode = 1
		set @StatusCodeEnd = 1
	END	
else
	set @StatusCodeEnd = @StatusCode
if @SearchText = '' 
begin
	SELECT	GroupId,
		GroupName as [Group Name],
		c.FullName as [Primary Contact],
		MainPhone as [Main Phone],
		MainPhoneExt as [Ext],
		u.Fullname as [Owning User],
		a.StatusCode,
		a.CreatedOn,
		a.ModifiedOn,
		GroupCategoryCode
	FROM	GroupBase a 
		Left Outer Join SystemUserBase u	On a.OwningUser = u.SystemUserId
		Left Outer Join ContactBase c 		On a.PrimaryContactId = c.ContactId
	Where (@UserId is NOT NULL AND a.OwningUser = @UserId AND (a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd))
		OR (@UserId is NULL AND (a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd))
	ORDER BY GroupName
end
else
begin
set @SearchText = '%' + @SearchText + '%'
	SELECT	GroupId,
		GroupName as [Group Name],
		c.FullName as [Primary Contact],
		MainPhone as [Main Phone],
		MainPhoneExt as [Ext],
		u.Fullname as [Owning User],
		a.StatusCode,
		a.CreatedOn,
		a.ModifiedOn,
		GroupCategoryCode
	FROM	GroupBase a 
		Left Outer Join SystemUserBase u	On a.OwningUser = u.SystemUserId
		Left Outer Join ContactBase c 		On a.PrimaryContactId = c.ContactId
	Where (@UserId is NOT NULL AND a.OwningUser = @UserId AND (a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd) AND (a.GroupName Like @SearchText))
		OR (@UserId is NULL AND (a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd) AND (a.GroupName Like @SearchText))
	ORDER BY GroupName
end


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserDetailBase_DeleteDetailAndProductClass]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserDetailBase_DeleteDetailAndProductClass]
(
	@FundraiserID uniqueidentifier
)
AS
SET NOCOUNT ON;
Delete From FundraiserDetailBase Where FundraiserID = @FundraiserID
Delete From FundraiserProductClassBase Where FundraiserID = @FundraiserID



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_CustomerPreferredPhoneLookup]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupBase_CustomerPreferredPhoneLookup]
(
	@PersonID as uniqueidentifier,
	@RecordType as int
)
AS

IF @RecordType = 1 -- Contact
	Begin
		select contactid, 
		Case PreferredPhoneCode
			When '1' Then BusinessPhone
			When '2' Then HomePhone
			When '3' then MobilePhone
			when '4' then OtherPhone
		end as [Preferred Phone],
		Case PreferredPhoneCode
			When '1' Then BusinessPhoneExt
			When '2' Then ''
			When '3' then ''
			when '4' then OtherPhoneExt
		end as [Ext]
		From contactbase 
		Where ContactID = @PersonID	
	end 
ELSE
IF @RecordType = 0 -- Group
	Begin
		select Groupid,
			MainPhone as [Preferred Phone],
			MainPhoneExt as Ext
		From GroupBase
		Where GroupID = @PersonID
	end 
ELSE
IF @RecordType = 3 -- User
	Begin
		SELECT SystemUserId,
		Case PreferredPhoneCode
			When '0' Then BusinessPhone
			When '1' Then HomePhone
			When '2' then MobilePhone
			when '3' then OtherPhone
		end as [Preferred Phone],
		Case PreferredPhoneCode
			When '0' Then BusinessPhoneExt
			When '1' Then ''
			When '2' then ''
			when '3' then OtherPhoneExt
		end as [Ext]
		FROM SystemUserBase
		Where SystemUserID = @PersonID
	End




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupTypeBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupTypeBase_Select]
AS
	SET NOCOUNT ON;
SELECT GroupTypeID, Name, Code, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy 
FROM GroupTypeBase 
ORDER BY Name


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_PrimaryAddressInsert]'
GO

CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_PrimaryAddressInsert]
(
	@AddressID uniqueidentifier,
	@AddressTypeCode int,
	@ParentID uniqueidentifier,
	@AddressName nvarchar(200),
	@PrimaryContactName nvarchar(150),
	@Street1 nvarchar(50),
	@Street2 nvarchar(50),
	@Street3 nvarchar(50),
	@City nvarchar(50),
	@State nvarchar(50),
	@ZipCode nvarchar(20),
	@FreightTermsCode int,
	@Latitude float,
	@Longitude float,
	@ShippingMethod nvarchar(200),
	@MainPhone nvarchar(50),
	@MainPhoneExt nvarchar(10),
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(10),
	@Fax nvarchar(50),
	@PrimaryAddressCode int,
	@DeletionStateCode int
)
AS
	SET NOCOUNT OFF;
INSERT INTO CustomerAddressBase(AddressID, AddressTypeCode, ParentID, AddressName, PrimaryContactName, Street1, Street2, Street3, City, State, ZipCode, FreightTermsCode, Latitude, Longitude, ShippingMethod, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, Fax, PrimaryAddressCode, DeletionStateCode) VALUES (@AddressID, @AddressTypeCode, @ParentID, @AddressName, @PrimaryContactName, @Street1, @Street2, @Street3, @City, @State, @ZipCode, @FreightTermsCode, @Latitude, @Longitude, @ShippingMethod, @MainPhone, @MainPhoneExt, @OtherPhone, @OtherPhoneExt, @Fax, @PrimaryAddressCode, @DeletionStateCode);
	SELECT AddressID, AddressTypeCode, ParentID, AddressName, PrimaryContactName, Street1, Street2, Street3, City, State, ZipCode, FreightTermsCode, Latitude, Longitude, ShippingMethod, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, Fax, PrimaryAddressCode, DeletionStateCode FROM CustomerAddressBase WHERE (AddressID = @AddressID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_DefaultBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_DefaultBase_Select]
AS
	SET NOCOUNT ON;
SELECT DefaultId, DefaultName, DefaultSubName, Code, DefaultText, Ordinal, ModifiedOn, ModifiedBy, CreatedOn, CreatedBy FROM DefaultBase



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_NoteBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_NoteBase_Select]
(
	@NoteID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT NoteID, ParentID, Subject, NoteText, DeletionStateCode, OwningUser, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM NoteBase WHERE (NoteID = @NoteID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_ContactBase_Update]
(
	@ContactId uniqueidentifier,
	@ParentgroupID uniqueidentifier,
	@Anniversary datetime,
	@AssistantName nvarchar(100),
	@AssistantPhone nvarchar(50),
	@AssistantPhoneExt nvarchar(5),
	@BirthDate datetime,
	@BusinessPhone nvarchar(50),
	@BusinessPhoneExt nvarchar(5),
	@ContactRole nvarchar(50),
	@CreditOnHold bit,
	@DeletionStateCode int,
	@Department nvarchar(100),
	@DescriptionInfo ntext,
	@DoNotBulkEMail bit,
	@DoNotBulkPostalMail bit,
	@DoNotEMail bit,
	@DoNotFax bit,
	@DoNotPhone bit,
	@DoNotPostalMail bit,
	@EMailAddress1 nvarchar(100),
	@EMailAddress2 nvarchar(100),
	@EMailAddress3 nvarchar(100),
	@FamilyStatusCode int,
	@Fax nvarchar(50),
	@FirstName nvarchar(50),
	@FreightTermsCode int,
	@FullName nvarchar(160),
	@GenderCode int,
	@HasChildrenCode int,
	@HomePhone nvarchar(50),
	@JobTitle nvarchar(100),
	@LastName nvarchar(50),
	@ManagerName nvarchar(100),
	@ManagerPhone nvarchar(50),
	@ManagerPhoneExt nvarchar(10),
	@MaritalStatus nvarchar(50),
	@MiddleName nvarchar(50),
	@MobilePhone nvarchar(50),
	@NickName nvarchar(50),
	@NumberOfChildren int,
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(10),
	@OwningUser uniqueidentifier,
	@PaymentTerms nvarchar(200),
	@PreferredContactMethodCode int,
	@PreferredPhoneCode int,
	@Salutation nvarchar(100),
	@ShippingMethod nvarchar(200),
	@SpousesName nvarchar(100),
	@StatusCode int,
	@Suffix nvarchar(10),
	@WebSiteUrl nvarchar(200),
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_ContactId uniqueidentifier,
	@Original_Anniversary datetime,
	@Original_AssistantName nvarchar(100),
	@Original_AssistantPhone nvarchar(50),
	@Original_AssistantPhoneExt nvarchar(5),
	@Original_BirthDate datetime,
	@Original_BusinessPhone nvarchar(50),
	@Original_BusinessPhoneExt nvarchar(5),
	@Original_ContactRole nvarchar(50),
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_CreditOnHold bit,
	@Original_DeletionStateCode int,
	@Original_Department nvarchar(100),
	@Original_DoNotBulkEMail bit,
	@Original_DoNotBulkPostalMail bit,
	@Original_DoNotEMail bit,
	@Original_DoNotFax bit,
	@Original_DoNotPhone bit,
	@Original_DoNotPostalMail bit,
	@Original_EMailAddress1 nvarchar(100),
	@Original_EMailAddress2 nvarchar(100),
	@Original_EMailAddress3 nvarchar(100),
	@Original_FamilyStatusCode int,
	@Original_Fax nvarchar(50),
	@Original_FirstName nvarchar(50),
	@Original_FreightTermsCode int,
	@Original_FullName nvarchar(160),
	@Original_GenderCode int,
	@Original_HasChildrenCode int,
	@Original_HomePhone nvarchar(50),
	@Original_JobTitle nvarchar(100),
	@Original_LastName nvarchar(50),
	@Original_ManagerName nvarchar(100),
	@Original_ManagerPhone nvarchar(50),
	@Original_ManagerPhoneExt nvarchar(10),
	@Original_MaritalStatus nvarchar(50),
	@Original_MiddleName nvarchar(50),
	@Original_MobilePhone nvarchar(50),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_NickName nvarchar(50),
	@Original_NumberOfChildren int,
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(10),
	@Original_OwningUser uniqueidentifier,
	@Original_ParentgroupID uniqueidentifier,
	@Original_PaymentTerms nvarchar(200),
	@Original_PreferredContactMethodCode int,
	@Original_PreferredPhoneCode int,
	@Original_Salutation nvarchar(100),
	@Original_ShippingMethod nvarchar(200),
	@Original_SpousesName nvarchar(100),
	@Original_StatusCode int,
	@Original_Suffix nvarchar(10),
	@Original_WebSiteUrl nvarchar(200)
)
AS
	SET NOCOUNT OFF;
UPDATE ContactBase SET ContactId = @ContactId, ParentgroupID = @ParentgroupID, Anniversary = @Anniversary, AssistantName = @AssistantName, AssistantPhone = @AssistantPhone, AssistantPhoneExt = @AssistantPhoneExt, BirthDate = @BirthDate, BusinessPhone = @BusinessPhone, BusinessPhoneExt = @BusinessPhoneExt, ContactRole = @ContactRole, CreditOnHold = @CreditOnHold, DeletionStateCode = @DeletionStateCode, Department = @Department, DescriptionInfo = @DescriptionInfo, DoNotBulkEMail = @DoNotBulkEMail, DoNotBulkPostalMail = @DoNotBulkPostalMail, DoNotEMail = @DoNotEMail, DoNotFax = @DoNotFax, DoNotPhone = @DoNotPhone, DoNotPostalMail = @DoNotPostalMail, EMailAddress1 = @EMailAddress1, EMailAddress2 = @EMailAddress2, EMailAddress3 = @EMailAddress3, FamilyStatusCode = @FamilyStatusCode, Fax = @Fax, FirstName = @FirstName, FreightTermsCode = @FreightTermsCode, FullName = @FullName, GenderCode = @GenderCode, HasChildrenCode = @HasChildrenCode, HomePhone = @HomePhone, JobTitle = @JobTitle, LastName = @LastName, ManagerName = @ManagerName, ManagerPhone = @ManagerPhone, ManagerPhoneExt = @ManagerPhoneExt, MaritalStatus = @MaritalStatus, MiddleName = @MiddleName, MobilePhone = @MobilePhone, NickName = @NickName, NumberOfChildren = @NumberOfChildren, OtherPhone = @OtherPhone, OtherPhoneExt = @OtherPhoneExt, OwningUser = @OwningUser, PaymentTerms = @PaymentTerms, PreferredContactMethodCode = @PreferredContactMethodCode, PreferredPhoneCode = @PreferredPhoneCode, Salutation = @Salutation, ShippingMethod = @ShippingMethod, SpousesName = @SpousesName, StatusCode = @StatusCode, Suffix = @Suffix, WebSiteUrl = @WebSiteUrl, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (ContactId = @Original_ContactId);
	SELECT ContactId, ParentgroupID, Anniversary, AssistantName, AssistantPhone, AssistantPhoneExt, BirthDate, BusinessPhone, BusinessPhoneExt, ContactRole, CreditOnHold, DeletionStateCode, Department, DescriptionInfo, DoNotBulkEMail, DoNotBulkPostalMail, DoNotEMail, DoNotFax, DoNotPhone, DoNotPostalMail, EMailAddress1, EMailAddress2, EMailAddress3, FamilyStatusCode, Fax, FirstName, FreightTermsCode, FullName, GenderCode, HasChildrenCode, HomePhone, JobTitle, LastName, ManagerName, ManagerPhone, ManagerPhoneExt, MaritalStatus, MiddleName, MobilePhone, NickName, NumberOfChildren, OtherPhone, OtherPhoneExt, OwningUser, PaymentTerms, PreferredContactMethodCode, PreferredPhoneCode, Salutation, ShippingMethod, SpousesName, StatusCode, Suffix, WebSiteUrl, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM ContactBase WHERE (ContactId = @ContactId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_SystemUserBase_Insert]
(
	@SystemUserId uniqueidentifier,
	@DeletionStateCode int,
	@UserName nvarchar(50),
	@Password nvarchar(50),
	@SecurityCode int,
	@CompanyID uniqueidentifier,
	@Salutation nvarchar(20),
	@FirstName nvarchar(50),
	@MiddleName nvarchar(50),
	@LastName nvarchar(50),
	@FullName nvarchar(160),
	@NickName nvarchar(50),
	@JobTitle nvarchar(100),
	@Email1 nvarchar(100),
	@Email2 nvarchar(100),
	@PreferredEmailCode int,
	@BusinessPhone nvarchar(50),
	@BusinessPhoneExt nvarchar(50),
	@HomePhone nvarchar(50),
	@MobilePhone nvarchar(50),
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(50),
	@PreferredPhoneCode int,
	@PreferredAddressCode int,
	@EmployeeId nvarchar(100),
	@DeliveryRepresentativeCode bit,
	@SalesRepresentativeCode bit,
	@Street1 nvarchar(50),
	@Street2 nvarchar(50),
	@City nvarchar(50),
	@State nvarchar(50),
	@ZipCode nvarchar(20),
	@OtherStreet1 nvarchar(50),
	@OtherStreet2 nvarchar(50),
	@OtherCity nvarchar(50),
	@OtherState nvarchar(50),
	@OtherZipCode nvarchar(20),
	@CreatedOn datetime,
	@ModifiedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO SystemUserBase(SystemUserId, DeletionStateCode, UserName, Password, SecurityCode, CompanyID, Salutation, FirstName, MiddleName, LastName, FullName, NickName, JobTitle, Email1, Email2, PreferredEmailCode, BusinessPhone, BusinessPhoneExt, HomePhone, MobilePhone, OtherPhone, OtherPhoneExt, PreferredPhoneCode, PreferredAddressCode, EmployeeId, DeliveryRepresentativeCode, SalesRepresentativeCode, Street1, Street2, City, State, ZipCode, OtherStreet1, OtherStreet2, OtherCity, OtherState, OtherZipCode, CreatedOn, ModifiedOn, CreatedBy, ModifiedBy) VALUES (@SystemUserId, @DeletionStateCode, @UserName, @Password, @SecurityCode, @CompanyID, @Salutation, @FirstName, @MiddleName, @LastName, @FullName, @NickName, @JobTitle, @Email1, @Email2, @PreferredEmailCode, @BusinessPhone, @BusinessPhoneExt, @HomePhone, @MobilePhone, @OtherPhone, @OtherPhoneExt, @PreferredPhoneCode, @PreferredAddressCode, @EmployeeId, @DeliveryRepresentativeCode, @SalesRepresentativeCode, @Street1, @Street2, @City, @State, @ZipCode, @OtherStreet1, @OtherStreet2, @OtherCity, @OtherState, @OtherZipCode, @CreatedOn, @ModifiedOn, @CreatedBy, @ModifiedBy);
	SELECT SystemUserId, DeletionStateCode, UserName, Password, SecurityCode, CompanyID, Salutation, FirstName, MiddleName, LastName, FullName, NickName, JobTitle, Email1, Email2, PreferredEmailCode, BusinessPhone, BusinessPhoneExt, HomePhone, MobilePhone, OtherPhone, OtherPhoneExt, PreferredPhoneCode, PreferredAddressCode, EmployeeId, DeliveryRepresentativeCode, SalesRepresentativeCode, Street1, Street2, City, State, ZipCode, OtherStreet1, OtherStreet2, OtherCity, OtherState, OtherZipCode, CreatedOn, ModifiedOn, CreatedBy, ModifiedBy FROM SystemUserBase WHERE (SystemUserId = @SystemUserId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_DefaultBase_ParameterSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_DefaultBase_ParameterSelect]
(
		@DefaultName as nvarchar(50),
		@DefaultSubName as nvarchar(50)
)
AS
	SET NOCOUNT ON;
IF @DefaultSubName IS NULL
BEGIN
	SELECT * FROM DefaultBase
	Where DefaultName = @DefaultName
	order by Ordinal, DefaultSubName
END
ELSE
BEGIN
	SELECT * FROM DefaultBase
	Where DefaultName = @DefaultName AND DefaultSubname = @DefaultSubName
	order by Ordinal, DefaultSubName
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CompanyAddress]'
GO

CREATE VIEW dbo.CompanyAddress
AS
SELECT     dbo.CompanyBase.CompanyID, dbo.CompanyBase.Name, dbo.CompanyBase.WebsiteURL, dbo.CompanyBase.EmailAddress, 
                      dbo.CompanyBase.BusinessPhone, dbo.CompanyBase.BusinessPhoneExt, dbo.CompanyBase.Fax, dbo.InternalAddressBase.BillStreet1, 
                      dbo.InternalAddressBase.BillCity, dbo.InternalAddressBase.BillStreet2, dbo.InternalAddressBase.BillState, dbo.InternalAddressBase.BillZipCode, 
                      dbo.InternalAddressBase.ParentId
FROM         dbo.CompanyBase INNER JOIN
                      dbo.InternalAddressBase ON dbo.CompanyBase.CompanyID = dbo.InternalAddressBase.ParentId
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_SelectDeliveriesByFundraiserID]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityBase_SelectDeliveriesByFundraiserID]
(
	@FundraiserID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT a.*, u.DisplayName 
FROM ActivityBase a LEFT OUTER JOIN SystemUserBase u ON a.OwningUser = u.SystemUserId
WHERE a.FundraiserID = @FundraiserID AND a.ActivityTypeCode =2













GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_FATopicByGroupIDSelect]'
GO
-- =============================================
-- Author:		Jordan Knapp	
-- Create date: July 31, 2006
-- Description:	Form assistant helper
-- =============================================
CREATE PROCEDURE [dbo].[FRP_FundraiserBase_FATopicByGroupIDSelect]
	-- Add the parameters for the stored procedure here
	@GroupID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT FundraiserID, Topic
	FROM FundraiserBase
	WHERE GroupId = @GroupID And DeletionStatusCode <> 1 And StatusCode <> 2
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ContactBaseView]'
GO
CREATE VIEW dbo.ContactBaseView
AS
SELECT     TOP (100) PERCENT c.LastName, c.FirstName, a.GroupName AS ParentGroup, u.DisplayName, e.AddressName, 
                      CASE WHEN e.AddressTypeCode = 0 THEN '' WHEN e.AddressTypeCode = 1 THEN 'BillTo' WHEN e.AddressTypeCode = 2 THEN 'ShipTo' ELSE '' END AS
                       AddressType, e.Street1, e.Street2, e.City, e.State, e.ZipCode, c.ContactId, c.ParentGroupID, c.Anniversary, c.AssistantName, c.AssistantPhone, 
                      c.AssistantPhoneExt, c.BirthDate, c.BusinessPhone, c.BusinessPhoneExt, c.CompanyName, c.ContactRole, c.CreditOnHold, c.DeletionStateCode, 
                      c.Department, c.DescriptionInfo, c.DoNotBulkEMail, c.DoNotBulkPostalMail, c.DoNotEMail, c.DoNotFax, c.DoNotPhone, c.DoNotPostalMail, 
                      c.EMailAddress1, c.EMailAddress2, c.EMailAddress3, c.FamilyStatusCode, c.Fax, c.FirstName AS Expr1, c.FreightTermsCode, c.FullName, 
                      c.GenderCode, c.HasChildrenCode, c.HomePhone, c.JobTitle, c.LastName AS Expr2, c.ManagerName, c.ManagerPhone, c.ManagerPhoneExt, 
                      c.MaritalStatus, c.MiddleName, c.MobilePhone, c.NickName, c.NumberOfChildren, c.OtherPhone, c.OtherPhoneExt, c.OwningUser, c.PaymentTerms, 
                      c.PreferredContactMethodCode, c.PreferredPhoneCode, c.PreferredPhoneNumber, c.PreferredPhoneExt, c.Salutation, c.ShippingMethod, c.SourceCode, 
                      c.SpousesName, c.StatusCode, c.Suffix, c.WebSiteUrl, c.CreatedOn, c.CreatedBy, c.ModifiedOn, c.ModifiedBy, 
                      CASE WHEN c.PreferredContactMethodCode = 1 THEN 'Email' WHEN c.PreferredContactMethodCode = 2 THEN 'Fax' WHEN c.PreferredContactMethodCode
                       = 3 THEN 'Phone' WHEN c.PreferredContactMethodCode = 4 THEN 'Mail' ELSE '' END AS PreferredContactMethod, 
                      CASE WHEN c.PreferredPhoneCode = 1 THEN 'Business' WHEN c.PreferredPhoneCode = 2 THEN 'Home' WHEN c.PreferredPhoneCode = 3 THEN 'Mobile'
                       WHEN c.PreferredPhoneCode = 4 THEN 'Other' ELSE '' END AS PreferredPhone, 
                      CASE WHEN c.StatusCode = 0 THEN 'Active' WHEN c.StatusCode = 1 THEN 'Inactive' WHEN c.StatusCode = 2 THEN 'Canceled' ELSE '' END AS ContactStatus,
                       c.ParentGroupID AS Expr3
FROM         dbo.ContactBase AS c LEFT OUTER JOIN
                      dbo.GroupBase AS a ON c.ParentGroupID = a.GroupId LEFT OUTER JOIN
                      dbo.CustomerAddressBase AS e ON c.ContactId = e.ParentID AND e.PrimaryAddressCode = 1 LEFT OUTER JOIN
                      dbo.SystemUserBase AS u ON c.OwningUser = u.SystemUserId
WHERE     (c.DeletionStateCode <> 1)
ORDER BY c.LastName, c.FirstName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_DeleteFromTable]'
GO

CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_DeleteFromTable]
(
@Original_AddressID uniqueidentifier
)
AS
BEGIN
	
	SET NOCOUNT ON;
DELETE FROM CustomerAddressBase WHERE (AddressId = @Original_AddressID)
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceDetailBase_RecordsFromFundraiserProductClass]'
GO




CREATE PROCEDURE [dbo].[FRP_InvoiceDetailBase_RecordsFromFundraiserProductClass]
(
	@FundraiserID uniqueidentifier,
	@InvoiceID uniqueidentifier
)
AS
	 SET NOCOUNT ON 
Declare @ProductID uniqueidentifier, @ProductNumber nvarchar(50), @ProductDescription nvarchar(50), @Quantity int, @PricePerUnit money, @ProductSalesPercentage decimal, @ProdClassID uniqueidentifier
/*
Declare @InvoiceID uniqueidentifier, @FundraiserID uniqueidentifier
SET @FundraiserID = 'C795BD30-8997-45DB-B38E-A1D1451EB345'
SET @InvoiceID = '00000000-0000-0000-0000-000000000000'
*/
DECLARE Product_Cursor CURSOR FOR
SELECT p.ProductID,
	p.ProductNumber,
	p.Description,
	fpc.Quantity,
	p.GroupRetailPrice,
	p.ProductSalesPercentage,
	fpc.ProductClassID
FROM FundraiserProductClassBase fpc
	Left Outer JOIN ProductBase p On p.ProductClassID = fpc.ProductClassID
Where fpc.FundraiserID = @FundraiserID AND p.carried <> 0 and p.deletionstatecode <> 1
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID, @ProductNumber, @ProductDescription, @Quantity, @PricePerUnit, @ProductSalesPercentage, @ProdClassID
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT InvoiceDetailBase(InvoiceDetailID, InvoiceID, DeletionStateCode, ProductID, ProductNumber, ProductDescription, Quantity, PricePerUnit, PriceOverride, ExtendedAmount, ProductClassID)
	--VALUES(newID(), @InvoiceID, 0, @ProductID, @ProductNumber, @ProductDescription, ROUND(@Quantity * @ProductSalesPercentage,0), @PricePerUnit, -1, ROUND(@Quantity * @ProductSalesPercentage,0) * @PricePerUnit)
	VALUES(newID(), @InvoiceID, 0, @ProductID, @ProductNumber, @ProductDescription, 0, @PricePerUnit, -1, 0, @ProdClassID)
	--Select newID(), @ProductID, @InvoiceID, 0, @ProductNumber, @ProductDescription, ROUND(@Quantity * @ProductSalesPercentage,0), @PricePerUnit, -1, ROUND(@Quantity * @ProductSalesPercentage,0) * @PricePerUnit
FETCH NEXT FROM Product_Cursor  
INTO @ProductID, @ProductNumber, @ProductDescription, @Quantity, @PricePerUnit, @ProductSalesPercentage, @ProdClassID
END
CLOSE Product_Cursor 
DEALLOCATE Product_Cursor 







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserProductClassBase_GridSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserProductClassBase_GridSelect]
(
	@FundraiserID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT	FundraiserProductClassID,
	p.Name as [Product Class],
	o.Quantity,
	o.Posters,
	o.Fliers,
	o.Goal
FROM	FundraiserProductClassBase o Left Outer Join ProductClassBase p
		On o.ProductClassID = p.ProductClassID
Where FundraiserID  = @FundraiserID 
ORDER BY p.Name, o.CreatedOn






GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_SystemUserBase_Update]
(
	@SystemUserId uniqueidentifier,
	@DeletionStateCode int,
	@UserName nvarchar(50),
	@Password nvarchar(50),
	@SecurityCode int,
	@CompanyID uniqueidentifier,
	@Salutation nvarchar(20),
	@FirstName nvarchar(50),
	@MiddleName nvarchar(50),
	@LastName nvarchar(50),
	@FullName nvarchar(160),
	@NickName nvarchar(50),
	@JobTitle nvarchar(100),
	@Email1 nvarchar(100),
	@Email2 nvarchar(100),
	@PreferredEmailCode int,
	@BusinessPhone nvarchar(50),
	@BusinessPhoneExt nvarchar(50),
	@HomePhone nvarchar(50),
	@MobilePhone nvarchar(50),
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(50),
	@PreferredPhoneCode int,
	@PreferredAddressCode int,
	@EmployeeId nvarchar(100),
	@DeliveryRepresentativeCode bit,
	@SalesRepresentativeCode bit,
	@Street1 nvarchar(50),
	@Street2 nvarchar(50),
	@City nvarchar(50),
	@State nvarchar(50),
	@ZipCode nvarchar(20),
	@OtherStreet1 nvarchar(50),
	@OtherStreet2 nvarchar(50),
	@OtherCity nvarchar(50),
	@OtherState nvarchar(50),
	@OtherZipCode nvarchar(20),
	@CreatedOn datetime,
	@ModifiedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedBy uniqueidentifier,
	@Original_SystemUserId uniqueidentifier,
	@Original_BusinessPhone nvarchar(50),
	@Original_BusinessPhoneExt nvarchar(50),
	@Original_City nvarchar(50),
	@Original_CompanyID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_DeliveryRepresentativeCode bit,
	@Original_Email1 nvarchar(100),
	@Original_Email2 nvarchar(100),
	@Original_EmployeeId nvarchar(100),
	@Original_FirstName nvarchar(50),
	@Original_FullName nvarchar(160),
	@Original_HomePhone nvarchar(50),
	@Original_JobTitle nvarchar(100),
	@Original_LastName nvarchar(50),
	@Original_MiddleName nvarchar(50),
	@Original_MobilePhone nvarchar(50),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_NickName nvarchar(50),
	@Original_OtherCity nvarchar(50),
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(50),
	@Original_OtherState nvarchar(50),
	@Original_OtherStreet1 nvarchar(50),
	@Original_OtherStreet2 nvarchar(50),
	@Original_OtherZipCode nvarchar(20),
	@Original_Password nvarchar(50),
	@Original_PreferredAddressCode int,
	@Original_PreferredEmailCode int,
	@Original_PreferredPhoneCode int,
	@Original_SalesRepresentativeCode bit,
	@Original_Salutation nvarchar(20),
	@Original_SecurityCode int,
	@Original_State nvarchar(50),
	@Original_Street1 nvarchar(50),
	@Original_Street2 nvarchar(50),
	@Original_UserName nvarchar(50),
	@Original_ZipCode nvarchar(20)
)
AS
	SET NOCOUNT OFF;
UPDATE SystemUserBase SET SystemUserId = @SystemUserId, DeletionStateCode = @DeletionStateCode, UserName = @UserName, Password = @Password, SecurityCode = @SecurityCode, CompanyID = @CompanyID, Salutation = @Salutation, FirstName = @FirstName, MiddleName = @MiddleName, LastName = @LastName, FullName = @FullName, NickName = @NickName, JobTitle = @JobTitle, Email1 = @Email1, Email2 = @Email2, PreferredEmailCode = @PreferredEmailCode, BusinessPhone = @BusinessPhone, BusinessPhoneExt = @BusinessPhoneExt, HomePhone = @HomePhone, MobilePhone = @MobilePhone, OtherPhone = @OtherPhone, OtherPhoneExt = @OtherPhoneExt, PreferredPhoneCode = @PreferredPhoneCode, PreferredAddressCode = @PreferredAddressCode, EmployeeId = @EmployeeId, DeliveryRepresentativeCode = @DeliveryRepresentativeCode, SalesRepresentativeCode = @SalesRepresentativeCode, Street1 = @Street1, Street2 = @Street2, City = @City, State = @State, ZipCode = @ZipCode, OtherStreet1 = @OtherStreet1, OtherStreet2 = @OtherStreet2, OtherCity = @OtherCity, OtherState = @OtherState, OtherZipCode = @OtherZipCode, CreatedOn = @CreatedOn, ModifiedOn = @ModifiedOn, CreatedBy = @CreatedBy, ModifiedBy = @ModifiedBy WHERE (SystemUserId = @Original_SystemUserId);
	SELECT SystemUserId, DeletionStateCode, UserName, Password, SecurityCode, CompanyID, Salutation, FirstName, MiddleName, LastName, FullName, NickName, JobTitle, Email1, Email2, PreferredEmailCode, BusinessPhone, BusinessPhoneExt, HomePhone, MobilePhone, OtherPhone, OtherPhoneExt, PreferredPhoneCode, PreferredAddressCode, EmployeeId, DeliveryRepresentativeCode, SalesRepresentativeCode, Street1, Street2, City, State, ZipCode, OtherStreet1, OtherStreet2, OtherCity, OtherState, OtherZipCode, CreatedOn, ModifiedOn, CreatedBy, ModifiedBy FROM SystemUserBase WHERE (SystemUserId = @SystemUserId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_Update]'
GO


CREATE PROCEDURE [dbo].[FRP_InvoiceBase_Update]
(
	@InvoiceId uniqueidentifier,
	@FundraiserId uniqueidentifier,
	@OwningUser uniqueidentifier,
	@GroupId uniqueidentifier,
	@GroupTypeCode int,
	@InvoiceNumber nvarchar(100),
	@GroupPONumber nvarchar(50),
	@Name nvarchar(300),
	@Description ntext,
	@DocumentDate datetime,
	@BillToName nvarchar(200),
	@BillToStreet1 nvarchar(50),
	@BillToStreet2 nvarchar(50),
	@BillToCity nvarchar(50),
	@BillToState nvarchar(50),
	@BillToZipCode nvarchar(20),
	@BillToTelephone nvarchar(50),
	@BillToTelephoneExt nvarchar(50),
	@BillToFax nvarchar(50),
	@ShipToName nvarchar(200),
	@ShipToStreet1 nvarchar(50),
	@ShipToStreet2 nvarchar(50),
	@ShipToCity nvarchar(50),
	@ShipToState nvarchar(50),
	@ShipToZipCode nvarchar(20),
	@ShipToTelephone nvarchar(50),
	@ShipToTelephoneExt nvarchar(50),
	@ShipToFax nvarchar(50),
	@DiscountAmount money,
	@InvoiceDiscount money,
	@FreightAmount money,
	@TotalAmount money,
	@TotalLineItemAmount money,
	@TotalLineItemDiscountAmount money,
	@TotalAmountLessFreight money,
	@TotalDiscountAmount money,
	@TotalTax money,
	@PaymentTerms nvarchar(50),
	@ShippingMethod nvarchar(50),
	@ShipToFreightTermsCode int,
	@StatusCode int,
	@StatusReasonCode int,
	@Delivered int,
	@DeliveredOn datetime,
	@QBStatusCode int,
	@CreatedBy uniqueidentifier,
	@CreatedOn datetime,
	@ModifiedBy uniqueidentifier,
	@ModifiedOn datetime,
	@Original_InvoiceId uniqueidentifier,
	@Original_BillToCity nvarchar(50),
	@Original_BillToFax nvarchar(50),
	@Original_BillToName nvarchar(200),
	@Original_BillToState nvarchar(50),
	@Original_BillToStreet1 nvarchar(50),
	@Original_BillToStreet2 nvarchar(50),
	@Original_BillToTelephone nvarchar(50),
	@Original_BillToTelephoneExt nvarchar(50),
	@Original_BillToZipCode nvarchar(20),
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_CustPONumber nvarchar(50),
	@Original_CustomerId uniqueidentifier,
	@Original_CustomerTypeCode int,
	@Original_Delivered int,
	@Original_DeliveredOn datetime,
	@Original_DiscountAmount money,
	@Original_DocumentDate datetime,
	@Original_FreightAmount money,
	@Original_InvoiceDiscount money,
	@Original_InvoiceNumber nvarchar(100),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(300),
	@Original_FundraiserId uniqueidentifier,
	@Original_OwningUser uniqueidentifier,
	@Original_PaymentTerms nvarchar(50),
	@Original_QBStatusCode int,
	@Original_ShipToCity nvarchar(50),
	@Original_ShipToFax nvarchar(50),
	@Original_ShipToFreightTermsCode int,
	@Original_ShipToName nvarchar(200),
	@Original_ShipToState nvarchar(50),
	@Original_ShipToStreet1 nvarchar(50),
	@Original_ShipToStreet2 nvarchar(50),
	@Original_ShipToTelephone nvarchar(50),
	@Original_ShipToTelephoneExt nvarchar(50),
	@Original_ShipToZipCode nvarchar(20),
	@Original_ShippingMethod nvarchar(50),
	@Original_StatusCode int,
	@Original_StatusReasonCode int,
	@Original_TotalAmount money,
	@Original_TotalAmountLessFreight money,
	@Original_TotalDiscountAmount money,
	@Original_TotalLineItemAmount money,
	@Original_TotalLineItemDiscountAmount money,
	@Original_TotalTax money
)
AS
	SET NOCOUNT OFF;
UPDATE InvoiceBase SET InvoiceId = @InvoiceId, FundraiserId = @FundraiserId, OwningUser = @OwningUser, GroupId = @GroupId, GroupTypeCode = @GroupTypeCode, InvoiceNumber = @InvoiceNumber, GroupPONumber = @GroupPONumber, Name = @Name, Description = @Description, DocumentDate = @DocumentDate, BillToName = @BillToName, BillToStreet1 = @BillToStreet1, BillToStreet2 = @BillToStreet2, BillToCity = @BillToCity, BillToState = @BillToState, BillToZipCode = @BillToZipCode, BillToTelephone = @BillToTelephone, BillToTelephoneExt = @BillToTelephoneExt, BillToFax = @BillToFax, ShipToName = @ShipToName, ShipToStreet1 = @ShipToStreet1, ShipToStreet2 = @ShipToStreet2, ShipToCity = @ShipToCity, ShipToState = @ShipToState, ShipToZipCode = @ShipToZipCode, ShipToTelephone = @ShipToTelephone, ShipToTelephoneExt = @ShipToTelephoneExt, ShipToFax = @ShipToFax, DiscountAmount = @DiscountAmount, InvoiceDiscount = @InvoiceDiscount, FreightAmount = @FreightAmount, TotalAmount = @TotalAmount, TotalLineItemAmount = @TotalLineItemAmount, TotalLineItemDiscountAmount = @TotalLineItemDiscountAmount, TotalAmountLessFreight = @TotalAmountLessFreight, TotalDiscountAmount = @TotalDiscountAmount, TotalTax = @TotalTax, PaymentTerms = @PaymentTerms, ShippingMethod = @ShippingMethod, ShipToFreightTermsCode = @ShipToFreightTermsCode, StatusCode = @StatusCode, StatusReasonCode = @StatusReasonCode, Delivered = @Delivered, DeliveredOn = @DeliveredOn, QBStatusCode = @QBStatusCode, CreatedBy = @CreatedBy, CreatedOn = @CreatedOn, ModifiedBy = @ModifiedBy, ModifiedOn = @ModifiedOn WHERE (InvoiceId = @Original_InvoiceId);
	SELECT InvoiceId, FundraiserId, OwningUser, GroupId, GroupTypeCode, InvoiceNumber, GroupPONumber, Name, Description, DocumentDate, BillToName, BillToStreet1, BillToStreet2, BillToCity, BillToState, BillToZipCode, BillToTelephone, BillToTelephoneExt, BillToFax, ShipToName, ShipToStreet1, ShipToStreet2, ShipToCity, ShipToState, ShipToZipCode, ShipToTelephone, ShipToTelephoneExt, ShipToFax, DiscountAmount, InvoiceDiscount, FreightAmount, TotalAmount, TotalLineItemAmount, TotalLineItemDiscountAmount, TotalAmountLessFreight, TotalDiscountAmount, TotalTax, PaymentTerms, ShippingMethod, ShipToFreightTermsCode, StatusCode, StatusReasonCode, Delivered, DeliveredOn, QBStatusCode, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM InvoiceBase WHERE (InvoiceId = @InvoiceId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InternalAddressBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_InternalAddressBase_Update]
(
	@InternalAddressId uniqueidentifier,
	@ParentId uniqueidentifier,
	@DeletionStateCode int,
	@AddressNumber int,
	@AddressTypeCode int,
	@BillCompanyName nvarchar(200),
	@BillStreet1 nvarchar(50),
	@BillStreet2 nvarchar(50),
	@BillCity nvarchar(50),
	@BillState nvarchar(50),
	@BillZipCode nvarchar(50),
	@BillBusinessPhone nvarchar(50),
	@BillBusinessPhoneExt nvarchar(50),
	@ShipCompanyName nvarchar(200),
	@ShipStreet1 nvarchar(50),
	@ShipStreet2 nvarchar(50),
	@ShipCity nvarchar(50),
	@ShipState nvarchar(50),
	@ShipZipCode nvarchar(20),
	@ShipBusinessPhone nvarchar(50),
	@ShipBusinessPhoneExt nvarchar(50),
	@ShippingMethodCode int,
	@Latitude float,
	@Longitude float,
	@CreatedBy uniqueidentifier,
	@CreatedOn datetime,
	@ModifiedBy uniqueidentifier,
	@ModifiedOn datetime,
	@Original_InternalAddressId uniqueidentifier,
	@Original_AddressNumber int,
	@Original_AddressTypeCode int,
	@Original_BillBusinessPhone nvarchar(50),
	@Original_BillBusinessPhoneExt nvarchar(50),
	@Original_BillCity nvarchar(50),
	@Original_BillCompanyName nvarchar(200),
	@Original_BillState nvarchar(50),
	@Original_BillStreet1 nvarchar(50),
	@Original_BillStreet2 nvarchar(50),
	@Original_BillZipCode nvarchar(50),
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_Latitude float,
	@Original_Longitude float,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_ParentId uniqueidentifier,
	@Original_ShipBusinessPhone nvarchar(50),
	@Original_ShipBusinessPhoneExt nvarchar(50),
	@Original_ShipCity nvarchar(50),
	@Original_ShipCompanyName nvarchar(200),
	@Original_ShipState nvarchar(50),
	@Original_ShipStreet1 nvarchar(50),
	@Original_ShipStreet2 nvarchar(50),
	@Original_ShipZipCode nvarchar(20),
	@Original_ShippingMethodCode int
)
AS
	SET NOCOUNT OFF;
UPDATE InternalAddressBase SET InternalAddressId = @InternalAddressId, ParentId = @ParentId, DeletionStateCode = @DeletionStateCode, AddressNumber = @AddressNumber, AddressTypeCode = @AddressTypeCode, BillCompanyName = @BillCompanyName, BillStreet1 = @BillStreet1, BillStreet2 = @BillStreet2, BillCity = @BillCity, BillState = @BillState, BillZipCode = @BillZipCode, BillBusinessPhone = @BillBusinessPhone, BillBusinessPhoneExt = @BillBusinessPhoneExt, ShipCompanyName = @ShipCompanyName, ShipStreet1 = @ShipStreet1, ShipStreet2 = @ShipStreet2, ShipCity = @ShipCity, ShipState = @ShipState, ShipZipCode = @ShipZipCode, ShipBusinessPhone = @ShipBusinessPhone, ShipBusinessPhoneExt = @ShipBusinessPhoneExt, ShippingMethodCode = @ShippingMethodCode, Latitude = @Latitude, Longitude = @Longitude, CreatedBy = @CreatedBy, CreatedOn = @CreatedOn, ModifiedBy = @ModifiedBy, ModifiedOn = @ModifiedOn WHERE (InternalAddressId = @Original_InternalAddressId);
	SELECT InternalAddressId, ParentId, DeletionStateCode, AddressNumber, AddressTypeCode, BillCompanyName, BillStreet1, BillStreet2, BillCity, BillState, BillZipCode, BillBusinessPhone, BillBusinessPhoneExt, ShipCompanyName, ShipStreet1, ShipStreet2, ShipCity, ShipState, ShipZipCode, ShipBusinessPhone, ShipBusinessPhoneExt, ShippingMethodCode, Latitude, Longitude, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM InternalAddressBase WHERE (InternalAddressId = @InternalAddressId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCSelect]'
GO


CREATE PROCEDURE [dbo].[FRP_ProductBase_PCSelect]
AS
	SET NOCOUNT ON;
SELECT ProductId, ProductNumber, Name, Description, ProductTypeCode, DefaultUoMScheduleID, ProductClassID, DefaultUoMId, RetailPrice, GroupRetailPrice, ConsumerRetailPrice, DealerPrice, QuantityOnHand, QuantityAllocated, Carried, DeletionStateCode, CreatedOn, ModifiedOn, CreatedBy, ModifiedBy, StatusCode, ProductSalesPercentage, FlierOrder 
FROM ProductBase
Order By ProductNumber


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_SelectByFundraiserID]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceBase_SelectByFundraiserID]
(
	@FundraiserID uniqueidentifier
)
AS
SELECT i.*,
	Case i.InvoiceStage
		WHEN '0' THEN 'Order Received'
		WHEN '1' THEN 'Billed'
		WHEN '2' THEN 'Paid'
	End As [Invoice Stage],
	Case i.StatusCode
		WHEN '0' THEN 'Open'
		WHEN '1' THEN 'Closed'
	    WHEN '2' THEN 'Canceled'
	End As [Invoice Status],
	   u.DisplayName AS [Owning User],
	   a.GroupName,
	   f.Topic,
	   c.FullName As [Primary Contact]
FROM InvoiceBase as i
		Left Outer Join SystemUserBase u On i.OwningUser = u.SystemUserId
		Left Outer Join GroupBase a On i.GroupId = a.GroupId
		Left Outer Join FundraiserBase f On i.FundraiserId = f.FundraiserId
 		Left Outer Join ContactBase c On i.PrimaryContactId = c.ContactId
Where i.FundraiserID = @FundraiserID And i.DeletionStatusCode <> 1
Order BY InvoiceNumber














GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQOHReceivedInventory]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdateQOHReceivedInventory] 
(
@PurchaseOrderID uniqueidentifier
)
AS
	SET NOCOUNT ON;
Declare @ProductID uniqueidentifier
Declare @InventoryQuantity integer
Declare @QOHValue integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
ORDER BY ProductNumber
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
Set @QOHValue = (Select SUM(pb.QuantityOnHand) as TotalQOH 
				FROM ProductBase pb
				WHERE pb.ProductID = @ProductID)
Set @InventoryQuantity  = (Select SUM(podb.QuantityOrdered) as TotalQuantity 
						FROM PurchaseOrderBase po Left Outer Join PurchaseOrderDetailBase podb  On po.PurchaseOrderID = podb.PurchaseOrderID
						WHERE podb.PurchaseOrderID = @PurchaseOrderID AND podb.ProductID = @ProductID AND po.Stage = 2 AND po.Status = 1 AND po.DeletionStateCode <> 1) 
Update ProductBase Set QuantityOnHand = @QOHValue + isNull(@InventoryQuantity,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor
INTO @ProductID
END
CLOSE Product_Cursor
DEALLOCATE Product_Cursor











GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQOHCanceledInventory]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdateQOHCanceledInventory] 
 (
@PurchaseOrderID uniqueidentifier
)
AS
BEGIN
		SET NOCOUNT ON;

Declare @ProductID uniqueidentifier
Declare @InventoryQuantity integer
Declare @QOHValue integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
ORDER BY ProductNumber
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
Set @QOHValue = (Select SUM(pb.QuantityOnHand) as TotalQOH 
				FROM ProductBase pb
				WHERE pb.ProductID = @ProductID)
Set @InventoryQuantity  = (Select SUM(podb.QuantityOrdered) as TotalQuantity 
						FROM PurchaseOrderBase po Left Outer Join PurchaseOrderDetailBase podb  On po.PurchaseOrderID = podb.PurchaseOrderID
						WHERE podb.PurchaseOrderID = @PurchaseOrderID AND podb.ProductID = @ProductID) 
Update ProductBase Set QuantityOnHand = @QOHValue - isNull(@InventoryQuantity,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor
INTO @ProductID
END
CLOSE Product_Cursor
DEALLOCATE Product_Cursor
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_FAFullNameSelect]'
GO
-- =============================================
-- Author:		Jordan Knapp
-- Create date: July, 31, 2006
-- Description:	Form Assistant helper
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ContactBase_FAFullNameSelect] 

AS
BEGIN
	
	SET NOCOUNT ON;
		
	SELECT	ContactId,	FullName
	FROM	ContactBase
	WHERE DeletionStateCode = 0 And StatusCode = 0
	ORDER BY FullName

END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_DeletionStatusCode]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_DeletionStatusCode]
	(
	@FundraiserID uniqueidentifier
)
AS
BEGIN

	SET NOCOUNT ON;

Update FundraiserBase Set DeletionStatusCode = 1 Where FundraiserID = @FundraiserID 
Delete From FundraiserDetailBase Where FundraiserID = @FundraiserID
Delete From FundraiserProductClassBase Where FundraiserID = @FundraiserID

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserProductClassBase_SelectByFundraiserID]'
GO
CREATE PROCEDURE [dbo].[FRP_FundraiserProductClassBase_SelectByFundraiserID]
(
	@FundraiserID uniqueidentifier
)
AS
SELECT f.*,
	   p.Name as [Product Class]
FROM FundraiserProductClassBase f
	Left Outer Join ProductClassBase p On f.ProductClassId = p.ProductClassId
Where FundraiserID = @FundraiserID
ORDER BY p.Name, f.CreatedOn







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceDetailBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceDetailBase_Delete]
(
	@Original_InvoiceDetailID uniqueidentifier,
	@Original_BaseAmount money,
	@Original_DeletionStateCode int,
	@Original_DeliveryRepID uniqueidentifier,
	@Original_ExtendedAmount money,
	@Original_InvoiceID uniqueidentifier,
	@Original_LineItemNumber int,
	@Original_ManualDiscountAmount money,
	@Original_PriceOverride bit,
	@Original_PricePerUnit money,
	@Original_ProductID uniqueidentifier,
	@Original_ProductNumber nvarchar(50),
	@Original_Quantity decimal(18),
	@Original_SalesRepID uniqueidentifier,
	@Original_Tax money,
	@Original_UofMID uniqueidentifier
)
AS
	SET NOCOUNT OFF;
DELETE FROM InvoiceDetailBase WHERE (InvoiceDetailID = @Original_InvoiceDetailID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_UpdateSalesStageCode]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_UpdateSalesStageCode]
(
	@FundraiserID as uniqueidentifier,
	@SalesStageCode as integer
)
AS
	SET NOCOUNT ON;
Update FundraiserBase Set SalesStageCode = @SalesStageCode
Where FundraiserID = @FundraiserID


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_PaymentTermsBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_PaymentTermsBase_Update]
(
	@PaymentTermsID uniqueidentifier,
	@Name nvarchar(200),
	@DeletionStateCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_PaymentTermsID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(200)
)
AS
	SET NOCOUNT OFF;
UPDATE PaymentTermsBase SET PaymentTermsID = @PaymentTermsID, Name = @Name, DeletionStateCode = @DeletionStateCode, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (PaymentTermsID = @Original_PaymentTermsID);
	SELECT PaymentTermsID, Name, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM PaymentTermsBase WHERE (PaymentTermsID = @PaymentTermsID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductClassBase_Select]'
GO


CREATE PROCEDURE [dbo].[FRP_ProductClassBase_Select]
AS
	SET NOCOUNT ON;
SELECT ProductClassId, Name, Description, ProductTypeCode, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy, Carried, Target FROM ProductClassBase


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[VendorAddressBase]'
GO
CREATE TABLE [dbo].[VendorAddressBase]
(
[VendorAddressID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_VendorAddressBase_VendorAddressID] DEFAULT (newid()),
[ParentID] [uniqueidentifier] NOT NULL,
[AddressTypeCode] [int] NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Latitude] [float] NULL,
[Longitude] [float] NULL,
[BusinessPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[Createdby] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_VendorAddressBase] on [dbo].[VendorAddressBase]'
GO
ALTER TABLE [dbo].[VendorAddressBase] ADD CONSTRAINT [PK_VendorAddressBase] PRIMARY KEY CLUSTERED  ([VendorAddressID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_VendorAddressBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_VendorAddressBase_Select]
(
	@ParentID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT VendorAddressID, ParentID, AddressTypeCode, Name, Street1, Street2, City, State, ZipCode, Latitude, Longitude, BusinessPhone, OtherPhone, Fax, CreatedOn, Createdby, ModifiedOn, ModifiedBy FROM VendorAddressBase WHERE (ParentID = @ParentID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_PaymentTermsBase_NameSelect]'
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_PaymentTermsBase_NameSelect]
AS
BEGIN
		SET NOCOUNT ON;

SELECT	Name
FROM	PaymentTermsBase
ORDER BY DefaultItem desc, name

END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_GridSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_GridSelect]
(
	@ParentID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT  AddressID,	
	AddressName As [Address Name],
	AddressTypeCode as Type,
	PrimaryContactName as [Address Contact],	
	MainPhone as [Main Phone],
	MainPhoneExt as Ext,
	PrimaryAddressCode
FROM CustomerAddressBase
WHERE ParentID = @ParentID
ORDER BY AddressName


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InternalAddressBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_InternalAddressBase_Insert]
(
	@InternalAddressId uniqueidentifier,
	@ParentId uniqueidentifier,
	@DeletionStateCode int,
	@AddressNumber int,
	@AddressTypeCode int,
	@BillCompanyName nvarchar(200),
	@BillStreet1 nvarchar(50),
	@BillStreet2 nvarchar(50),
	@BillCity nvarchar(50),
	@BillState nvarchar(50),
	@BillZipCode nvarchar(50),
	@BillBusinessPhone nvarchar(50),
	@BillBusinessPhoneExt nvarchar(50),
	@ShipCompanyName nvarchar(200),
	@ShipStreet1 nvarchar(50),
	@ShipStreet2 nvarchar(50),
	@ShipCity nvarchar(50),
	@ShipState nvarchar(50),
	@ShipZipCode nvarchar(20),
	@ShipBusinessPhone nvarchar(50),
	@ShipBusinessPhoneExt nvarchar(50),
	@ShippingMethodCode int,
	@Latitude float,
	@Longitude float,
	@CreatedBy uniqueidentifier,
	@CreatedOn datetime,
	@ModifiedBy uniqueidentifier,
	@ModifiedOn datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO InternalAddressBase(InternalAddressId, ParentId, DeletionStateCode, AddressNumber, AddressTypeCode, BillCompanyName, BillStreet1, BillStreet2, BillCity, BillState, BillZipCode, BillBusinessPhone, BillBusinessPhoneExt, ShipCompanyName, ShipStreet1, ShipStreet2, ShipCity, ShipState, ShipZipCode, ShipBusinessPhone, ShipBusinessPhoneExt, ShippingMethodCode, Latitude, Longitude, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn) VALUES (@InternalAddressId, @ParentId, @DeletionStateCode, @AddressNumber, @AddressTypeCode, @BillCompanyName, @BillStreet1, @BillStreet2, @BillCity, @BillState, @BillZipCode, @BillBusinessPhone, @BillBusinessPhoneExt, @ShipCompanyName, @ShipStreet1, @ShipStreet2, @ShipCity, @ShipState, @ShipZipCode, @ShipBusinessPhone, @ShipBusinessPhoneExt, @ShippingMethodCode, @Latitude, @Longitude, @CreatedBy, @CreatedOn, @ModifiedBy, @ModifiedOn);
	SELECT InternalAddressId, ParentId, DeletionStateCode, AddressNumber, AddressTypeCode, BillCompanyName, BillStreet1, BillStreet2, BillCity, BillState, BillZipCode, BillBusinessPhone, BillBusinessPhoneExt, ShipCompanyName, ShipStreet1, ShipStreet2, ShipCity, ShipState, ShipZipCode, ShipBusinessPhone, ShipBusinessPhoneExt, ShippingMethodCode, Latitude, Longitude, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM InternalAddressBase WHERE (InternalAddressId = @InternalAddressId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_Update]'
GO


CREATE PROCEDURE [dbo].[FRP_ProductBase_Update]
(
	@ProductId uniqueidentifier,
	@ProductNumber nvarchar(100),
	@Name nvarchar(100),
	@Description ntext,
	@ProductTypeCode int,
	@DefaultUoMScheduleID uniqueidentifier,
	@ProductClassID uniqueidentifier,
	@DefaultUoMId uniqueidentifier,
	@RetailPrice money,
	@GroupRetailPrice money,
	@ConsumerRetailPrice money,
	@DealerPrice money,
	@QuantityOnHand decimal(18,5),
	@QuantityAllocated decimal(18),
	@Carried bit,
	@DeletionStateCode int,
	@CreatedOn datetime,
	@ModifiedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedBy uniqueidentifier,
	@StatusCode int,
	@ProductSalesPercentage decimal(18,5),
	@FlierOrder int,
	@Original_ProductId uniqueidentifier,
	@Original_ConsumerRetailPrice money,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DealerPrice money,
	@Original_DefaultUoMId uniqueidentifier,
	@Original_DefaultUoMScheduleID uniqueidentifier,
	@Original_DeletionStateCode int,
	@Original_FlierOrder int,
	@Original_GroupRetailPrice money,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(100),
	@Original_ProductClassID uniqueidentifier,
	@Original_ProductNumber nvarchar(100),
	@Original_ProductSalesPercentage decimal(18,5),
	@Original_Carried bit,
	@Original_ProductTypeCode int,
	@Original_QuantityAllocated decimal(18),
	@Original_QuantityOnHand decimal(18,5),
	@Original_RetailPrice money,
	@Original_StateCode int,
	@Original_StatusCode int
)
AS
	SET NOCOUNT OFF;
UPDATE ProductBase SET ProductId = @ProductId, ProductNumber = @ProductNumber, Name = @Name, Description = @Description, ProductTypeCode = @ProductTypeCode, DefaultUoMScheduleID = @DefaultUoMScheduleID, ProductClassID = @ProductClassID, DefaultUoMId = @DefaultUoMId, RetailPrice = @RetailPrice, GroupRetailPrice = @GroupRetailPrice, ConsumerRetailPrice = @ConsumerRetailPrice, DealerPrice = @DealerPrice, QuantityOnHand = @QuantityOnHand, QuantityAllocated = @QuantityAllocated, Carried = @Carried, DeletionStateCode = @DeletionStateCode, CreatedOn = @CreatedOn, ModifiedOn = @ModifiedOn, CreatedBy = @CreatedBy, ModifiedBy = @ModifiedBy, StatusCode = @StatusCode, ProductSalesPercentage = @ProductSalesPercentage, FlierOrder = @FlierOrder WHERE (ProductId = @Original_ProductId);
	SELECT ProductId, ProductNumber, Name, Description, ProductTypeCode, DefaultUoMScheduleID, ProductClassID, DefaultUoMId, RetailPrice, GroupRetailPrice, ConsumerRetailPrice, DealerPrice, QuantityOnHand, QuantityAllocated, Carried, DeletionStateCode, CreatedOn, ModifiedOn, CreatedBy, ModifiedBy, StatusCode, ProductSalesPercentage, FlierOrder FROM ProductBase WHERE (ProductId = @ProductId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductClassBase_Update]'
GO


CREATE PROCEDURE [dbo].[FRP_ProductClassBase_Update]
(
	@ProductClassId uniqueidentifier,
	@Name nvarchar(100),
	@Description ntext,
	@ProductTypeCode nvarchar(50),
	@DeletionStateCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Carried bit,
	@Target int,
	@Original_ProductClassId uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(100),
	@Original_ProductTypeCode nvarchar(50),
	@Original_Carried bit,
	@Original_Target int
)
AS
	SET NOCOUNT OFF;
UPDATE ProductClassBase SET ProductClassId = @ProductClassId, Name = @Name, Description = @Description, ProductTypeCode = @ProductTypeCode, DeletionStateCode = @DeletionStateCode, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy, Carried = @Carried, Target = @Target WHERE (ProductClassId = @Original_ProductClassId);
	SELECT ProductClassId, Name, Description, ProductTypeCode, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy, Carried, Target FROM ProductClassBase WHERE (ProductClassId = @ProductClassId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_PaperworkWizInvoiceGrandTotal]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityBase_PaperworkWizInvoiceGrandTotal]
(
	@OwningUserID uniqueidentifier,
@UseDates bit,
@StartDate datetime,
@EndDate datetime

)
AS
SET NOCOUNT ON;
IF @UseDates = 0
BEGIN	
SELECT     SUM(dbo.InvoiceDetailBase.Quantity) AS Total
FROM         dbo.ActivityBase LEFT OUTER JOIN
                      dbo.InvoiceBase ON dbo.ActivityBase.DocID = dbo.InvoiceBase.InvoiceId LEFT OUTER JOIN
                      dbo.InvoiceDetailBase ON dbo.InvoiceBase.InvoiceId = dbo.InvoiceDetailBase.InvoiceID LEFT OUTER JOIN
                      dbo.ProductClassBase ON dbo.InvoiceDetailBase.ProductClassID = dbo.ProductClassBase.ProductClassId
Where dbo.ActivityBase.OwningUser = @OwningUserID
END

ELSE IF @UseDates = 1
BEGIN
SELECT     SUM(dbo.InvoiceDetailBase.Quantity) AS Total
FROM         dbo.ActivityBase LEFT OUTER JOIN
                      dbo.InvoiceBase ON dbo.ActivityBase.DocID = dbo.InvoiceBase.InvoiceId LEFT OUTER JOIN
                      dbo.InvoiceDetailBase ON dbo.InvoiceBase.InvoiceId = dbo.InvoiceDetailBase.InvoiceID LEFT OUTER JOIN
                      dbo.ProductClassBase ON dbo.InvoiceDetailBase.ProductClassID = dbo.ProductClassBase.ProductClassId
Where dbo.ActivityBase.OwningUser = @OwningUserID AND dbo.ActivityBase.ScheduledStartDate Between @StartDate And @EndDate
END




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InventoryAdjustmentBase_GridSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_InventoryAdjustmentBase_GridSelect]
(
	@StatusReasonCode integer
)
AS
	SET NOCOUNT ON;
	
Declare @StatusReasonCodeEnd as int
if @StatusReasonCode = -1 -- ALL
	Begin
		set @StatusReasonCode = 0 
		set @StatusReasonCodeEnd = 4
	End
ELSE 
IF @StatusReasonCode = 0 --Open
	Begin
		set @StatusReasonCode = 0
		set @StatusReasonCodeEnd = 0
	End
ELSE 
IF @StatusReasonCode = 1 --Received
	Begin
		set @StatusReasonCode = 1
		set @StatusReasonCodeEnd = 1
	End
ELSE 
IF @StatusReasonCode = 2 --Closed
	Begin
		set @StatusReasonCode = 2
		set @StatusReasonCodeEnd = 2
	End
ELSE 
	set @StatusReasonCodeEnd = @StatusReasonCode
	
SELECT	InventoryAdjustmentID,
	InventoryAdjNumber as [Inventory Adjustment Number],
	StartDate as [Start Date],
	u.FullName as [Owning User],
	StatusReasonCode as [Status]
FROM InventoryAdjustmentBase  i Left Outer Join SystemUserBase u On i.OwningUser = u.SystemUserID
WHERE StatusReasonCode >= @StatusReasonCode And StatusReasonCode <= @StatusReasonCodeEnd
ORDER BY InventoryAdjNumber DESC


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_UofMScheduleBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_UofMScheduleBase_Delete]
(
	@Original_UoMScheduleId uniqueidentifier,
	@Original_BaseUofM uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(200)
)
AS
	SET NOCOUNT OFF;
DELETE FROM UofMScheduleBase WHERE (UoMScheduleId = @Original_UoMScheduleId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CompanyBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_CompanyBase_Insert]
(
	@CompanyID uniqueidentifier,
	@Name nvarchar(160),
	@WebsiteURL nvarchar(200),
	@EmailAddress nvarchar(50),
	@BusinessPhone nvarchar(50),
	@BusinessPhoneExt nvarchar(50),
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(50),
	@Fax nvarchar(50),
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO CompanyBase(CompanyID, Name, WebsiteURL, EmailAddress, BusinessPhone, BusinessPhoneExt, OtherPhone, OtherPhoneExt, Fax, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@CompanyID, @Name, @WebsiteURL, @EmailAddress, @BusinessPhone, @BusinessPhoneExt, @OtherPhone, @OtherPhoneExt, @Fax, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT CompanyID, Name, WebsiteURL, EmailAddress, BusinessPhone, BusinessPhoneExt, OtherPhone, OtherPhoneExt, Fax, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM CompanyBase WHERE (CompanyID = @CompanyID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_NoteBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_NoteBase_Insert]
(
	@NoteID uniqueidentifier,
	@ParentID uniqueidentifier,
	@Subject nvarchar(500),
	@NoteText ntext,
	@DeletionStateCode int,
	@OwningUser uniqueidentifier,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO NoteBase(NoteID, ParentID, Subject, NoteText, DeletionStateCode, OwningUser, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@NoteID, @ParentID, @Subject, @NoteText, @DeletionStateCode, @OwningUser, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT NoteID, ParentID, Subject, NoteText, DeletionStateCode, OwningUser, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM NoteBase WHERE (NoteID = @NoteID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InternalAddressBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_InternalAddressBase_Delete]
(
	@Original_InternalAddressId uniqueidentifier,
	@Original_AddressNumber int,
	@Original_AddressTypeCode int,
	@Original_BillBusinessPhone nvarchar(50),
	@Original_BillBusinessPhoneExt nvarchar(50),
	@Original_BillCity nvarchar(50),
	@Original_BillCompanyName nvarchar(200),
	@Original_BillState nvarchar(50),
	@Original_BillStreet1 nvarchar(50),
	@Original_BillStreet2 nvarchar(50),
	@Original_BillZipCode nvarchar(50),
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_Latitude float,
	@Original_Longitude float,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_ParentId uniqueidentifier,
	@Original_ShipBusinessPhone nvarchar(50),
	@Original_ShipBusinessPhoneExt nvarchar(50),
	@Original_ShipCity nvarchar(50),
	@Original_ShipCompanyName nvarchar(200),
	@Original_ShipState nvarchar(50),
	@Original_ShipStreet1 nvarchar(50),
	@Original_ShipStreet2 nvarchar(50),
	@Original_ShipZipCode nvarchar(20),
	@Original_ShippingMethodCode int
)
AS
	SET NOCOUNT OFF;
DELETE FROM InternalAddressBase WHERE (InternalAddressId = @Original_InternalAddressId)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_FATopicByGroupIDSelectDelivery]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_FundraiserBase_FATopicByGroupIDSelectDelivery]
	@GroupID uniqueidentifier
AS
BEGIN
		SET NOCOUNT ON;

  SELECT FundraiserID, Topic, DeliveryID
	FROM FundraiserBase
	WHERE GroupId = @GroupID And DeletionStatusCode <> 1 And StatusCode <> 2
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_SelectType]'
GO


CREATE PROCEDURE [dbo].[FRP_ProductBase_SelectType]
(
	@ProductID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT ProductId, ProductNumber, Name, Description, ProductTypeCode, DefaultUoMScheduleID, ProductClassID, DefaultUoMId, RetailPrice, GroupRetailPrice, ConsumerRetailPrice, DealerPrice, QuantityOnHand, QuantityAllocated, Carried, DeletionStateCode, CreatedOn, ModifiedOn, CreatedBy, ModifiedBy, StatusCode, ProductSalesPercentage, FlierOrder FROM ProductBase WHERE (ProductId = @ProductID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CompanyBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_CompanyBase_Select]
AS
	SET NOCOUNT ON;
SELECT CompanyID, Name, WebsiteURL, EmailAddress, BusinessPhone, BusinessPhoneExt, OtherPhone, OtherPhoneExt, Fax, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM CompanyBase


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_NoteBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_NoteBase_Update]
(
	@NoteID uniqueidentifier,
	@ParentID uniqueidentifier,
	@Subject nvarchar(500),
	@NoteText ntext,
	@DeletionStateCode int,
	@OwningUser uniqueidentifier,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_NoteID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_OwningUser uniqueidentifier,
	@Original_ParentID uniqueidentifier,
	@Original_Subject nvarchar(500)
)
AS
	SET NOCOUNT OFF;
UPDATE NoteBase SET NoteID = @NoteID, ParentID = @ParentID, Subject = @Subject, NoteText = @NoteText, DeletionStateCode = @DeletionStateCode, OwningUser = @OwningUser, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (NoteID = @Original_NoteID);
	SELECT NoteID, ParentID, Subject, NoteText, DeletionStateCode, OwningUser, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM NoteBase WHERE (NoteID = @NoteID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQuantityPOPending]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdateQuantityPOPending] 
(
@UseDates bit,
@StartDate datetime,
@EndDate datetime
)
	AS
		SET NOCOUNT ON;
Declare @ProductID uniqueidentifier
Declare @QuantityPending integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
IF @UseDates = 0
BEGIN		
	Set @QuantityPending = (Select SUM(podb.QuantityOrdered) as TotalQuantity 
						FROM PurchaseOrderBase po Left Outer Join PurchaseOrderDetailBase podb  On po.PurchaseOrderID= podb.PurchaseOrderID
						WHERE podb.ProductID = @ProductID AND po.Stage = 0 And po.Status = 0 AND po.DeletionStateCode <> 1) 
Update ProductBase Set QuantityPOPending = isNull(@QuantityPending,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END
ELSE IF @UseDates = 1
BEGIN		
	Set @QuantityPending = (Select SUM(podb.QuantityOrdered) as TotalQuantity 
						FROM PurchaseOrderBase po Left Outer Join PurchaseOrderDetailBase podb  On po.PurchaseOrderID= podb.PurchaseOrderID
						WHERE podb.ProductID = @ProductID AND po.ReceivedOn >= @StartDate AND po.ReceivedOn <= @EndDate AND po.Stage = 0 And po.Status = 0 AND po.DeletionStateCode <> 1) 
Update ProductBase Set QuantityPOPending = isNull(@QuantityPending,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END
END
CLOSE Product_Cursor 
DEALLOCATE Product_Cursor 


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_CheckForMultiplePrimaryAddresses]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_CheckForMultiplePrimaryAddresses] 
	(
@ParentID uniqueidentifier,
@AddressID uniqueidentifier
)
AS
BEGIN
		SET NOCOUNT ON;

   	SELECT * FROM CustomerAddressBase
WHERE CustomerAddressBase.ParentID = @ParentID AND CustomerAddressBase.PrimaryAddressCode = 1 AND CustomerAddressBase.AddressID <> @AddressID
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_ContactBase_Insert]
(
	@ContactId uniqueidentifier,
	@ParentgroupID uniqueidentifier,
	@Anniversary datetime,
	@AssistantName nvarchar(100),
	@AssistantPhone nvarchar(50),
	@AssistantPhoneExt nvarchar(5),
	@BirthDate datetime,
	@BusinessPhone nvarchar(50),
	@BusinessPhoneExt nvarchar(5),
	@ContactRole nvarchar(50),
	@CreditOnHold bit,
	@DeletionStateCode int,
	@Department nvarchar(100),
	@DescriptionInfo ntext,
	@DoNotBulkEMail bit,
	@DoNotBulkPostalMail bit,
	@DoNotEMail bit,
	@DoNotFax bit,
	@DoNotPhone bit,
	@DoNotPostalMail bit,
	@EMailAddress1 nvarchar(100),
	@EMailAddress2 nvarchar(100),
	@EMailAddress3 nvarchar(100),
	@FamilyStatusCode int,
	@Fax nvarchar(50),
	@FirstName nvarchar(50),
	@FreightTermsCode int,
	@FullName nvarchar(160),
	@GenderCode int,
	@HasChildrenCode int,
	@HomePhone nvarchar(50),
	@JobTitle nvarchar(100),
	@LastName nvarchar(50),
	@ManagerName nvarchar(100),
	@ManagerPhone nvarchar(50),
	@ManagerPhoneExt nvarchar(10),
	@MaritalStatus nvarchar(50),
	@MiddleName nvarchar(50),
	@MobilePhone nvarchar(50),
	@NickName nvarchar(50),
	@NumberOfChildren int,
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(10),
	@OwningUser uniqueidentifier,
	@PaymentTerms nvarchar(200),
	@PreferredContactMethodCode int,
	@PreferredPhoneCode int,
	@Salutation nvarchar(100),
	@ShippingMethod nvarchar(200),
	@SpousesName nvarchar(100),
	@StatusCode int,
	@Suffix nvarchar(10),
	@WebSiteUrl nvarchar(200),
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO ContactBase(ContactId, ParentgroupID, Anniversary, AssistantName, AssistantPhone, AssistantPhoneExt, BirthDate, BusinessPhone, BusinessPhoneExt, ContactRole, CreditOnHold, DeletionStateCode, Department, DescriptionInfo, DoNotBulkEMail, DoNotBulkPostalMail, DoNotEMail, DoNotFax, DoNotPhone, DoNotPostalMail, EMailAddress1, EMailAddress2, EMailAddress3, FamilyStatusCode, Fax, FirstName, FreightTermsCode, FullName, GenderCode, HasChildrenCode, HomePhone, JobTitle, LastName, ManagerName, ManagerPhone, ManagerPhoneExt, MaritalStatus, MiddleName, MobilePhone, NickName, NumberOfChildren, OtherPhone, OtherPhoneExt, OwningUser, PaymentTerms, PreferredContactMethodCode, PreferredPhoneCode, Salutation, ShippingMethod, SpousesName, StatusCode, Suffix, WebSiteUrl, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@ContactId, @ParentgroupID, @Anniversary, @AssistantName, @AssistantPhone, @AssistantPhoneExt, @BirthDate, @BusinessPhone, @BusinessPhoneExt, @ContactRole, @CreditOnHold, @DeletionStateCode, @Department, @DescriptionInfo, @DoNotBulkEMail, @DoNotBulkPostalMail, @DoNotEMail, @DoNotFax, @DoNotPhone, @DoNotPostalMail, @EMailAddress1, @EMailAddress2, @EMailAddress3, @FamilyStatusCode, @Fax, @FirstName, @FreightTermsCode, @FullName, @GenderCode, @HasChildrenCode, @HomePhone, @JobTitle, @LastName, @ManagerName, @ManagerPhone, @ManagerPhoneExt, @MaritalStatus, @MiddleName, @MobilePhone, @NickName, @NumberOfChildren, @OtherPhone, @OtherPhoneExt, @OwningUser, @PaymentTerms, @PreferredContactMethodCode, @PreferredPhoneCode, @Salutation, @ShippingMethod, @SpousesName, @StatusCode, @Suffix, @WebSiteUrl, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT ContactId, ParentgroupID, Anniversary, AssistantName, AssistantPhone, AssistantPhoneExt, BirthDate, BusinessPhone, BusinessPhoneExt, ContactRole, CreditOnHold, DeletionStateCode, Department, DescriptionInfo, DoNotBulkEMail, DoNotBulkPostalMail, DoNotEMail, DoNotFax, DoNotPhone, DoNotPostalMail, EMailAddress1, EMailAddress2, EMailAddress3, FamilyStatusCode, Fax, FirstName, FreightTermsCode, FullName, GenderCode, HasChildrenCode, HomePhone, JobTitle, LastName, ManagerName, ManagerPhone, ManagerPhoneExt, MaritalStatus, MiddleName, MobilePhone, NickName, NumberOfChildren, OtherPhone, OtherPhoneExt, OwningUser, PaymentTerms, PreferredContactMethodCode, PreferredPhoneCode, Salutation, ShippingMethod, SpousesName, StatusCode, Suffix, WebSiteUrl, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM ContactBase WHERE (ContactId = @ContactId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FundraiserProductClassView]'
GO
CREATE VIEW dbo.FundraiserProductClassView
AS
SELECT     u.Topic, SUM(o.Quantity) AS Total
FROM         dbo.FundraiserProductClassBase AS o LEFT OUTER JOIN
                      dbo.FundraiserBase AS u ON o.FundraiserID = u.FundraiserID
GROUP BY u.Topic

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceDetailBase_SelectByInvoiceId]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceDetailBase_SelectByInvoiceId]
(
	@InvoiceID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT *
FROM InvoiceDetailBase  
WHERE (InvoiceID = @InvoiceID) 



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_SetPrimaryAddressesToFalse]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_SetPrimaryAddressesToFalse]
(
	@ParentID uniqueidentifier,
	@AddressID uniqueidentifier
)
AS
BEGIN
		SET NOCOUNT ON;
    UPDATE CustomerAddressBase SET PrimaryAddressCode = 0 WHERE CustomerAddressBase.ParentID = @ParentID AND CustomerAddressBase.PrimaryAddressCode = 1 AND CustomerAddressBase.AddressID <> @AddressID
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserDetailBase_RecordsFromFundraiserProductClass]'
GO





--Create FRP_FundraiserDetailBase_RecordsFromFundraiserProductClass SP

CREATE PROCEDURE [dbo].[FRP_FundraiserDetailBase_RecordsFromFundraiserProductClass]
(
	@FundraiserID uniqueidentifier
)
AS
	 SET NOCOUNT ON 
Declare @ProductID uniqueidentifier, @ProductNumber nvarchar(50), @ProductDescription nvarchar(50), @Quantity int, @PricePerUnit money, @ProductSalesPercentage float

--First Delete all records for FundraiserId
DELETE FROM FundraiserDetailBase Where FundraiserID = @FundraiserID

DECLARE Product_Cursor CURSOR FOR
SELECT p.ProductID,
	p.ProductNumber,
	p.Description,
	fpc.Quantity,
	p.GroupRetailPrice,
	p.ProductSalesPercentage
FROM FundraiserProductClassBase fpc
	Left Outer JOIN ProductBase p On p.ProductClassID = fpc.ProductClassID
Where fpc.FundraiserID = @FundraiserID AND p.carried <> 0 and p.deletionstatecode <> 1
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID, @ProductNumber, @ProductDescription, @Quantity, @PricePerUnit, @ProductSalesPercentage
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT FundraiserDetailBase(FundraiserDetailID, FundraiserID, ProductID, ProductNumber, ProductDescription, Quantity, PricePerUnit, ExtendedAmount) --ManualDiscountAmount, BaseAmount, UofMID
	VALUES(newID(), @FundraiserID, @ProductID, @ProductNumber, @ProductDescription, ROUND(@Quantity * @ProductSalesPercentage,0), @PricePerUnit, ROUND(@Quantity * @ProductSalesPercentage,0) * @PricePerUnit)	
	--Select newID(), @ProductID, @InvoiceID, 0, @ProductNumber, @ProductDescription, ROUND(@Quantity * @ProductSalesPercentage,0), @PricePerUnit, -1, ROUND(@Quantity * @ProductSalesPercentage,0) * @PricePerUnit
FETCH NEXT FROM Product_Cursor  
INTO @ProductID, @ProductNumber, @ProductDescription, @Quantity, @PricePerUnit, @ProductSalesPercentage
END
CLOSE Product_Cursor 
DEALLOCATE Product_Cursor 










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_DefaultBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_DefaultBase_Insert]
(
	@DefaultId uniqueidentifier,
	@DefaultName nvarchar(50),
	@DefaultSubName nvarchar(50),
	@Code bigint,
	@DefaultText nvarchar(50),
	@Ordinal bigint,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO DefaultBase(DefaultId, DefaultName, DefaultSubName, Code, DefaultText, Ordinal, ModifiedOn, ModifiedBy, CreatedOn, CreatedBy) VALUES (@DefaultId, @DefaultName, @DefaultSubName, @Code, @DefaultText, @Ordinal, @ModifiedOn, @ModifiedBy, @CreatedOn, @CreatedBy);
	SELECT DefaultId, DefaultName, DefaultSubName, Code, DefaultText, Ordinal, ModifiedOn, ModifiedBy, CreatedOn, CreatedBy FROM DefaultBase WHERE (DefaultId = @DefaultId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_NotDeletedProducts]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_NotDeletedProducts] 
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT * FROM ProductBase
WHERE ProductBase.DeletionStateCode <> 1
Order By ProductNumber

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ShippingMethodBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_ShippingMethodBase_Insert]
(
	@ShippingMethodID uniqueidentifier,
	@Name nvarchar(200),
	@DeletionStateCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO ShippingMethodBase(ShippingMethodID, Name, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@ShippingMethodID, @Name, @DeletionStateCode, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT ShippingMethodID, Name, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM ShippingMethodBase WHERE (ShippingMethodID = @ShippingMethodID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[fnColumnDefault]'
GO

CREATE FUNCTION dbo.fnColumnDefault(@sTableName varchar(128), @sColumnName varchar(128))
RETURNS varchar(4000)
AS
BEGIN
	DECLARE @sDefaultValue varchar(4000)
	SELECT	@sDefaultValue = dbo.fnCleanDefaultValue(COLUMN_DEFAULT)
	FROM	INFORMATION_SCHEMA.COLUMNS
	WHERE	TABLE_NAME = @sTableName
	 AND 	COLUMN_NAME = @sColumnName
	RETURN 	@sDefaultValue
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_SelectActiveContactsByGroupID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE[dbo].[FRP_ContactBase_SelectActiveContactsByGroupID]   
	(
		@GroupID uniqueidentifier
)
AS
BEGIN
		SET NOCOUNT ON;
Select * from contactbase
where ParentGroupID = @GroupID AND DeletionStateCode = 0 And StatusCode = 0
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_GridSelectDateRange]'
GO

/*
If StatusCode is 0 then all records are returned
*/
CREATE PROCEDURE [dbo].[FRP_ContactBase_GridSelectDateRange]
(
	@StatusCode as int,
	@StartDate as datetime,
	@EndDate as datetime
)
AS
	SET NOCOUNT ON;
Declare @StatusCodeEnd as int
if @StatusCode = 0
	set @StatusCodeEnd = 4
else
if @StatusCode = 1
	Begin
		set @StatusCode = 0
		set @StatusCodeEnd = 0
	End
else
if @StatusCode = 2
	Begin
		set @StatusCode = 1
		set @StatusCodeEnd = 1
	End
else
	set @StatusCodeEnd = @StatusCode

	SELECT 
		c.*,
		a.groupName as [Parent group],
		u.FullName as [Owning User]
	FROM ContactBase c 
		Left Outer Join groupBase a 	On c.ParentgroupID = a.groupId
		Left Outer Join SystemUserBase u 	On c.OwningUser = u.SystemUserId
	Where c.StatusCode >= @StatusCode And c.StatusCode <= @StatusCodeEnd
		AND c.CreatedOn >= @StartDate And c.CreatedOn <= @EndDate And c.DeletionStateCode = 0
	ORDER BY c.LastName, c.FirstName


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_GridSelectByParentID]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_GridSelectByParentID]
(
	@ParentID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT	FundraiserID,
	Topic as [Event Name],
	SalesStageCode as [Sales Stage],
	StartOn as [Start On],
	CallInOrderBy as [Call In Order By],
	CreatedOn as [Created On]
FROM	FundraiserBase
Where GroupID = @ParentID And DeletionStatusCode <> 1 And StatusCode <> 2
Order By StartOn DESC



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupBase_Update]
(
	@GroupCategoryCode int,
	@GroupId uniqueidentifier,
	@GroupName nvarchar(160),
	@GroupNumber nvarchar(20),
	@CreditOnHold bit,
	@DeletionStateCode int,
	@DescriptionInfo ntext,
	@DoNotBulkEMail bit,
	@DoNotBulkPostalMail bit,
	@DoNotEMail bit,
	@DoNotFax bit,
	@DoNotPhone bit,
	@DoNotPostalMail bit,
	@EMailAddress1 nvarchar(100),
	@Fax nvarchar(50),
	@FreightTermsCode int,
	@GroupSize int,
	@GroupType nvarchar(200),
	@MainPhone nvarchar(50),
	@MainPhoneExt nvarchar(10),
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(10),
	@OwningUser uniqueidentifier,
	@PaymentTerms nvarchar(200),
	@PreferredContactMethodCode int,
	@PreferredPhoneCode int,
	@PrimaryContactId uniqueidentifier,
	@ShippingMethod nvarchar(200),
	@StatusCode int,
	@WebSiteURL nvarchar(200),
	@CreatedBy uniqueidentifier,
	@CreatedOn datetime,
	@ModifiedBy uniqueidentifier,
	@ModifiedOn datetime,
	@Original_GroupId uniqueidentifier,
	@Original_GroupCategoryCode int,
	@Original_GroupName nvarchar(160),
	@Original_GroupNumber nvarchar(20),
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_CreditOnHold bit,
	@Original_DeletionStateCode int,
	@Original_DoNotBulkEMail bit,
	@Original_DoNotBulkPostalMail bit,
	@Original_DoNotEMail bit,
	@Original_DoNotFax bit,
	@Original_DoNotPhone bit,
	@Original_DoNotPostalMail bit,
	@Original_EMailAddress1 nvarchar(100),
	@Original_Fax nvarchar(50),
	@Original_FreightTermsCode int,
	@Original_GroupSize int,
	@Original_GroupType nvarchar(200),
	@Original_MainPhone nvarchar(50),
	@Original_MainPhoneExt nvarchar(10),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(10),
	@Original_OwningUser uniqueidentifier,
	@Original_PaymentTerms nvarchar(200),
	@Original_PreferredContactMethodCode int,
	@Original_PreferredPhoneCode int,
	@Original_PrimaryContactId uniqueidentifier,
	@Original_ShippingMethod nvarchar(200),
	@Original_StatusCode int,
	@Original_WebSiteURL nvarchar(200)
)
AS
	SET NOCOUNT OFF;
UPDATE GroupBase SET GroupCategoryCode = @GroupCategoryCode, GroupId = @GroupId, GroupName = @GroupName, GroupNumber = @GroupNumber, CreditOnHold = @CreditOnHold, DeletionStateCode = @DeletionStateCode, DescriptionInfo = @DescriptionInfo, DoNotBulkEMail = @DoNotBulkEMail, DoNotBulkPostalMail = @DoNotBulkPostalMail, DoNotEMail = @DoNotEMail, DoNotFax = @DoNotFax, DoNotPhone = @DoNotPhone, DoNotPostalMail = @DoNotPostalMail, EMailAddress1 = @EMailAddress1, Fax = @Fax, FreightTermsCode = @FreightTermsCode, GroupSize = @GroupSize, GroupType = @GroupType, MainPhone = @MainPhone, MainPhoneExt = @MainPhoneExt, OtherPhone = @OtherPhone, OtherPhoneExt = @OtherPhoneExt, OwningUser = @OwningUser, PaymentTerms = @PaymentTerms, PreferredContactMethodCode = @PreferredContactMethodCode, PreferredPhoneCode = @PreferredPhoneCode, PrimaryContactId = @PrimaryContactId, ShippingMethod = @ShippingMethod, StatusCode = @StatusCode, WebSiteURL = @WebSiteURL, CreatedBy = @CreatedBy, CreatedOn = @CreatedOn, ModifiedBy = @ModifiedBy, ModifiedOn = @ModifiedOn WHERE (GroupId = @Original_GroupId);
	SELECT GroupCategoryCode, GroupId, GroupName, GroupNumber, CreditOnHold, DeletionStateCode, DescriptionInfo, DoNotBulkEMail, DoNotBulkPostalMail, DoNotEMail, DoNotFax, DoNotPhone, DoNotPostalMail, EMailAddress1, Fax, FreightTermsCode, GroupSize, GroupType, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, OwningUser, PaymentTerms, PreferredContactMethodCode, PreferredPhoneCode, PrimaryContactId, ShippingMethod, StatusCode, WebSiteURL, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM GroupBase WHERE (GroupId = @GroupId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_NoteBase_DeleteFromTable]'
GO
CREATE PROCEDURE [dbo].[FRP_NoteBase_DeleteFromTable]
	(
	@Original_NoteID uniqueidentifier
)
AS
BEGIN
	
SET NOCOUNT OFF;
DELETE FROM NoteBase WHERE (NoteID = @Original_NoteID) 
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_Update]
(
	@AddressID uniqueidentifier,
	@AddressTypeCode int,
	@ParentID uniqueidentifier,
	@AddressName nvarchar(200),
	@PrimaryContactName nvarchar(150),
	@Street1 nvarchar(50),
	@Street2 nvarchar(50),
	@Street3 nvarchar(50),
	@City nvarchar(50),
	@State nvarchar(50),
	@ZipCode nvarchar(20),
	@FreightTermsCode int,
	@Latitude float,
	@Longitude float,
	@ShippingMethod nvarchar(200),
	@MainPhone nvarchar(50),
	@MainPhoneExt nvarchar(10),
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(10),
	@Fax nvarchar(50),
	@PrimaryAddressCode int,
	@DeletionStateCode int,
	@Original_AddressID uniqueidentifier,
	@Original_AddressName nvarchar(200),
	@Original_AddressTypeCode int,
	@Original_City nvarchar(50),
	@Original_DeletionStateCode int,
	@Original_Fax nvarchar(50),
	@Original_FreightTermsCode int,
	@Original_Latitude float,
	@Original_Longitude float,
	@Original_MainPhone nvarchar(50),
	@Original_MainPhoneExt nvarchar(10),
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(10),
	@Original_ParentID uniqueidentifier,
	@Original_PrimaryAddressCode int,
	@Original_PrimaryContactName nvarchar(150),
	@Original_ShippingMethod nvarchar(200),
	@Original_State nvarchar(50),
	@Original_Street1 nvarchar(50),
	@Original_Street2 nvarchar(50),
	@Original_Street3 nvarchar(50),
	@Original_ZipCode nvarchar(20)
)
AS
	SET NOCOUNT OFF;
UPDATE CustomerAddressBase SET AddressID = @AddressID, AddressTypeCode = @AddressTypeCode, ParentID = @ParentID, AddressName = @AddressName, PrimaryContactName = @PrimaryContactName, Street1 = @Street1, Street2 = @Street2, Street3 = @Street3, City = @City, State = @State, ZipCode = @ZipCode, FreightTermsCode = @FreightTermsCode, Latitude = @Latitude, Longitude = @Longitude, ShippingMethod = @ShippingMethod, MainPhone = @MainPhone, MainPhoneExt = @MainPhoneExt, OtherPhone = @OtherPhone, OtherPhoneExt = @OtherPhoneExt, Fax = @Fax, PrimaryAddressCode = @PrimaryAddressCode, DeletionStateCode = @DeletionStateCode WHERE (AddressID = @Original_AddressID);
	SELECT AddressID, AddressTypeCode, ParentID, AddressName, PrimaryContactName, Street1, Street2, Street3, City, State, ZipCode, FreightTermsCode, Latitude, Longitude, ShippingMethod, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, Fax, PrimaryAddressCode, DeletionStateCode FROM CustomerAddressBase WHERE (AddressID = @AddressID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_GridSelectByParentID]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceBase_GridSelectByParentID]
(
	@ParentID as uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT	InvoiceId,
	InvoiceNumber as [Invoice Number],
	StatusReasonCode as [Status],	
	TotalAmount as [Total Amount],	
	CreatedOn as [Created On]
FROM	InvoiceBase
Where GroupID = @ParentId And DeletionStatusCode <> 1
ORDER BY InvoiceNumber DESC


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_Select]
(
	@FundraiserID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT * FROM FundraiserBase WHERE (FundraiserID = @FundraiserID)




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_SelectDeliveriesByInvoiceID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_SelectDeliveriesByInvoiceID] 
	(
	@InvoiceID uniqueidentifier
)
AS
BEGIN
	SELECT ActivityBase.Activityid, ActivityBase.Subject, ActivityBase.ScheduledStartDate, ActivityBase.ScheduledEndDate, ActivityBase.AllDayEvent, ActivityBase.Message, ActivityBase.AddressName, ActivityBase.Street1, ActivityBase.Street2, ActivityBase.City, ActivityBase.State, ActivityBase.ZipCode, ActivityBase.MapGridId, ActivityBase.Label, ActivityBase.AddressNotes, ActivityBase.PhoneNumber, ActivityBase.PhoneNumberExt, ActivityBase.PrimaryDelivery, ContactBase.Fullname, ContactBase.ContactID, SystemUserBase.DisplayName 
FROM ActivityBase  
LEFT OUTER JOIN SystemUserBase ON ActivityBase.OwningUser = SystemUserBase.SystemUserId
LEFT OUTER JOIN ContactBase ON ActivityBase.ContactID = ContactBase.ContactID
WHERE ActivityBase.DocID = @InvoiceID AND ActivityBase.ActivityTypeCode = 2 AND ActivityBase.StatusCode <> 2
ORDER BY ActivityBase.PrimaryDelivery DESC
END







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_SelectByUsername]'
GO

CREATE PROCEDURE [dbo].[FRP_SystemUserBase_SelectByUsername]
(
	@username as nvarchar(50)
)
AS
	SET NOCOUNT ON;
SELECT	SystemUserId,
	DeletionStateCode,
	UserName,
	Password,
	SecurityCode,
	CompanyID,
	Salutation,
	FirstName,
	MiddleName,
	LastName,
	FullName,
	NickName,
	JobTitle,
	Email1,
	Email2,
	PreferredEmailCode,
	BusinessPhone,
	BusinessPhoneExt,
	HomePhone,
	MobilePhone,
	OtherPhone,
	OtherPhoneExt,
	PreferredPhoneCode,
	PreferredAddressCode,
	EmployeeId,
	DeliveryRepresentativeCode,
	SalesRepresentativeCode,
	Street1,
	Street2,
	City,
	State,
	ZipCode,
	OtherStreet1,
	OtherStreet2,
	OtherCity,
	OtherState,
	OtherZipCode,
	CreatedOn,
	ModifiedOn,
	CreatedBy,
	ModifiedBy
FROM SystemUserBase 
WHERE UserName = @username --And DeletionStateCode <> 1


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_PaymentTermsBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_PaymentTermsBase_Select]
AS
	SET NOCOUNT ON;
SELECT PaymentTermsID,  Name, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy
FROM PaymentTermsBase
Order By Name



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_DeletionStateCode]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupBase_DeletionStateCode]
	(
	@GroupID uniqueidentifier
)
AS
BEGIN

	SET NOCOUNT ON;

Update GroupBase Set DeletionStateCode = 1 Where GroupID = @GroupID 

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_FullNameSelectByID]'
GO

CREATE  PROCEDURE [dbo].[FRP_ContactBase_FullNameSelectByID]
(
	@ContactId uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT ContactId, FullName FROM ContactBase 
WHERE (ContactId = @ContactId) And DeletionStateCode = 0 And StatusCode = 0


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_UpdateRelatedFundraisers]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_InvoiceBase_UpdateRelatedFundraisers]
(
	@FundraiserID uniqueidentifier,
	@NewFundStage int,
	@NewFundStatus int
)
AS
BEGIN
	SET NOCOUNT ON;

UPDATE FundraiserBase SET FundraiserBase.SalesStageCode = @NewFundStage, FundraiserBase.StatusCode = @NewFundStatus WHERE FundraiserBase.FundraiserID = @FundraiserID

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserProductClassBase_ProductClassCount]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserProductClassBase_ProductClassCount]
	(
		@FundraiserID uniqueidentifier,
		@FundraiserProductClassID uniqueidentifier,
		@ProductClassID uniqueidentifier
	)
AS
	
SELECT COUNT(*) FROM FundraiserProductClassBase Where FundraiserID = @FundraiserID AND ProductClassID = @ProductClassID AND FundraiserProductClassID <> @FundraiserProductClassID


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductClassBase_GetCarriedProductClasses]'
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductClassBase_GetCarriedProductClasses]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT * FROM ProductClassBase
WHERE DeletionStateCode = 0 And Carried <> 0
Order By OrderNumber, Name
   
END







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_DeleteInvoiceAndDetails]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceBase_DeleteInvoiceAndDetails] 
		(
	@InvoiceID uniqueidentifier
)
AS
BEGIN

	SET NOCOUNT ON;

Update InvoiceBase Set DeletionStatusCode = 1 Where InvoiceID = @InvoiceID
Update InvoiceDetailBase Set DeletionStateCode = 1 Where InvoiceID = @InvoiceID 
END




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdate]'
GO


CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdate]
(
	@ProductId uniqueidentifier,
	@ProductNumber nvarchar(100),
	@Name nvarchar(100),
	@Description ntext,
	@ProductTypeCode int,
	@DefaultUoMScheduleID uniqueidentifier,
	@ProductClassID uniqueidentifier,
	@DefaultUoMId uniqueidentifier,
	@RetailPrice money,
	@GroupRetailPrice money,
	@ConsumerRetailPrice money,
	@DealerPrice money,
	@QuantityOnHand decimal(18,5),
	@QuantityAllocated decimal(18),
	@Carried bit,
	@DeletionStateCode int,
	@CreatedOn datetime,
	@ModifiedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedBy uniqueidentifier,
	@StatusCode int,
	@ProductSalesPercentage decimal(18,5),
	@FlierOrder int,
	@Original_ProductId uniqueidentifier,
	@Original_ConsumerRetailPrice money,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DealerPrice money,
	@Original_DefaultUoMId uniqueidentifier,
	@Original_DefaultUoMScheduleID uniqueidentifier,
	@Original_DeletionStateCode int,
	@Original_FlierOrder int,
	@Original_GroupRetailPrice money,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(100),
	@Original_ProductClassID uniqueidentifier,
	@Original_ProductNumber nvarchar(100),
	@Original_ProductSalesPercentage decimal(18,5),
	@Original_Carried bit,
	@Original_ProductTypeCode int,
	@Original_QuantityAllocated decimal(18),
	@Original_QuantityOnHand decimal(18,5),
	@Original_RetailPrice money,
	@Original_StateCode int,
	@Original_StatusCode int
)
AS
	SET NOCOUNT OFF;
UPDATE ProductBase SET ProductId = @ProductId, ProductNumber = @ProductNumber, Name = @Name, Description = @Description, ProductTypeCode = @ProductTypeCode, DefaultUoMScheduleID = @DefaultUoMScheduleID, ProductClassID = @ProductClassID, DefaultUoMId = @DefaultUoMId, RetailPrice = @RetailPrice, GroupRetailPrice = @GroupRetailPrice, ConsumerRetailPrice = @ConsumerRetailPrice, DealerPrice = @DealerPrice, QuantityOnHand = @QuantityOnHand, QuantityAllocated = @QuantityAllocated, Carried = @Carried, DeletionStateCode = @DeletionStateCode, CreatedOn = @CreatedOn, ModifiedOn = @ModifiedOn, CreatedBy = @CreatedBy, ModifiedBy = @ModifiedBy, StatusCode = @StatusCode, ProductSalesPercentage = @ProductSalesPercentage, FlierOrder = @FlierOrder WHERE (ProductId = @Original_ProductId);
	SELECT ProductId, ProductNumber, Name, Description, ProductTypeCode, DefaultUoMScheduleID, ProductClassID, DefaultUoMId, RetailPrice, GroupRetailPrice, ConsumerRetailPrice, DealerPrice, QuantityOnHand, QuantityAllocated, Carried, DeletionStateCode, CreatedOn, ModifiedOn, CreatedBy, ModifiedBy, StatusCode, ProductSalesPercentage, FlierOrder FROM ProductBase WHERE (ProductId = @ProductId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceDetailBase_GridInsert]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceDetailBase_GridInsert]
(
	@InvoiceDetailID uniqueidentifier,
	@ProductNumber nvarchar(50),
	@ProductDescription ntext,
	@Quantity decimal(18),
	@PricePerUnit money,
	@ExtendedAmount money
)
AS
	SET NOCOUNT OFF;
INSERT INTO InvoiceDetailBase(InvoiceDetailID, ProductNumber, ProductDescription, Quantity, PricePerUnit, ExtendedAmount) VALUES (@InvoiceDetailID, @ProductNumber, @ProductDescription, @Quantity, @PricePerUnit, @ExtendedAmount);
	SELECT InvoiceDetailID, ProductNumber AS [Product Number], ProductDescription AS Description, Quantity, PricePerUnit AS [Unit Price], ExtendedAmount AS [Extended Amount] FROM InvoiceDetailBase i WHERE (InvoiceDetailID = @InvoiceDetailID) ORDER BY ProductNumber


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_UofMScheduleDetailBase_SelectByUoMScheduleID]'
GO

CREATE PROCEDURE [dbo].[FRP_UofMScheduleDetailBase_SelectByUoMScheduleID]
(
			@UoMScheduleId as uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT UoMId,
UoMScheduleId,
IsScheduleBaseUoM,
UofM,
Name,
Quantity,
Eqivalent,
DeletionStateCode,
CreatedOn,
CreatedBy,
ModifiedBy,
ModifiedOn
FROM UofMScheduleDetailBase
Where UoMScheduleId = @UoMScheduleId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_SaveBlankFundraiserDelID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_SaveBlankFundraiserDelID]
	(
	@FundraiserID uniqueidentifier
)
AS
BEGIN
	
	SET NOCOUNT ON;

Update FundraiserBase Set DeliveryID = '00000000-0000-0000-0000-000000000000' Where FundraiserID = @FundraiserID

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CompanyBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_CompanyBase_Update]
(
	@CompanyID uniqueidentifier,
	@Name nvarchar(160),
	@WebsiteURL nvarchar(200),
	@EmailAddress nvarchar(50),
	@BusinessPhone nvarchar(50),
	@BusinessPhoneExt nvarchar(50),
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(50),
	@Fax nvarchar(50),
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_CompanyID uniqueidentifier,
	@Original_BusinessPhone nvarchar(50),
	@Original_BusinessPhoneExt nvarchar(50),
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_EmailAddress nvarchar(50),
	@Original_Fax nvarchar(50),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(160),
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(50),
	@Original_WebsiteURL nvarchar(200)
)
AS
	SET NOCOUNT OFF;
UPDATE CompanyBase SET CompanyID = @CompanyID, Name = @Name, WebsiteURL = @WebsiteURL, EmailAddress = @EmailAddress, BusinessPhone = @BusinessPhone, BusinessPhoneExt = @BusinessPhoneExt, OtherPhone = @OtherPhone, OtherPhoneExt = @OtherPhoneExt, Fax = @Fax, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (CompanyID = @Original_CompanyID);
	SELECT CompanyID, Name, WebsiteURL, EmailAddress, BusinessPhone, BusinessPhoneExt, OtherPhone, OtherPhoneExt, Fax, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM CompanyBase WHERE (CompanyID = @CompanyID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQuantityForecastedFundraisers]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_PCUpdateQuantityForecastedFundraisers]
(
@UseDates bit,
@StartDate datetime,
@EndDate datetime
)
	AS
	SET NOCOUNT ON;
Declare @ProductID uniqueidentifier
Declare @FundraiserQuantity integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
IF @UseDates = 0
BEGIN		
	Set @FundraiserQuantity = (Select SUM(fdb.Quantity) as TotalQuantity 
						FROM FundraiserBase f Left Outer Join FundraiserDetailBase fdb  On f.FundraiserId = fdb.FundraiserID
						WHERE fdb.ProductID = @ProductID AND f.SalesStageCode <= 1 And f.StatusCode = 1 AND f.DeletionStatusCode <> 1) 
Update ProductBase Set QuantityFundForecasted = isNull(@FundraiserQuantity,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END
ELSE IF @UseDates = 1
BEGIN	
		Set @FundraiserQuantity = (Select SUM(fdb.Quantity) as TotalQuantity 
						FROM FundraiserBase f Left Outer Join FundraiserDetailBase fdb  On f.FundraiserId = fdb.FundraiserID
						WHERE fdb.ProductID = @ProductID AND f.CallInOrderBy >= @StartDate AND f.CallInOrderBy <= @EndDate AND f.SalesStageCode <= 1 And f.StatusCode = 1 AND f.DeletionStatusCode <> 1) 
Update ProductBase Set QuantityFundForecasted = isNull(@FundraiserQuantity,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor  
INTO @ProductID
END
END
CLOSE Product_Cursor 
DEALLOCATE Product_Cursor 








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_UofMScheduleBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_UofMScheduleBase_Select]
AS
	SET NOCOUNT ON;
SELECT UoMScheduleId,
 Name,
 Description,
 BaseUofM,
 DeletionStateCode,
 CreatedOn,
 CreatedBy,
 ModifiedOn,
 ModifiedBy 
FROM UofMScheduleBase
Order By Name


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserDetailBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserDetailBase_Update]
(
	@FundraiserDetailID uniqueidentifier,
	@FundraiserID uniqueidentifier,
	@ProductID uniqueidentifier,
	@ProductNumber nvarchar(50),
	@ProductDescription ntext,
	@Quantity decimal(18),
	@PricePerUnit money,
	@BaseAmount money,
	@ExtendedAmount money,
	@UofMID uniqueidentifier,
	@ManualDiscountAmount money,
	@Tax money,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_FundraiserDetailID uniqueidentifier,
	@Original_BaseAmount money,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_ExtendedAmount money,
	@Original_ManualDiscountAmount money,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_FundraiserID uniqueidentifier,
	@Original_PricePerUnit money,
	@Original_ProductDescription ntext,
	@Original_ProductID uniqueidentifier,
	@Original_ProductNumber nvarchar(50),
	@Original_Quantity decimal(18),
	@Original_Tax money,
	@Original_UofMID uniqueidentifier
)
AS
	SET NOCOUNT OFF;
UPDATE FundraiserDetailBase SET FundraiserDetailID = @FundraiserDetailID, FundraiserID = @FundraiserID, ProductID = @ProductID, ProductNumber = @ProductNumber, ProductDescription = @ProductDescription, Quantity = @Quantity, PricePerUnit = @PricePerUnit, BaseAmount = @BaseAmount, ExtendedAmount = @ExtendedAmount, UofMID = @UofMID, ManualDiscountAmount = @ManualDiscountAmount, Tax = @Tax, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (FundraiserDetailID = @Original_FundraiserDetailID);
	SELECT FundraiserDetailID, FundraiserID, ProductID, ProductNumber, ProductDescription, Quantity, PricePerUnit, BaseAmount, ExtendedAmount, UofMID, ManualDiscountAmount, Tax, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM FundraiserDetailBase WHERE (FundraiserDetailID = @FundraiserDetailID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupTypeBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupTypeBase_Insert]
(
	@GroupTypeID uniqueidentifier,
	@Name nvarchar(200),
	@Code int,
	@DeletionStateCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO GroupTypeBase(GroupTypeID, Name, Code, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@GroupTypeID, @Name, @Code, @DeletionStateCode, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT GroupTypeID, Name, Code, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM GroupTypeBase WHERE (GroupTypeID = @GroupTypeID) ORDER BY Name


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupBase_Insert]
(
	@GroupCategoryCode int,
	@GroupId uniqueidentifier,
	@GroupName nvarchar(160),
	@GroupNumber nvarchar(20),
	@CreditOnHold bit,
	@DeletionStateCode int,
	@DescriptionInfo ntext,
	@DoNotBulkEMail bit,
	@DoNotBulkPostalMail bit,
	@DoNotEMail bit,
	@DoNotFax bit,
	@DoNotPhone bit,
	@DoNotPostalMail bit,
	@EMailAddress1 nvarchar(100),
	@Fax nvarchar(50),
	@FreightTermsCode int,
	@GroupSize int,
	@GroupType nvarchar(200),
	@MainPhone nvarchar(50),
	@MainPhoneExt nvarchar(10),
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(10),
	@OwningUser uniqueidentifier,
	@PaymentTerms nvarchar(200),
	@PreferredContactMethodCode int,
	@PreferredPhoneCode int,
	@PrimaryContactId uniqueidentifier,
	@ShippingMethod nvarchar(200),
	@StatusCode int,
	@WebSiteURL nvarchar(200),
	@CreatedBy uniqueidentifier,
	@CreatedOn datetime,
	@ModifiedBy uniqueidentifier,
	@ModifiedOn datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO GroupBase(GroupCategoryCode, GroupId, GroupName, GroupNumber, CreditOnHold, DeletionStateCode, DescriptionInfo, DoNotBulkEMail, DoNotBulkPostalMail, DoNotEMail, DoNotFax, DoNotPhone, DoNotPostalMail, EMailAddress1, Fax, FreightTermsCode, GroupSize, GroupType, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, OwningUser, PaymentTerms, PreferredContactMethodCode, PreferredPhoneCode, PrimaryContactId, ShippingMethod, StatusCode, WebSiteURL, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn) VALUES (@GroupCategoryCode, @GroupId, @GroupName, @GroupNumber, @CreditOnHold, @DeletionStateCode, @DescriptionInfo, @DoNotBulkEMail, @DoNotBulkPostalMail, @DoNotEMail, @DoNotFax, @DoNotPhone, @DoNotPostalMail, @EMailAddress1, @Fax, @FreightTermsCode, @GroupSize, @GroupType, @MainPhone, @MainPhoneExt, @OtherPhone, @OtherPhoneExt, @OwningUser, @PaymentTerms, @PreferredContactMethodCode, @PreferredPhoneCode, @PrimaryContactId, @ShippingMethod, @StatusCode, @WebSiteURL, @CreatedBy, @CreatedOn, @ModifiedBy, @ModifiedOn);
	SELECT GroupCategoryCode, GroupId, GroupName, GroupNumber, CreditOnHold, DeletionStateCode, DescriptionInfo, DoNotBulkEMail, DoNotBulkPostalMail, DoNotEMail, DoNotFax, DoNotPhone, DoNotPostalMail, EMailAddress1, Fax, FreightTermsCode, GroupSize, GroupType, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, OwningUser, PaymentTerms, PreferredContactMethodCode, PreferredPhoneCode, PrimaryContactId, ShippingMethod, StatusCode, WebSiteURL, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM GroupBase WHERE (GroupId = @GroupId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_ContactBase_Select]
(
	@ContactID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT ContactId, ParentgroupID, Anniversary, AssistantName, AssistantPhone, AssistantPhoneExt, BirthDate, BusinessPhone, BusinessPhoneExt, ContactRole, CreditOnHold, DeletionStateCode, Department, DescriptionInfo, DoNotBulkEMail, DoNotBulkPostalMail, DoNotEMail, DoNotFax, DoNotPhone, DoNotPostalMail, EMailAddress1, EMailAddress2, EMailAddress3, FamilyStatusCode, Fax, FirstName, FreightTermsCode, FullName, GenderCode, HasChildrenCode, HomePhone, JobTitle, LastName, ManagerName, ManagerPhone, ManagerPhoneExt, MaritalStatus, MiddleName, MobilePhone, NickName, NumberOfChildren, OtherPhone, OtherPhoneExt, OwningUser, PaymentTerms, PreferredContactMethodCode, PreferredPhoneCode, Salutation, ShippingMethod, SpousesName, StatusCode, Suffix, WebSiteUrl, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM ContactBase WHERE (ContactId = @ContactID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceDetailBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceDetailBase_Update]
(
	@InvoiceDetailID uniqueidentifier,
	@InvoiceID uniqueidentifier,
	@DeletionStateCode int,
	@SalesRepID uniqueidentifier,
	@DeliveryRepID uniqueidentifier,
	@LineItemNumber int,
	@UofMID uniqueidentifier,
	@ProductID uniqueidentifier,
	@ProductNumber nvarchar(50),
	@ProductDescription ntext,
	@Quantity decimal(18),
	@PricePerUnit money,
	@PriceOverride bit,
	@BaseAmount money,
	@ExtendedAmount money,
	@ManualDiscountAmount money,
	@Tax money,
	@Original_InvoiceDetailID uniqueidentifier,
	@Original_BaseAmount money,
	@Original_DeletionStateCode int,
	@Original_DeliveryRepID uniqueidentifier,
	@Original_ExtendedAmount money,
	@Original_InvoiceID uniqueidentifier,
	@Original_LineItemNumber int,
	@Original_ManualDiscountAmount money,
	@Original_PriceOverride bit,
	@Original_PricePerUnit money,
	@Original_ProductID uniqueidentifier,
	@Original_ProductNumber nvarchar(50),
	@Original_Quantity decimal(18),
	@Original_SalesRepID uniqueidentifier,
	@Original_Tax money,
	@Original_UofMID uniqueidentifier
)
AS
	SET NOCOUNT OFF;
UPDATE InvoiceDetailBase SET InvoiceDetailID = @InvoiceDetailID, InvoiceID = @InvoiceID, DeletionStateCode = @DeletionStateCode, SalesRepID = @SalesRepID, DeliveryRepID = @DeliveryRepID, LineItemNumber = @LineItemNumber, UofMID = @UofMID, ProductID = @ProductID, ProductNumber = @ProductNumber, ProductDescription = @ProductDescription, Quantity = @Quantity, PricePerUnit = @PricePerUnit, PriceOverride = @PriceOverride, BaseAmount = @BaseAmount, ExtendedAmount = @ExtendedAmount, ManualDiscountAmount = @ManualDiscountAmount, Tax = @Tax WHERE (InvoiceDetailID = @Original_InvoiceDetailID);
	SELECT InvoiceDetailID, InvoiceID, DeletionStateCode, SalesRepID, DeliveryRepID, LineItemNumber, UofMID, ProductID, ProductNumber, ProductDescription, Quantity, PricePerUnit, PriceOverride, BaseAmount, ExtendedAmount, ManualDiscountAmount, Tax FROM InvoiceDetailBase WHERE (InvoiceDetailID = @InvoiceDetailID)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_DeletionStateCode]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_DeletionStateCode]
(
@ProductID uniqueidentifier
)
AS
BEGIN
SET NOCOUNT ON;
	UPDATE ProductBase SET DeletionStateCode = 1 Where ProductID = @ProductID
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_DisplayNameSelectByType]'
GO

CREATE PROCEDURE [dbo].[FRP_SystemUserBase_DisplayNameSelectByType]
(
	@RecordType integer
)
AS
	SET NOCOUNT ON;
IF @RecordType = 210 --TYPE_SALES_PERSON
BEGIN
	SELECT SystemUserId, 
			DisplayName 
	FROM SystemUserBase 
	WHERE Visible = 'True' And SalesRepresentativeCode = 1 -- (bit) equals true 
	ORDER BY DisplayName
END
ELSE
IF @RecordType = 211 --TYPE_DELIVERY_PERSON
BEGIN
	SELECT SystemUserId, 
			DisplayName
	FROM SystemUserBase 
	WHERE Visible = 'True' And DeliveryRepresentativeCode = 1 -- (bit) equals true
	ORDER BY DisplayName
END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_Delete]
(
	@Original_AddressID uniqueidentifier,
	@Original_AddressName nvarchar(200),
	@Original_AddressTypeCode int,
	@Original_City nvarchar(50),
	@Original_DeletionStateCode int,
	@Original_Fax nvarchar(50),
	@Original_FreightTermsCode int,
	@Original_Latitude float,
	@Original_Longitude float,
	@Original_MainPhone nvarchar(50),
	@Original_MainPhoneExt nvarchar(10),
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(10),
	@Original_ParentID uniqueidentifier,
	@Original_PrimaryAddressCode int,
	@Original_PrimaryContactName nvarchar(150),
	@Original_ShippingMethod nvarchar(200),
	@Original_State nvarchar(50),
	@Original_Street1 nvarchar(50),
	@Original_Street2 nvarchar(50),
	@Original_Street3 nvarchar(50),
	@Original_ZipCode nvarchar(20)
)
AS
	SET NOCOUNT OFF;
DELETE FROM CustomerAddressBase WHERE (AddressID = @Original_AddressID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_Contact_LifetimeSales]'
GO
CREATE PROCEDURE dbo.FRP_Contact_LifetimeSales
(
	@ContactID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT Sum(ExtendedAmount)  FROM FundraiserBase f LEFT OUTER JOIN 
				 FundraiserDetailBase fd on f.FundraiserID = fd.FundraiserID
Where PrimaryContactID = @ContactID
GROUP BY fd.FundraiserID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_Delete]
(
	@Original_FundraiserID uniqueidentifier,
	@Original_CallinOrderBy datetime,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_GroupId uniqueidentifier,
	@Original_GroupTypeCode int,
	@Original_DeletionStatusCode int,
	@Original_FollowUpCode int,
	@Original_FundsFor nvarchar(500),
	@Original_GoalInformation nvarchar(1000),
	@Original_GroupGoal money,
	@Original_GroupSize int,
	@Original_GroupType nvarchar(200),
	@Original_MakeChecksTo nvarchar(75),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_FundraiserRatingCode int,
	@Original_OwningUser uniqueidentifier,
	@Original_PriorityCode int,
	@Original_ReturnOrderBy datetime,
	@Original_SalesPersonID uniqueidentifier,
	@Original_SalesStageCode int,
	@Original_StartOn datetime,
	@Original_StatusCode int,
	@Original_StatusReasonCode int,
	@Original_Topic nvarchar(300)
)
AS
	SET NOCOUNT OFF;
DELETE FROM FundraiserBase WHERE (FundraiserID = @Original_FundraiserID)




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CompanyBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_CompanyBase_Delete]
(
	@Original_CompanyID uniqueidentifier,
	@Original_BusinessPhone nvarchar(50),
	@Original_BusinessPhoneExt nvarchar(50),
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_EmailAddress nvarchar(50),
	@Original_Fax nvarchar(50),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(160),
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(50),
	@Original_WebsiteURL nvarchar(200)
)
AS
	SET NOCOUNT OFF;
DELETE FROM CompanyBase WHERE (CompanyID = @Original_CompanyID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_Select]
(
	@AddressID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT AddressID, AddressTypeCode, ParentID, AddressName, PrimaryContactName, Street1, Street2, Street3, City, State, ZipCode, FreightTermsCode, Latitude, Longitude, ShippingMethod, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, Fax, PrimaryAddressCode, DeletionStateCode FROM CustomerAddressBase WHERE (AddressID = @AddressID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_PrimaryAddressSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_PrimaryAddressSelect]
(
	@ParentID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT AddressID, AddressTypeCode, ParentID, AddressName, PrimaryContactName, Street1, Street2, Street3, City, State, ZipCode, FreightTermsCode, Latitude, Longitude, ShippingMethod, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, Fax, PrimaryAddressCode, DeletionStateCode FROM CustomerAddressBase WHERE (ParentID = @ParentID) AND (PrimaryAddressCode = 1)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InternalAddressBase_ShipToAddress]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_InternalAddressBase_ShipToAddress]

AS
BEGIN
		SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT InternalAddressId, ShipCompanyName, ShipStreet1, ShipStreet2, ShipCity, ShipState, ShipZipCode
 FROM InternalAddressBase
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupTypeBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupTypeBase_Update]
(
	@GroupTypeID uniqueidentifier,
	@Name nvarchar(200),
	@Code int,
	@DeletionStateCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_GroupTypeID uniqueidentifier,
	@Original_Code int,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(200)
)
AS
	SET NOCOUNT OFF;
UPDATE GroupTypeBase SET GroupTypeID = @GroupTypeID, Name = @Name, Code = @Code, DeletionStateCode = @DeletionStateCode, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (GroupTypeID = @Original_GroupTypeID);
	SELECT GroupTypeID, Name, Code, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM GroupTypeBase WHERE (GroupTypeID = @GroupTypeID) ORDER BY Name


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupTypeBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupTypeBase_Delete]
(
	@Original_GroupTypeID uniqueidentifier,
	@Original_Code int,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(200)
)
AS
	SET NOCOUNT OFF;
DELETE FROM GroupTypeBase WHERE (GroupTypeID = @Original_GroupTypeID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_Delete]'
GO


CREATE PROCEDURE [dbo].[FRP_InvoiceBase_Delete]
(
	@Original_InvoiceId uniqueidentifier,
	@Original_BillToCity nvarchar(50),
	@Original_BillToFax nvarchar(50),
	@Original_BillToName nvarchar(200),
	@Original_BillToState nvarchar(50),
	@Original_BillToStreet1 nvarchar(50),
	@Original_BillToStreet2 nvarchar(50),
	@Original_BillToTelephone nvarchar(50),
	@Original_BillToTelephoneExt nvarchar(50),
	@Original_BillToZipCode nvarchar(20),
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_GroupPONumber nvarchar(50),
	@Original_GroupId uniqueidentifier,
	@Original_GroupTypeCode int,
	@Original_Delivered int,
	@Original_DeliveredOn datetime,
	@Original_DiscountAmount money,
	@Original_DocumentDate datetime,
	@Original_FreightAmount money,
	@Original_InvoiceDiscount money,
	@Original_InvoiceNumber nvarchar(100),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(300),
	@Original_FundraiserId uniqueidentifier,
	@Original_OwningUser uniqueidentifier,
	@Original_PaymentTerms nvarchar(50),
	@Original_QBStatusCode int,
	@Original_ShipToCity nvarchar(50),
	@Original_ShipToFax nvarchar(50),
	@Original_ShipToFreightTermsCode int,
	@Original_ShipToName nvarchar(200),
	@Original_ShipToState nvarchar(50),
	@Original_ShipToStreet1 nvarchar(50),
	@Original_ShipToStreet2 nvarchar(50),
	@Original_ShipToTelephone nvarchar(50),
	@Original_ShipToTelephoneExt nvarchar(50),
	@Original_ShipToZipCode nvarchar(20),
	@Original_ShippingMethod nvarchar(50),
	@Original_StatusCode int,
	@Original_StatusReasonCode int,
	@Original_TotalAmount money,
	@Original_TotalAmountLessFreight money,
	@Original_TotalDiscountAmount money,
	@Original_TotalLineItemAmount money,
	@Original_TotalLineItemDiscountAmount money,
	@Original_TotalTax money
)
AS
	SET NOCOUNT OFF;
DELETE FROM InvoiceBase WHERE (InvoiceId = @Original_InvoiceId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupTypeBase_NameSelect]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_GroupTypeBase_NameSelect]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT	GroupTypeID, Name
FROM	GroupTypeBase
ORDER BY Name
   
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_PrimaryAddressUpdate]'
GO

CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_PrimaryAddressUpdate]
(
	@AddressID uniqueidentifier,
	@AddressTypeCode int,
	@ParentID uniqueidentifier,
	@AddressName nvarchar(200),
	@PrimaryContactName nvarchar(150),
	@Street1 nvarchar(50),
	@Street2 nvarchar(50),
	@Street3 nvarchar(50),
	@City nvarchar(50),
	@State nvarchar(50),
	@ZipCode nvarchar(20),
	@FreightTermsCode int,
	@Latitude float,
	@Longitude float,
	@ShippingMethod nvarchar(200),
	@MainPhone nvarchar(50),
	@MainPhoneExt nvarchar(10),
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(10),
	@Fax nvarchar(50),
	@PrimaryAddressCode int,
	@DeletionStateCode int,
	@Original_AddressID uniqueidentifier,
	@Original_AddressName nvarchar(200),
	@Original_AddressTypeCode int,
	@Original_City nvarchar(50),
	@Original_DeletionStateCode int,
	@Original_Fax nvarchar(50),
	@Original_FreightTermsCode int,
	@Original_Latitude float,
	@Original_Longitude float,
	@Original_MainPhone nvarchar(50),
	@Original_MainPhoneExt nvarchar(10),
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(10),
	@Original_ParentID uniqueidentifier,
	@Original_PrimaryAddressCode int,
	@Original_PrimaryContactName nvarchar(150),
	@Original_ShippingMethod nvarchar(200),
	@Original_State nvarchar(50),
	@Original_Street1 nvarchar(50),
	@Original_Street2 nvarchar(50),
	@Original_Street3 nvarchar(50),
	@Original_ZipCode nvarchar(20)
)
AS
	SET NOCOUNT OFF;
UPDATE CustomerAddressBase SET AddressID = @AddressID, AddressTypeCode = @AddressTypeCode, ParentID = @ParentID, AddressName = @AddressName, PrimaryContactName = @PrimaryContactName, Street1 = @Street1, Street2 = @Street2, Street3 = @Street3, City = @City, State = @State, ZipCode = @ZipCode, FreightTermsCode = @FreightTermsCode, Latitude = @Latitude, Longitude = @Longitude, ShippingMethod = @ShippingMethod, MainPhone = @MainPhone, MainPhoneExt = @MainPhoneExt, OtherPhone = @OtherPhone, OtherPhoneExt = @OtherPhoneExt, Fax = @Fax, PrimaryAddressCode = @PrimaryAddressCode, DeletionStateCode = @DeletionStateCode WHERE (AddressID = @Original_AddressID);
	SELECT AddressID, AddressTypeCode, ParentID, AddressName, PrimaryContactName, Street1, Street2, Street3, City, State, ZipCode, FreightTermsCode, Latitude, Longitude, ShippingMethod, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, Fax, PrimaryAddressCode, DeletionStateCode FROM CustomerAddressBase WHERE (AddressID = @AddressID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceDetailBase_GridUpdate]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceDetailBase_GridUpdate]
(
	@InvoiceDetailID uniqueidentifier,
	@ProductNumber nvarchar(50),
	@ProductDescription ntext,
	@Quantity decimal(18),
	@PricePerUnit money,
	@ExtendedAmount money,
	@Original_InvoiceDetailID uniqueidentifier,
	@Original_Extended_Amount money,
	@Original_Unit_Price money,
	@Original_Description ntext,
	@Original_Product_Number nvarchar(50),
	@Original_Quantity decimal(18)
)
AS
	SET NOCOUNT OFF;
UPDATE InvoiceDetailBase SET InvoiceDetailID = @InvoiceDetailID, ProductNumber = @ProductNumber, ProductDescription = @ProductDescription, Quantity = @Quantity, PricePerUnit = @PricePerUnit, ExtendedAmount = @ExtendedAmount WHERE (InvoiceDetailID = @Original_InvoiceDetailID)
	SELECT InvoiceDetailID, ProductNumber AS [Product Number], ProductDescription AS Description, Quantity, PricePerUnit AS [Unit Price], ExtendedAmount AS [Extended Amount] FROM InvoiceDetailBase i WHERE (InvoiceDetailID = @InvoiceDetailID) ORDER BY ProductNumber


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_FASelectByParentID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_FASelectByParentID] 
	(
	@ParentID uniqueidentifier
)
AS
BEGIN
	SELECT c.addressid, c.AddressName, c.Street1, c.Street2, c.City, c.State, c.ZipCode, c.MainPhone, c.PrimaryAddressCode
FROM CustomerAddressBase c 
WHERE c.ParentId = @ParentID
END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserProductClassBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserProductClassBase_Select]
(
	@FundraiserProductClassID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT FundraiserProductClassID, FundraiserID, ProductClassID, Quantity, Posters, Fliers, Goal, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM FundraiserProductClassBase WHERE (FundraiserProductClassID = @FundraiserProductClassID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserDetailBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserDetailBase_Insert]
(
	@FundraiserDetailID uniqueidentifier,
	@FundraiserID uniqueidentifier,
	@ProductID uniqueidentifier,
	@ProductNumber nvarchar(50),
	@ProductDescription ntext,
	@Quantity decimal(18),
	@PricePerUnit money,
	@BaseAmount money,
	@ExtendedAmount money,
	@UofMID uniqueidentifier,
	@ManualDiscountAmount money,
	@Tax money,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO FundraiserDetailBase(FundraiserDetailID, FundraiserID, ProductID, ProductNumber, ProductDescription, Quantity, PricePerUnit, BaseAmount, ExtendedAmount, UofMID, ManualDiscountAmount, Tax, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@FundraiserDetailID, @FundraiserID, @ProductID, @ProductNumber, @ProductDescription, @Quantity, @PricePerUnit, @BaseAmount, @ExtendedAmount, @UofMID, @ManualDiscountAmount, @Tax, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT FundraiserDetailID, FundraiserID, ProductID, ProductNumber, ProductDescription, Quantity, PricePerUnit, BaseAmount, ExtendedAmount, UofMID, ManualDiscountAmount, Tax, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM FundraiserDetailBase WHERE (FundraiserDetailID = @FundraiserDetailID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_Insert]'
GO


CREATE PROCEDURE [dbo].[FRP_InvoiceBase_Insert]
(
	@InvoiceId uniqueidentifier,
	@FundraiserId uniqueidentifier,
	@OwningUser uniqueidentifier,
	@GroupId uniqueidentifier,
	@GroupTypeCode int,
	@InvoiceNumber nvarchar(100),
	@GroupPONumber nvarchar(50),
	@Name nvarchar(300),
	@Description ntext,
	@DocumentDate datetime,
	@BillToName nvarchar(200),
	@BillToStreet1 nvarchar(50),
	@BillToStreet2 nvarchar(50),
	@BillToCity nvarchar(50),
	@BillToState nvarchar(50),
	@BillToZipCode nvarchar(20),
	@BillToTelephone nvarchar(50),
	@BillToTelephoneExt nvarchar(50),
	@BillToFax nvarchar(50),
	@ShipToName nvarchar(200),
	@ShipToStreet1 nvarchar(50),
	@ShipToStreet2 nvarchar(50),
	@ShipToCity nvarchar(50),
	@ShipToState nvarchar(50),
	@ShipToZipCode nvarchar(20),
	@ShipToTelephone nvarchar(50),
	@ShipToTelephoneExt nvarchar(50),
	@ShipToFax nvarchar(50),
	@DiscountAmount money,
	@InvoiceDiscount money,
	@FreightAmount money,
	@TotalAmount money,
	@TotalLineItemAmount money,
	@TotalLineItemDiscountAmount money,
	@TotalAmountLessFreight money,
	@TotalDiscountAmount money,
	@TotalTax money,
	@PaymentTerms nvarchar(50),
	@ShippingMethod nvarchar(50),
	@ShipToFreightTermsCode int,
	@StatusCode int,
	@StatusReasonCode int,
	@Delivered int,
	@DeliveredOn datetime,
	@QBStatusCode int,
	@CreatedBy uniqueidentifier,
	@CreatedOn datetime,
	@ModifiedBy uniqueidentifier,
	@ModifiedOn datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO InvoiceBase(InvoiceId, FundraiserId, OwningUser, GroupId, GroupTypeCode, InvoiceNumber, GroupPONumber, Name, Description, DocumentDate, BillToName, BillToStreet1, BillToStreet2, BillToCity, BillToState, BillToZipCode, BillToTelephone, BillToTelephoneExt, BillToFax, ShipToName, ShipToStreet1, ShipToStreet2, ShipToCity, ShipToState, ShipToZipCode, ShipToTelephone, ShipToTelephoneExt, ShipToFax, DiscountAmount, InvoiceDiscount, FreightAmount, TotalAmount, TotalLineItemAmount, TotalLineItemDiscountAmount, TotalAmountLessFreight, TotalDiscountAmount, TotalTax, PaymentTerms, ShippingMethod, ShipToFreightTermsCode, StatusCode, StatusReasonCode, Delivered, DeliveredOn, QBStatusCode, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn) VALUES (@InvoiceId, @FundraiserId, @OwningUser, @GroupId, @GroupTypeCode, @InvoiceNumber, @GroupPONumber, @Name, @Description, @DocumentDate, @BillToName, @BillToStreet1, @BillToStreet2, @BillToCity, @BillToState, @BillToZipCode, @BillToTelephone, @BillToTelephoneExt, @BillToFax, @ShipToName, @ShipToStreet1, @ShipToStreet2, @ShipToCity, @ShipToState, @ShipToZipCode, @ShipToTelephone, @ShipToTelephoneExt, @ShipToFax, @DiscountAmount, @InvoiceDiscount, @FreightAmount, @TotalAmount, @TotalLineItemAmount, @TotalLineItemDiscountAmount, @TotalAmountLessFreight, @TotalDiscountAmount, @TotalTax, @PaymentTerms, @ShippingMethod, @ShipToFreightTermsCode, @StatusCode, @StatusReasonCode, @Delivered, @DeliveredOn, @QBStatusCode, @CreatedBy, @CreatedOn, @ModifiedBy, @ModifiedOn);
	SELECT InvoiceId, FundraiserId, OwningUser, GroupId, GroupTypeCode, InvoiceNumber, GroupPONumber, Name, Description, DocumentDate, BillToName, BillToStreet1, BillToStreet2, BillToCity, BillToState, BillToZipCode, BillToTelephone, BillToTelephoneExt, BillToFax, ShipToName, ShipToStreet1, ShipToStreet2, ShipToCity, ShipToState, ShipToZipCode, ShipToTelephone, ShipToTelephoneExt, ShipToFax, DiscountAmount, InvoiceDiscount, FreightAmount, TotalAmount, TotalLineItemAmount, TotalLineItemDiscountAmount, TotalAmountLessFreight, TotalDiscountAmount, TotalTax, PaymentTerms, ShippingMethod, ShipToFreightTermsCode, StatusCode, StatusReasonCode, Delivered, DeliveredOn, QBStatusCode, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM InvoiceBase WHERE (InvoiceId = @InvoiceId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_FATopicSelect]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_FundraiserBase_FATopicSelect]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT	FundraiserID, Topic
FROM	FundraiserBase
WHERE  DeletionStatusCode <> 1 And StatusCode <> 2
ORDER BY Topic
   
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_UofMScheduleBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_UofMScheduleBase_Insert]
(
	@UoMScheduleId uniqueidentifier,
	@Name nvarchar(200),
	@Description ntext,
	@BaseUofM uniqueidentifier,
	@DeletionStateCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO UofMScheduleBase(UoMScheduleId, Name, Description, BaseUofM, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@UoMScheduleId, @Name, @Description, @BaseUofM, @DeletionStateCode, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT UoMScheduleId, Name, Description, BaseUofM, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM UofMScheduleBase WHERE (UoMScheduleId = @UoMScheduleId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserProductClassBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserProductClassBase_Update]
(
	@FundraiserProductClassID uniqueidentifier,
	@FundraiserID uniqueidentifier,
	@ProductClassID uniqueidentifier,
	@Quantity decimal(18),
	@Posters int,
	@Fliers int,
	@Goal int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_FundraiserProductClassID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_FundraiserID uniqueidentifier,
	@Original_ProductClassID uniqueidentifier,
	@Original_Quantity decimal(18)
)
AS
	SET NOCOUNT OFF;
UPDATE FundraiserProductClassBase SET FundraiserProductClassID = @FundraiserProductClassID, FundraiserID = @FundraiserID, ProductClassID = @ProductClassID, Quantity = @Quantity, Posters = @Posters, Fliers = @Fliers, Goal = @Goal, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (FundraiserProductClassID = @Original_FundraiserProductClassID);
	SELECT FundraiserProductClassID, FundraiserID, ProductClassID, Quantity, Posters, Fliers, Goal, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM FundraiserProductClassBase WHERE (FundraiserProductClassID = @FundraiserProductClassID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_GetCarriedProducts]'
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductBase_GetCarriedProducts] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT * FROM ProductBase
WHERE ProductBase.Carried <> 0 and ProductBase.DeletionStateCode <> 1
Order By ProductNumber

END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_FAGroupNameSelect]'
GO

CREATE  PROCEDURE [dbo].[FRP_GroupBase_FAGroupNameSelect]
AS
	SET NOCOUNT ON;
SELECT GroupID,
	GroupName
FROM	GroupBase
WHERE DeletionStateCode <> 1 and StatusCode = 0
ORDER BY GroupName




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_SelectALL]'
GO


CREATE PROCEDURE [dbo].[FRP_ProductBase_SelectALL]
AS
	SET NOCOUNT ON;
SELECT ProductId, ProductNumber, Name, Description, ProductTypeCode, DefaultUoMScheduleID, ProductClassID, DefaultUoMId, RetailPrice, GroupRetailPrice, ConsumerRetailPrice, DealerPrice, QuantityOnHand, QuantityAllocated, Carried, DeletionStateCode, CreatedOn, ModifiedOn, CreatedBy, ModifiedBy, StatusCode, ProductSalesPercentage, FlierOrder 
FROM ProductBase
Order By ProductNumber


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupBase_Delete]
(
	@Original_GroupId uniqueidentifier,
	@Original_GroupCategoryCode int,
	@Original_GroupName nvarchar(160),
	@Original_GroupNumber nvarchar(20),
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_CreditOnHold bit,
	@Original_DeletionStateCode int,
	@Original_DoNotBulkEMail bit,
	@Original_DoNotBulkPostalMail bit,
	@Original_DoNotEMail bit,
	@Original_DoNotFax bit,
	@Original_DoNotPhone bit,
	@Original_DoNotPostalMail bit,
	@Original_EMailAddress1 nvarchar(100),
	@Original_Fax nvarchar(50),
	@Original_FreightTermsCode int,
	@Original_GroupSize int,
	@Original_GroupType nvarchar(200),
	@Original_MainPhone nvarchar(50),
	@Original_MainPhoneExt nvarchar(10),
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_OtherPhone nvarchar(50),
	@Original_OtherPhoneExt nvarchar(10),
	@Original_OwningUser uniqueidentifier,
	@Original_PaymentTerms nvarchar(200),
	@Original_PreferredContactMethodCode int,
	@Original_PreferredPhoneCode int,
	@Original_PrimaryContactId uniqueidentifier,
	@Original_ShippingMethod nvarchar(200),
	@Original_StatusCode int,
	@Original_WebSiteURL nvarchar(200)
)
AS
	SET NOCOUNT OFF;
DELETE FROM GroupBase WHERE (GroupId = @Original_GroupId) 



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_Insert]
(
	@AddressID uniqueidentifier,
	@AddressTypeCode int,
	@ParentID uniqueidentifier,
	@AddressName nvarchar(200),
	@PrimaryContactName nvarchar(150),
	@Street1 nvarchar(50),
	@Street2 nvarchar(50),
	@Street3 nvarchar(50),
	@City nvarchar(50),
	@State nvarchar(50),
	@ZipCode nvarchar(20),
	@FreightTermsCode int,
	@Latitude float,
	@Longitude float,
	@ShippingMethod nvarchar(200),
	@MainPhone nvarchar(50),
	@MainPhoneExt nvarchar(10),
	@OtherPhone nvarchar(50),
	@OtherPhoneExt nvarchar(10),
	@Fax nvarchar(50),
	@PrimaryAddressCode int,
	@DeletionStateCode int
)
AS
	SET NOCOUNT OFF;
INSERT INTO CustomerAddressBase(AddressID, AddressTypeCode, ParentID, AddressName, PrimaryContactName, Street1, Street2, Street3, City, State, ZipCode, FreightTermsCode, Latitude, Longitude, ShippingMethod, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, Fax, PrimaryAddressCode, DeletionStateCode) VALUES (@AddressID, @AddressTypeCode, @ParentID, @AddressName, @PrimaryContactName, @Street1, @Street2, @Street3, @City, @State, @ZipCode, @FreightTermsCode, @Latitude, @Longitude, @ShippingMethod, @MainPhone, @MainPhoneExt, @OtherPhone, @OtherPhoneExt, @Fax, @PrimaryAddressCode, @DeletionStateCode);
	SELECT AddressID, AddressTypeCode, ParentID, AddressName, PrimaryContactName, Street1, Street2, Street3, City, State, ZipCode, FreightTermsCode, Latitude, Longitude, ShippingMethod, MainPhone, MainPhoneExt, OtherPhone, OtherPhoneExt, Fax, PrimaryAddressCode, DeletionStateCode FROM CustomerAddressBase WHERE (AddressID = @AddressID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_GridSelectByFundraiser]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceBase_GridSelectByFundraiser]
(
	@FundraiserID as uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT	InvoiceId,
	InvoiceNumber as [Invoice Number],
	StatusReasonCode as [Status],	
	TotalAmount as [Total Amount],	
	CreatedOn as [Created On]
FROM	InvoiceBase
Where FundraiserID = @FundraiserID And DeletionStatusCode <> 1
ORDER BY InvoiceNumber DESC




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserProductClassBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserProductClassBase_Delete]
(
	@Original_FundraiserProductClassID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_FundraiserID uniqueidentifier,
	@Original_ProductClassID uniqueidentifier,
	@Original_Quantity decimal(18),
	@Original_Posters int,
	@Original_Fliers int,
	@Original_Goal int
)
AS
	SET NOCOUNT OFF;
DELETE FROM FundraiserProductClassBase WHERE (FundraiserProductClassID = @Original_FundraiserProductClassID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceDetailBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceDetailBase_Select]
(
	@InvoiceDetailID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT InvoiceDetailID, InvoiceID, DeletionStateCode, SalesRepID, DeliveryRepID, LineItemNumber, UofMID, ProductID, ProductNumber, ProductDescription, Quantity, PricePerUnit, PriceOverride, BaseAmount, ExtendedAmount, ManualDiscountAmount, Tax FROM InvoiceDetailBase WHERE (InvoiceDetailID = @InvoiceDetailID)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_Select]'
GO


CREATE PROCEDURE [dbo].[FRP_ProductBase_Select]
(
	@ProductID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT ProductId, ProductNumber, Name, Description, ProductTypeCode, DefaultUoMScheduleID, ProductClassID, DefaultUoMId, RetailPrice, GroupRetailPrice, ConsumerRetailPrice, DealerPrice, QuantityOnHand, QuantityAllocated, Carried, DeletionStateCode, CreatedOn, ModifiedOn, CreatedBy, ModifiedBy, StatusCode, ProductSalesPercentage, FlierOrder FROM ProductBase WHERE (ProductId = @ProductID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_SelectDeliveriesByGroupID]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ActivityBase_SelectDeliveriesByGroupID]
(
	@GroupID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;
SELECT a.*, u.DisplayName 
FROM ActivityBase a LEFT OUTER JOIN SystemUserBase u ON a.OwningUser = u.SystemUserId
WHERE a.GroupID = @GroupID AND a.ActivityTypeCode = 2
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ContactBase_GridSelectByParentID]'
GO

CREATE PROCEDURE [dbo].[FRP_ContactBase_GridSelectByParentID]
(
	@ParentID as uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT ContactID,
		FullName as [Name],
		JobTitle as Title,
		Case PreferredPhoneCode
			When '1' Then BusinessPhone
			When '2' Then HomePhone
			When '3' then MobilePhone
			when '4' then OtherPhone
		end as [Preferred Phone],
		Case PreferredPhoneCode
			When '1' Then BusinessPhoneExt
			When '2' Then ''
			When '3' then ''
			when '4' then OtherPhoneExt
		end as [Ext]
FROM ContactBase 
Where ParentGroupID = @ParentID And DeletionStateCode = 0 And StatusCode = 0
ORDER BY LastName, FirstName


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ShippingMethodBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_ShippingMethodBase_Update]
(
	@ShippingMethodID uniqueidentifier,
	@Name nvarchar(200),
	@DeletionStateCode int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier,
	@Original_ShippingMethodID uniqueidentifier,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_DeletionStateCode int,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_Name nvarchar(200)
)
AS
	SET NOCOUNT OFF;
UPDATE ShippingMethodBase SET ShippingMethodID = @ShippingMethodID, Name = @Name, DeletionStateCode = @DeletionStateCode, CreatedOn = @CreatedOn, CreatedBy = @CreatedBy, ModifiedOn = @ModifiedOn, ModifiedBy = @ModifiedBy WHERE (ShippingMethodID = @Original_ShippingMethodID);
	SELECT ShippingMethodID, Name, DeletionStateCode, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM ShippingMethodBase WHERE (ShippingMethodID = @ShippingMethodID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserDetailBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserDetailBase_Select]
(
	@FundraiserID uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT * FROM FundraiserDetailBase WHERE (FundraiserID = @FundraiserID)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserDetailBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserDetailBase_Delete]
(
	@Original_FundraiserDetailID uniqueidentifier,
	@Original_BaseAmount money,
	@Original_CreatedBy uniqueidentifier,
	@Original_CreatedOn datetime,
	@Original_ExtendedAmount money,
	@Original_ManualDiscountAmount money,
	@Original_ModifiedBy uniqueidentifier,
	@Original_ModifiedOn datetime,
	@Original_FundraiserID uniqueidentifier,
	@Original_PricePerUnit money,
	@Original_ProductDescription ntext,
	@Original_ProductID uniqueidentifier,
	@Original_ProductNumber nvarchar(50),
	@Original_Quantity decimal(18),
	@Original_Tax money,
	@Original_UofMID uniqueidentifier
)
AS
	SET NOCOUNT OFF;
DELETE FROM FundraiserDetailBase WHERE (FundraiserDetailID = @Original_FundraiserDetailID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductClassBase_NameSelect]'
GO



CREATE PROCEDURE [dbo].[FRP_ProductClassBase_NameSelect]
AS
	SET NOCOUNT ON;
SELECT ProductClassId,
		Name,
		ProductTypeCode
FROM ProductClassBase
WHERE DeletionStateCode = 0 and Carried <> 0







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_GridSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_ProductBase_GridSelect]
AS
SET NOCOUNT ON;
		
SELECT	ProductId,
	ProductNumber as [Product Number],
	Name as [Product],
	nullif(QuantityOnHand,0) as [Quantity On Hand],
	nullif(QuantityAllocated,0) as [Quantity Allocated]
FROM	ProductBase
ORDER BY ProductNumber


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_DisplayNameSelect]'
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE  PROCEDURE [dbo].[FRP_SystemUserBase_DisplayNameSelect]
AS
	SET NOCOUNT ON;
SELECT SystemUserId, 
	DisplayName 
FROM SystemUserBase 
WHERE Visible = 'True'
ORDER BY DisplayName





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_VendorAddressBase_Insert]'
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[FRP_VendorAddressBase_Insert]
(
	@VendorAddressID uniqueidentifier,
	@ParentID uniqueidentifier,
	@AddressTypeCode int,
	@Name nvarchar(200),
	@Street1 nvarchar(50),
	@Street2 nvarchar(50),
	@City nvarchar(50),
	@State nvarchar(50),
	@ZipCode nvarchar(20),
	@Latitude float,
	@Longitude float,
	@BusinessPhone nvarchar(50),
	@OtherPhone nvarchar(50),
	@Fax nvarchar(50),
	@CreatedOn datetime,
	@Createdby uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO VendorAddressBase(VendorAddressID, ParentID, AddressTypeCode, Name, Street1, Street2, City, State, ZipCode, Latitude, Longitude, BusinessPhone, OtherPhone, Fax, CreatedOn, Createdby, ModifiedOn, ModifiedBy) VALUES (@VendorAddressID, @ParentID, @AddressTypeCode, @Name, @Street1, @Street2, @City, @State, @ZipCode, @Latitude, @Longitude, @BusinessPhone, @OtherPhone, @Fax, @CreatedOn, @Createdby, @ModifiedOn, @ModifiedBy);
	SELECT VendorAddressID, ParentID, AddressTypeCode, Name, Street1, Street2, City, State, ZipCode, Latitude, Longitude, BusinessPhone, OtherPhone, Fax, CreatedOn, Createdby, ModifiedOn, ModifiedBy FROM VendorAddressBase WHERE (VendorAddressID = @VendorAddressID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_NoteBase_SelectByParentID]'
GO
CREATE PROCEDURE [dbo].[FRP_NoteBase_SelectByParentID]
(
	@ParentID uniqueidentifier
)
AS
SELECT * FROM NoteBase Where ParentID = @ParentID



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_InvoiceBase_FundraiserInvoiceCount]'
GO

CREATE PROCEDURE [dbo].[FRP_InvoiceBase_FundraiserInvoiceCount]
(
	@FundraiserID uniqueidentifier,
	@InvoiceID uniqueidentifier
)
AS
	SET NOCOUNT ON;
Select COUNT(*) FROM InvoiceBase Where FundraiserID = @FundraiserID AND InvoiceID <> @InvoiceID AND StatusCode <> 2 AND DeletionStatusCode <>1



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserProductClassBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserProductClassBase_Insert]
(
	@FundraiserProductClassID uniqueidentifier,
	@FundraiserID uniqueidentifier,
	@ProductClassID uniqueidentifier,
	@Quantity decimal(18),
	@Posters int,
	@Fliers int,
	@Goal int,
	@CreatedOn datetime,
	@CreatedBy uniqueidentifier,
	@ModifiedOn datetime,
	@ModifiedBy uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO FundraiserProductClassBase(FundraiserProductClassID, FundraiserID, ProductClassID, Quantity, Posters, Fliers, Goal, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy) VALUES (@FundraiserProductClassID, @FundraiserID, @ProductClassID, @Quantity, @Posters, @Fliers, @Goal, @CreatedOn, @CreatedBy, @ModifiedOn, @ModifiedBy);
	SELECT FundraiserProductClassID, FundraiserID, ProductClassID, Quantity, Posters, Fliers, Goal, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM FundraiserProductClassBase WHERE (FundraiserProductClassID = @FundraiserProductClassID)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_SelectByParentID]'
GO
CREATE PROCEDURE [dbo].[FRP_CustomerAddressBase_SelectByParentID]
(
	@ParentID uniqueidentifier
)
AS
SELECT * FROM CustomerAddressBase Where ParentID = @ParentID





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductClassBase_DeletionStateCode]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FRP_ProductClassBase_DeletionStateCode]
	(
@ProductClassID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;
		UPDATE ProductClassBase SET DeletionStateCode = 1 Where ProductClassID = @ProductClassID
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_CustomerAddressBase_GridSelectBackup]'
GO

-- Address Name, Type (bill to, ship to), Address Contact (text field), Main Phone
CREATE     PROCEDURE [dbo].[FRP_CustomerAddressBase_GridSelectBackup]
(
	@ParentId uniqueidentifier
)
AS
SET NOCOUNT ON;
SELECT	AddressID,
	AddressName as [Address Name],
	AddressTypeCode as Type,
	PrimaryContactName as [Address Contact],
	customers.[Main Phone],
	customers.Ext
FROM	CustomerAddressBase c
--	Inner Join SystemUserBase u	On n.OwningUser = u.SystemUserId
	Left Outer Join (select ContactId as CustomerID, FullName, BusinessPhone as [Main Phone], BusinessPhoneExt as Ext From contactbase union select groupid, groupName, MainPhone, MainPhoneExt from groupBase) as customers
		On c.ParentId = customers.CustomerID
WHERE ParentId = @ParentId
ORDER By c.AddressName



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_PCUpdateQOHDeliveredInvoice]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[FRP_ProductBase_PCUpdateQOHDeliveredInvoice]
(
@InvoiceID uniqueidentifier
)
AS
	SET NOCOUNT ON;
Declare @ProductID uniqueidentifier
Declare @DeliveredQuantity integer
Declare @QOHValue integer
DECLARE Product_Cursor CURSOR FOR
SELECT ProductID FROM ProductBase
ORDER BY ProductNumber
OPEN Product_Cursor 
FETCH NEXT FROM Product_Cursor 
INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
Set @QOHValue = (Select SUM(pb.QuantityOnHand) as TotalQOH 
				FROM ProductBase pb
				WHERE pb.ProductID = @ProductID)
Set @DeliveredQuantity = (Select SUM(idb.Quantity) as TotalQuantity 
						FROM InvoiceBase i Left Outer Join InvoiceDetailBase idb  On i.InvoiceID= idb.InvoiceID
						WHERE idb.InvoiceID = @InvoiceID AND idb.ProductID = @ProductID AND i.DeletionStatusCode <> 1)
Update ProductBase Set QuantityOnHand = @QOHValue - isNull(@DeliveredQuantity,0)
Where ProductID = @ProductID
FETCH NEXT FROM Product_Cursor
INTO @ProductID
END
CLOSE Product_Cursor
DEALLOCATE Product_Cursor





































GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_HomeGridSelect]'
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[FRP_ActivityBase_HomeGridSelect]
	(
		@SystemUserID uniqueidentifier,
		@StatusCode as integer,
		@UseDates as integer,
		@SearchText as nvarchar(50),
		@StartDate as datetime,
		@EndDate as datetime
		
		 --Type (Picture Col), Start On, Status, Regarding, Subject, Owning User, 
	)
	AS
		SET NOCOUNT ON;
	Declare @StatusCodeEnd as int
	
	if @StatusCode = 3
		Begin
			set @StatusCode = 1
			set @StatusCodeEnd = 4
		End
	else
		set @StatusCodeEnd = @StatusCode
		
		
	If @SearchText = ''
		If @SystemUserID IS NOT NULL
			BEGIN
				SELECT ActivityId, 
					ScheduledStartDate as [Start On],
					StatusCode as Status,
					CustomerName as [Customer Name],	
					Subject,
					u.FullName as [Owning User],
					ActivityTypeCode as Type,
					ActivityTypeCode as PictureCode
				FROM ActivityBase a Left Outer Join SystemUserBase u On a.OwningUser= u.SystemUserID
									Left Outer Join (SELECT ContactId as CustomerID, FullName as CustomerName FROM Contactbase
													UNION
													Select GroupID, GroupName FROM GroupBase
													UNION
													Select SystemUserID, FullName FROM SystemUserBase) as Customer
													On a.RegardingID = Customer.CustomerID
				WHERE (@UseDates <> 1 AND (OwningUser = @SystemUserID AND (a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd)))
					OR (@UseDates = 1 AND (OwningUser = @SystemUserID AND (a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd) AND (a.ScheduledStartDate >= @StartDate And a.ScheduledStartDate <= @EndDate)))
				Order By ScheduledStartDate
			END
			ELSE
			BEGIN
				SELECT ActivityId, 
					ScheduledStartDate as [Start On],
					StatusCode as Status,
					CustomerName as [Customer Name],	
					Subject,
					u.FullName as [Owning User],
					ActivityTypeCode as Type,
					ActivityTypeCode as PictureCode
				FROM ActivityBase a Left Outer Join SystemUserBase u On a.OwningUser= u.SystemUserID
									Left Outer Join (SELECT ContactId as CustomerID, FullName as CustomerName FROM Contactbase
													UNION
													Select GroupID, GroupName FROM GroupBase
													UNION
													Select SystemUserID, FullName FROM SystemUserBase) as Customer
													On a.RegardingID = Customer.CustomerID
				WHERE (@UseDates <> 1 AND ((a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd)))
					OR (@UseDates = 1 AND ((a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd) AND (a.ScheduledStartDate >= @StartDate And a.ScheduledStartDate <= @EndDate)))
				Order By ScheduledStartDate	
			END
	Else
		set @SearchText = '%' + @SearchText + '%'
		If @SystemUserID IS NOT NULL
			BEGIN
				SELECT ActivityId, 
					ScheduledStartDate as [Start On],
					StatusCode as Status,
					CustomerName as [Customer Name],	
					Subject,
					u.FullName as [Owning User],
					ActivityTypeCode as Type,
					ActivityTypeCode as PictureCode
				FROM ActivityBase a Left Outer Join SystemUserBase u On a.OwningUser= u.SystemUserID
									Left Outer Join (SELECT ContactId as CustomerID, FullName as CustomerName FROM Contactbase
													UNION
													Select GroupID, GroupName FROM GroupBase
													UNION
													Select SystemUserID, FullName FROM SystemUserBase) as Customer
													On a.RegardingID = Customer.CustomerID
				WHERE (@UseDates <> 1 AND (OwningUser = @SystemUserID AND (a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd)))
					OR (@UseDates = 1 AND (OwningUser = @SystemUserID AND (a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd) AND (a.ScheduledStartDate >= @StartDate And a.ScheduledStartDate <= @EndDate)))
					AND ((Subject Like @SearchText) OR (CustomerName Like @SearchText))
				Order By ScheduledStartDate
			END
			ELSE
			BEGIN
				SELECT ActivityId, 
					ScheduledStartDate as [Start On],
					StatusCode as Status,
					CustomerName as [Customer Name],	
					Subject,
					u.FullName as [Owning User],
					ActivityTypeCode as Type,
					ActivityTypeCode as PictureCode
				FROM ActivityBase a Left Outer Join SystemUserBase u On a.OwningUser= u.SystemUserID
									Left Outer Join (SELECT ContactId as CustomerID, FullName as CustomerName FROM Contactbase
													UNION
													SELECT ContactID, FullName FROM ContactBase
													UNION
													Select GroupID, GroupName FROM GroupBase
													UNION
													Select SystemUserID, FullName FROM SystemUserBase) as Customer
													On a.RegardingID = Customer.CustomerID
				WHERE (@UseDates <> 1 AND ((a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd)))
					OR (@UseDates = 1 AND ((a.StatusCode >= @StatusCode And a.StatusCode <= @StatusCodeEnd) AND (a.ScheduledStartDate >= @StartDate And a.ScheduledStartDate <= @EndDate)))
					AND ((Subject Like @SearchText) OR (CustomerName Like @SearchText))
				Order By ScheduledStartDate	
			END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ProductBaseForecastedInventoryView]'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.ProductBaseForecastedInventoryView
AS
SELECT     dbo.PurchaseOrderBase.ReceivedOn AS TrxDate, '' AS TrxName, dbo.PurchaseOrderBase.PONumber AS TrxName2, dbo.ProductBase.ProductNumber, 
                      dbo.ProductClassBase.Name AS ProductClass, dbo.PurchaseOrderDetailBase.QuantityOrdered AS Quantity, 
                      dbo.ProductBase.QuantityOnHand AS OriginalQOH, 'PO - Pending' AS TrxType, 0 AS Type
FROM         dbo.PurchaseOrderBase INNER JOIN
                      dbo.PurchaseOrderDetailBase ON dbo.PurchaseOrderBase.PurchaseOrderID = dbo.PurchaseOrderDetailBase.PurchaseOrderID LEFT OUTER JOIN
                      dbo.ProductBase ON dbo.PurchaseOrderDetailBase.ProductID = dbo.ProductBase.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase ON dbo.ProductBase.ProductClassID = dbo.ProductClassBase.ProductClassId
WHERE     (dbo.PurchaseOrderBase.Stage = 0) AND (dbo.PurchaseOrderBase.Status = 0) AND (dbo.PurchaseOrderBase.DeletionStateCode <> 1)
UNION ALL
SELECT     PurchaseOrderBase_1.ReceivedOn AS TrxDate, '' AS TrxName, PurchaseOrderBase_1.PONumber AS TrxName2, ProductBase_4.ProductNumber, 
                      ProductClassBase_4.Name AS ProductClass, PurchaseOrderDetailBase_1.QuantityOrdered AS Quantity, 
                      ProductBase_4.QuantityOnHand AS OriginalQOH, 'PO - Ordered' AS TrxType, 1 AS Type
FROM         dbo.PurchaseOrderBase AS PurchaseOrderBase_1 INNER JOIN
                      dbo.PurchaseOrderDetailBase AS PurchaseOrderDetailBase_1 ON 
                      PurchaseOrderBase_1.PurchaseOrderID = PurchaseOrderDetailBase_1.PurchaseOrderID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_4 ON PurchaseOrderDetailBase_1.ProductID = ProductBase_4.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_4 ON ProductBase_4.ProductClassID = ProductClassBase_4.ProductClassId
WHERE     (PurchaseOrderBase_1.Stage = 1) AND (PurchaseOrderBase_1.Status = 0) AND (PurchaseOrderBase_1.DeletionStateCode <> 1)
UNION ALL
SELECT     dbo.InvoiceBase.DocumentDate AS TrxDate, dbo.InvoiceBase.Name AS TrxName, '' AS TrxName2, ProductBase_3.ProductNumber, 
                      ProductClassBase_3.Name AS ProductClass, dbo.InvoiceDetailBase.Quantity * - 1 AS Quantity, ProductBase_3.QuantityOnHand AS OriginalQOH, 
                      'Invoice - Ordered' AS TrxType, 2 AS Type
FROM         dbo.InvoiceBase INNER JOIN
                      dbo.InvoiceDetailBase ON dbo.InvoiceBase.InvoiceId = dbo.InvoiceDetailBase.InvoiceID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_3 ON dbo.InvoiceDetailBase.ProductID = ProductBase_3.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_3 ON ProductBase_3.ProductClassID = ProductClassBase_3.ProductClassId
WHERE     (dbo.InvoiceBase.InvoiceStage = 0) AND (dbo.InvoiceBase.StatusCode = 0) AND (dbo.InvoiceBase.DeletionStatusCode <> 1)
UNION ALL
SELECT     dbo.FundraiserBase.StartOn AS TrxDate, dbo.FundraiserBase.Topic AS TrxName, '' AS TrxName2, ProductBase_2.ProductNumber, 
                      ProductClassBase_2.Name AS ProductClass, dbo.FundraiserDetailBase.Quantity * - 1 AS Quantity, ProductBase_2.QuantityOnHand AS OriginalQOH, 
                      'Fundraiser - Pending' AS TrxType, 3 AS Type
FROM         dbo.FundraiserBase INNER JOIN
                      dbo.FundraiserDetailBase ON dbo.FundraiserBase.FundraiserID = dbo.FundraiserDetailBase.FundraiserID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_2 ON dbo.FundraiserDetailBase.ProductID = ProductBase_2.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_2 ON ProductBase_2.ProductClassID = ProductClassBase_2.ProductClassId
WHERE     (dbo.FundraiserBase.SalesStageCode = 0) AND (dbo.FundraiserBase.StatusCode = 0) AND (dbo.FundraiserBase.DeletionStatusCode <> 1)
UNION ALL
SELECT     TOP (100) PERCENT FundraiserBase_1.StartOn AS TrxDate, FundraiserBase_1.Topic AS TrxName, '' AS TrxName2, ProductBase_1.ProductNumber, 
                      ProductClassBase_1.Name AS ProductClass, FundraiserDetailBase_1.Quantity * - 1 AS Quantity, ProductBase_1.QuantityOnHand AS OriginalQOH, 
                      'Fundraiser - Booked' AS TrxType, 4 AS Type
FROM         dbo.FundraiserBase AS FundraiserBase_1 INNER JOIN
                      dbo.FundraiserDetailBase AS FundraiserDetailBase_1 ON FundraiserBase_1.FundraiserID = FundraiserDetailBase_1.FundraiserID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_1 ON FundraiserDetailBase_1.ProductID = ProductBase_1.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_1 ON ProductBase_1.ProductClassID = ProductClassBase_1.ProductClassId
WHERE     (FundraiserBase_1.SalesStageCode = 1) AND (FundraiserBase_1.StatusCode = 0) AND (FundraiserBase_1.DeletionStatusCode <> 1)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityBase_SelectByFundraiserID]'
GO
CREATE PROCEDURE [dbo].[FRP_ActivityBase_SelectByFundraiserID]
(
	@FundraiserID uniqueidentifier
)
AS
SELECT a.*,
	Case ActivityTypeCode
		WHEN '1' Then 'Appointment'
		WHEN '2' Then 'Delivery'
		WHEN '4' Then 'Phone Call'
		WHEN '8' Then 'Print Fliers'
		WHEN '16' Then 'Scheduled Email'
		WHEN '32' Then 'Task'
		WHEN '64' Then 'Thank You'
	End As [Activity Type],
Case PrimaryDelivery
		WHEN 'True' Then 'True'
		WHEN 'False' Then 'False'
		ELSE 'False'
	End As [Primary Delivery],
	g.GroupName,
	f.Topic,
	c.FullName As [Primary Contact],
    u.DisplayName As [Owning User]
FROM ActivityBase a
		Left Outer Join SystemUserBase u On a.OwningUser = u.SystemUserId
		Left Outer Join GroupBase g On a.GroupId = g.GroupId
 		Left Outer Join ContactBase c On a.ContactId = c.ContactId
		Left Outer Join FundraiserBase f On a.FundraiserId = f.FundraiserId
Where a.FundraiserId = @FundraiserID












GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FundraiserRelatedNames]'
GO
CREATE VIEW dbo.FundraiserRelatedNames
AS
SELECT     o.FundraiserID, CASE o.GroupTypeCode WHEN '0' THEN a.GroupName WHEN '1' THEN c.FullName END AS Customer, 
                      u1.DisplayName AS OwningUser, u2.FullName AS SalesPerson, u4.FullName AS CreatedBy, u5.FullName AS ModifiedBy
FROM         dbo.FundraiserBase AS o LEFT OUTER JOIN
                      dbo.GroupBase AS a ON o.GroupId = a.GroupId LEFT OUTER JOIN
                      dbo.ContactBase AS c ON o.GroupId = c.ContactId LEFT OUTER JOIN
                      dbo.SystemUserBase AS u1 ON o.OwningUser = u1.SystemUserId LEFT OUTER JOIN
                      dbo.SystemUserBase AS u2 ON o.SalesPersonID = u2.SystemUserId LEFT OUTER JOIN
                      dbo.SystemUserBase AS u4 ON o.CreatedBy = u4.SystemUserId LEFT OUTER JOIN
                      dbo.SystemUserBase AS u5 ON o.ModifiedBy = u5.SystemUserId

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_AssignRecordToUser]'
GO

CREATE PROCEDURE [dbo].[FRP_SystemUserBase_AssignRecordToUser]
(
	@RecordID uniqueidentifier,
	@UserID uniqueidentifier,
	@RecordType as int
)
AS

IF @RecordType = 4 -- Fundraiser
	Begin
		UPDATE FundraiserBase SET OwningUser = @UserID
		WHERE FundraiserID = @RecordID
	end 
ELSE
IF @RecordType = 1 -- Contact
	Begin
		UPDATE ContactBase SET OwningUser = @UserID
		WHERE ContactID = @RecordID
	end 
ELSE
IF @RecordType = 0 -- Group
	Begin
		UPDATE GroupBase SET OwningUser = @UserID
		WHERE GroupID = @RecordID
	end 
ELSE
IF @RecordType = 5 -- Invoice
	Begin
		UPDATE InvoiceBase SET OwningUser = @UserID
		WHERE InvoiceID = @RecordID
	end 
ELSE
IF @RecordType = 6 -- Sample
	Begin
		UPDATE SampleBase SET OwningUser = @UserID
		WHERE SampleID = @RecordID
	end 
ELSE
IF @RecordType = 7 -- Activity
	Begin
		UPDATE ActivityBase SET OwningUser = @UserID
		WHERE ActivityID = @RecordID
	end 
ELSE
IF @RecordType = 8 -- Note
	Begin
		UPDATE NoteBase SET OwningUser = @UserID
		WHERE NoteID = @RecordID
	end 



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PrintFliersView]'
GO
CREATE VIEW dbo.PrintFliersView
AS
SELECT     dbo.FundraiserProductClassBase.FundraiserProductClassID, dbo.ProductClassBase.Name, dbo.FundraiserProductClassBase.Quantity, 
                      dbo.FundraiserProductClassBase.Posters, dbo.FundraiserProductClassBase.Fliers, dbo.FundraiserProductClassBase.Goal
FROM         dbo.FundraiserProductClassBase LEFT OUTER JOIN
                      dbo.ProductClassBase ON dbo.FundraiserProductClassBase.ProductClassID = dbo.ProductClassBase.ProductClassId

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_DeleteAndAssign]'
GO

CREATE PROCEDURE [dbo].[FRP_SystemUserBase_DeleteAndAssign]
(
	@SystemUserId uniqueidentifier,
	@AssignToUserID uniqueidentifier
)
AS
	SET NOCOUNT OFF;
	
DELETE FROM SystemUserBase WHERE SystemUserId = @SystemUserId
UPDATE GroupBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE GroupBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE GroupBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE ActivityBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE ActivityBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE ActivityBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE CompanyBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE CompanyBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE ContactBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE ContactBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE ContactBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE GroupTypeBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE GroupTypeBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE InternalAddressBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE InternalAddressBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE InvoiceBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE InvoiceBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE InvoiceBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE InvoiceDetailBase Set DeliveryRepID = @AssignToUserID Where DeliveryRepID = @SystemUserId
UPDATE InvoiceDetailBase Set SalesRepID = @AssignToUserID Where SalesRepID = @SystemUserId
UPDATE NoteBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE NoteBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE NoteBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE FundraiserBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE FundraiserBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE FundraiserBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE FundraiserBase Set SalesPersonID = @AssignToUserID Where SalesPersonID = @SystemUserId
UPDATE FundraiserDetailBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE FundraiserDetailBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE FundraiserProductClassBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE FundraiserProductClassBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE PaymentTermsBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE PaymentTermsBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE ProductBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE ProductBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE ProductClassBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE ProductClassBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE SampleBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE SampleBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE SampleBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE ShippingMethodBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE ShippingMethodBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE SystemUserBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE SystemUserBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE UofMScheduleBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE UofMScheduleBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE UofMScheduleDetailBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE UofMScheduleDetailBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE VendorAddressBase Set Createdby = @AssignToUserID Where Createdby = @SystemUserId
UPDATE VendorAddressBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE VendorBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE VendorBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_NoteBase_GridSelect]'
GO

CREATE PROCEDURE [dbo].[FRP_NoteBase_GridSelect]
(
	@ParentId uniqueidentifier,
	@StatusCode integer
)
AS
	SET NOCOUNT ON;
SELECT 	NoteID,
	Subject,
	NoteText as Body,	
	u.Fullname as [Owning User],
	u2.Fullname as [Created By],
	n.CreatedOn as [Created On]	
FROM	NoteBase n
	Inner Join SystemUserBase u	On n.OwningUser = u.SystemUserId
	Inner Join SystemUserBase u2 On n.CreatedBy = u2.SystemUserId
WHERE ParentId = @ParentId And n.DeletionStateCode = @StatusCode
Order By n.CreatedOn DESC


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[InvoiceBaseView]'
GO
CREATE VIEW dbo.InvoiceBaseView
AS
SELECT     dbo.InvoiceBase.InvoiceId, dbo.InvoiceBase.FundraiserId, dbo.InvoiceBase.OwningUser, dbo.InvoiceBase.GroupId, dbo.InvoiceBase.GroupTypeCode, 
                      dbo.InvoiceBase.InvoiceNumber, dbo.InvoiceBase.GroupPONumber, dbo.InvoiceBase.Name, dbo.InvoiceBase.Description, dbo.InvoiceBase.DocumentDate, 
                      dbo.InvoiceBase.BillToName, dbo.InvoiceBase.BillToStreet1, dbo.InvoiceBase.BillToStreet2, dbo.InvoiceBase.BillToCity, dbo.InvoiceBase.BillToState, 
                      dbo.InvoiceBase.BillToZipCode, dbo.InvoiceBase.BillToTelephone, dbo.InvoiceBase.BillToTelephoneExt, dbo.InvoiceBase.BillToFax, dbo.InvoiceBase.ShipToName, 
                      dbo.InvoiceBase.ShipToStreet1, dbo.InvoiceBase.ShipToStreet2, dbo.InvoiceBase.ShipToCity, dbo.InvoiceBase.ShipToState, dbo.InvoiceBase.ShipToZipCode, 
                      dbo.InvoiceBase.ShipToTelephone, dbo.InvoiceBase.ShipToTelephoneExt, dbo.InvoiceBase.ShipToFax, dbo.InvoiceBase.DiscountAmount, 
                      dbo.InvoiceBase.InvoiceDiscount, dbo.InvoiceBase.FreightAmount, dbo.InvoiceBase.TotalAmount, dbo.InvoiceBase.TotalLineItemAmount, 
                      dbo.InvoiceBase.TotalLineItemDiscountAmount, dbo.InvoiceBase.TotalAmountLessFreight, dbo.InvoiceBase.TotalDiscountAmount, dbo.InvoiceBase.TotalTax, 
                      dbo.InvoiceBase.PaymentTerms, dbo.InvoiceBase.ShippingMethod, dbo.InvoiceBase.ShipToFreightTermsCode, dbo.InvoiceBase.StatusCode, 
                      dbo.InvoiceBase.StatusReasonCode, dbo.InvoiceBase.Delivered, dbo.InvoiceBase.DeliveredOn AS InvoiceDeliveredOn, dbo.InvoiceBase.QBStatusCode, 
                      dbo.InvoiceBase.CreatedBy, dbo.InvoiceBase.CreatedOn, dbo.InvoiceBase.ModifiedBy, dbo.InvoiceBase.ModifiedOn, 
                      SystemUserBase_1.DisplayName AS InvoiceOwningUser, 
                      CASE WHEN dbo.InvoiceBase.StatusCode = 0 THEN 'Open' WHEN dbo.InvoiceBase.StatusCode = 1 THEN 'Closed' WHEN dbo.InvoiceBase.StatusCode = 2 THEN 'Canceled'
                       ELSE '' END AS InvoiceStatus, 
                      CASE WHEN dbo.InvoiceBase.InvoiceStage = 0 THEN 'Order Received' WHEN dbo.InvoiceBase.InvoiceStage = 1 THEN 'Delivered' WHEN dbo.InvoiceBase.InvoiceStage
                       = 2 THEN 'Paid' ELSE '' END AS InvoiceStage, dbo.InvoiceBase.ShipToCode, dbo.GroupBase.GroupName, dbo.FundraiserBase.Topic, 
                      dbo.ContactBase.FullName AS PrimaryContact, dbo.SystemUserBase.DisplayName AS SalesPerson
FROM         dbo.InvoiceBase LEFT OUTER JOIN
                      dbo.SystemUserBase ON dbo.InvoiceBase.OwningUser = dbo.SystemUserBase.SystemUserId LEFT OUTER JOIN
                      dbo.GroupBase ON dbo.InvoiceBase.GroupId = dbo.GroupBase.GroupId LEFT OUTER JOIN
                      dbo.FundraiserBase ON dbo.InvoiceBase.FundraiserId = dbo.FundraiserBase.FundraiserID LEFT OUTER JOIN
                      dbo.ContactBase ON dbo.InvoiceBase.PrimaryContactId = dbo.ContactBase.ContactId LEFT OUTER JOIN
                      dbo.SystemUserBase AS SystemUserBase_1 ON dbo.InvoiceBase.OwningUser = SystemUserBase_1.SystemUserId
WHERE     (dbo.InvoiceBase.DeletionStatusCode <> 1)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_FundraiserBase_DeleteActivities]'
GO

CREATE PROCEDURE [dbo].[FRP_FundraiserBase_DeleteActivities]
(
	@FundraiserID uniqueidentifier
)
AS
SET NOCOUNT ON;
Declare @EmptyID nvarchar(40)
set @EmptyID = '00000000-0000-0000-0000-000000000000'
DELETE FROM FundraiserBase 
WHERE FundraiserId = @FundraiserID
Update InvoiceBase Set FundraiserId = @EmptyID Where FundraiserId = @FundraiserID
Delete From FundraiserDetailBase Where FundraiserID = @FundraiserID
Delete From FundraiserProductClassBase Where FundraiserID = @FundraiserID
Delete From NoteBase Where ParentID = @FundraiserID
--Activities
Declare @TempID uniqueidentifier
DECLARE Activity_cursor CURSOR FOR
SELECT ActivityID FROM ActivityBase 
WHERE GroupId = @FundraiserID
OPEN Activity_cursor
FETCH NEXT FROM Activity_cursor INTO @TempID
WHILE @@FETCH_STATUS = 0
BEGIN
 DELETE FROM ActivityPartyBase WHERE ActivityID = @TempID
 FETCH NEXT FROM Activity_cursor INTO @TempID
END
CLOSE Activity_cursor
DEALLOCATE Activity_cursor
Delete From ActivityBase Where GroupId = @FundraiserID



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ProductBase_ForecastedInventorySelectByProductID]'
GO



CREATE PROCEDURE [dbo].[FRP_ProductBase_ForecastedInventorySelectByProductID] 
(
	@ProductID uniqueidentifier
)
AS
SET NOCOUNT ON;




DECLARE @EmptyGUID uniqueidentifier
SET @EmptyGUID = '00000000-0000-0000-0000-000000000000'



CREATE TABLE #EstInventoryTemp(
	[TrxID] uniqueidentifier,
	[TrxDate] datetime,
	[TrxName] nvarchar(300),	
	[ProductNumber] nvarchar(100),
	[QtyOnHand] decimal(18,0),
	[ProductClass] nvarchar(100),
	[Quantity] decimal(18,0),
	[ForecastedQty] decimal(18,0),
	[TrxType] nvarchar(20),
	[Type] int,
	[Reorder] decimal(18,0),
	[Minimum] decimal(18,0)
)

DECLARE @TrxID uniqueidentifier, @TrxDate datetime, @TrxName nvarchar(300), @ProductNumber nvarchar(100), @QOH decimal(18,0), @ProductClass nvarchar(100), @Quantity decimal(18,0),  @TrxType nvarchar(20), @Type int, @Reorder decimal(18,0), @Minimum decimal(18,0)

DECLARE @EstInvLevel as integer 

SET @EstInvLevel = (select QuantityOnHand FROM ProductBase Where ProductID = @ProductID)

 

 

DECLARE Quanity_Cursor CURSOR FOR
-- This should add to the forecasted inv. quantity.
SELECT     dbo.PurchaseOrderBase.PurchaseOrderID As TrxID, dbo.PurchaseOrderBase.ReceivedOn AS TrxDate, dbo.PurchaseOrderBase.PONumber AS TrxName,  dbo.ProductBase.ProductNumber, dbo.ProductBase.QuantityOnHand, 
                      dbo.ProductClassBase.Name AS ProductClass, dbo.PurchaseOrderDetailBase.QuantityOrdered AS Quantity, 
                       'PO - Pending' AS TrxType, 0 AS Type, dbo.ProductBase.ReorderPoint, dbo.ProductBase.MinimumQty
FROM         dbo.PurchaseOrderBase INNER JOIN
                      dbo.PurchaseOrderDetailBase ON dbo.PurchaseOrderBase.PurchaseOrderID = dbo.PurchaseOrderDetailBase.PurchaseOrderID LEFT OUTER JOIN
                      dbo.ProductBase ON dbo.PurchaseOrderDetailBase.ProductID = dbo.ProductBase.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase ON dbo.ProductBase.ProductClassID = dbo.ProductClassBase.ProductClassId
WHERE     (dbo.PurchaseOrderBase.Stage = 0) AND (dbo.PurchaseOrderBase.Status = 0) AND (dbo.PurchaseOrderBase.DeletionStateCode <> 1) AND (dbo.PurchaseOrderDetailBase.ProductID = @ProductID) AND (dbo.ProductBase.ProductID = @ProductID)
			AND (dbo.PurchaseOrderDetailBase.QuantityOrdered <> 0) AND (dbo.ProductBase.Carried <> 0)
UNION ALL

-- This should add to the forecasted inv. quantity.
SELECT     PurchaseOrderBase_1.PurchaseOrderID, PurchaseOrderBase_1.ReceivedOn, PurchaseOrderBase_1.PONumber, ProductBase_4.ProductNumber, ProductBase_4.QuantityOnHand,
                      ProductClassBase_4.Name, PurchaseOrderDetailBase_1.QuantityOrdered, 
                       'PO - Ordered', 1, ProductBase_4.ReorderPoint, ProductBase_4.MinimumQty
FROM         dbo.PurchaseOrderBase AS PurchaseOrderBase_1 INNER JOIN
                      dbo.PurchaseOrderDetailBase AS PurchaseOrderDetailBase_1 ON 
                      PurchaseOrderBase_1.PurchaseOrderID = PurchaseOrderDetailBase_1.PurchaseOrderID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_4 ON PurchaseOrderDetailBase_1.ProductID = ProductBase_4.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_4 ON ProductBase_4.ProductClassID = ProductClassBase_4.ProductClassId
WHERE     (PurchaseOrderBase_1.Stage = 1) AND (PurchaseOrderBase_1.Status = 0) AND (PurchaseOrderBase_1.DeletionStateCode <> 1) AND (PurchaseOrderDetailBase_1.ProductID = @ProductID) AND (ProductBase_4.ProductID = @ProductID)
			AND (PurchaseOrderDetailBase_1.QuantityOrdered <> 0) AND (ProductBase_4.Carried <> 0)
UNION ALL

-- This should subtract from the forecasted inv. quantity.
SELECT     dbo.InvoiceBase.InvoiceID, CASE UseDeliveryDate When 0 then dbo.InvoiceBase.DocumentDate Else ActivityBase_2.ScheduledStartDate End as TrxDate, dbo.InvoiceBase.Name, ProductBase_3.ProductNumber, ProductBase_3.QuantityOnHand,
                      ProductClassBase_3.Name, dbo.InvoiceDetailBase.Quantity * - 1,
                      'Invoice - Ordered', 2, ProductBase_3.ReorderPoint, ProductBase_3.MinimumQty
FROM         dbo.InvoiceBase INNER JOIN
                      dbo.InvoiceDetailBase ON dbo.InvoiceBase.InvoiceId = dbo.InvoiceDetailBase.InvoiceID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_3 ON dbo.InvoiceDetailBase.ProductID = ProductBase_3.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_3 ON ProductBase_3.ProductClassID = ProductClassBase_3.ProductClassId LEFT Outer Join
					  dbo.ActivityBase as ActivityBase_2 On ActivityBase_2.DocID = InvoiceBase.InvoiceId
WHERE     (dbo.InvoiceBase.InvoiceStage = 0) AND (dbo.InvoiceBase.StatusCode = 0) AND (dbo.InvoiceBase.DeletionStatusCode <> 1) AND (dbo.InvoiceDetailBase.ProductID = @ProductID) AND (ProductBase_3.ProductID = @ProductID)
			AND (dbo.InvoiceDetailBase.Quantity <> 0) AND (ProductBase_3.Carried <> 0)
UNION ALL

-- These have a primary delivery. This should subtract from the forecasted inv. quantity.
SELECT     dbo.FundraiserBase.FundraiserID,dbo.ActivityBase.ScheduledStartDate, dbo.FundraiserBase.Topic, ProductBase_2.ProductNumber, ProductBase_2.QuantityOnHand,
                      ProductClassBase_2.Name, dbo.FundraiserDetailBase.Quantity * - 1, 
                      'Fundraiser - Pending', 3, ProductBase_2.ReorderPoint, ProductBase_2.MinimumQty
FROM         dbo.FundraiserBase INNER JOIN
                      dbo.FundraiserDetailBase ON dbo.FundraiserBase.FundraiserID = dbo.FundraiserDetailBase.FundraiserID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_2 ON dbo.FundraiserDetailBase.ProductID = ProductBase_2.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_2 ON ProductBase_2.ProductClassID = ProductClassBase_2.ProductClassId LEFT OUTER JOIN
					  dbo.ActivityBase ON dbo.FundraiserBase.DeliveryID = dbo.ActivityBase.ActivityID
WHERE     (dbo.FundraiserBase.SalesStageCode = 0) AND (dbo.FundraiserBase.StatusCode = 1) AND (dbo.FundraiserBase.DeletionStatusCode <> 1) AND (dbo.FundraiserBase.DeliveryID <> @EmptyGUID) AND (dbo.FundraiserDetailBase.ProductID = @ProductID) AND (ProductBase_2.ProductID = @ProductID)
			AND (dbo.FundraiserDetailBase.Quantity <> 0) AND (ProductBase_2.Carried <> 0) AND (dbo.ActivityBase.PrimaryDelivery = 'True')
UNION ALL

-- These DO NOT have a primary delivery. This should subtract from the forecasted inv. quantity.
SELECT     dbo.FundraiserBase.FundraiserID, dbo.FundraiserBase.CallinOrderBy, dbo.FundraiserBase.Topic,  ProductBase_2.ProductNumber, ProductBase_2.QuantityOnHand,
                      ProductClassBase_2.Name, dbo.FundraiserDetailBase.Quantity * - 1,  
                      'Fundraiser - Pending', 4, ProductBase_2.ReorderPoint, ProductBase_2.MinimumQty
FROM         dbo.FundraiserBase INNER JOIN
                      dbo.FundraiserDetailBase ON dbo.FundraiserBase.FundraiserID = dbo.FundraiserDetailBase.FundraiserID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_2 ON dbo.FundraiserDetailBase.ProductID = ProductBase_2.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_2 ON ProductBase_2.ProductClassID = ProductClassBase_2.ProductClassId LEFT OUTER JOIN
					  dbo.ActivityBase ON dbo.FundraiserBase.DeliveryID = dbo.ActivityBase.ActivityID
WHERE     (dbo.FundraiserBase.SalesStageCode = 0) AND (dbo.FundraiserBase.StatusCode = 1) AND (dbo.FundraiserBase.DeletionStatusCode <> 1) AND (dbo.FundraiserBase.DeliveryID = @EmptyGUID) AND (dbo.FundraiserDetailBase.ProductID = @ProductID) AND (ProductBase_2.ProductID = @ProductID)
			AND (dbo.FundraiserDetailBase.Quantity <> 0) AND (ProductBase_2.Carried <> 0) AND (dbo.ActivityBase.PrimaryDelivery <> 'True')
UNION ALL

-- These have a primary delivery. This should subtract from the forecasted inv. quantity.
SELECT     FundraiserBase_1.FundraiserID, dbo.ActivityBase.ScheduledStartDate, FundraiserBase_1.Topic, ProductBase_1.ProductNumber, ProductBase_1.QuantityOnHand,
                      ProductClassBase_1.Name, FundraiserDetailBase_1.Quantity * - 1, 
                      'Fundraiser - Booked', 5, ProductBase_1.ReorderPoint, ProductBase_1.MinimumQty
FROM         dbo.FundraiserBase AS FundraiserBase_1 INNER JOIN
                      dbo.FundraiserDetailBase AS FundraiserDetailBase_1 ON FundraiserBase_1.FundraiserID = FundraiserDetailBase_1.FundraiserID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_1 ON FundraiserDetailBase_1.ProductID = ProductBase_1.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_1 ON ProductBase_1.ProductClassID = ProductClassBase_1.ProductClassId LEFT OUTER JOIN
				      dbo.ActivityBase ON FundraiserBase_1.DeliveryID = dbo.ActivityBase.ActivityID
WHERE     (FundraiserBase_1.SalesStageCode = 1) AND (FundraiserBase_1.StatusCode = 1) AND (FundraiserBase_1.DeletionStatusCode <> 1) AND (FundraiserBase_1.DeliveryID <> @EmptyGUID) AND (FundraiserDetailBase_1.ProductID = @ProductID) AND (ProductBase_1.ProductID = @ProductID)
			AND (FundraiserDetailBase_1.Quantity <> 0) AND (ProductBase_1.Carried <> 0)
UNION ALL

-- These DO NOT have a primary delivery. This should subtract from the forecasted inv. quantity.
SELECT    FundraiserBase_1.FundraiserID, FundraiserBase_1.CallInOrderBy, ''+FundraiserBase_1.Topic, ProductBase_1.ProductNumber, ProductBase_1.QuantityOnHand,
                      ProductClassBase_1.Name, FundraiserDetailBase_1.Quantity * - 1,  
                      'Fundraiser - Booked', 6, ProductBase_1.ReorderPoint, ProductBase_1.MinimumQty
FROM         dbo.FundraiserBase AS FundraiserBase_1 INNER JOIN
                      dbo.FundraiserDetailBase AS FundraiserDetailBase_1 ON FundraiserBase_1.FundraiserID = FundraiserDetailBase_1.FundraiserID LEFT OUTER JOIN
                      dbo.ProductBase AS ProductBase_1 ON FundraiserDetailBase_1.ProductID = ProductBase_1.ProductId LEFT OUTER JOIN
                      dbo.ProductClassBase AS ProductClassBase_1 ON ProductBase_1.ProductClassID = ProductClassBase_1.ProductClassId
WHERE     (FundraiserBase_1.SalesStageCode = 1) AND (FundraiserBase_1.StatusCode = 1) AND (FundraiserBase_1.DeletionStatusCode <> 1) AND (FundraiserBase_1.DeliveryID = @EmptyGUID) AND (FundraiserDetailBase_1.ProductID = @ProductID) AND (ProductBase_1.ProductID = @ProductID)
			AND (FundraiserDetailBase_1.Quantity <> 0) AND (ProductBase_1.Carried <> 0)
ORDER BY TrxDate



OPEN Quanity_Cursor 
FETCH NEXT FROM Quanity_Cursor
INTO @TrxID, @TrxDate, @TrxName, @ProductNumber, @QOH, @ProductClass, @Quantity, @TrxType, @Type, @Reorder, @Minimum
WHILE @@FETCH_STATUS = 0
BEGIN

 
Set @EstInvLevel = @EstInvLevel + @Quantity

Insert #EstInventoryTemp (TrxID, TrxDate, TrxName,ProductNumber, QtyOnHand, ProductClass, Quantity, ForecastedQty, TrxType, Type, Reorder, Minimum )
Values (@TrxID, @TrxDate, @TrxName, @ProductNumber, @QOH, @ProductClass, @Quantity, @EstInvlevel, @TrxType, @Type, @Reorder, @Minimum)



FETCH NEXT FROM Quanity_Cursor
INTO @TrxID, @TrxDate, @TrxName, @ProductNumber, @QOH, @ProductClass, @Quantity, @TrxType, @Type, @Reorder, @Minimum
END




CLOSE Quanity_Cursor 
DEALLOCATE Quanity_Cursor 


Select *  FROM #EstInventoryTemp

DROP TABLE #EstInventoryTemp
















GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_SystemUserBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_SystemUserBase_Delete]
(
	@SystemUserId uniqueidentifier,
	@AssignToUserID uniqueidentifier
)
AS
	SET NOCOUNT OFF;
	
DELETE FROM SystemUserBase WHERE SystemUserId = @SystemUserId
UPDATE GroupBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE GroupBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE GroupBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE ActivityBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE ActivityBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE ActivityBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE CompanyBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE CompanyBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE ContactBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE ContactBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE ContactBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE GroupTypeBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE GroupTypeBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE InternalAddressBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE InternalAddressBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE InvoiceBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE InvoiceBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE InvoiceBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE InvoiceDetailBase Set DeliveryRepID = @AssignToUserID Where DeliveryRepID = @SystemUserId
UPDATE InvoiceDetailBase Set SalesRepID = @AssignToUserID Where SalesRepID = @SystemUserId
UPDATE NoteBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE NoteBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE NoteBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE FundraiserBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE FundraiserBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE FundraiserBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE FundraiserBase Set SalesPersonID = @AssignToUserID Where SalesPersonID = @SystemUserId
UPDATE FundraiserDetailBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE FundraiserDetailBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE FundraiserProductClassBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE FundraiserProductClassBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE PaymentTermsBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE PaymentTermsBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE ProductBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE ProductBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE ProductClassBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE ProductClassBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE SampleBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE SampleBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE SampleBase Set OwningUser = @AssignToUserID Where OwningUser = @SystemUserId
UPDATE ShippingMethodBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE ShippingMethodBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE SystemUserBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE SystemUserBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE UofMScheduleBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE UofMScheduleBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE UofMScheduleDetailBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE UofMScheduleDetailBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE VendorAddressBase Set Createdby = @AssignToUserID Where Createdby = @SystemUserId
UPDATE VendorAddressBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId
UPDATE VendorBase Set CreatedBy = @AssignToUserID Where CreatedBy = @SystemUserId
UPDATE VendorBase Set ModifiedBy = @AssignToUserID Where ModifiedBy = @SystemUserId



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GroupBase_DeleteActivitiesFundraisersInvoices]'
GO

CREATE PROCEDURE [dbo].[FRP_GroupBase_DeleteActivitiesFundraisersInvoices]
(
	@GroupID uniqueidentifier
)
AS
SET NOCOUNT ON;
DELETE FROM GroupBase 
WHERE GroupId = @GroupID
Declare @EmptyID nvarchar(40)
set @EmptyID = '00000000-0000-0000-0000-000000000000'
Update ContactBase Set ParentGroupID = @EmptyID Where ParentGroupID = @GroupID 
Update ActivityBase Set RecipientId = @EmptyID Where RecipientId = @GroupID 
Update ActivityBase Set RegardingId = @EmptyID Where RegardingId = @GroupID 
Update ActivityBase Set SenderId = @EmptyID Where SenderId = @GroupID 
-- Notes
Delete From NoteBase Where ParentID = @GroupID
--Addresses
Delete From CustomerAddressBase Where ParentID = @GroupID
--Activities
Declare @TempID uniqueidentifier
DECLARE Activity_cursor CURSOR FOR
SELECT ActivityID FROM ActivityBase 
WHERE GroupID = @GroupID
OPEN Activity_cursor
FETCH NEXT FROM Activity_cursor INTO @TempID
WHILE @@FETCH_STATUS = 0
BEGIN
 DELETE FROM ActivityPartyBase WHERE ActivityID = @TempID
 FETCH NEXT FROM Activity_cursor INTO @TempID
END
CLOSE Activity_cursor
DEALLOCATE Activity_cursor
Delete From ActivityBase Where GroupId = @GroupID
Delete From ActivityPartyBase Where PartyId = @GroupID

DECLARE Fundraiser_cursor CURSOR FOR
SELECT FundraiserID FROM FundraiserBase
WHERE GroupID = @GroupID
OPEN Fundraiser_cursor
FETCH NEXT FROM Fundraiser_cursor INTO @TempID
WHILE @@FETCH_STATUS = 0
BEGIN
 DELETE FROM FundraiserDetailBase WHERE FundraiserID = @TempID
 DELETE FROM FundraiserProductClassBase WHERE FundraiserID = @TempID
 FETCH NEXT FROM Fundraiser_cursor INTO @TempID
END
CLOSE Fundraiser_cursor
DEALLOCATE Fundraiser_cursor
Delete From FundraiserBase Where GroupID = @GroupID
--Invoices
DECLARE Invoice_cursor CURSOR FOR
SELECT InvoiceID FROM InvoiceBase
WHERE GroupID = @GroupID
OPEN Invoice_cursor
FETCH NEXT FROM Invoice_cursor INTO @TempID
WHILE @@FETCH_STATUS = 0
BEGIN
 DELETE FROM InvoiceDetailBase WHERE InvoiceID = @TempID 
 FETCH NEXT FROM Invoice_cursor INTO @TempID
END
CLOSE Invoice_cursor
DEALLOCATE Invoice_cursor
Delete From InvoiceBase Where GroupId = @GroupID



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[fnTableColumnInfo]'
GO

CREATE       FUNCTION dbo.fnTableColumnInfo(@sTableName varchar(128))
RETURNS TABLE
AS
	RETURN
	SELECT	c.name AS sColumnName,
		c.colid AS nColumnID,
		dbo.fnIsColumnPrimaryKey(@sTableName, c.name) AS bPrimaryKeyColumn,
		CASE 	WHEN t.name IN ('char', 'varchar', 'binary', 'varbinary', 'nchar', 'nvarchar') THEN 1
			WHEN t.name IN ('decimal', 'numeric') THEN 2
			ELSE 0
		END AS nAlternateType,
		c.length AS nColumnLength,
		c.prec AS nColumnPrecision,
		c.scale AS nColumnScale, 
		c.IsNullable, 
		SIGN(c.status & 128) AS IsIdentity,
		t.name as sTypeName,
		dbo.fnColumnDefault(@sTableName, c.name) AS sDefaultValue
	FROM	syscolumns c 
		INNER JOIN systypes t ON c.xtype = t.xtype and c.usertype = t.usertype
	WHERE	c.id = OBJECT_ID(@sTableName)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_GenericRecordDelete]'
GO

CREATE PROCEDURE [dbo].[FRP_GenericRecordDelete]
(
		@RecordID uniqueidentifier,
		@RecordType integer
)
AS
	SET NOCOUNT OFF;
	
Declare @EmptyID nvarchar(40)
set @EmptyID = '00000000-0000-0000-0000-000000000000'
	
IF @RecordType = 4 -- Fundraiser
	Begin
		Exec FRP_FundraiserBase_DeleteActivities @FundraiserID = @RecordID
	end 
ELSE
IF @RecordType = 1 -- Contact
	Begin
		Exec FRP_ContactBase_DeleteActivitiesInvoices @ContactID = @RecordID
	end 
ELSE
IF @RecordType = 0 -- Group
	Begin
		Exec FRP_GroupBase_DeleteActivitiesFundraisersInvoices @GroupID = @RecordID
	end 
ELSE
IF @RecordType = 5 -- Invoice
	Begin		
		Exec FRP_InvoiceBase_DeleteActivities @InvoiceID = @RecordID
		--Update QuantityAllocated
		Exec FRP_ProductBase_PCUpdateQuantityAllocated
	end 
ELSE
/*IF @RecordType = 6 -- Sample
	Begin
		Exec Delete_Sample @SampleID = @RecordID
	END
ELSE*/
IF @RecordType = 3 -- User
	Begin
		--DELETE FROM SystemUserBase WHERE SystemUserId = @RecordID
		--Set as disabled - do not delete
		Update SystemUserBase Set DeletionStateCode = 1 Where SystemUserId = @RecordID
	end 
ELSE
IF @RecordType = 7 -- Activity
	Begin
		DELETE FROM ActivityBase Where ActivityID = @RecordID
		DELETE FROM ActivityPartyBase Where ActivityID = @RecordID
	End
ELSE
IF @RecordType = 8 -- Note
	Begin
		DELETE FROM NoteBase Where NoteID = @RecordID
	End
ELSE
IF @RecordType = 10 -- Fundraiser Product
	Begin
		DELETE FROM FundraiserProductClassBase Where FundraiserProductClassID = @RecordID
	End
ELSE
IF @RecordType = 11 -- Invoice Product
	Begin
		DELETE FROM InvoiceDetailBase Where InvoiceDetailID = @RecordID
	End	
ELSE
IF @RecordType = 12 -- Customer Address
	Begin
		DELETE FROM CustomerAddressBase Where AddressID = @RecordID
	End
ELSE
IF @RecordType = 20 -- GroupType
	Begin
		DELETE FROM GroupTypeBase Where GroupTypeID = @RecordID
	End	
ELSE
IF @RecordType = 21 -- Payment Term
	Begin
		DELETE FROM PaymentTermsBase Where PaymentTermsID = @RecordID
	End
ELSE
IF @RecordType = 22 -- Shipping Method
	Begin
		DELETE FROM ShippingMethodBase Where ShippingMethodID = @RecordID
	End





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[fnTableHasPrimaryKey]'
GO

CREATE FUNCTION dbo.fnTableHasPrimaryKey(@sTableName varchar(128))
RETURNS bit
AS
BEGIN
	DECLARE @nTableID int,
		@nIndexID int
	
	SET 	@nTableID = OBJECT_ID(@sTableName)
	
	SELECT 	@nIndexID = indid
	FROM 	sysindexes
	WHERE 	id = @nTableID
	 AND 	indid BETWEEN 1 And 254 
	 AND 	(status & 2048) = 2048
	
	IF @nIndexID IS NOT Null
		RETURN 1
	
	RETURN 0
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DocumentBase]'
GO
CREATE TABLE [dbo].[DocumentBase]
(
[DocumentId] [uniqueidentifier] NOT NULL,
[Name] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Body] [xml] NULL,
[Type] [int] NULL,
[DeletionStateCode] [int] NULL,
[StatusCode] [int] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_DocumentBase] on [dbo].[DocumentBase]'
GO
ALTER TABLE [dbo].[DocumentBase] ADD CONSTRAINT [PK_DocumentBase] PRIMARY KEY CLUSTERED  ([DocumentId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[EmailBase]'
GO
CREATE TABLE [dbo].[EmailBase]
(
[EmailID] [uniqueidentifier] NOT NULL,
[ParentId] [uniqueidentifier] NOT NULL,
[EmailTo] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailFrom] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailDate] [datetime] NULL,
[Subject] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attachment] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_EmailBase] on [dbo].[EmailBase]'
GO
ALTER TABLE [dbo].[EmailBase] ADD CONSTRAINT [PK_EmailBase] PRIMARY KEY CLUSTERED  ([EmailID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[EmailClientIntegrationBase]'
GO
CREATE TABLE [dbo].[EmailClientIntegrationBase]
(
[EmailItemID] [uniqueidentifier] NOT NULL,
[EmailDate] [datetime] NULL,
[EmailTo] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailFrom] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Request] [int] NOT NULL,
[Attachment] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentID] [uniqueidentifier] NULL,
[MachineName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_MailClientIntegrationBase] on [dbo].[EmailClientIntegrationBase]'
GO
ALTER TABLE [dbo].[EmailClientIntegrationBase] ADD CONSTRAINT [PK_MailClientIntegrationBase] PRIMARY KEY CLUSTERED  ([EmailItemID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[EmailTrackingBase]'
GO
CREATE TABLE [dbo].[EmailTrackingBase]
(
[EmailItemID] [uniqueidentifier] NOT NULL,
[EmailTrackingID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentID] [uniqueidentifier] NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_EmailTrackingBase] on [dbo].[EmailTrackingBase]'
GO
ALTER TABLE [dbo].[EmailTrackingBase] ADD CONSTRAINT [PK_EmailTrackingBase] PRIMARY KEY CLUSTERED  ([EmailItemID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ProgramBase]'
GO
CREATE TABLE [dbo].[ProgramBase]
(
[ProgramId] [uniqueidentifier] NOT NULL,
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[DeletionStateCode] [int] NULL,
[StatusCode] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ProgramBase] on [dbo].[ProgramBase]'
GO
ALTER TABLE [dbo].[ProgramBase] ADD CONSTRAINT [PK_ProgramBase] PRIMARY KEY CLUSTERED  ([ProgramId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ProgramDetailBase]'
GO
CREATE TABLE [dbo].[ProgramDetailBase]
(
[ProgramDetailId] [uniqueidentifier] NOT NULL,
[ProgramId] [uniqueidentifier] NOT NULL,
[ProductId] [uniqueidentifier] NOT NULL,
[ProductClassId] [uniqueidentifier] NOT NULL,
[ProductName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RetailPrice] [money] NULL,
[GroupRetailPrice] [money] NULL,
[ConsumerRetailPrice] [money] NULL,
[FlierLayoutOrder] [int] NULL,
[ForecastSalesPercentage] [decimal] (18, 5) NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[DeletionStateCode] [int] NULL,
[StatusCode] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ProgramDetailBase] on [dbo].[ProgramDetailBase]'
GO
ALTER TABLE [dbo].[ProgramDetailBase] ADD CONSTRAINT [PK_ProgramDetailBase] PRIMARY KEY CLUSTERED  ([ProgramDetailId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SampleDetailBase]'
GO
CREATE TABLE [dbo].[SampleDetailBase]
(
[SampleDetailID] [uniqueidentifier] NOT NULL,
[SampleID] [uniqueidentifier] NULL,
[ProductID] [uniqueidentifier] NULL,
[ProductDescription] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quanitity] [int] NULL,
[DeletionStateCode] [int] NULL,
[CreatedOn] [datetime] NULL,
[ModifiedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedBy] [uniqueidentifier] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_SampleDetailBase] on [dbo].[SampleDetailBase]'
GO
ALTER TABLE [dbo].[SampleDetailBase] ADD CONSTRAINT [PK_SampleDetailBase] PRIMARY KEY CLUSTERED  ([SampleDetailID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityPartyBase_Delete]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityPartyBase_Delete]
(
	@Original_ActivityPartyId uniqueidentifier,
	@Original_ActivityId uniqueidentifier,
	@Original_PartyId uniqueidentifier
)
AS
	SET NOCOUNT OFF;
DELETE FROM ActivityPartyBase WHERE (ActivityPartyId = @Original_ActivityPartyId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_UserSettings_Update]'
GO
-- =============================================
-- Author:		Michael Bierman
-- Create date: 11/7/2006
-- Description:	Insert or Update user settings
-- =============================================
CREATE PROCEDURE [dbo].[FRP_UserSettings_Update] 
	-- Add the parameters for the stored procedure here
	@userID varchar(50), 
	@settingKey varchar(100),
	@setting ntext
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (SELECT Count(settingKey) FROM UserSettings WHERE userID = @userID AND settingKey = @settingKey) > 0
		BEGIN
			UPDATE UserSettings SET settingXML = @setting WHERE userID = @userID AND settingKey = @settingKey
		END
	ELSE
		BEGIN
			INSERT INTO UserSettings(userID, settingKey, settingXML) VALUES(@userID, @settingKey, @setting)
		END
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_UserSettings_SelectSettingsByUserID]'
GO
-- =============================================
-- Author:		Michael Bierman
-- Create date: 11/7/2006
-- Description:	Get Settings for current user
-- =============================================
CREATE PROCEDURE [dbo].[FRP_UserSettings_SelectSettingsByUserID] 
	-- Add the parameters for the stored procedure here
	@userID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM UserSettings WHERE UserID = @userID
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityPartyBase_Insert]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityPartyBase_Insert]
(
	@ActivityPartyId uniqueidentifier,
	@ActivityId uniqueidentifier,
	@PartyId uniqueidentifier
)
AS
	SET NOCOUNT OFF;
INSERT INTO ActivityPartyBase(ActivityPartyId, ActivityId, PartyId) VALUES (@ActivityPartyId, @ActivityId, @PartyId);
	SELECT ActivityPartyId, ActivityId, PartyId FROM ActivityPartyBase WHERE (ActivityPartyId = @ActivityPartyId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityPartyBase_Update]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityPartyBase_Update]
(
	@ActivityPartyId uniqueidentifier,
	@ActivityId uniqueidentifier,
	@PartyId uniqueidentifier,
	@Original_ActivityPartyId uniqueidentifier,
	@Original_ActivityId uniqueidentifier,
	@Original_PartyId uniqueidentifier
)
AS
	SET NOCOUNT OFF;
UPDATE ActivityPartyBase SET ActivityPartyId = @ActivityPartyId, ActivityId = @ActivityId, PartyId = @PartyId WHERE (ActivityPartyId = @Original_ActivityPartyId);
	SELECT ActivityPartyId, ActivityId, PartyId FROM ActivityPartyBase WHERE (ActivityPartyId = @ActivityPartyId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FRP_ActivityPartyBase_Select]'
GO

CREATE PROCEDURE [dbo].[FRP_ActivityPartyBase_Select]
(
	@ActivityId uniqueidentifier
)
AS
	SET NOCOUNT ON;
SELECT ActivityPartyId, ActivityId, PartyId FROM ActivityPartyBase WHERE (ActivityId = @ActivityId)


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating extended properties'
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[49] 4[5] 2[17] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 210
               Left = 274
               Bottom = 318
               Right = 499
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 96
               Left = 659
               Bottom = 211
               Right = 878
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 318
               Left = 230
               Bottom = 426
               Right = 455
            End
            DisplayFlags = 280
            TopColumn = 29
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 98
               Left = 288
               Bottom = 206
               Right = 475
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 64
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = ', 'SCHEMA', N'dbo', 'VIEW', N'ActivityBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane2', N'1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'ActivityBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 2, 'SCHEMA', N'dbo', 'VIEW', N'ActivityBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[20] 2[19] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -480
         Left = 0
      End
      Begin Tables = 
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 261
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 302
               Bottom = 121
               Right = 528
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 823
               Bottom = 252
               Right = 1005
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 6
               Left = 566
               Bottom = 265
               Right = 785
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 72
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
 ', 'SCHEMA', N'dbo', 'VIEW', N'ContactBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane2', N'        Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 3015
         Width = 3720
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2040
         Alias = 2160
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'ContactBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 2, 'SCHEMA', N'dbo', 'VIEW', N'ContactBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[17] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "o"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 32
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 6
               Left = 528
               Bottom = 121
               Right = 754
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 6
               Left = 271
               Bottom = 121
               Right = 490
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 582
               Left = 38
               Bottom = 697
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 57
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 996
               Bottom = 121
               Right = 1178
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 40
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 14', 'SCHEMA', N'dbo', 'VIEW', N'FundraiserBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane2', N'40
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2490
         Table = 1170
         Output = 705
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'FundraiserBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 2, 'SCHEMA', N'dbo', 'VIEW', N'FundraiserBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "o"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 6
               Left = 297
               Bottom = 121
               Right = 501
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'FundraiserProductClassView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'FundraiserProductClassView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "o"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 264
               Bottom = 121
               Right = 490
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 528
               Bottom = 121
               Right = 754
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u1"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u2"
            Begin Extent = 
               Top = 126
               Left = 295
               Bottom = 241
               Right = 514
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u4"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 361
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u5"
            Begin Extent = 
               Top = 246
               Left = 295
               Bottom = 361
               Right = 514
            End
            DisplayFlags = 280
            TopColumn = 0
         End', 'SCHEMA', N'dbo', 'VIEW', N'FundraiserRelatedNames', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane2', N'
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'FundraiserRelatedNames', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 2, 'SCHEMA', N'dbo', 'VIEW', N'FundraiserRelatedNames', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CustomerAddressBase"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 123
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'FutureSalesChecklist_HomeAddressView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'FutureSalesChecklist_HomeAddressView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[45] 4[16] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[66] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 5
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 99
               Left = 439
               Bottom = 214
               Right = 658
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 2
               Left = 805
               Bottom = 117
               Right = 987
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 221
               Left = 452
               Bottom = 336
               Right = 678
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 43
         Width = 284
         Width = 1440
         Width = 1920
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
   ', 'SCHEMA', N'dbo', 'VIEW', N'GroupBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane2', N'      Width = 1440
         Width = 1440
         Width = 2190
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2115
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'GroupBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 2, 'SCHEMA', N'dbo', 'VIEW', N'GroupBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "i"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 23
               Left = 486
               Bottom = 138
               Right = 705
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2925
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'InventoryAdjustmentBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'InventoryAdjustmentBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[21] 4[15] 2[42] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -593
         Left = -288
      End
      Begin Tables = 
         Begin Table = "InvoiceBase"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 288
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SystemUserBase"
            Begin Extent = 
               Top = 503
               Left = 326
               Bottom = 618
               Right = 545
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GroupBase"
            Begin Extent = 
               Top = 503
               Left = 809
               Bottom = 618
               Right = 1035
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FundraiserBase"
            Begin Extent = 
               Top = 623
               Left = 326
               Bottom = 738
               Right = 514
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ContactBase"
            Begin Extent = 
               Top = 623
               Left = 552
               Bottom = 738
               Right = 778
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SystemUserBase_1"
            Begin Extent = 
               Top = 623
               Left = 816
               Bottom = 738
               Right = 1035
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 60
         Width = 284
      ', 'SCHEMA', N'dbo', 'VIEW', N'InvoiceBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane2', N'   Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2370
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'InvoiceBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 2, 'SCHEMA', N'dbo', 'VIEW', N'InvoiceBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "NoteBase"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 159
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "ParentItem"
            Begin Extent = 
               Top = 6
               Left = 247
               Bottom = 99
               Right = 398
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SystemUserBase"
            Begin Extent = 
               Top = 186
               Left = 253
               Bottom = 294
               Right = 471
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'NoteBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'NoteBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FundraiserProductClassBase"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "ProductClassBase"
            Begin Extent = 
               Top = 6
               Left = 263
               Bottom = 114
               Right = 433
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1380
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'PrintFliersView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'PrintFliersView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 5
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'ProductBaseForecastedInventoryView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'ProductBaseForecastedInventoryView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 6
               Left = 247
               Bottom = 121
               Right = 466
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'PurchaseOrderBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'PurchaseOrderBaseView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO
