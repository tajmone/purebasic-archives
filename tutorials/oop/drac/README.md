Dräc’s *PureBasic and OOP*
==========================

By «Dräc,» (c) 2005, license: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

-   [English version](./en/OOP-Demystified.html)

------------------------------------------------------------------------

<!-- #toc -->
-   [About This Article](#about-this-article)
    -   [Reprint And Changes](#reprint-and-changes)
    -   [AsciiDoc Format](#asciidoc-format)
-   [Files List](#files-list)
    -   [English Tutorial Files](#english-tutorial-files)
    -   [Shared Files](#shared-files)
    -   [Dev-Files](#dev-files)

<!-- /toc -->
About This Article
==================

This long tutorials shows, step by step, how to implement the OOP paradigm in PureBASIC. Two approaches to OOP implementation are presented, in order of complexity, with detailed explanations and in-document code examples. Along with the tutorial are provided the fully functional source codes of the two OOP implementations, along with a `*.pbi` OOP resource reusable in other projects.

Reprint And Changes
-------------------

This is a reprint of «Dräc»’s multi-part tutorial *PureBasic and the Object-Oriented Programming* (French title: *PureBasic et la Programmation Orientée Objet*) also knwon as *the OOP demystified*, published in 2005 on [drac.site.chez-alice.fr](http://drac.site.chez-alice.fr/Tutorials%20Programming%20PureBasic/indexTutorials_en.htm):

-   [Original French article](http://drac.site.chez-alice.fr/Tutorials%20Programming%20PureBasic/POO/POO_Pourquoi.htm)
-   [Original English article](http://drac.site.chez-alice.fr/Tutorials%20Programming%20PureBasic/POO/POO_Pourquoi_en.htm)

It was reprinted with explicit permission of the author, who released the tutorial text and source codes under Creative Commons Attribution (CC BY 4.0) in response to the permission request to reproduce it inside the [**PureBASIC Archives**](https://github.com/tajmone/purebasic-archives).

The tutorial was ported from HTML to AsciiDoc by Tristano Ajmone, who also polsihed the English text — introducing slight adjustments in line with the tutorial aims (using the original French tutorial as a reference) — and made minor changes to code examples (either aesthetic or to ensure compatibility with latest version of PureBASIC).

AsciiDoc Format
---------------

The text was recreated in [AsciiDoc](http://asciidoc.org/) format using the [AsciidocFX](http://www.asciidocfx.com/) free editor.

If you wish to edit the AsciiDoc source, and/or compile it to HTML, you might do so with AsciidocFX: it’s a cross-platform, self-contanied and standalone toolchain that doesn’t require installation of Python AsciiDoc or Ruby Asciidoctor.

Files List
==========

English Tutorial Files
----------------------

-   [`/en/`](./en/) – Folder of English article.
-   [`/en/OOP-Demystified.asciidoc`](./en/OOP-Demystified.asciidoc) – AsciiDoc source of English article.
-   [`/en/OOP-Demystified.html`](./en/OOP-Demystified.html) – HTML output of English article.
-   [`/en/OOP-Inheritance-Ex1.pb`](./en/OOP-Inheritance-Ex1.pb) – PureBASIC source of First Example of OOP implementation (English comments and naming convention).
-   [`/en/OOP-Inheritance-Ex2.pb`](./en/OOP-Inheritance-Ex1.pb) – PureBASIC source of Second Example of OOP implementation (EN ver.).
-   [`/en/OOP-Inheritance-Ex2_preprocessed.pb`](./en/OOP-Inheritance-Ex2_preprocessed.pb) – The preprocessed version of `./en/OOP-Inheritance-Ex1.pb`: contains all included external code, and macros are expanded (orignal macros are kept as comments next to their expanded code), comments are preserved. Included by Tristano Ajmone to simplify analysis of source code.
-   [`/en/OOP.pbi`](./en/OOP.pbi) – PureBASIC include file, imported by Second Example, and reusable in custom OOP-projects (EN ver.).

Shared Files
------------

These files are required by, and common to, all locale versions of the tutorial. Don’t rename these files and folders.

-   [`/hjs/`](./hjs/) – Folder containing JavaScript and CSS resources for PureBASIC syntax highlighting in final HTML articles (common to both English and French versions).
-   [`/hjs/highlight.min.js`](./hjs/highlight.min.js) – Highlight.js v9.3.0 prebuilt for PureBASIC (only) syntax highlighting — [modded version](https://github.com/tajmone/highlight.js/tree/PureBASIC), mimicking 100% PB native IDE.
-   [`/hjs/styles/github.min.css`](./hjs/styles/github.min.css) – CSS from modded Highlight.js syntax coloring: theme mimicks PB native IDE. Added a few tweaks to change background of PureBASIC «pseudocode» examples found in tutorial.
-   [LICENSE](./LICENSE) — CC BY 4.0 license terms.

Dev-Files
---------

Work files used during republishing the tutorial from HTML to AsciiDoc. Stored here to aid contributors wishing to make changes or translate to other locales.

-   [`/work/`](./work/) – Dev-Files folder.
-   [`/work/DEV-NOTES.md`](./work/DEV-NOTES.md) — Some work notes left behind for contributors.
-   [`/work/ppEnEx2.bat`](./work/ppEnEx2.bat) — The batch script used for creating `/en/OOP-Inheritance-Ex2_preprocessed.pb`. Works by invoking `/work/pppbsource.bat`.
-   [`/work/ppEnEx2_header`](./work/ppEnEx2_header) — Text file of the header injected in the final preprocessed version of `/en/OOP-Inheritance-Ex2.pb`. Adds a description (PB comments) to the preprocessed source.
-   [`/work/pppbsource.bat`](./work/pppbsource.bat) — The common batch script that handles preprocessing Examples for all locales.
-   [`/work/tutorial_en_code_snippets.pb`](./work/tutorial_en_code_snippets.pb) – All the snippets of PB code and pseudocode found in English tutorial, with reference numbers pointing to HTML comments in AsciiDoc source. This source file was used to auto-indent the snippets in PB IDE and carry out S&R operations.

