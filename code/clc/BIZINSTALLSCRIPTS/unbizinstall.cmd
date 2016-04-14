



@SET DeploymentServer=CLC-SQLBIZ-IQ1





@ECHO *************************************************************************
	
@REM @SET Framework=C:\WINDOWS\Microsoft.NET\Framework\v1.1.4322
@REM @SET PATH=%Framework%;%PATH%;

@SET BasePath="C:\Program Files\CLC\BizTalk2004\CLC.Biztalk.EDI"


@SET ConfigurationPath=%BasePath%

@SET AssemblyPath=.\files

@SET POSInterfaceBase=.\

@SET MSScriptingPath=.\

@SET BindingFilePath=.\files
@ECHO %BasePath%


@CScript /NoLogo "%MSScriptingPath%\stoporch.vbs" CLC.Biztalk.EDI.Orchestrations.BatchRetry  %Assembly% Unenlist
@CScript /NoLogo "%MSScriptingPath%\stoporch.vbs" CLC.Biztalk.EDI.Orchestrations.ChangeTransSendIn %Assembly% Unenlist
@CScript /NoLogo "%MSScriptingPath%\stoporch.vbs" CLC.Biztalk.EDI.RequestCertification  %Assembly% Unenlist
@CScript /NoLogo "%MSScriptingPath%\stoporch.vbs" CLC.Biztalk.EDI.ResponseIn  %Assembly% Unenlist
@CScript /NoLogo "%MSScriptingPath%\stoporch.vbs" CLC.Biztalk.EDI.SendChangeResponse  %Assembly% Unenlist
@CScript /NoLogo "%MSScriptingPath%\stoporch.vbs" CLC.Biztalk.EDI.SendGuaranteeRequest  %Assembly% Unenlist
@CScript /NoLogo "%MSScriptingPath%\stoporch.vbs" CLC.Biztalk.EDI.AppSendIn  %Assembly% Unenlist
@CScript /NoLogo "%MSScriptingPath%\stoporch.vbs" CLC.Biztalk.EDI.Orchestrations.ChangeTransSendIn %Assembly% Unenlist


@ECHO.
@SET Assembly=CLC.Biztalk.EDI.Orchestrations
@ECHO undeploying the %Assembly% assembly
@BTSDeploy REMOVE SERVER=%DeploymentServer% DATABASE=BizTalkMgmtDb ASSEMBLY="%AssemblyPath%\%Assembly%.dll" Uninstall=True Log=Undeploy


@ECHO.
@SET Assembly=CLC.Biztalk.EDI.Maps
@ECHO undeploying the %Assembly% assembly
@BTSDeploy REMOVE SERVER=%DeploymentServer% DATABASE=BizTalkMgmtDb ASSEMBLY="%AssemblyPath%\%Assembly%.dll" Uninstall=True Log=Undeploy



@ECHO.
@SET Assembly=CLC.Biztalk.EDI.Schemas
@ECHO undeploying the %Assembly% assembly
@BTSDeploy REMOVE SERVER=%DeploymentServer% DATABASE=BizTalkMgmtDb ASSEMBLY="%AssemblyPath%\%Assembly%.dll" Uninstall=True Log=Undeploy

RemoveSendPort.vbs LO.CertRequest_SP
RemoveSendPort.vbs LO.ChangeResponse_SP
RemoveSendPort.vbs LO.BatchRetryFolder_SP

RemoveSendPort.vbs CLC.Biztalk.EDI.Orchestrations_2.0.1.0_CLC.Biztalk.EDI.RequestCertification_Port_BatchFolder_ae127c55d264ef9e
RemoveSendPort.vbs CLC.Biztalk.EDI.Orchestrations_2.0.1.0_CLC.Biztalk.EDI.SendChangeResponse_Port_ChangeResponse_SND_ae127c55d264ef9e
RemoveSendPort.vbs CLC.Biztalk.EDI.Orchestrations_2.0.1.0_CLC.Biztalk.EDI.SendGuaranteeRequest_Port_GuaranteeRequest_Send_ae127c55d264ef9e
RemoveSendPort.vbs LO.LO.GuaranteeRequest_SP



@ECHO.
@SET Assembly=CLC.Biztalk.EDI.Pipelines
@ECHO undeploying the %Assembly% assembly
@BTSDeploy REMOVE SERVER=%DeploymentServer% DATABASE=BizTalkMgmtDb ASSEMBLY="%AssemblyPath%\%Assembly%.dll" Uninstall=True Log=Undeploy
