PureBASIC For Highlight
=======================

This folder is the home of the PureBASIC language definition and theme files for André Simons’ **Highlight**.


> __NOTE1__: The PureBASIC language definition is now bundled in Highlight (v &gt;=3.33). No need to install it manually, just [download/update](http://www.andre-simon.de/zip/download.php) to the latest version of Highlight. 

> __NOTE2__: It seems that the PureBASIC color theme was accidently left out of Highlight 3.33 release. You’ll need to [manually setup the theme file](#manually-installing-the-purebasic-theme) untill it will be included in Highlight.

<!-- #toc -->
-   [About This Project](#about-this-project)
-   [About Highlight](#about-highlight)
    -   [AsciiDoc Integration](#asciidoc-integration)
-   [Manual Installation](#manual-installation)
    -   [Installing PureBASIC Lang Definition](#installing-purebasic-lang-definition)
    -   [Manually Installing The PureBASIC Theme](#manually-installing-the-purebasic-theme)

<!-- /toc -->
About This Project
==================

The PureBASIC language and theme files herein contained were written by Tristano Ajmone ([@tajmone](https://github.com/tajmone)) and released in October 2016 under the public domain according to the [Unlicense terms](./UNLICENSE) ([Unlicense.org](http://unlicense.org)).

About Highlight
===============

-   http://www.andre-simon.de/doku/highlight/en/highlight.php

Highilight is a crossplatform FOSS application for converting source code to formatted text with syntax highlighting. It’s a command line tool with an optional GUI fontend.

Highilight is maintained by André Simon (main developer), and released under the GPL3 license.

Main Features:

-   Coloured output in HTML, RTF, ODT, TeX, LaTeX, SVG, Pango, BBCode and ANSI terminal sequences

-   Supports 200 programming languages

-   Includes 80 colour themes

-   Recognition of nested languages

-   Reformatting and indentation of C, C++, C\# and Java source code

-   Plug-In interface to tweak the output

-   CLI, GUI and Lib builds available

-   Platform independent

On Windows it’s available both with an installer or in standalone format (unzip and run).

AsciiDoc Integration
--------------------

[AsciiDoc](http://asciidoc.org) can natively use Highlight for xhtml11, html5 and html4 outputs:

-   http://asciidoc.org/source-highlight-filter.html

This opens the doors of the powerful AsciiDoc publishing toolchain to PureBASIC: eBook with elegant code can be easily created with tools like [Asciidoc FX](http://www.asciidocfx.com/).

Manual Installation
===================

Installing PureBASIC Lang Definition
------------------------------------

The PureBASIC language definition is now part of the Highlight distribution since version 3.33 (2nd Nov. 2016). Just download/update to the latest version of Highlight to enjoy PureBASIC syntax highlighting!

If — for any reasons — you wish to manually download and install the language file from this repo, follow the instructions below…

1.  **Fetch the PB Language-Definition file**:

    -   `purebasic.lang`

    If you cloned/download this repo, you’ll find it in the same folder of this README file. Else, you can [download it directly from GitHub](https://raw.githubusercontent.com/tajmone/purebasic-archives/master/syntax-highlighting/highlight/purebasic.lang).

2.  **Copy it to the language difinitions folder**:

    Navigate to Highlight’s setup folder.

    Copy/move the `purebasic.lang` file to the `\langDefs\` folder.

3.  **Edit Highlight’s configuration file**:

    Open in a plain-text editor the `filetypes.conf` found in the root of Highlight’s setup folder. To be on the safe side, make a copy of the file before making changes to it.

    Find this line of code (at the beginning of the file, around line 8):

    ``` {.lua}
    FileMapping = {
    ```

    you’ll need to add after it the following line:

    ``` {.lua}
     { Lang="purebasic",  Extensions={"pb", "pbi"} },
    ```

    This will ensure that PureBASIC source file will be correctly reckognized from their extensions (ie: `.pb` and `.pbi`).

That’s it! Now you can open Highlight’s GUI (or run it via CLI) and convert PureBASIC source files to color-formatted output.

Manually Installing The PureBASIC Theme
---------------------------------------

PureBASIC language file will render with any of Highilight’s themes: language definitions and color themes are independent of each other. The PureBASIC theme file was created to reproduce the look and feel of PureBASIC’s native IDE, so when you publish some PB code it will look familiar to users.

> __NOTE__: It seems that the PureBASIC color theme was accidently left out of Highlight 3.33 release (it was announced in the ChangeLog, but left out of the final release). It should soon be fixed. Meanwhile, if you want the native PureBASIC look and feel, you’ll need to manually download and copy the theme file.

1.  **Fetch the PureBASIC Theme file**:

    -   `pure_basic.theme`

    If you cloned/download this repo, you’ll find it in the same folder of this README file. Else, you can [download it directly from GitHub](ttps://raw.githubusercontent.com/tajmone/purebasic-archives/master/syntax-highlighting/highlight/pure_basic.theme).

2.  __Copy it to the Themes folder__:

    Navigate to Highlight’s setup folder.

    Copy/move the `pure_basic.theme` file to the `\langDefs\` folder.

That’s it! Now the theme will uppear as “**pure\_basic**” under the “**Color theme:**” drop-down menu in the “**Formatting**” tab of Highlight’s GUI, or available via options form CLI invocation.

> __NOTE__: If Highlight GUI was running, you’ll need to restart it for the theme to show up.

------------------------------------------------------------------------

Enjoy…
