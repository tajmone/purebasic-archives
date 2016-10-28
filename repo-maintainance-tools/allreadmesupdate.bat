@ECHO OFF

REM ******************************************************************************
REM *                                                                            *
REM *                          UPDATE ALL README FILES                           *
REM *                                                                            *
REM ******************************************************************************
REM 
REM ----------------------------{ v1.0 - 2016/10/28 }-----------------------------
REM 
REM                               by Tristano Ajmone                              
REM ==============================================================================
REM This script invokes "updatemarkdown.bat" on every README.md file within the
REM repository: TOC is auto-generated and markdown source formatting is cleaned up 
REM (including smart punctiation). 
REM ------------------------------------------------------------------------------
REM DON'T MOVE THIS FILE!! -- It's set to scan for READMEs starting from its parent
REM folder, so it should alway be located in a repo's subfolder (not in its root).
REM REQUIRES "updatemarkdown.bat" to be in same folder.

ECHO.
ECHO ==============================================================================
ECHO                 README FILES CLEANER AND AUTO-TOC GENERATOR                   
ECHO ==============================================================================
ECHO This script will invoke "updatemarkdown.bat" on every README.md file in this
ECHO repository: their TOC will be auto-generated, their markdown source formatting
ECHO cleaned up.
ECHO ------------------------------------------------------------------------------

FOR /R "..\" %%i  IN (READM?.md) DO (
	ECHO -- NOW PROCESSING:
	ECHO    %%i
	CALL updatemarkdown.bat "%%i" >nul 2>&1
	IF ERRORLEVEL 1 (
		ECHO    ERROR -- invocation failed! 1>&2
	) ELSE (
		ECHO    DONE!
	)
)
