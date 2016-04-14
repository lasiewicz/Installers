 

TRIGADM /Request:AddRule /Name:LaunchApplicationRoutingListener /Desc:Process ApplicationRoutingEvent /Action:EXE;c:\program files\clc\application routing listener\clc.applications.applicationroutinglistener.exe;$MSG_ID $MSG_QUEUE_FORMATNAME /ShowWindow:false

TRIGADM /Request:AddTrigger /Name:ApplicationPNoteChange /Queue:applicationpnotechangequeue /Enabled:true /Serialized:false /MsgProcess:peek

TRIGADM /Request:AddTrigger /Name:ApplicationRouting /Queue:applicationroutingqueue /Enabled:true /Serialized:true /MsgProcess:peek


TRIGADM /Request:AddRule /Name:LaunchApplicationRoutingListener /Desc:Process ApplicationChangeEvent /Action:EXE;c:\program files\clc\application routing listener\clc.applications.applicationroutinglistener.exe;$MSG_ID $MSG_QUEUE_FORMATNAME /ShowWindow:false

TRIGADM /Request:AddTrigger /Name:ApplicationChange /Queue:applicationchangequeue /Enabled:true /Serialized:false /MsgProcess:peek

TRIGADM /Request:GetRulesList





TRIGADM /Request:GetTriggersList

TRIGADM /Request:GetRulesList


