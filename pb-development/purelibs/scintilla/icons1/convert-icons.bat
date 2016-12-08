@ECHO OFF
ECHO:
ECHO ******************************************************************************
ECHO *                                                                            *
ECHO *                       CONVERT XPM ICONS TO PNG ^& BMP                       *
ECHO *                                                                            *
ECHO ******************************************************************************
ECHO ------------------------------------------------------------------------------
ECHO ----------------  { v1.0 - 2016/12/07 ^| by Tristano Ajmone } -----------------
ECHO ------------------------------------------------------------------------------
::   | Released into the public domain according to the Unlicense license terms:  |
::   |                           http://unlicense.org                             |
ECHO ==============================================================================
ECHO This script invokes ImageMagick on every *.xpm file in this folder and all its
ECHO subfolders, and converts every icon from X PixMap (XPM) format to PNG and BMP.
ECHO ------------------------------------------------------------------------------
ECHO Requires ImageMagick to be installed on the system:
ECHO:
ECHO  -- https://www.imagemagick.org
ECHO ------------------------------------------------------------------------------

::EXIT /B


FOR /R "..\" %%i  IN (*.xpm) DO (
    ECHO == NOW PROCESSING: ===========================================================
    ECHO    %%i
    magick convert %%i %%~pni.png > nul 2>&1
    CALL :_ERROR_CHECK PNG
    magick convert %%i %%~pni.bmp > nul 2>&1
    CALL :_ERROR_CHECK BMP
)
ECHO ------------------------------------------------------------------------------
ECHO JOB COMPLETED!
EXIT /B
:: ******************************************************************************
:: *                                                                            *
:: *                              BATCH FUNCTIONS                               *
:: *                                                                            *
:: ******************************************************************************
:_ERROR_CHECK
    IF ERRORLEVEL 1 (
        ECHO    -- %1 CONVERSION ERROR -- invocation failed! 1>&2
    ) ELSE (
        ECHO    -- %1 CONVERTED!
    )
EXIT /B
