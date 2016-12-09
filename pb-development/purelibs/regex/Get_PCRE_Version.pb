; ******************************************************************************
; *                                                                            *
; *                         GET PB'S PCRE LIB VERSION                          *
; *                                                                            *
; ******************************************************************************
; PureBASIC 5.50
; Code provided by Fred (Oct 05, 2016): 
; http://www.purebasic.fr/english/viewtopic.php?f=13&t=66707

ImportC ""
  pb_pcre_version(void);
EndImport

regex = CreateRegularExpression(#PB_Any, "")
pcre_version = pb_pcre_version(0)
Debug PeekS(pcre_version, -1, #PB_Ascii)