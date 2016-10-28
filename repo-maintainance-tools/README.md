Repo-Maintainance Tools
=======================

This folder contains a bunch of tools for automating repository-related tasks. Unless you are contributing to the project, you can ignore them.

<!-- #toc -->
-   [Files Description](#files-description)
    -   [`updatemarkdown.bat`](#updatemarkdownbat)
    -   [`allreadmesupdate.bat`](#allreadmesupdatebat)
    -   [`snippets.txt`](#snippetstxt)

<!-- /toc -->
Files Description
=================

`updatemarkdown.bat`
--------------------

Auto-generates TOC in markdown files, and cleans up their source.

Runs under MS Windows.

**USAGE:**

-   from CMD: `updatemarkdown <filename>`
-   within file explorer: drag markdown file over `updatemarkdown.bat`

**REQUIRES:**

-   [gfmtoc](https://github.com/hail2u/node-gfmtoc) — must be installed globally (or available on the PATH). Requires [Node.js](https://nodejs.org) to be installed on the system.
-   [Pandoc](http://pandoc.org/) — must be installed or available on the PATH.

This batch script accepts a single markdown file as parameter (filename must include file extension):

1.  **Autogenerates TOC** — gfmtoc will scan the markdown source for the following HTML-comment tags:

        <!-- #toc -->
        <!-- /toc -->

    and will create and inject between them a navigable Table-Of-Contents, GitHub Style. Previous TOCs are just written over, so at each succesive run the TOC gets updated to the current status of the document.

2.  **Cleanup Markdown** — then Pandoc will perform a reformatting of the markdown source (no hard-wrapping though):
    -   *Reformatting* — the file is converted from markdown back to markdown: this will enforce a clean and consistent formatting to all markdown files.
    -   *Normalization* — merges adjacent **Str** or **Emph** elements, for example, and removes extra **Spaces**.
    -   *Smart punctuation* — converts straight quotes to curly quotes, `---` to em-dashes, `--` to en-dashes, and `...` to ellipses. Nonbreaking spaces are inserted after certain abbreviations, such as “Mr.”

`allreadmesupdate.bat`
----------------------

Invokes `updatemarkdown.bat` on every `README.md` file within the repository.

**USAGE:**

-   from CMD: `allreadmesupdate`
-   within file explorer: just double click it

**REQUIRES:**

-   same as `updatemarkdown.bat`

This is useful when you’ve been editing many `README.md` files, and want to update their TOC with a single click. It will not affect other markdown files.

`snippets.txt`
--------------

Just a container for snippets that need to be cut-&-pasted often. For the lazy and/or forgetful ones…
