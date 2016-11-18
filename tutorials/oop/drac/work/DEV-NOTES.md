Dev-Notes
=========

    /tutorials/oop/drac/

[@tajmone](https://github.com/tajmone) – 2016/11/18

------------------------------------------------------------------------

Here are some (more or less hasty) personal notes on the work done in republishing this tutorial. First of all, the [CC BY license](https://creativecommons.org/licenses/by/4.0/#) mandates that any changes made should be listed:

> **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.

Second, I’d like to leave behind some technical notes that might help anyone wishing to take on the work from where I left it.

------------------------------------------------------------------------

<!-- #toc -->
-   [AsciiDoc Porting](#asciidoc-porting)
    -   [AsciidocFX](#asciidocfx)
    -   [Sections Numbering](#sections-numbering)
    -   [In-Doc Code Examples](#in-doc-code-examples)
        -   [Code Examples Numbering](#code-examples-numbering)
        -   [Pseudo-Code](#pseudo-code)
-   [English Tutorial](#english-tutorial)
    -   [Text Changes](#text-changes)
        -   [Terminology](#terminology)
        -   [Passages Polishing](#passages-polishing)
    -   [Section Numbering Changes](#section-numbering-changes)
    -   [TODOs](#todos)

<!-- /toc -->
AsciiDoc Porting
================

The original tutorial was published as an HTML document. I chose to convert it to [AsciiDoc](http://asciidoc.org/) format because it offers better separation of contents and presentation across many different formats. AsciiDoc is good intermediate standard allowing compilation of documents to multiple formats — HTML based ones being of immediate use here, since the tutorial might be included in a static site generator soon, or become a chapter of an ebook.

AsciidocFX
----------

To keep things simple, I’ve opted to work on the tutorial using [AsciidocFX](http://www.asciidocfx.com/), a free and open source cross-platform editor that allows working on AsciiDoc projects without having to install the Python (AsciiDoc) or Ruby (Asciidoctor) toolchain.

Therefore, to edit and compile the tutorial’s `.asciidoc` file, all you need is a vanilla AsciidocFX installation (or even use its standalone version: unzip and run).

Sections Numbering
------------------

When editing, it’s strongly reccomended to enable sections numbering. Just change the `sectnums` attribute (found in the header, around line 10) from:

    :sectnums!:

to

    :sectnums:

In-Doc Code Examples
--------------------

All the code samples that appear in the tutorial have been gathered in the [tutorial\_en\_code\_snippets.pb](tutorial_en_code_snippets.pb) file, to benefit from PureBASIC’ IDE auto-formatting.

### Code Examples Numbering

Next to each piece of code (both in the pb file as in the asciidoc document) there is a commented line with a numbered reference based on the section-number it belongs to. These references are for easily finding code examples in both files during copy-&-paste operations.

Inside the asciidoc document:

    // Example N. 4.2-1
    [source,purebasic]
    ---------------------------------------------------------------------
    Rect1.Rectangle
    ---------------------------------------------------------------------

In the pb file:

    ; ==============================================================================
    ; 4.2-1                          Instanciation 1
    ; ==============================================================================

    Rect1.Rectangle

The reference numbers are no longer aligned with the section-numbering because chapters numbering shifted during work; but this is not an issue, since it doesn’t affect numbering of the examples themselves.

### Pseudo-Code

Some of the tutorial code is intended as syntax usage-template (just like in PureBASIC’s Help), so to distinguish it from real code examples I’ve declared it as `purebasic pseudocode`:

    [source,purebasic pseudocode]
    ---------------------------------------------------------------------
    Interface <Interface> {Extends <ParentInterface>}
      Method1()
      [Method2()]
      [Method3()]
      ...
    EndInterface
    ---------------------------------------------------------------------

This will add an extra classto the `<pre><code>` block in the final HTML doc, thus enforcing a different background color via CSS:

    <pre class="highlightjs highlight">
        <code class="language-purebasic pseudocode hljs" data-lang="purebasic pseudocode">

In the future, I might implement a different highlights.js language definition for PureBASIC syntax pseudocode, which could handle properly parsing the customary use of “`[]<>{}|...`” symbols — right now, hjs parsing breaks up a little when encountering these symbols, and highlighting isn’t always carried out properly. But for now, a grey background will do as a distinguishing sign between real PB code and pseudocode syntax.

English Tutorial
================

Title capitalization was done according to “Chicago Manual of Style”:

-   http://capitalizemytitle.com

Text Changes
------------

The English version of the tutorial has undergone heavy polishing. Without trespassing the boundaries of re-adaptation, I’ve done my best to make the text as easier as possible to read — the subject matter being already complex in its nature, trying to keep sentences concise and smooth improves readability and assimilation of contents. Nevertheless, I didn’t succumb to the temptation of adding to the original text, except for a few extra qualifiers here and there whenever the subject matter was becoming conceptually entangled, and a synonim could help precise the context. But I did take some things from the French version of the tutorial, and added them to the English text (more on that ahead); but since the French text was written by the author, it should be fine.

### Terminology

Some key terms have been changed (in both text and code):

-   “**Mother**,” in reference to Classes (the proper OOP term in French), as been rendered to “**Parent**” (the common OOP term in English)

-   “**table of methods**” became “**method table**.”

-   “**Accessor**” has been rendered as “**mutator**,” “**setter/getter**” or “`Set()` **and** `Get()`” — according to context.

-   “**Form**,” in reference to geometrical shapes, was changed to “**Shape**.”

### Passages Polishing

Many passages were rather entangled, I therefore re-written them to make them smoother on the reader, and also shorter (wherever it could be done without compromising their meaning).

Other passages were ambiguos, in this case I’ve relied on the French version of the tutorial to disambiguate them.

For all changes, the French text was referenced. Mostly, the English version of the tutorial has a one-two-one correspondence with its French counterpart — not sure which one the author wrote first. But sometimes the two text differs slightly. At times I have taken liberty to fallback on the French version of some passages when the English text couldn’t be disambiguated, or when the French version offered better understanding.

In rare occasion, wherever the French text didn’t come to my rescue, I had to improvise…

My knowledge of French is rudimentary, and mostly colloquial, so I did my best (with the aid of oline translators) to fill the gaps. Any mistakes are my fault, not the author’s!

Some passages were not resolved, and have been left has found in the original English tutorial — and I’ve added a commented note in the asciidoc source:

    // TODO: SENTENCE BELOW NEEDS CHECKING

sometimes followed by another comment block containing the French equivalent text, and/or some additional notes regarding the problem.

Section Numbering Changes
-------------------------

The original HTML document didn’t enforce a strict sectioning scheme (no header tags used), but AsciiDoc has some rather strict requirements when it comes to document sectioning. Proper header levelling was enforced.

Slight changes were introduced in sectioning, so that if the document is to be published as a book (instead as a long article), level 2 headers provide a meaningful division into separate chapters.

The (level 2) header “Concepts Implementation” has been replaced by the “First Implementation” header (which came after it), this provided more sectioning simmetry with its counterpart section “Second Implementation” — and prevents having a single-paragraph chapter in the final document.

The “Appendix” has been formally declared as a section of Appendix type, according to AsciiDoc standard.

TODOs
-----

A possible area of improvement is that of the document’s notation.

I haven’t employed a uniform inline styling convention when it comes to key-terms. PureBASIC inline instructions are presented within code markers (eg: `Structure`), and key OOP concept are usually (but not always) presented in bold.

Sometimes its not easy to distinguish when a term refers to its PureBASIC instruction (eg: `Interface`) or its concept (eg: an object’s **Interface**). Somey key-terms are present both as instructions and concepts, while others are only conceptual (like **Class**). But the presence of PB macros introduces these terms as instruction also.

Since AsciiDoc offers different tags to stylize words (colors), a formal methodology could be employed, allowing to differentiate when a term refers to a general concept, its instruction/command, or to a specific object’s property. Examples:

-   “In OOP an object has an **Interface**…”

-   “the `Interface` instruction…”

-   “through `Shape1`’s interface…”

But I haven’t got around to work on it…

Also, I haven’t levelled out uniformely when such terms should appear in lowercase or capitalized.
