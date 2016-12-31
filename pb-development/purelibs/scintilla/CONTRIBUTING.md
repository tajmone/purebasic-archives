Contributing to Scintilla Section
=================================

Guidelines for contributors and maintainers of `/pb-development/purelibs/scintilla/` folder.

------------------------------------------------------------------------

<!-- #toc -->
-   [Aims](#aims)
    -   [PB Betas](#pb-betas)
    -   [PB Stable and PB LTS](#pb-stable-and-pb-lts)
-   [Updating](#updating)
    -   [Scintilla Docs Folder](#scintilla-docs-folder)

<!-- /toc -->

------------------------------------------------------------------------

Aims
====

The aim of the **Scintilla PureLib** section is to provide resources matching the Scintilla component version employed by the latest stable release of PureBASIC. We need to ensure that the contents provided here don’t lag behind newer PureBASIC releases.

The Scintilla PureLib component is not updated very often, so most of the time we only need to check if newer versions of PureBASIC are using the same version of Scintilla as before, and just update references to PureBASIC version.

When a newer version of PureBASIC contains an updated Scintilla component, then all Scintilla related documents will have to be updated to the correct version, following these guidelines.

PB Betas
--------

Beta versions of PureBASIC will not be taken in account.

PB Stable and PB LTS
--------------------

In case the latest **PureBASIC stable** release should use a different (updated) Scintilla component than the one found in the latest **PureBASIC LTS** release, we might start to maintain two subfolders for the Scintilla PureLib, to cover both versions. This is because some users will be sticking to the LTS version until a newer LTS is released.

> **NOTE**: This shall apply only to a PB &gt;= 5.5x LTS — because of the major change introduced with v5.50 no longer supporting Ascii compilation. Currently the latest LTS release is 5.44.

For more info on PureBASIC LTS policy:

-   [LTS — PureBasic Team Blog](http://www.purebasic.fr/blog/?p=437)

Updating
========

Scintilla Docs Folder
---------------------

-   [`/scidoc/`](scidoc/)

The contents of this folder should be replaced with the equivalent files, taken from the Scintilla source code package matchine the newer version used by the latest PureBASIC stable release.

Since not all of these files change from one release to another, you might as well do some diffing between the new package files and the ones in this repo. Probably most files are unchaged.

The only exception is the `/scidoc/ScintillaHistory.html` file, which should reflect the latest available, so that users might read what changes are being introduced in the latests Scintilla releases. Newer versions of this file add contents to previous versions of itself, so no contents are lost by keeping it up to date.

If you happen to be carrying out some routine checks, and find that an updated version of `ScintillaHistory.html` is available, please add it and make a pull request. You can view the latest file here:

-   <http://www.scintilla.org/ScintillaHistory.html>

