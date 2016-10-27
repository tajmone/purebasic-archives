PureBASIC For Highlight
=======================

This folder is the home of the PureBASIC language definition and theme files for André Simons’ **Highlight**.

<!-- #toc -->
-   [About This Project](#about-this-project)
-   [About Highlight](#about-highlight)
    -   [AsciiDoc Integration](#asciidoc-integration)
-   [Installing The Lang Definition And Theme](#installing-the-lang-definition-and-theme)
    -   [1) Downloading the Files](#1-downloading-the-files)
    -   [2) Copying the Files](#2-copying-the-files)
    -   [3) Editing the Config File](#3-editing-the-config-file)

<!-- /toc -->
About This Project
==================

The PureBASIC language and theme files herein contained were written by Tristano Ajmone ([@tajmone](https://github.com/tajmone/)) and released in October 2016 under the public domain according to the [Unlicense terms](./UNLICENSE) ([Unlicense.org](http://unlicense.org/)).

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

Installing The Lang Definition And Theme
========================================

While awaiting for the integration of the PureBASIC files into the next release of Highlight, you can manually download them and install from here.

1) Downloading the Files
------------------------

Donwload these 2 files:

-   `purebasic.lang`
-   `pure_basic.theme`

2) Copying the Files
--------------------

Navigate to Highlight’s setup folder.

Copy/move the `purebasic.lang` file to the `\themes\` folder; and the `pure_basic.theme` file to the `\langDefs\` folder.

3) Editing the Config File
--------------------------

Then open in a plain-text editor the `filetypes.conf` found in the root of Highlight’s setup folder. To be on the safe side, make a copy of the file before making changes to it.

Find this line of code (at the beginning of the file, around line 8):

``` {.lua}
FileMapping = {
```

you’ll need to add after it the following line:

``` {.lua}
 { Lang="purebasic",  Extensions={"pb", "pbi"} },
```

This will ensure that PureBASIC source file will be correctly reckognized from their extensions (ie: `.pb` and `.pbi`).

That’s it. Now you can open Highlight’s GUI (or run it via CLI) and convert PureBASIC source files to color-formatted output.

Enjoy…
