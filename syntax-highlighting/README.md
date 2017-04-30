PureBASIC Syntax Highlighting
=============================

When it comes to publishing code, PureBASIC language is still unsupported in most syntax highlighting tools. I’ve created PB syntax files for highlight.js and highlight, and working toward the creation of syntax files for Pygments and Kate.

------------------------------------------------------------------------

<!-- #toc -->
-   [In This Repo](#in-this-repo)
    -   [Highlight.js](#highlightjs)
    -   [Highlight](#highlight)
    -   [Highlighting Guidelines](#highlighting-guidelines)
-   [Available Highlighters](#available-highlighters)
    -   [Backend HTML Highlighters](#backend-html-highlighters)
        -   [GeSHi — Generic Syntax Highlighter](#geshi--generic-syntax-highlighter)
    -   [In-Browser Highlighters](#in-browser-highlighters)
-   [Needed Highlighters](#needed-highlighters)
    -   [Pygments](#pygments)

<!-- /toc -->

------------------------------------------------------------------------

In This Repo
============

Highlight.js
------------

-   [`/highlight.js/`](./highlight.js/)
-   [HTML online live demo](https://cdn.rawgit.com/tajmone/purebasic-archives/a4c2c1a/syntax-highlighting/highlight.js/pb-prebuilt/hljs-all/example.html) (needed if you are on GitHub)

Highlight.js is a JavaScript syntax highlighter that works in the browser or on the server. It allows syntax highlighting source code — including PureBASIC — in HTML based documents, and it’s used in websites, offline documentation, and ebooks.

Here you’ll find prebuilt packages, with customized themes, built with PureBASIC developement in mind. The packages are ready for use: no need to install Node.js or go through the building process.

Highlight
---------

-   [`/highlight/`](./highlight/)

This repo hosts the project page of the PureBASIC language definition and color theme for [**Highlight**](http://www.andre-simon.de/doku/highlight/en/highlight.php) syntax highligther (PB lang definition file and theme are now bundled in Highlight since v3.33).

Written by Tristano Ajmone, public domain.

Highlighting Guidelines
-----------------------

-   [`/guidelines/`](./guidelines/)

This folder contains information and resources pertaining to syntax highlighting PureBASIC code. They are intended to help anyone wishing to create a new PureBASIC syntax definition for third party highlighters and code editors.

Available Highlighters
======================

Backend HTML Highlighters
-------------------------

### GeSHi — Generic Syntax Highlighter

-   <http://qbnz.com/highlighter/>

GeSHi is a GPL licensed syntax highlighter for HTML written in PHP, originally conceived for the [phpBB](http://phpbb.net/) forum system but now supporting integration in a wide variety of CMSs, as well as being a PHP (&gt; 4.3.0) library.

GeSHi 1.0 nativaly supports PureBASIC — syntax file created by GuShH (Gustavo Julio Fiorenza), ©2009, licensed under GNU 2 (or above):

-   <https://github.com/GeSHi/geshi-1.0/blob/master/src/geshi/purebasic.php>

In-Browser Highlighters
-----------------------

JavaScript tools capable of syntax highlighting code directly into the webpage.

Needed Highlighters
===================

There is a need to create PureBASIC syntax highligthing for some popular highlighters that are commonly used in publishing toolchains.

Pygments
--------

-   <http://pygments.org/>

Pygments is a very popular Python (2/3) syntax highlighter. By creating a PureBASIC syntax file for Pygments it would allow PB syntax support for the following apps/services (among many others):

-   [Hugo](https://gohugo.io/) — a powerful cross-platform static site generator written in Go, distributed as a single standalone binary executable. Converts markdown source files to an HTML5 site and serves it locally; can also deploy it online. It uses Pygments as the default syntax highlighter. For more info, [see Hugo documentation](https://gohugo.io/extras/highlighting).

    NOTE: Currently PureBASIC code can be highlighted on Hugo via highlight.js (client-side) instead of Pygments (server-side); but Pygments offers finer control (line numbers, highlighting certain lines, and more).


