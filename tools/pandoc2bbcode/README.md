2bbcode
=======

A set of custom Pandoc writers for converting to BBCode.

------------------------------------------------------------------------

<!-- #toc -->
-   [Introduction](#introduction)
    -   [About Pandoc](#about-pandoc)
    -   [About BBCode](#about-bbcode)
-   [System Requirements](#system-requirements)
-   [Linux Usage](#linux-usage)
    -   [2bbcode](#2bbcode)
    -   [2bbcode\_phpbb](#2bbcode_phpbb)
-   [Windows Usage](#windows-usage)
    -   [2bbcode](#2bbcode-1)
    -   [2bbcode\_phpbb](#2bbcode_phpbb-1)
-   [Pandoc Setup](#pandoc-setup)
    -   [Windows](#windows)
        -   [Pandoc MSI Installer](#pandoc-msi-installer)
        -   [Pandoc via Chocolatey](#pandoc-via-chocolatey)
        -   [Pandoc Standalone](#pandoc-standalone)
    -   [Pandoc Supported Input Formats](#pandoc-supported-input-formats)

<!-- /toc -->
Introduction
============

**2bbcode** is a project hosting custom pandoc writers, written in Lua, which allow to convert to BBCode any input format supported by pandoc.

Since pandoc ships with a built-in Lua interpreter, using **2bbcode** wrtiers doesn’t require installing Lua on the system.

There are currently two 2bbcode writers in this project, addressing different BBCode flavors:

-   `2bbcode.lua` – the original 2bbcode writer by [@lilydjwg](https://github.com/lilydjwg/2bbcode), targeting the BBCode used by [FluxBB](https://fluxbb.org/forums/help.php#bbcode).
-   `bbcode_phpbb.lua` – a fork of `2bbcode.lua` by [@tajmone](https://github.com/tajmone/2bbcode), targeting the BBCode used by [**phpBB**](https://www.phpbb.com/community/faq.php?mode=bbcode).

About Pandoc
------------

-   [Pandoc website](http://pandoc.org/) | [User’s Guide](http://pandoc.org/MANUAL.html)
-   [Pandoc’s GitHub repo](https://github.com/jgm/pandoc)
-   [Pandoc download page](https://github.com/jgm/pandoc/releases/latest)
-   [Pandoc entry at Wikipedia](https://en.wikipedia.org/wiki/Pandoc)

Pandoc is a cross-platform FOSS command line tool for converting documents from one format to another. It natively supports more than 20 [input formats](#pandoc-supported-input-formats) and over 40 output formats, and can be extended to work with custom input (*reader*) and outupt (*writer*) formats through external scripts – likes the custom BBCode writers in this project.

Pandoc is written in Haskell, and precompiled binary releases for Windows, Mac OS X and Linux are available for download.

Pandoc was originally created by [John MacFarlane](http://johnmacfarlane.net/), a philosophy professor at the University of California, Berkeley, and is now maintained collaboratively on [GitHub](https://github.com/jgm/pandoc).

About BBCode
------------

-   [BBCode manual at PHP.net](http://php.net/manual/en/book.bbcode.php)
-   [BBCode.org](http://www.bbcode.org/) (website dedicate to BBCode resources)
-   [**phpBB**’s BBCode guide](https://www.phpbb.com/community/faq.php?mode=bbcode)
-   [BBCode entry at Wikipedia](https://en.wikipedia.org/wiki/BBCode)

BBCode (Bulletin Board Code) is a lightweight markup language used by many message boards to format posts. From [Wikipedia](https://en.wikipedia.org/wiki/BBCode):

> BBCode was introduced in 1998 by the messageboard software **Ultimate Bulletin Board** (**UBB**) implemented in Perl. In 2000 BBCode was used in [**phpBB**](https://www.phpbb.com/) – an internet forum system written in PHP. [**vBulletin**](https://www.vbulletin.com/) also uses BBCode.

BBCode tags work in a similar way to HTML tags, but square brackets are employed instead of angle brackets, and no paragraph tag is needed:

``` bbcode
Here comes a [b]bold word[/d].
```

BBCode has fewer tags than HTML, intended to cover simple formatting cases.

Since different implementations of BBCode employ different subsets of tags, there are different flavors of BBCode, and while the most common tags should work across all BBCode implementations, advanced formatting tags might not.

System Requirements
===================

Just **pandoc**:

-   [Pandoc](https://github.com/jgm/pandoc/releases/latest)

For more information, see [Pandoc Setup](#pandoc-setup).

Linux Usage
===========

2bbcode
-------

Required **2bbcode** Linux files:

-   `bbcode.lua`
-   `2bbcode`

``` bash
./2bbcode -f FORMAT <input >output
```

`FORMAT` defaults to `markdown_github`. Use `pandoc --list-input-formats` to list [acceptable formats](#pandoc-supported-input-formats).

2bbcode\_phpbb
--------------

Required **2bbcode\_phpbb** Linux files:

-   `bbcode_phpbb.lua`
-   `2bbcode_phpbb`

``` bash
./2bbcode_phpbb -f FORMAT <input >output
```

Same as with **2bbcode**, except for scripts names.

Windows Usage
=============

If you want to use **2bbcode** globally, put all the required `*.lua` and `*.bat` files in a same folder which is on the system `%PATH%`.

2bbcode
-------

Required **2bbcode** Windows files:

-   `bbcode.lua`
-   `2bbcode.bat`
-   `gfm2bbcode.bat`

1.  Using `2bbcode.bat` via command line:

    ``` dos
    2bbcode filename.ext
    ```

    creates `filename.bbcode`.

    Pandoc will guess input format from input file’s extension. This batch script allows conversion from any [pandoc supported input format](). For markdown input files, it will default to [pandoc’s extended Markdown](http://pandoc.org/MANUAL.html#pandocs-markdown).

2.  Using `gfm2bbcode.bat` via command line:

    ``` dos
    gfm2bbcode filename.md
    ```

    This will convert the GitHub-Flavored (no hard-linebreaks) input markdown file to `filename.bbcode`. This batch script invokes pandoc with the following settings:

        --smart --wrap=none --normalize -f markdown_github-hard_line_breaks

    … which is most likely what you’re looking for when working with GitHub related markdown files.

3.  Using `2bbcode.bat` and `gfm2bbcode.bat` from Windows File Explorer:

    Just drag’n’drop input file over `2bbcode.bat` or `gfm2bbcode.bat`, a converted `*.bbcode` file will be created in the same folder as input file.

2bbcode\_phpbb
--------------

Required **2bbcode\_phpbb** Windows files:

-   `bbcode_phpbb.lua`
-   `2bbcode_phpbb.bat`
-   `gfm2bbcode_phpbb.bat`

Use is the same as with **2bbcode**, except for scripts names.

Pandoc Setup
============

Windows
-------

You have different choices for setting up pandoc:

1.  [Use pandoc’s msi installer](#pandoc-msi-installer)
2.  [Install via Chocolatey](#pandoc-via-chocolatey)
3.  [Use pandoc executable in standalone mode](#pandoc-standalone)

The advised choice is **\#2** – install via Chocolatey!

### Pandoc MSI Installer

Pandoc for Windows ships with an msi installer.

When asked, choose “install pandoc for current user” (best choice).

### Pandoc via Chocolatey

Since Pandoc doesn’t (can’t) check for updates, the best method of installation is via [Chocolatey](https://chocolatey.org/) (or [ChocolateyGUI](https://chocolatey.org/packages/ChocolateyGUI)):

-   [Pandoc package](https://chocolatey.org/packages/pandoc) at Chocolatey.org

Chocolatey handles silent installation and updates in the background (using default options), and helps you keeping pandoc always updated to the latest release.

### Pandoc Standalone

If you prefer to use pandoc in standalone mode, you’ll need to extract pandoc binary executable from the installer file – for some reasons, the standalone version is no longer available for download. The installer contains two binary files (`pandoc.exe` and `pandoc-citeproc.exe`), the html User’s Guide and the license files.

1.  Dowload the pandoc msi installer (eg: `pandoc-1.XX-windows.msi`)
2.  Unpack it (using [7-Zip](http://www.7-zip.org/)) and extract and rename the `pandocEXE` file to `pandoc.exe`
3.  Optionally (if you need to use [CiteProc](https://en.wikipedia.org/wiki/CiteProc) for working with citations and bibliography files) also extract `pandoc_citeprocEXE` and rename it to `pandoc_citeproc.exe`.

Make sure that `pandoc.exe` (and, eventually, `pandoc_citeproc.exe`) is reachable via `%PATH%`, or just put it in the same folder as the `2bbcode.lua` script and the documents you want to convert (this is a good solution if you want to keep all your work within one folder).

Pandoc Supported Input Formats
------------------------------

As of pandoc v1.19, the supported input formats are:

-   `commonmark` – [CommonMark Markdown](http://commonmark.org/).
-   `docbook` – [DocBook](http://docbook.org/).
-   `docx` – Word [docx](https://en.wikipedia.org/wiki/Office_Open_XML).
-   `epub` – [EPUB](http://idpf.org/epub).
-   `haddock` – [Haddock markup](https://www.haskell.org/haddock/doc/html/ch03s08.html).
-   `html` – HTML.
-   `json` – [JSON](http://www.json.org/) version of native AST.
-   `latex` – [LaTeX](https://www.latex-project.org).
-   `markdown` – [pandoc’s extended Markdown](http://pandoc.org/MANUAL.html#pandocs-markdown).
-   `markdown_github` – [GitHub-Flavored Markdown](https://help.github.com/articles/about-writing-and-formatting-on-github/).
-   `markdown_mmd` – [MultiMarkdown](http://fletcherpenney.net/multimarkdown/).
-   `markdown_phpextra` – [PHP Markdown Extra](https://michelf.ca/projects/php-markdown/extra/).
-   `markdown_strict` – original unextended [Markdown](http://daringfireball.net/projects/markdown/).
-   `mediawiki` – [MediaWiki markup](https://www.mediawiki.org/wiki/Help:Formatting).
-   `native` – native [Haskell](https://www.haskell.org/).
-   `odt` – [ODT](http://en.wikipedia.org/wiki/OpenDocument) (Open Document Format for Office Applications).
-   `opml` – [OPML](http://dev.opml.org/spec2.html) (Outline Processor Markup Language).
-   `org` – [Emacs Org mode](http://orgmode.org/).
-   `rst` – [reStructuredText](http://docutils.sourceforge.net/docs/ref/rst/introduction.html).
-   `t2t` – [txt2tags](http://txt2tags.org/).
-   `textile` – (subsets of) [Textile](http://redcloth.org/textile).
-   `twiki` – [TWiki markup](http://twiki.org/cgi-bin/view/TWiki/TextFormattingRules).

You can view a list of all input formats supported in pandoc by typing:

``` nohighlight
pandoc --list-input-formats
```
