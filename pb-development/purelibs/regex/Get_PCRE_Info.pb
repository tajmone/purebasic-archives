; ******************************************************************************
; *                                                                            *
; *                             "Get_PCRE_Info.pb"                             *
; *                                                                            *
; ******************************************************************************
;                        GET INFO ABOUT PB’S PCRE VERSION                       
;                      and print it in a GFM Markdown table                     
;{==============================================================================
;                       — by Tristano Ajmone (@tajmone) —                       
; ==============================================================================
; PureBASIC 5.50 | "Get_PCRE_Info.pb" v1.0 (2016/12/09)
; https://github.com/tajmone/purebasic-archives
; ==============================================================================
; Copyright (c) Tristano Ajmone, 2016:
; -- https://github.com/tajmone
; Released under the terms of CC-BY 4.0 license:
; -- Creative Commons Attribution 4.0 International license
; -- https://creativecommons.org/licenses/by/4.0/
; ------------------------------------------------------------------------------
; This program will query PureBASIC’s built-in PCRE library (“RegularExpression”
; PureLibrary) and obtain information about its version and compilation options.
; The gathered data will be printed on the Debugger window, then the program
; will create a GitHub flavoured (GFM) markdown table with all the info and
; store into the clipboard, so the user can paste it inside a markdown document.
; ------------------------------------------------------------------------------
; This program was created to help maintain updated the documentation hosted at
; «The PureBASIC Archives»:
; --- https://github.com/tajmone/purebasic-archives
;}------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
;                                   TODOs LIST                                  
;{------------------------------------------------------------------------------
; -- Verify if PCRE’s C unsigned long integer type (for `*where`) is being handled
;    correctly by `hereU.u`. I’ve done some research but the issue is still a bit
;    unclear to me -- PB doesn’t have native unsigned long ints, and there are
;    various workarounds to be found in PB forums, but they might not work with
;    all OSs and architectures. The current use of this type, here, is only with
;    PCRE_CONFIG_MATCH_LIMIT and PCRE_CONFIG_MATCH_LIMIT_RECURSION; so far, the
;    returned values seem OK (maybe because they are small enough).
;    Looks like a C unsigned long integer type should be 4 bytes long.
;}------------------------------------------------------------------------------

Declare   AddRow(Column1.s, Column2.s, Column3.s)
Declare   QueryPCRE_Config (featCode.i)
Declare   PCRE_ConfigError(Feature.s, ErrorNum.i)
Declare   PCRE_ConfigReport(Feature.s, FeatureValue.s)
Declare.s ColumnAdjust(columNum.i, contents.s)

Structure TableRows
  Column1.s
  Column2.s
  Column3.s
EndStructure

Global NewList Table.TableRows()   ; Yes, GLOBALS!!! (Whatcha gonna do, sue me?)
Global MaxLenColumn1, MaxLenColumn2, MaxLenColumn3

