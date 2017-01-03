Scintilla
=========

    PureBASIC 5.51
    Scintilla version: 3.4.2 (2014-05-22)
    License: Historical Permission Notice and Disclaimer (HPND)

------------------------------------------------------------------------

<!-- #toc -->
-   [External Refrence Links](#external-refrence-links)
-   [In This Repo](#in-this-repo)
    -   [Documentation](#documentation)
        -   [Scintilla Documentation](#scintilla-documentation)
        -   [PB-Scintilla Documentation](#pb-scintilla-documentation)
    -   [GoScintilla](#goscintilla)
    -   [Icons](#icons)
-   [About Scintilla](#about-scintilla)
    -   [PB Scintilla Version](#pb-scintilla-version)
    -   [License](#license)

<!-- /toc -->

------------------------------------------------------------------------

External Refrence Links
=======================

-   [Scintilla Homepage](http://www.scintilla.org/)
-   [Scintilla – PureBASIC Documentation](http://www.purebasic.com/documentation/scintilla/index.html)
-   [Scintilla – WikiPedia](https://en.wikipedia.org/wiki/Scintilla_(software))

In This Repo
============

-   [`/GoScintilla/`](./GoScintilla/) — **GoScintilla** updated to PB 5.x.
-   [`/icons1/`](./icons1/) — Icons that can be used with Scintilla.
-   [`/pb-scidoc/`](./pb-scidoc/) — Scintilla documentation adapted to PB usage (empty)
-   [`/scidoc/`](./scidoc/) — Selected files from Scintilla documentation.
-   [`CONTRIBUTING.md`](./CONTRIBUTING.md) — Maintainers/contributors guidelines for this repo section.
-   [`Scintilla_License`](./Scintilla_License) – License for Scintilla and SciTE (HPND), as required.

Documentation
-------------

This sections strives to gather documentation matching the version of the Scintilla component used in the latest PureBASIC stable release. This ensures that we are reading the correct documentation for using the Scintilla PureLib component.

The current latest version of Scintilla is 3.7.2 (2016/12/30), the version used by PureBASIC (5.51) is lagging behind Scintilla by 21 releases — with 3 major releases inbetween —, and it’s over 2 years older (954 days); therefore the online Scintilla documentation might contain references to features which are not present in the Scintilla PureLib, or that have changed since.

### Scintilla Documentation

-   [`/scidoc/`](./scidoc/)

This folder contains a selection of documentation files taken from the Scintilla 3.4.2 source code package — except `ScintillaHistory.html` (3.7.2) — and are licensed under the [Historical Permission Notice and Disclaimer (HPND)](https://en.wikipedia.org/wiki/Historical_Permission_Notice_and_Disclaimer) license:

-   [`/scidoc/Design.html`](./scidoc/Design.html) – «*Scintilla Component Design*».
-   [`/scidoc/ScintillaDoc.html`](./scidoc/ScintillaDoc.html) – «*Scintilla Documentation*».
-   [`/scidoc/ScintillaHistory.html`](./scidoc/ScintillaHistory.html) – «*History of Scintilla and SciTE*» updated to Scintilla 3.7.2 (2016/12/30).
-   [`/scidoc/ScintillaUsage.html`](./scidoc/ScintillaUsage.html) – «*Scintilla Usage Notes*» (Implementing Auto-Indent, Syntax Styling, and Calltips).
-   [`/scidoc/Steps.html`](./scidoc/Steps.html) – «*How to use the Scintilla Edit Control in windows?*».
-   [`/scidoc/Lexer.txt`](./scidoc/Lexer.txt) – «*How to Write a Scintilla Lexer*», C++ tutorial by Edward K. Ream.
-   [`/scidoc/Lexer.md`](./scidoc/Lexer.md) – markdown adaptation of `Lexer.txt`, formatting added.

### PB-Scintilla Documentation

-   [`/pb-scidoc/`](pb-scidoc/) (empty)

This folder will contain a readaptation of Scintilla documentation for PureBASIC specific usage.

(coming soon)

GoScintilla
-----------

-   [`/GoScintilla/`](./GoScintilla/)

by Stephen Rodriguez (aka [**@srod**](http://www.purebasic.fr/english/memberlist.php?mode=viewprofile&u=678) and **nxSoftWare**).

GoScintilla is a small Purebasic source-code utility which wraps a lot of the Scintilla API in order to make it easier to use the Scintilla control within our applications to give our programs source code editing facilities.

It comes with a powerful little lexer which is easily configured to give us syntax styling and/or code folding and/or code-completion and/or call-tips (code-tips) … as appropriate for some programming/scripting language or other.

With a few lines of Purebasic code we can have a fully configured Scintilla control up and running in no time and without the need to code our own lexer.

Icons
-----

-   [`/icons1/`](./icons1/)

Drawn by Iago Rubio, Philippe Lhoste, and Neil Hodgson.

Available sizes: 12x12, 16x16, 24x24, 32x32.

These `*.xpp` icons images were downloaded from [Scintilla website](http://www.scintilla.org/Icons.html) and may be used under the same [license](Scintilla_License) as Scintilla.

From [Wikipedia](https://en.wikipedia.org/wiki/X_PixMap):

> **X PixMap** (**XPM**) is an image file format used by the X Window System \[…\] primarily for creating icon pixmaps, and supports transparent pixels.

The `*.png` and `*.bmp` version of the icons were added by @tajmone via [**ImageMagick**](https://www.imagemagick.org)’s `convert` utility, using the following batch script:

-   [`/icons1/convert-icons.bat`](./icons1/convert-icons.bat)

------------------------------------------------------------------------

About Scintilla
===============

In PureBASIC for Windows the Scintilla component comes as a shared library (DLL) which has to be distributed with the final application — it’s named `Scintilla.dll` and can be found inside PureBASIC’s `/compilers/` subfolder, usually at this path:

``` nohighlight
C:\Program Files\PureBasic\compilers\Scintilla.dll
```

In PureBASIC for Linux and Mac it comes as a static library that is automatically linked with the final compiled binary application, and no additioanl files need to be distributed with your app.

PB Scintilla Version
--------------------

PureBASIC 5.51 uses Scintilla version 3.4.2 (2014-05-22) — last updated in PureBASIC 5.30 (2014/07/23).

The current latest version of Scintilla is 3.7.2 (2016/12/30):

-   [Scintilla History Page](http://www.scintilla.org/ScintillaHistory.html)

From the Scintilla History page you might download the source code package matching the version that ships with PureBASIC, and extract the documentation, lexers examples, headers files, and other useful stuff.

There are no known hacks to display which version of Scintilla component is used by the current PureBASIC release — Scintilla doesn’t offer any function to query for version number, nor any constants are present with such info.

The only way of knowing which version of Scintilla is being used by PureBASIC is from PureBASIC History page (also available ins PB Help):

-   [PureBASIC Documentation: History](http://www.purebasic.com/documentation/mainguide/history.html)

License
-------

Scintilla and SciTE are released under the terms of the **Historical Permission Notice and Disclaimer** (**HPND**) license:

-   [HPND License — Open Source Initiative (OSI)](https://opensource.org/licenses/HPND)
-   [HPND License — Wikipedia](https://en.wikipedia.org/wiki/Historical_Permission_Notice_and_Disclaimer)

Scintilla license terms requires that the following copyright notice shall appear in all copies of a software application using the Scintilla component:

    License for Scintilla and SciTE
    Copyright 1998-2003 by Neil Hodgson <neilh@scintilla.org>
    All Rights Reserved 

and that the following license text is included in the documentation for the software:

    License for Scintilla and SciTE

    Copyright 1998-2003 by Neil Hodgson <neilh@scintilla.org>

    All Rights Reserved 

    Permission to use, copy, modify, and distribute this software and its 
    documentation for any purpose and without fee is hereby granted, 
    provided that the above copyright notice appear in all copies and that 
    both that copyright notice and this permission notice appear in 
    supporting documentation. 

    NEIL HODGSON DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS 
    SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY 
    AND FITNESS, IN NO EVENT SHALL NEIL HODGSON BE LIABLE FOR ANY 
    SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
    WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER 
    TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE 
    OR PERFORMANCE OF THIS SOFTWARE.
