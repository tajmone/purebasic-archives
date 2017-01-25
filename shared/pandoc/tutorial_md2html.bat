@ECHO OFF
ECHO.
ECHO ******************************************************************************
ECHO *                                  MD2HTML                                   *
ECHO *                                                                            *
ECHO *           Convert Markdown Tutorial Sources into Templated HTML            *
ECHO ******************************************************************************
ECHO md2html.bat v1.0 (2017-01-18) -- by Tristano Ajmone.
::   Released into the public domain under the terms of the Unlicense license:
::    -- http://unlicense.org
ECHO ------------------------------------------------------------------------------
ECHO SOURCE FILES:
ECHO -- "%_SRC%.md"
::   ==============================================================================
::                         Check if ".before_body.md" exists                       
::   ==============================================================================
::   Check if MD source has a corresponding "<source_filename>.before_body.md" file
::   associated to it. If there is one, convert it to HTML and create a pandoc
::   "--include-before-body=" directive for it via the %_INC_BODY_BEF% env-variable.
::   If there isn't one, leave %_INC_BODY_BEF% an empty string and nothing will be
::   passed to pandoc.
::   ------------------------------------------------------------------------------
SET "_INC_BODY_BEF="
SET "_BODY_BEF=%_SRC%.before_body"
IF EXIST "%_BODY_BEF%.md" (
    :: A "*.before_body.md" was found.
    ECHO -- "%_BODY_BEF%.md"
    :: Convert it to HTML
    CALL :ConvMD2HTML %_BODY_BEF%
    :: Set the "--include-before-body=" pandoc directive
    SET _INC_BODY_BEF=--include-before-body="%_BODY_BEF%.html"
)
::  ==============================================================================
::                             Check if ".yaml" exists                            
::  ==============================================================================
::   Check if MD source has a corresponding "<source_filename>.yaml" file.
::   If there is one, pandoc will include it via the %_YAML% env-var.
::   If not, set %_YAML% to empty string and nothing will be passed to pandoc.
::   ------------------------------------------------------------------------------
SET "_YAML=%_SRC%.yaml"
IF EXIST "%_YAML%" (
    :: A "*.yaml" was found.
    ECHO -- "%_YAML%"
) ELSE (
    :: No "*.yaml" found. Zero-out the include yaml pandoc parameter
    SET "_YAML="
)
ECHO ------------------------------------------------------------------------------
ECHO DESTINATION FILE:
ECHO -- "%_DST%.html"
ECHO ==============================================================================
ECHO                                   DEBUG INFO                                  
ECHO ==============================================================================
ECHO A list of variables (and their values) used by this script.
ECHO ------------------------------------------------------------------------------
ECHO ENV-VARS RECEIVED FROM CALLING SCRIPT:
ECHO -- %%_SRC%% = %_SRC%
ECHO -- %%_DST%% = %_DST%
ECHO -- %%_PATH2ROOT%% = %_PATH2ROOT%
ECHO ------------------------------------------------------------------------------
ECHO PANDOC VARIABLES SET BY THIS SCRIPT (AVAILABLE IN TEMPLATE):
ECHO -- root:%_PATH2ROOT%
ECHO ------------------------------------------------------------------------------
ECHO MISC.ENV-VARS VALUES WITHIN "md2html.bat":
ECHO -- %%CD%% = %CD%
ECHO -- %%0 = %0
ECHO -- %%~dp0 = %~dp0
ECHO ------------------------------------------------------------------------------
SET _EXITCODE=0
pandoc  --smart --normalize ^
        --wrap=none --no-highlight ^
        --toc ^
        --template=%~dp0tutorial.template.html ^
        --variable=root:%_PATH2ROOT% ^
        %_INC_BODY_BEF% ^
        -f markdown_github+markdown_in_html_blocks+yaml_metadata_block ^
        -t html5 ^
        -o %_DST%.html ^
           %_YAML% ^
           %_SRC%.md
IF ERRORLEVEL 1 (
    SET _EXITCODE=1
    ECHO:
    ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{ ERROR! }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ECHO Something went wrong during pandoc invocation! 1>&2
) ELSE (
    ECHO Markdown source convertion to html completed without errors.
    ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{ DONE! }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
)
EXIT /B %_EXITCODE%
::   ******************************************************************************
::   *                                                                            *
::   *                                 FUNCTIONS                                  *
::   *                                                                            *
::   ******************************************************************************
::   ==============================================================================
::                                      MD2HTML                                    
::   ==============================================================================
:ConvMD2HTML
pandoc  --smart --normalize ^
        --wrap=none --no-highlight ^
        -f markdown_github+markdown_in_html_blocks ^
        -t html5 ^
        -o %1.html ^
           %1.md
EXIT /B