Assembly Resources
==================

    /asm/

This section is dedicated to all ASM-related resources (reference documentation, tutorials, examples, ecc). Since ASM is an indepedented subject from PureBASIC, all ASM resources will be confined to this section.

-   [`/fasm/`](./fasm/) — FASM-specific resources.
-   [`/fasm/tutorials/`](./fasm/tutorials/) — the only folder of this section with contents right now.
-   Vid’s «[*TAJGA FASM Tutorial*](https://cdn.rawgit.com/tajmone/purebasic-archives/1351562/asm/fasm/tutorials/tajga-fasm-tutorial.html)» (also [available in CHM format](./asm/fasm/tutorials/))  
-   Vid’s «[*FASM Preprocessor Guide*](https://cdn.rawgit.com/tajmone/purebasic-archives/1351562/asm/fasm/tutorials/fasm-preprocessor-guide.html)»

------------------------------------------------------------------------

<!-- #toc -->
-   [PureBASIC and ASM](#purebasic-and-asm)
-   [Section Organization](#section-organization)
-   [External Links](#external-links)

<!-- /toc -->

------------------------------------------------------------------------

PureBASIC and ASM
=================

PureBASIC allows to include x86 assembly code directly in its source code (inline ASM):

> PureBasic allows you to include any x86 assembler commands (including MMX and FPU one) directly in the source code, as if it was a real assembler. And it gives you even more: you can use directly any variables or pointers in the assembler keywords, you can put any ASM commands on the same line, …

Section Organization
====================

Since PureBASIC for Windows and Linux uses **FASM** (flat assembler), and PureBASIC for Mac uses **Yasm**, this section is divided in two main subfolders:

-   [`/fasm/`](./fasm/) — dedicated to FASM-specific resources.
-   [`/yasm/`](./yasm/) — dedicated to Yasm-specific resources (*coming soon*).

This root folder will contain any resources that are common to both **FASM** and **Yasm** – x86 architecture resources, etc.

External Links
==============

-   [PureBASIC Documentation — Inline x86 ASM](http://www.purebasic.com/documentation/reference/inlinedasm.html)
-   [FASM Home Page](https://flatassembler.net/)
-   [Yasm Home Page](http://yasm.tortall.net/)

