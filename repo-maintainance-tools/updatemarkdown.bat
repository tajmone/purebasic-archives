@ECHO OFF

:: ******************************************************************************
:: *                                                                            *
:: *                        MARKDOWN CLEAN UP + AUTO-TOC                        *
:: *                                                                            *
:: ******************************************************************************
::                               by Tristano Ajmone                              
:: ==============================================================================
:: | This batch file auto-cleans up the markdown source and re-generates its TOC |
:: | Invoke from CMD with target filename as argument, or drag-and-drop target   |
:: | file over its icon. Requires Pandoc and gfmtoc to be installed on OS.       |
:: | -- Pandoc:
:: |    http://pandoc.org
:: | -- gfmtoc (requires Node.JS):
:: |    https://github.com/hail2u/node-gfmtoc

ECHO:
ECHO ==============================================================================
ECHO                    MARKDOWN CLEANER AND AUTO-TOC GENERATOR                    
ECHO:
ECHO ----------------------------{ v1.2 - 2016/11/23 }-----------------------------
ECHO:
ECHO                               by Tristano Ajmone                              
ECHO ==============================================================================
IF %1=="" (
	ECHO ERROR -- Missing filename parameter! 1>&2
	GOTO:PRINT_HELP
	)
IF NOT EXIST "%~1" (
	ECHO ERROR -- File not found: "%~1"
	GOTO:PRINT_HELP
	)

:: ==============================================================================
::                                Invoke "gfmtoc"                                
:: ==============================================================================
:: | Gfmtoc is a Node.JS app that auto-generates a GitHub Flavour Markdown-Style |
:: | Table of Contents within the target markdown file.                          |
:: | Gfmtoc will look for the following HTML-comment tags for placing the TOC:   |
:: <!-- #toc -->
:: <!-- /toc -->

ECHO 1) Invoking gfmtoc on "%~1" for TOC creation/update
CALL gfmtoc "%~1"
IF ERRORLEVEL 1 (
	ECHO:
	ECHO    ERROR -- Something went wrong during gfmtoc invocation! 1>&2
	GOTO:PRINT_HELP
	)
ECHO    DONE!

ECHO:
ECHO 2) Invoking Pandoc on "%~1" for markdown source cleanup
pandoc --smart --wrap=none --normalize -f markdown -t markdown -o "%~1" "%~1"
IF ERRORLEVEL 1 (
	ECHO:
	ECHO    ERROR -- Something went wrong during Pandoc invocation! 1>&2
	GOTO:PRINT_HELP
	)
ECHO    DONE!

EXIT /B 0

:PRINT_HELP
ECHO ==============================================================================
ECHO                          USAGE AND SETUP INSTRUCTIONS                         
ECHO ==============================================================================
ECHO This batch file auto-cleans up the markdown source and re-generates its TOC.
ECHO Usage:
ECHO:
ECHO    updatemarkdown.bat ^<filename^>
ECHO:
ECHO where ^<filename^> will be any markdown target file, extension included.
ECHO This script requires Pandoc and gfmtoc to be installed on the OS:
ECHO -- Pandoc: http://pandoc.org
ECHO -- gfmtoc: https://github.com/hail2u/node-gfmtoc
EXIT /B 1
