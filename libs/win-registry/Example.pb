;======================================================================
; Author:          Thomas (ts-soft) Schulz
; Date:            Sep 04, 2015
; License:         Free, unrestricted, no warranty whatsoever
;                  Use at your own risk
;======================================================================
; Posted on PureBASIC Forums:
;  -- http://www.purebasic.fr/english/viewtopic.php?p=422572#p422572
; ---------------------------------------------------------------------
; GitHub fork:
;  -- https://github.com/tajmone/purebasic-archives/tree/master/libs/win-registry
;======================================================================

IncludeFile "Registry.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Define count, i
  
  count = Registry::CountSubValues(#HKEY_CURRENT_USER, "Software\Microsoft\Windows NT\CurrentVersion\Devices")
  For i = 0 To count - 1
    Debug Registry::ListSubValue(#HKEY_CURRENT_USER, "Software\Microsoft\Windows NT\CurrentVersion\Devices", i)
  Next
  
  Debug "-----------------------"
  
  UseModule Registry
  
  Define.s Multi_SZ_Str = "ts-soft" + #LF$ + "Software-Development" + #LF$ + #LF$ + "Copyright 2013" + #LF$ + "Programmed in PureBasic"
  
  If  WriteValue(#HKEY_CURRENT_USER, "Software\ts-soft", "demo", Multi_SZ_Str, #REG_MULTI_SZ)
    Debug ReadValue(#HKEY_CURRENT_USER, "Software\ts-soft", "demo")
    Select MessageRequester("Registry-Example", "Delete the demo Registry-Value?", #PB_MessageRequester_YesNo)
      Case #PB_MessageRequester_Yes
        If DeleteValue(#HKEY_CURRENT_USER, "Software\ts-soft", "demo")
          Debug "Value deleted"
        Else
          Debug "Value not deleted"
        EndIf
    EndSelect
  EndIf
CompilerEndIf