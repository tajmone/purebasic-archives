@ECHO OFF
ECHO:
ECHO ******************************************************************************
ECHO *                                                                            *
ECHO *                      PB SOURCE PRE-PROCESSING SCRIPT                       *
ECHO *                                                                            *
ECHO ******************************************************************************
REM  
REM  ----------------------------{ v1.0 - 2016/11/16 }-----------------------------
REM  
ECHO                               by Tristano Ajmone                              
REM  ==============================================================================
REM  This script invokes PureBASIC compiler on the example file, with "/PREPROCESS"
REM  option: it produces as output a single source file containing all the included
REM  external files, and with all its macros expanded. The "--commented" option
REM  ensures that original comments are preserved, and that expanded macros are
REM  kept as comments next to the code they produced.
REM  The preprocced source file should simplify analysis of the original source.
REM  ------------------------------------------------------------------------------
ECHO:

REM --- Check that there are at least 2 parameters
IF [%2]==[] (
	ECHO ERROR -- Missing parameters! 1>&2
	GOTO:PRINT_HELP
	)
REM --- Check that PureBASIC target source file exists
IF NOT EXIST "%1.pb" (
	ECHO ERROR -- File not found: "%1.pb"
	GOTO:PRINT_HELP
)
REM --- Check that target header-include file exists
IF NOT EXIST "%2" (
	ECHO ERROR -- File not found: "%2"
	GOTO:PRINT_HELP
)

REM --- Ensure that our changes to the PATH are discarded after script execution:
SETLOCAL

REM --- Add PureBASIC Compilers path to env PATH
PATH=%PATH%;%ProgramFiles%\PureBasic\Compilers

ECHO 1) Pre-processing "%1.pb"
pbcompiler "%1.pb" /PREPROCESS "pp.tmp"  --commented

IF ERRORLEVEL 1 (
	ECHO:
	ECHO    ERROR -- PureBASIC compiler reported an error! 1>&2
	ECHO:
	ECHO Aborting...
	EXIT /B 1
)

ECHO:
ECHO 2) Injecting "%2" header-file into final output
TYPE %2 >"%1_preprocessed.pb"

type pp.tmp >>"%1_preprocessed.pb"
DEL pp.tmp

ECHO:
ECHO DONE! The preprocessed file was created:
ECHO %1_preprocessed.pb

EXIT /B 0


:PRINT_HELP
ECHO:
ECHO ==============================================================================
ECHO                               USAGE INSTRUCTIONS                              
ECHO ==============================================================================
ECHO This batch file creates a compiler-preprocessed version of a target PureBASIC
ECHO source code file (1st param), and injects into it a target header-include file
ECHO (2nd param) -- containing additional description and comments.
ECHO:
ECHO Usage:
ECHO:
ECHO    pppbsource.bat ^<source filename^> ^<header-include filename^>
ECHO:
ECHO where ^<source filename^> is the PB source filename WITHOUT EXTENSION (ie: leave
ECHO out the ".pb" part of the name); and ^<header-include filename^> is the name
ECHO of the header file to include in the head of pre-processed output file.
ECHO If filenames (or their path) contain spaces, you must enclose them in quotes.
EXIT /B 1
