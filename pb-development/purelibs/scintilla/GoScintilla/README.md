GoScintilla
===========

    GoScintilla v3.0.1 (2017/09/08)

GoScintilla is a small Purebasic source-code utility which wraps a lot of the Scintilla API in order to make it easier to use the Scintilla control within our applications to give our programs source code editing facilities.

It comes with a powerful little lexer which is easily configured to give us syntax styling and/or code folding and/or code-completion and/or call-tips (code-tips) … as appropriate for some programming/scripting language or other.

With a few lines of Purebasic code we can have a fully configured Scintilla control up and running in no time and without the need to code our own lexer.

------------------------------------------------------------------------

<!-- #toc -->
-   [Introduction](#introduction)
    -   [About GoScintilla v2](#about-goscintilla-v2)
    -   [About GoScintilla v3](#about-goscintilla-v3)
-   [License](#license)

<!-- /toc -->

------------------------------------------------------------------------

Introduction
============

About GoScintilla v2
--------------------

-   [GoScintilla on PureBASIC Forums](http://www.purebasic.fr/english/viewtopic.php?f=14&t=40088&hilit=go+scintilla)

**GoScintilla** was created by Stephen Rodriguez (aka [**@srod**](http://www.purebasic.fr/english/memberlist.php?mode=viewprofile&u=678) and **nxSoftWare**). The latest published version of **GoScintilla 2** was version 2.7 (11th Aug 2012), which was no longer compatible with PureBASIC &gt;= 5.10.

GoScintilla 2.7 can still be downloaded in a zip archive (`GoScintilla.zip`) from **RSBasic.de**:

-   <http://www.rsbasic.de/backups/>

About GoScintilla v3
--------------------

**GoScintilla 3** takes on from the latest version of **GoScintilla 2**, tweaking slighlty its source code to make it compatible with PureBASIC 5.51.

The required changes were few (just 3 lines of code changed) and should make **GoScintilla 3** work with any PureBASIC version &gt;= 5.10. Future versions of **GoScintilla 3** might contain further optimizations that take into account the changes that both PureBASIC and the Scintilla component have undergone since **GoScintilla 2.7**.

Please, note that the shift from v2 to v3 only denotes a backward compatiblity breakage, NOT ADDITIONAL FEATURES! I’m following here the [criteria of Semantic Versioning](http://semver.org/#spec-item-8):

> **8)** Major version X (X.y.z | X &gt; 0) MUST be incremented if any backwards incompatible changes are introduced to the public API. It MAY include minor and patch level changes. Patch and minor version MUST be reset to 0 when major version is incremented.

The aim of **GoScintilla 3** will be to make the most out of PureBASIC’s Scintilla gadget with the latest stable release of PureBASIC. The project is open to contributions.

This fork of **GoScintilla** is maintained by Tristano Ajmone at **The PureBASIC Archives** on GitHub:

-   <https://github.com/tajmone/purebasic-archives>

I contacted Rodriguez seeking permission to create this fork, and to attribute a license to the project that might satisfy GitHub’s legal requirements regarding reuse of third party code. Rodriguez confirmed that I could “do what I wanted with it”, so I’ve decided to republish **GoScintilla** under the **WTFPL** (Do What the Fuck You Want to Public License) license terms:

-   <http://www.wtfpl.net/>

This license is the closest I could find to the original license terms statement of Rodriguez, as found inside the `GoScintilla.chm` file:

> **License**
>
> License, what license? Do as you like with this code; use it, study it, laugh at it, eat it… so many choices! :)
>
> Needless to say though that I will accept no responsibility for any damage or injury (???) caused by the use (or misuse) of this software, you use it entirely at your own risk. I do not even assert that this software is ‘fit for purpose’ in any way shape or form.
>
> An acknowledgement within any application making use of this wrapper is always nice, but not a requirement as such.

I see the **WTFPL** has being 100% compatible with these intents, and at the same time allowing to retain the author’s copyright statement and being a widely reckognized software license.

License
=======

Copyright © nxSoftWare (Stephen Rodriguez) 2010.

**GoScintilla 3** is released under the terms of the [**WTFPL**](http://www.wtfpl.net/) (Do What the Fuck You Want to Public License):

-   [`LICENSE`](./LICENSE) — **GoScintilla 3** license terms.
-   [`COPYING`](./COPYING) — **WTFPL** license file.