; ******************************************************************************
; *                                                                            *
; *                       PCRE INTERFACING AND CONSTANTS                       *
; *                                                                            *
;{******************************************************************************
; Declare/import external functions from PureBASIC’s built-in “RegularExpression” 
; PureLibrary (PCRE). For more info, see PCRE documentation:
;  -- pcre_version.html
;  -- pcre_config.html
;  -- pcre_pcreapi.html#SEC10
; ==============================================================================
;                         IMPORT PCRE EXTERNAL FUNCTIONS                        
;{==============================================================================
ImportC ""
  pb_pcre_version(void)       ; const char *pcre_version(void);
  pb_pcre_config.l(int, void) ; int pcre_config(int what, void *where);
EndImport
;}==============================================================================
;                         BUILD-TIME PCRE FEATURES CODES                        
;{==============================================================================
; These constants are passed as first agrument (int what) to `pb_pcre_config()`
; external C function in order to query if the optional feature they represent is
; available in the built-in version of the PCRE library used by PureBASIC’s
; “RegularExpression” PureLibary. 
; ------------------------------------------------------------------------------
; taken from pcre-8.30 > "pcre.h.generic" (238-)
Enumeration
  #PCRE_CONFIG_UTF8                   ;  0 | *where = integer
  #PCRE_CONFIG_NEWLINE                ;  1 | *where = integer
  #PCRE_CONFIG_LINK_SIZE              ;  2 | *where = integer
  #PCRE_CONFIG_POSIX_MALLOC_THRESHOLD ;  3 | *where = integer
  #PCRE_CONFIG_MATCH_LIMIT            ;  4 | *where = unsigned long integer
  #PCRE_CONFIG_STACKRECURSE           ;  5 | *where = integer
  #PCRE_CONFIG_UNICODE_PROPERTIES     ;  6 | *where = integer
  #PCRE_CONFIG_MATCH_LIMIT_RECURSION  ;  7 | *where = unsigned long integer
  #PCRE_CONFIG_BSR                    ;  8 | *where = integer
  #PCRE_CONFIG_JIT                    ;  9 | *where = integer
  #PCRE_CONFIG_UTF16                  ; 10 | *where = integer <= works only with `pcre16_config();`
  #PCRE_CONFIG_JITTARGET              ; 11 | *where = integer
EndEnumeration
#PCRE_Total_Features = #PB_Compiler_EnumerationValue 
; ------------------------------------------------------------------------------
; NOTE: #PCRE_CONFIG_UTF16 can only be queried with `pcre16_config();` and will
;       return error #PCRE_ERROR_BADOPTION if passed to `pb_pcre_config()`.
;       There is no `pb_pcre16_config()` function in “RegularExpression” PureLib.
;       (see "pcre16.html" for more info)
;}==============================================================================
;                         FEATURES RETURNED VALUE-TYPES                         
;{==============================================================================
; These constants are used to handle the different type of values to expect in
; `*where` after querying `pb_pcre_config()` for a given PCRE feature.
; ------------------------------------------------------------------------------
Enumeration
  #PCRE_Feat_Bool         ; *where -> boolean value
  #PCRE_Feat_Int          ; *where -> integer value
  #PCRE_Feat_ULInt        ; *where -> unsigned long integer
  #PCRE_Feat_StrPointer   ; *where -> pointer to a zero-terminated "const char *" string
  #PCRE_Feat_NEWLINE      ; *where -> PCRE_NEWLINE
  #PCRE_Feat_STACKRECURSE ; *where -> PCRE_STACKRECURSE
  #PCRE_Feat_CONFIG_BSR   ; *where -> PCRE_CONFIG_BSR
EndEnumeration
Enumeration
  #Int    ; *where = integer
  #ULInt  ; *where = unsigned long integer
EndEnumeration
;}==============================================================================
;                        PCRE_CONFIG RETURNED ERROR CODES                       
;{==============================================================================
; Possible error codes returned by `pb_pcre_version()` calls.
; ------------------------------------------------------------------------------

#PCRE_ERROR_BADOPTION = -3 ; value in first argument (what) is not recognized.

;}==============================================================================
;                             PCRE NEWLINE CONSTANTS                            
;{==============================================================================
; These constants represent the possible return valuse for PCRE_CONFIG_NEWLINE.
; They specify the value of the default newline character sequence that PCRE
; recognizes as meaning “newline”.
; ------------------------------------------------------------------------------
#PCRE_NEWLINE_CR      =   13
#PCRE_NEWLINE_LF      =   10
#PCRE_NEWLINE_CRLF    = 3338
#PCRE_NEWLINE_ANYCRLF =   -2
#PCRE_NEWLINE_ANY     =   -1
;}
;}******************************************************************************
; *                                                                            *
; *                                 INITIALIZE                                 *
; *                                                                            *
;{******************************************************************************

PB_Ver$ = InsertString(Str(#PB_Compiler_Version), ".", 2) ; Add dot separator

CreateRegularExpression(0, "") ; <= Dummy RegEx to force inclusion of PCRE lib
                               ;    (ie: “RegularExpression” PureLib)

AddRow("Feature Name", "Value", "Description") ; Create Table Header

;}******************************************************************************
; *                                                                            *
; *                            QUERY PCRE FOR INFO                             *
; *                                                                            *
;{******************************************************************************

; ==============================================================================
;                                GET PCRE VERSION                               
;{==============================================================================
*PCRE_Version = pb_pcre_version(0) ; returns a pointer to a zero-terminated, 8-bit
                                   ; character string containing PCRE’s version
                                   ; and its date of release.
PCRE_Version.s = PeekS(*PCRE_Version, -1, #PB_Ascii)
PCRE_Version = StringField(PCRE_Version, 1, " ") ; Get rid of Date field!
Debug "PCRE Version: " + PCRE_Version
AddRow("PCRE Version", PCRE_Version, "PCRE lib used by PureBASIC " + PB_Ver$ +".")

;}==============================================================================
;                             QUERY PB_PCRE_CONFIG()                            
;{==============================================================================
For i = 1 To #PCRE_Total_Features
  Read Query
  QueryPCRE_Config(Query)
Next

;}------------------------------------------------------------------------------
;                          PB_PCRE_CONFIG QUERIES ORDER                         
;{------------------------------------------------------------------------------
DataSection ; Order in which PCRE Features are Queried
  Data.i #PCRE_CONFIG_UTF8
  Data.i #PCRE_CONFIG_UTF16 ; Will be skipped -- works only with `pcre16_config();`
  Data.i #PCRE_CONFIG_UNICODE_PROPERTIES
  Data.i #PCRE_CONFIG_NEWLINE
  Data.i #PCRE_CONFIG_BSR
  Data.i #PCRE_CONFIG_STACKRECURSE
  Data.i #PCRE_CONFIG_LINK_SIZE
  Data.i #PCRE_CONFIG_POSIX_MALLOC_THRESHOLD
  Data.i #PCRE_CONFIG_MATCH_LIMIT
  Data.i #PCRE_CONFIG_MATCH_LIMIT_RECURSION
  Data.i #PCRE_CONFIG_JIT
  Data.i #PCRE_CONFIG_JITTARGET
EndDataSection
;}

;}******************************************************************************
; *                                                                            *
; *                           CREATE MARKDOWN TABLE                            *
; *                                                                            *
;{******************************************************************************
i = 0
ForEach Table()
  COL1$ = ColumnAdjust(1, Table()\Column1)
  COL2$ = ColumnAdjust(2, Table()\Column2)
  COL3$ = ColumnAdjust(3, Table()\Column3)
  MDTable$ + COL1$ + COL2$ + COL3$ +"|"+ #CRLF$
  i + 1
  If i = 1         ; Create Table-Headers separator line
    MDTable$ +"|"+ RSet("|", MaxLenColumn1 + 3, "-")
    MDTable$ +     RSet("|", MaxLenColumn2 + 3, "-")
    MDTable$ +     RSet("|", MaxLenColumn3 + 3, "-") + #CRLF$
  EndIf
Next
;}

Debug #CRLF$ +"Markdown Table:" + #CRLF$
Debug MDTable$              ; Print Markdown Table preview to Debugger output window
SetClipboardText(MDTable$)  ; Copy Markdown Table to Clipboard
MessageRequester("PCRE Info", ~"The Markdown Table containing PureBASIC’s\nPCRE info has been copied to the clipboard!")
End                         ; Exit Program!

; ******************************************************************************
; *                                                                            *
; *                              PROCEDURES CODE                               *
; *                                                                            *
;{******************************************************************************
; ==============================================================================
;                                QueryPCRE_Config                               
;{==============================================================================
; Invoke `pb_pcre_version()` for the feature code passed as parameter.
; This procedure handles creation of all needed text and adds results to Table.
; `Name`, `Value` and `Description` have to be kept short, otherwise Pandoc will
; force convertion of Table to html during markdown cleanup operations!
; ------------------------------------------------------------------------------
Procedure QueryPCRE_Config (featCode.i)
  Feature.s         ; holds the constant name of the feature being queried for
  FeatureValue.s    ; holds the returned value for the feature being queried
  FeatureDesc.s     ; holds the desciption of the feature being queried
  
  FeatureType = #PCRE_Feat_Bool ; Defaults to most commonly occuring type
  
  ; TODO: Verify if unsigned long integer is being correctly handled by hereU.u
  
  whereType = #Int  ; Defaults to most common used type (integer)
  whereI.i          ; for *where = integer (#Int)
  whereU.u          ; for *where = unsigned long integer (#ULInt)
  
  ; ------------------------------------------------------------------------------
  ;                      CHECK WHICH FEATURE IS BEING QUERIED                     
  ; ------------------------------------------------------------------------------
  Select featCode
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_UTF8
      ; ------------------------------------------------------------------------------
      Feature = "`PCRE_CONFIG_UTF8`"
      FeatureDesc = "UTF-8 support."
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_NEWLINE
      ; ------------------------------------------------------------------------------
      Feature = "`PCRE_CONFIG_NEWLINE`"
      FeatureDesc = ~"Default \"newline\" sequence."
      FeatureType = #PCRE_Feat_NEWLINE
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_LINK_SIZE
      ; ------------------------------------------------------------------------------
      Feature = "`PCRE_CONFIG_LINK_SIZE`"
      FeatureDesc = "RegExs internal link size."
      FeatureType = #PCRE_Feat_Int
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_POSIX_MALLOC_THRESHOLD
      ; ------------------------------------------------------------------------------
      Feature = "`PCRE_CONFIG_POSIX_MALLOC_THRESHOLD`"
      FeatureDesc = "POSIX API threshold for `malloc()`."
      FeatureType = #PCRE_Feat_Int
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_MATCH_LIMIT
      ; ------------------------------------------------------------------------------
      Feature = "`PCRE_CONFIG_MATCH_LIMIT`"
      FeatureDesc = "Default internal resource limit."
      whereType = #ULInt 
      FeatureType = #PCRE_Feat_ULInt
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_STACKRECURSE
      ; ------------------------------------------------------------------------------
      Feature = "`PCRE_CONFIG_STACKRECURSE`"
      FeatureType = #PCRE_Feat_STACKRECURSE
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_UNICODE_PROPERTIES
      ; ------------------------------------------------------------------------------
      Feature = "`PCRE_CONFIG_UNICODE_PROPERTIES`"
      FeatureDesc = "Unicode property support."
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_MATCH_LIMIT_RECURSION
      ; ------------------------------------------------------------------------------
      Feature = "`PCRE_CONFIG_MATCH_LIMIT_RECURSION`"
      FeatureDesc = "Internal recursion depth limit."
      whereType = #ULInt
      FeatureType = #PCRE_Feat_ULInt
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_BSR
      ; ------------------------------------------------------------------------------
      Feature = "`PCRE_CONFIG_BSR`"
      FeatureDesc = "Default EOLs matched by `\R`."
      FeatureType = #PCRE_Feat_CONFIG_BSR
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_JIT
      ; ------------------------------------------------------------------------------
      Feature = "`PCRE_CONFIG_JIT`"
      FeatureDesc = "Availability of JIT compiler support."
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_UTF16
      Feature = "`PCRE_CONFIG_UTF16`"
      Debug(">> SKIPPING '"+ Feature +"' (only available in `pcre16_config();`)")
      ProcedureReturn
      ; ------------------------------------------------------------------------------
    Case #PCRE_CONFIG_JITTARGET
      Feature = "`PCRE_CONFIG_JITTARGET`"
      FeatureDesc = "Target architecture for JIT compiler."
      FeatureType = #PCRE_Feat_StrPointer
  EndSelect
  
  ; ------------------------------------------------------------------------------
  ;                            Invoke pb_pcre_config()                            
  ; ------------------------------------------------------------------------------
  ; Check if curr. feature's `*where` is of type integer or unsigned long integer
  Select whereType
    Case #Int
      ; ============================== *were = integer ===============================
      ErrCode = pb_pcre_config(featCode, @whereI)
      where$ = Str(whereI)
    Case #ULInt
      ; ======================= *were = unsigned long integer ========================
      ErrCode = pb_pcre_config(featCode, @whereU)
      where$ = StrU(whereU, #PB_Unicode)
  EndSelect   
  If Not ErrCode
    Select FeatureType
        ; ------------------------------------------------------------------------------
      Case #PCRE_Feat_Bool
        ; ------------------------------------------------------------------------------
        If whereI
          FeatureValue = "True"
        Else
          FeatureValue = "False"
        EndIf
        ; ------------------------------------------------------------------------------
      Case #PCRE_Feat_NEWLINE
        ; ------------------------------------------------------------------------------
        Select whereI
          Case #PCRE_NEWLINE_CR
            FeatureValue = "`CR`"
          Case #PCRE_NEWLINE_LF
            FeatureValue = "`LF`"
          Case #PCRE_NEWLINE_CRLF
            FeatureValue = "`CRLF`"
          Case #PCRE_NEWLINE_ANYCRLF
            FeatureValue = "`ANYCRLF`"
          Case #PCRE_NEWLINE_ANY
            FeatureValue = "`ANY`"
        EndSelect
        ; ------------------------------------------------------------------------------
      Case #PCRE_Feat_Int
        ; ------------------------------------------------------------------------------
        FeatureValue = Str(whereI)
        Select featCode
          Case #PCRE_CONFIG_LINK_SIZE
            FeatureValue + " bytes"
        EndSelect
        ; ------------------------------------------------------------------------------
      Case #PCRE_Feat_ULInt
        ; ------------------------------------------------------------------------------
        FeatureValue = StrU(whereU, #PB_Unicode)
        ; ------------------------------------------------------------------------------
      Case #PCRE_Feat_STACKRECURSE
        ; ------------------------------------------------------------------------------
        If  whereI = 1 ; Recursion implementation = stack
          FeatureDesc = "Stack-based recursion (rec. functions)."
          FeatureValue = "stack"
        Else           ; Recursion implementation = heap
          FeatureDesc = "Heap-based recursion (data-blocks)."
          FeatureValue = "heap"
        EndIf
        were$ = FeatureValue
        ; ------------------------------------------------------------------------------
      Case #PCRE_Feat_CONFIG_BSR
        ; ------------------------------------------------------------------------------
        If  whereI = 0
          FeatureValue = "All Unicode EOLs"
        Else
          FeatureValue = "`CR`, `LF`, or `CRLF` only"
        EndIf
        were$ = FeatureValue
        ; ------------------------------------------------------------------------------
      Case #PCRE_Feat_StrPointer
        ; ------------------------------------------------------------------------------
        If whereI ; !!! UNTESTED: hopefully should work, just didn't find a way to test it
          FeatureValue = PeekS(whereI, -1, #PB_Ascii) 
          ; returns a pointer to a zero-terminated, 8-bit character string
          ; containing name of the architecture for which the JIT compiler
          ; is configured -- eg:  "x86 32bit (little endian + unaligned)"
        Else
          FeatureValue = "NULL" ; No string value returned
        EndIf
        were$ = FeatureValue
    EndSelect
    
    AddRow(Feature, FeatureValue, FeatureDesc)
    PCRE_ConfigReport(Feature, where$)
  Else
    ; ------------------------------------------------------------------------------
    ;                       pb_pcre_config() returned an error                      
    ; ------------------------------------------------------------------------------
    PCRE_ConfigError(Feature, ErrCode)
  EndIf
EndProcedure

;}==============================================================================
;                                PCRE_ConfigError                               
;{==============================================================================
; Report via Debugger a `pb_pcre_config()` returned error.
; ------------------------------------------------------------------------------
Procedure PCRE_ConfigError(Feature.s, ErrorNum.i)
  If ErrorNum = #PCRE_ERROR_BADOPTION
    Error$ = "PCRE_ERROR_BADOPTION"
  Else
    Error$ = "Error "+ Str(ErrorNum)
  EndIf
  Debug("ERROR: pb_pcre_config(#"+ Feature +") failed: " + Error$)  
EndProcedure

;}==============================================================================
;                               PCRE_ConfigReport                               
;{==============================================================================
; Report via Debugger `pb_pcre_config()` returned value.
; ------------------------------------------------------------------------------
Procedure PCRE_ConfigReport(Feature.s, FeatureValue.s)
  Debug(Feature +": "+ FeatureValue)
EndProcedure

;}==============================================================================
;                                     AddRow                                    
;{==============================================================================
; Add a row to the unformatted Table (3 columns: `Name`, `Value`, `Description`)
; ------------------------------------------------------------------------------
Procedure AddRow(Column1.s, Column2.s, Column3.s)
  AddElement(Table())
  Table()\Column1 = Column1
  Table()\Column2 = Column2
  Table()\Column3 = Column3
  ; ======================== Check if Column1 is Longest =========================
  If Len(Column1) > MaxLenColumn1
    MaxLenColumn1 = Len(Column1)
  EndIf
  ; ======================== Check if Column2 is Longest =========================
  If Len(Column2) > MaxLenColumn2
    MaxLenColumn2 = Len(Column2)
  EndIf
  ; ======================== Check if Column3 is Longest =========================
  If Len(Column3) > MaxLenColumn3
    MaxLenColumn3 = Len(Column3)
  EndIf
EndProcedure

;}==============================================================================
;                                  ColumnAdjust                                 
;{==============================================================================
; Add space-padding to columns of Markdown Table, so that output is balanced.
; ------------------------------------------------------------------------------
Procedure.s ColumnAdjust(columNum.i, contents.s)
  Select columNum
    Case 1
      PADDING = MaxLenColumn1 - Len(contents) + 1
    Case 2
      PADDING = MaxLenColumn2 - Len(contents) + 1
    Case 3
      PADDING = MaxLenColumn3 - Len(contents) + 1
  EndSelect
  STR$ = "| " + contents + Space(PADDING)
  ProcedureReturn STR$
EndProcedure
;}
;}
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;                                  FILE HISTORY                                 
;{//////////////////////////////////////////////////////////////////////////////
;
; 2016-12-09 -- First release: v1.0.
;}