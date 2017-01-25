@ECHO OFF
ECHO ==============================================================================
ECHO                     BUILD TEMPLATE USAGE INSTRUCTION FILES                    
ECHO ==============================================================================
ECHO Invoking pandoc script for conversion to HTML.
SET "_SRC=%~dp0TEMPLATE_USAGE"
:: %%_SRC%% -- The full path of the source markdown doc, ".md" extension excluded.
::             Eg: "/full/path/md-src/source_filename" for a "source_filename.md" doc
::             (NOTE: ".md" extension left out).
SET "_DST=%~dp0..\TEMPLATE_USAGE"
:: %%_DST%% -- The full path of the final html document (extension excluded).
::             Eg: "/full/path/dest_filename" for a "dest_filename.html" doc (".html" left out).
::             Markdown source doc and final html file might be on different paths
::             or in same folder, have same name or a different one, according to use cases.
SET "_PATH2ROOT=../../"
:: %%_PATH2ROOT%% -- The path back to the repo's root from the final HTML doc (not
::                   from this batch file). Used by pandoc for setting relative path to
::                   CSS and JS files, and other shared resources.
CALL ..\%_PATH2ROOT%\shared\pandoc\tutorial_md2html.bat
ECHO ------------------------------------------------------------------------------
ECHO BUILD TEMPLATE USAGE FILES: DONE!