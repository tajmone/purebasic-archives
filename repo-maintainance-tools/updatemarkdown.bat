@ECHO OFF

::   ******************************************************************************
::   *                                                                            *
::   *                        MARKDOWN CLEAN UP + AUTO-TOC                        *
::   *                                                                            *
::   ******************************************************************************
::   |                             by Tristano Ajmone                             |
::   |                               -------------                                |
::   | Released into the public domain according to the Unlicense license terms:  |
::   |                           http://unlicense.org                             |
::   ==============================================================================
::   | This batch file processes target markdown files and either:                |
::   |  -- cleans up the markdown source and re-generates its TOC (default)       |
::   |  -- appends to the file gfmtoc's TOC-tags (via "-t" option)                |
::   | Invoke from CMD with target filenames as argument, or drag-and-drop target |
::   | files over its icon. Invoke with "-a" option to process all *md files in   |
::   | current folder (or with "-ar" to recursively process also its subfolders). |
::   | Requires Pandoc and gfmtoc to be installed on OS.                          |
::   |  -- Pandoc:                                                                |
::   |     http://pandoc.org                                                      |
::   |  -- gfmtoc (requires Node.JS):                                             |
::   |     https://github.com/hail2u/node-gfmtoc                                  |
ECHO:
ECHO ==============================================================================
ECHO                    MARKDOWN CLEANER AND AUTO-TOC GENERATOR
ECHO:
ECHO ----------------------------{ v1.3 - 2016/11/24 }-----------------------------
ECHO:
ECHO                               by Tristano Ajmone
ECHO ==============================================================================
SET _RECURSIVE=
SET _TAG=
SET _EXITCODE=0
:: if no paramter found...
IF "%~1"=="" GOTO:PRINT_HELP
IF "%~1"=="-t" (
    SET _TAG=1
    SHIFT
)
IF "%~1"=="-a" GOTO:ALLFILES
IF "%~1"=="-ar" GOTO:CONFIRM_RECURSIVE
:: ==============================================================================
::                               PROCESS FILES LIST
:: ==============================================================================
:NEXT_PARAM
IF NOT "%~1" == "" (
    IF NOT EXIST "%~1" (
        ECHO ERROR -- File not found: "%~1"
        SET _EXITCODE=1
        ) ELSE (
        IF "%_TAG%"=="" (
            CALL :CLEAN_FILE "%~1"
        ) ELSE (
            CALL :TAG_FILE "%~1"
        )
    )
    SHIFT
    GOTO :NEXT_PARAM
)
GOTO:PRE_LEAVE

:CONFIRM_RECURSIVE
ECHO !!! WARNING !!! You've chosen RECURSIVE MODE. This option is very aggressive:
ECHO It will process all *.md files within this folder AND ALL ITS SUBFOLDERS!
ECHO (Choose NO to revert to non-recursive folder precessing)
ECHO                                 -------------
CHOICE /C NY /D N /T 5 /N /M "Are you sure (Y/N)"

IF ERRORLEVEL 2 SET _RECURSIVE=/R
ECHO ==============================================================================
:: ==============================================================================
::                          PROCESS ALL FILES IN FOLDER
:: ==============================================================================
:ALLFILES
IF "%_RECURSIVE%"=="/R" (
    ECHO Recursively processing all *.md files in this folder and its subfolders...
    ) ELSE (
    ECHO Processing all *.md files within this folder...
)
ECHO ==============================================================================
FOR %_RECURSIVE% %%G IN (*.md) DO (
    ECHO Processing %%G
    IF "%_TAG%"=="" (
        CALL :CLEAN_FILE "%%G"
    ) ELSE (
        CALL :TAG_FILE "%%G"
    )
)

