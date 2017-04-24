PureBASIC Highlighting Guidelines
=================================

This folder contains information and resources pertaining to syntax highlighting PureBASIC code. They are intended to help anyone wishing to create a new PureBASIC syntax definition for third party highlighters and code editors.

------------------------------------------------------------------------

<!-- #toc -->
-   [Introduction](#introduction)
    -   [General Considerations](#general-considerations)
-   [Native PureBASIC IDE Highlighting](#native-purebasic-ide-highlighting)
-   [Useful Links](#useful-links)

<!-- /toc -->

------------------------------------------------------------------------

Introduction
============

Syntax highlighting tools and code editors can differ greatly on their approach to language definitions, so there can’t be a unique solution to cover all possible tools. The aim here is to provide as much information and resources as possible regarding PureBASIC syntax, to help creating and maintaining syntax definitions.

You might contribute on this topic, or ask further questions, through the PureBASIC Forum thread [\#68368](http://www.purebasic.fr/english/viewtopic.php?f=13&t=68368&start=0).

General Considerations
----------------------

Depending on the task at hand, you might want to approach syntax highlighting in different ways. For example, if you are writing a language definition for an highlighter tool intened for beautifying source code examples (on the web, in books, etc), your aim will be to cover the syntax of all possible PureBASIC versions — ie: you’ll want to keep in your definition file deprecated or renamed keyords, so that code snippets written for PB 5.00 up to the latest version will be correctly highlighted.

But if you are writing a definition for a code editor — which includes autocompletion functionality — you might want to stick to the syntax of a particular PureBASIC version (usually the latest). For example, in PB 5.60 `Base64Encoder()` and `Base64Decoder()` were renamed to `Base64EncoderBuffer()` and `Base64DecoderBuffer()`, respectively. While a code beautifier should cover both syntaxes, a code editor auto-completion should only suggest the latest working syntax.

In both use cases, keeping track of keywords/commands changes is important — code beautifiers should be updated to include new keywords, and editors’ definitions need to remove depreacted/renamed keywords and add new ones.

Generally speaking, PureBASIC keywords don’t change too often; once you have the full set of keywords, built-in functions and commands of the first 5.x release, new changes can be easily tracked manually by looking at each release’s changelog in the [History page](http://www.purebasic.com/documentation/mainguide/history.html) of the user documentation.

Native PureBASIC IDE Highlighting
=================================

We’ll begin by analyzing the way PureBASIC code is highlighted in its native IDE. This will serve as a common reference point and to establish some basic terminology. In many cases, you might want to emulate the native IDE’s behavior when implementing a syntax file for an highlighting tool (this was my approach in creating the definitions for Highlight and highlight.js).

Useful Links
============

-   [PB Forum \#68368](http://www.purebasic.fr/english/viewtopic.php?f=13&t=68368&start=0) — a thread on how to get the full list of PureBASIC keywords. Contains many suggestions, links and code examples. It’s also a thread for general discussion of PB syntax highlighting.

