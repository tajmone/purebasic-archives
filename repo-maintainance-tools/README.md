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

Auto-generates TOC in markdown files, and cleans up their source (GFM flavor).

Runs under MS Windows.

**REQUIRES:**

-   [gfmtoc](https://github.com/hail2u/node-gfmtoc) — must be installed globally (or available on the PATH). Requires [Node.js](https://nodejs.org) to be installed on the system.
-   [Pandoc](http://pandoc.org/) — must be installed or available on the PATH.

**DESCRIPTION:**

This batch script accepts one or more markdown files as parameter (filenames must include file extension):

1.  **Autogenerates TOC** — gfmtoc will scan the markdown source for the following HTML-comment tags:

        <!-- #toc -->
        <!-- /toc -->

    and will create and inject between them a navigable Table-Of-Contents, GitHub Style. Previous TOCs are just written over, so at each succesive run the TOC gets updated to the current status of the document.

2.  **Cleanup Markdown** — then Pandoc will perform a reformatting of the markdown source according to GitHub flavored Markdown rules (no hard\_line\_breaks and no hard-wrapping though):
    -   *Reformatting* — the file is converted from markdown back to markdown: this will enforce a clean and consistent formatting to all markdown files.
    -   *Normalization* — merges adjacent **Str** or **Emph** elements, for example, and removes extra **Spaces**.
    -   *Smart punctuation* — converts straight quotes to curly quotes, `---` to em-dashes, `--` to en-dashes, and `...` to ellipses. Nonbreaking spaces are inserted after certain abbreviations, such as “Mr.”

**FILE EXPLORER USAGE:**

-   drag markdown file(s) over `updatemarkdown.bat`

**CLI USAGE:**

``` nohighlight
Usage (1), target specific files:

   updatemarkdown <filename1> [ <filename2> ... <filenameN> ]

where each <filenameN> is the full path name of a target markdown document,
file extension included.
------------------------------------------------------------------------------
Usage (2), target all files within folder:

   updatemarkdown -a

The "-a" (all) option will process all *.md files in the current folder.
------------------------------------------------------------------------------
Usage (3), recursively process folder:

   updatemarkdown -ar

The "-ar" (all + recursive) option will process all *.md files within the
current folder and all its subfolders. Since this is an aggressive option, the
user will be asked for confirmation. Chosing "NO" (or timing out on the choice)
will cause the script to fallback on non-recursive processing (ie: "-a").
The "-ar" option is not employable in automed script invocation.
------------------------------------------------------------------------------
Usage (4), add TOC tags to files:

   updatemarkdown -t <filename1> [ <filename2> ... <filenameN> ]
   updatemarkdown -t -a
   updatemarkdown -t -ar

The "-t" (tag) option must always precede other options/parameters.
With this option enabled, instead of performing cleanup/update of the markdown
target files, it will append to them the tags required by gfmtoc to build the
Table of Contents in the markdown file:

   <!-- #toc -->
   <!-- /toc -->

It is a useful shortcut for adding the TOC tags to one or more files within a
folder (and its subfolders, through "-ar" option). A true time-saver!
```

------------------------------------------------------------------------

`allreadmesupdate.bat`
----------------------

Invokes `updatemarkdown.bat` on every `README.md` file within the repository.

**USAGE:**

-   from CMD: `allreadmesupdate`
-   within file explorer: just double click it

**REQUIRES:**

-   same as `updatemarkdown.bat`

This is useful when you’ve been editing many `README.md` files, and want to update their TOC with a single click. It will not affect other markdown files.

------------------------------------------------------------------------

`snippets.txt`
--------------

Just a container for snippets that need to be cut-&-pasted often. For the lazy and/or forgetful ones…