:: ==============================================================================
::                              COMMON PRE-EXIT CODE
:: ==============================================================================
:PRE_LEAVE
IF %_EXITCODE%==1 (
    ECHO !!! SOME ERRORS OCCURED !!! Check usage instructions...
    GOTO:PRINT_HELP
)
ECHO No errors reported...
GOTO:WRAPUP_AND_EXIT
:: ******************************************************************************
:: *                                                                            *
:: *                              BATCH FUNCTIONS                               *
:: *                                                                            *
:: ******************************************************************************
:TAG_FILE
ECHO Adding TOC tags to "%~1" file
ECHO:>>"%~1"
ECHO:>>"%~1"
ECHO ^<!-- #toc --^>>>"%~1"
ECHO ^<!-- /toc --^>>>"%~1"
ECHO:>>"%~1"
ECHO:>>"%~1"
ECHO ------------------------------------------------------------------------------
EXIT /B
:CLEAN_FILE
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
    SET _EXITCODE=1
    ECHO:
    ECHO    ERROR -- Something went wrong during gfmtoc invocation! 1>&2
    )
ECHO    DONE!
:: ==============================================================================
::                                Invoke "Pandoc"
:: ==============================================================================
::
ECHO:
ECHO 2) Invoking Pandoc on "%~1" for markdown source cleanup
pandoc --smart --wrap=none --normalize -f markdown -t markdown -o "%~1" "%~1"
IF ERRORLEVEL 1 (
    SET _EXITCODE=1
    ECHO:
    ECHO    ERROR -- Something went wrong during Pandoc invocation! 1>&2
    )
ECHO    DONE!
ECHO ------------------------------------------------------------------------------
EXIT /B

:PRINT_HELP
ECHO ==============================================================================
ECHO                          USAGE AND SETUP INSTRUCTIONS
ECHO ==============================================================================
ECHO This batch file auto-cleans up the markdown source and re-generates its TOC.
ECHO It requires Pandoc and gfmtoc to be installed on the OS:
ECHO  -- Pandoc: http://pandoc.org
ECHO  -- gfmtoc: https://github.com/hail2u/node-gfmtoc
ECHO ------------------------------------------------------------------------------
ECHO Usage (1), target specific files:
ECHO:
ECHO    updatemarkdown ^<filename1^> [ ^<filename2^> ... ^<filenameN^> ]
ECHO:
ECHO where each ^<filenameN^> is the full path name of a target markdown document,
ECHO file extension included.
ECHO ------------------------------------------------------------------------------
ECHO Usage (2), target all files within folder:
ECHO:
ECHO    updatemarkdown -a
ECHO:
ECHO The "-a" (all) option will process all *.md files in the current folder.
ECHO ------------------------------------------------------------------------------
ECHO Usage (3), recursively process folder:
ECHO:
ECHO    updatemarkdown -ar
ECHO:
ECHO The "-ar" (all + recursive) option will process all *.md files within the
ECHO current folder and all its subfolders. Since this is an aggressive option, the
ECHO user will be asked for confirmation. Chosing "NO" (or timing out on the choice)
ECHO will cause the script to fallback on non-recursive processing (ie: "-a").
ECHO The "-ar" option is not employable in automed script invocation.
ECHO ------------------------------------------------------------------------------
ECHO Usage (4), add TOC tags to files:
ECHO:
ECHO    updatemarkdown -t ^<filename1^> [ ^<filename2^> ... ^<filenameN^> ]
ECHO    updatemarkdown -t -a
ECHO    updatemarkdown -t -ar
ECHO:
ECHO The "-t" (tag) option must always precede other options/parameters.
ECHO With this option enabled, instead of performing cleanup/update of the markdown
ECHO target files, it will append to them the tags required by gfmtoc to build the
ECHO Table of Contents in the markdown file:
ECHO:
ECHO    ^<!-- #toc --^>
ECHO    ^<!-- /toc --^>
ECHO:
ECHO It is a useful shortcut for adding the TOC tags to one or more files within a
ECHO folder (and its subfolders, through "-ar" option). A true time-saver!
ECHO ------------------------------------------------------------------------------
:: ==============================================================================
::                            WRAP-UP AND EXIT SCRIPT
:: ==============================================================================
:WRAPUP_AND_EXIT
SET _RECURSIVE=
SET _TAG=
EXIT /B %_EXITCODE%

:: ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
::                                  Rev.History
:: ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
:: v1.3 - 2016/11/24
::      - Added multiple taaget files support.
::      - Added "-a" and "-ar" options (process all *md files + recursively)
::      - Added the "-t" (tag) option for addin gfmtoc TOC-tags to documents.