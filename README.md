The PureBASIC Archives
======================

A collection of PureBASIC resources.

<!-- #toc -->
-   [Introduction](#introduction)
-   [Resources Organization](#resources-organization)
-   [Developement Branches](#developement-branches)
-   [License](#license)
    -   [Third Party Resources Licensing Terms](#third-party-resources-licensing-terms)
    -   [«PureBASIC Archives» Overall License Terms](#purebasic-archives-overall-license-terms)
-   [Contributing](#contributing)
-   [About PureBASIC](#about-purebasic)
-   [More Collections on GitHub](#more-collections-on-github)
    -   [FOSS Collections](#foss-collections)
    -   [Non-FOSS Collections](#non-foss-collections)
    -   [PureBasic CodeArchiv (Rebirth)](#purebasic-codearchiv-rebirth)
-   [Repo History](#repo-history)

<!-- /toc -->
Introduction
============

-   <https://github.com/tajmone/purebasic-archives>

This repo was created by Tristano Ajmone ([@tajmone](https://github.com/tajmone)) as a centralized place for gathering and sharing PureBASIC-realted resources: code examples and snippets, libraries, tutorials, books, and links — anything that can simplify a programmer’s life by either being herein archived or linked/reviewed.

Resources Organization
======================

The Archives project is divided into folders according to categories:

-   [`/books/`](./books/) — books on PureBASIC programming.
-   [`/libs/`](./libs/) – 3rd party PureBASIC libraries, modules, wrappers, ecc.
-   [`/syntax-highlighting/`](./syntax-highlighting/) — publishing PureBASIC source code in colored syntax.
-   [`/text-editors/`](./text-editors/) — PureBASIC syntax support in text editors.
-   [`/tutorials/`](./tutorials/) — PureBASIC learning tutorials.

Some folders contain material specific to this repo’s developement and maintainance:

-   [`/repo-maintainance-tools/`](./repo-maintainance-tools/) — scripts related to the maintainance of this repository.

Developement Branches
=====================

Some resources might require long-term work before being ready for inclusion in the main branch of the repo — eg: porting code from PB v4, translating documents, porting text to Markdown or Asciidoc (from HTML, Doc, or PDF), and so on.

For this purpose, some developement branches have been created to host different kind of works-in-progress (WIP):

-   [`dev-tutorials`](https://github.com/tajmone/purebasic-archives/tree/dev-tutorials) – WIP for upcoming tutorials.

You might consider peeking into the dev-branches to get a preview of what is coming next and — why not?! — join the work.

License
=======

This is a collection of various resources, and each resource comes with its own license. Please read carefully the licenses terms on a per-resource basis before incorporating them into your projects.

This repo acts as a «general container» through compartmentalization: hosting each resource under its own folder, governed by its own license terms. **PureBASIC Archives** provides a license-neutral structure for organizing into categories the various resources it hosts. In this respect, it resembles the CD-Roms with collections of software tools which are distributed with computer magazines — except that **PureBASIC Archives** is freely accesible to all.

Nothing has been incorporated here that would prevent cloning this repository.

Third Party Resources Licensing Terms
-------------------------------------

Licenses are placed (or linked/mentioned) in the main folder of each resource and sub-project, and the license terms should cover all files in that folder and sufolders. Further details and exceptions shall be indicated in the `README` file within the resource folder and/or in its parent folder.

«PureBASIC Archives» Overall License Terms
------------------------------------------

As for the project in itself — ie: this repo as a «container», its structural organization, and my personal contributions in terms of documentations (`README` markdown and html files) and project-related resources (scripts, templates, stylesheets, ecc) — its to be considered as released into the public domain according to the Unlicense terms (see: [Unlicense.org](http://unlicense.org/)), unless otherwise specified — since it wouldn’t be feasible to add a public-domain license to every single document file, I’ll instead ensure that a licence file will be provided where required (like third party tutorials and documents).

The choice of the Unlicense public-domain terms for the overall project ensures flexibility in contributing and forking, and should prevent licenses conflicts.

Contributing
============

If you’ve found these archives helpful in finding resources for learning and working with PureBASIC, consider helping the project grow by contributing your own resources, or adding links to external resources, writing reviews or tutorials.

Before submitting pull requests, please read the [`CONTRIBUTING.md`](./CONTRIBUTING.md) file.

Ideas, proposals, and corrections can be discussed by opening an Issue:

-   https://github.com/tajmone/purebasic-archives/issues

About PureBASIC
===============

PureBASIC is a commercial programming language and IDE published by Fantaisie Software (France):

-   https://www.purebasic.com/

> PureBasic is a native 32-bit and 64-bit programming language based on established BASIC rules. The key features of PureBasic are portability (Windows, Linux and MacOS X are currently supported), the production of very fast and highly optimized executables and, of course, the very simple BASIC syntax. PureBasic has been created for the beginner and expert alike. We have put a lot of effort into its realization to produce a fast, reliable system friendly language.
>
> In spite of its beginner-friendly syntax, the possibilities are endless with PureBasic’s advanced features such as pointers, structures, procedures, dynamically linked lists and much more. Experienced coders will have no problem gaining access to any of the legal OS structures or API objects and PureBasic even allows inline ASM.

More Collections on GitHub
==========================

Some links to other GitHub repos acting as containers for PureBASIC code.

FOSS Collections
----------------

> **NOTE**: The statement “`LICENSE file is a [LICENSE-NAME] template`” means that the author chose a license during repo creation, but did not fill-in its fields (author and project name, date, ecc). Even if the author’s intentions are clear, a blank license template might not be an effective license.

-   blendman/[Purebasic](https://github.com/blendman/Purebasic) – “Some purebasic codes, under GPL.”
-   aziascreations/[Random-PureBasic-Projects](https://github.com/aziascreations/Random-PureBasic-Projects) – “A collection of random PureBasic projects”. LICENSE file is a GNU GPL template.
-   IndigoFuzz/[PureBasicLibrary](https://github.com/IndigoFuzz/PureBasicLibrary) – “Purebasic Code Library: The purpose of this library is to provide a useful repository of code for the PureBasic programming language.” LICENSE file is a GNU GPL template.

Non-FOSS Collections
--------------------

In absence of explicit licensing terms, their contents should be considered copyrighted and for viewing purposes only.

-   aistun/[PureBasic-Sources](https://github.com/aistun/PureBasic-Sources) – various PB project by aistun, in French. No license.

PureBasic CodeArchiv (Rebirth)
------------------------------

-   https://github.com/GPIforGit/PureBasic-CodeArchiv-Rebirth

This project deserves a special mention. It seems to be a WIP to recreate an updated version of the historical **PureBasic CodeArchiv**, hosted at PureArea.net:

-   http://www.purearea.net/pb/CodeArchiv/CodeArchiv.html

**PureBasic CodeArchiv** contains a wealth of resources for PureBASIC version 3 and 4. Its license terms are:

> Design and compilation of the PureBasic CodeArchive is (c) 2003-2007 by Andre Beer and exclusive component of the www.PureArea.net PureBasic support site. You may use the codes published on this site without restrictions for your own projects, however a publication of this code archive on other web pages, CDRom etc., require the express consent of the author. The copyright of the individual codes lies at the respective authors.

Repo History
============

A record of the milestones of this repository history (reversed order).

-   `2016/11/18` — Republished Dräc’s tutorial *PureBasic and Object-Oriented Programming* (English version).
-   `2016/10/31` — Added [*Programming 2D Scrolling Games*](./books/2d-games/) PDF book and code examples.
-   `2016/10/27` — **Highlight**: this repo becomes the home of the PureBASIC language definition and color theme files for [**Highlight** syntax highlighter](./syntax-highlighting/highlight/).
-   `2016/10/26` — repository creation date.

