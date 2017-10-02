PureBASIC For Highlight
=======================

    v1.7 (2017/10/02)
    PureBASIC 5.00 -> 5.60

This folder is the home of the PureBASIC language definition and theme files for André Simons’ **Highlight**.

> **NOTE**: The PureBASIC language definition and theme are now bundled in Highlight (v &gt;=3.33). No need to install them manually, just [download/update](http://www.andre-simon.de/zip/download.php) to the latest version of Highlight. When I update the language definition you might get here an early release before it’s actually integrated into the next Highlight release.

------------------------------------------------------------------------

<!-- #toc -->
-   [About This Project](#about-this-project)
    -   [PureBASIC’s Native IDE Look and Feel](#purebasics-native-ide-look-and-feel)
    -   [Beyond The Native Look and Feel](#beyond-the-native-look-and-feel)
    -   [ASM Syntax Support](#asm-syntax-support)
    -   [Files](#files)
-   [About Highlight](#about-highlight)
    -   [AsciiDoc Integration](#asciidoc-integration)
-   [Manual Installation](#manual-installation)
    -   [Installing PureBASIC Lang Definition](#installing-purebasic-lang-definition)
    -   [Manually Installing The PureBASIC Theme](#manually-installing-the-purebasic-theme)

<!-- /toc -->
About This Project
==================

The PureBASIC language and theme files herein contained were written by Tristano Ajmone ([@tajmone](https://github.com/tajmone)) and released in October 2016 under the public domain according to the [Unlicense terms](./UNLICENSE) ([Unlicense.org](http://unlicense.org)).

These files are now part of the official Highlight project and since v3.33 are bundled with it.

PureBASIC’s Native IDE Look and Feel
------------------------------------

The PureBASIC language definition was originally designed with the sole purpose of mimicking the way PB’s native IDE highlights its source code with its default color scheme — the goal being to use Highlight to render PureBASIC code just as users would see it in PB’s IDE, so that it would look familiar to them.

The `edit-purebasic` color theme was created specifically to mimic the look and feel of PB’s native IDE, and can be accessed in the “**Formatting**” tab, under the “**Color theme:**” drop-down menu of Highlight’s GUI, or invoked via options from the command line.

Currently, the language definition is being improved so that it can highlight also syntax elements that are not usually differentiated in PB’s native IDE. For example, the IDE doesn’t colorize escape sequences inside escape strings (eg: `~"\n"`), and the default color scheme will show numbers, labels, structures, and other elements with the same color as normal text (ie: black).

Although users can change the IDE’s default color scheme (**Preferences** » **Editor** » **Coloring**), the `edit-purebasic` color theme aims to replicate the IDE’s default settings plus inline ASM syntax coloring. This means that the theme will asign the same color to different syntax elements, making them unidstinguishable in the final rendering.

Beyond The Native Look and Feel
-------------------------------

Since some Highlight users might wish to use also other themes to highlighting PB code, efforts are being carried out to make the language definition capture more syntax elements than merely those required for mimicking the native IDE — eg: escape sequences within strings, labels, pointers, etc.

So far, these are the milestone achieved in that direction:

-   `v1.5` Escaped-strings delimiter (the “`~`” in “`~"`”) is no longer rendered via an Highlight Keyword (`kwd`) but is rendered as part of the actual string.
-   `v1.6` Numbers definition (hex, binary, floats an integers) were added.
-   `v1.7` Escape sequences are now parsed correctly, and only if occuring in due context (ie: Escaped strings).

And this is a list of more syntax elements (available in PB’s IDE preferences) that could be added in the future:

-   Labels
-   Structures
-   Pointers
-   Module Names
-   Separators (`(; ,[])`)

As the PureBASIC language definition will be refined and grow in time, the `edit-purebasic` color theme will be updated accordingly, to ensure that it will always be possible to mimick PureBASIC’s native look and feel.

ASM Syntax Support
------------------

With v1.2 the PB syntax definition now supports inline Assembly highlighting — just like within PureBASIC’s IDE.

The syntax definition has been tested against edge cases and great care has been taken to ensure that the resulting highlighted code mimicks the behavior of PureBASIC’s native IDE.

Files
-----

-   [`/archived/`](./archived/) — folder containing the various versions of the lang definition and theme.
-   `purebasic.lang` — PureBASIC language definition file for Highlight.
-   `edit-purebasic.theme` — PureBASIC color theme for Highlight, mimicking PB’s native IDE look and feel.
-   [`UNLICENSE`](./UNLICENSE) — Full text of “Unlicense” terms.

About Highlight
===============

-   <http://www.andre-simon.de/doku/highlight/en/highlight.php>
-   <https://github.com/andre-simon/highlight>

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

-   <http://asciidoc.org/source-highlight-filter.html>

This opens the doors of the powerful AsciiDoc publishing toolchain to PureBASIC: eBook with elegant code can be easily created with tools like [Asciidoc FX](http://www.asciidocfx.com/).

Manual Installation
===================

The PureBASIC language definition and theme are now part of the Highlight distribution since version 3.33 (2nd Nov. 2016). Just download/update to the latest version of Highlight to enjoy PureBASIC syntax highlighting!

If — for any reasons — you wish to manually install them from this repo, follow the instructions below…

Installing PureBASIC Lang Definition
------------------------------------

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

> **NOTE**: All Highlight themes wich mimic an editor or IDE have the “edit-” prefix.

1.  **Fetch the PureBASIC Theme file**:

    -   `edit-purebasic.theme`

    If you cloned/download this repo, you’ll find it in the same folder of this README file. Else, you can [download it directly from GitHub](https://raw.githubusercontent.com/tajmone/purebasic-archives/master/syntax-highlighting/highlight/edit-purebasic.theme).

2.  **Copy it to the Themes folder**:

    Navigate to Highlight’s setup folder.

    Copy/move the `edit-purebasic.theme` file to the `\langDefs\` folder.

That’s it! Now the theme will uppear as “**edit-purebasic**” under the “**Color theme:**” drop-down menu in the “**Formatting**” tab of Highlight’s GUI, or available via options form CLI invocation.

> **NOTE**: If Highlight GUI was running, you’ll need to restart it for the theme to show up.

------------------------------------------------------------------------

Enjoy…
