PureBASIC Development
=====================

Resources for PureBASIC development.

------------------------------------------------------------------------

<!-- #toc -->
-   [Licenses for PureBASIC Applications](#licenses-for-purebasic-applications)
    -   [PB 5.50 License Files](#pb-550-license-files)
-   [PureBASIC IDE Tools](#purebasic-ide-tools)
    -   [PBHGEN (PureBasic Header Generator)](#pbhgen-purebasic-header-generator)
    -   [History Viewer](#history-viewer)

<!-- /toc -->

------------------------------------------------------------------------

Licenses for PureBASIC Applications
===================================

PureBASIC developers have to include a Licenses file with their software releases, because the PureBASIC compiler includes third party components in the final binaries.

PureBASIC documentation includes two ready-to-use license texts: a [common licenses text](https://www.purebasic.com/documentation/reference/license_application.html), for inclusion with all created applications; and additional [licenses text for apps that make use of the 3D engine](https://www.purebasic.com/documentation/reference/license_engine3d.html). So, the first one has to be *always* included with your apps, the second one only if your app uses the 3D engine.

PB 5.50 License Files
---------------------

Here you’ll find both licenses files in plaintext format, ready to be copied into your project folder:

-   [`PureBASIC_Applications_Licenses.txt`](PureBASIC_Applications_Licenses.txt)
-   [`PureBASIC_Applications_Licenses_3D-engine.txt`](PureBASIC_Applications_Licenses_3D-engine.txt)

> **NOTE 1**: These files contain the licenses as found on PureBASIC online documentation at the time of PuraBASIC version 5.50. Changes to these licenses are rare, but the introduction of new components in future versions of PureBASIC might introduce new licenses. If you are using a different version of PB, get the right licenses text from PureBASIC’s Help guide.

> **NOTE 2**: I’ve opted to use the `.txt` externsion and `CR+LF` linebreaks for the licenses files since it makes things easier on Windows users.

------------------------------------------------------------------------

PureBASIC IDE Tools
===================

Beside PureBASIC IDE’s built-in Tools, it’s possible to add custom external tools to the **Tools** menu.

-   [Using external tools](https://www.purebasic.com/documentation/reference/ide_externaltools.html) (PB online documentation)

Users have created a wide range of custom tools to enhance PB development workflow withouth leaving the IDE. I’ll try to maintain here a curated list of such tools.

PBHGEN (PureBasic Header Generator)
-----------------------------------

by [Henry de Jongh](https://00laboratories.com/about/henry-de-jongh) | License: [CC-BY 4.0](https://bitbucket.org/Henry00/pbhgen/src/e5828286b22ca59ec6168e49c57a1c51718978b4/LICENSE?at=master&fileviewer=file-view-default) | Supported OS: All

-   [`/pb-ide/tools/pbhgen/`](./pb-ide/tools/pbhgen/) – PBHGEN v5.42 (taken from [PBHGEN on Bitbucket](https://bitbucket.org/Henry00/pbhgen))
-   [PBHGEN homepage](http://00laboratories.com/downloads/programming/purebasic-header-generator) (00laboratories)
-   [PBHGEN on Bitbucket](https://bitbucket.org/Henry00/pbhgen)
-   [PBHGEN thread on PB Forums](http://www.purebasic.fr/english/viewtopic.php?f=27&t=53414)

PBHGEN will read a PureBasic source file (`*.pb`) and generate a header file (`*.pbi`) out of it, automatically generating `Declare` statements for every procedure. Works also with [SpiderBasic](https://www.spiderbasic.com/).

History Viewer
--------------

by HeX0Rs | License: Copyrighted, closed-source | Supported OS: Win + Linux

-   [History Viewer for Windows](http://hex0rs.coderbu.de/e107_plugins/download/download.php?view.2)
-   [History Viewer for Linux](http://hex0rs.coderbu.de/e107_plugins/download/download.php?view.10)
-   [History Viewer thread on PB Forums](http://www.purebasic.fr/english/viewtopic.php?f=27&t=45757)

History Viewer is a simple personal VCS (Version Control System) and projects-backup tool:

-   create semantic versioned snapshots of your projects
-   granular preferences-control over which files to include/exclude in snapshots
-   easily view a project’s versioned history
-   view source code changes (fidds) between snapshots
-   selectively restore any snapshot
-   all files archiving and handling transparently managed in the background
-   database driven
-   *and more*…

