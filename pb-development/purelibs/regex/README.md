RegularExpression (PCRE)
========================

    PureBASIC 5.50
    PCRE version 8.30 (2012-02-04)
    License: New BSD

PureBASIC’s «**RegularExpression**» PureLibrary uses the **PCRE** (Perl Compatible Regular Expressions) library component.

------------------------------------------------------------------------

<!-- #toc -->
-   [External Refrence Links](#external-refrence-links)
-   [About PCRE](#about-pcre)
-   [PCRE License](#pcre-license)
    -   [Using PCRE/RegEx in Your Apps](#using-pcreregex-in-your-apps)
-   [Info About PB’s PCRE Lib](#info-about-pbs-pcre-lib)
    -   [PCRE Version](#pcre-version)
    -   [PCRE Build-Time Options](#pcre-build-time-options)
-   [Documents](#documents)

<!-- /toc -->

------------------------------------------------------------------------

External Refrence Links
=======================

-   [PCRE Homepage](http://www.pcre.org/)
-   [RegularExpression – PureBASIC Documentation](http://www.purebasic.com/documentation/regularexpression/index.html)
-   [PCRE – WikiPedia](https://en.wikipedia.org/wiki/Perl_Compatible_Regular_Expressions)

About PCRE
==========

PureBASIC’s «**RegularExpression**» PureLibrary uses the **PCRE** (Perl Compatible Regular Expressions) library component, an open source implementation of Perl regular expressions. Any PCRE supported RegEx (regular expression) is also supported in PureBASIC.

PCRE License
============

PCRE is released under the [**New BSD License**](PCRE_License) license (aka: “BSD-new”, “New BSD”, “revised BSD”, “BSD-3”, and “3-clause BSD”).

Using PCRE/RegEx in Your Apps
-----------------------------

> **IMPORTANT**: The PCRE license requires that a copyright notice and the license text itself be included in any software that uses the library.

If your PureBASIC software uses the **RegularExpression** library, and you want to distribute it publicly, you must include the [PCRE license file](PCRE_License) with the software – ie: *in addition* to the [`PureBASIC_Applications_Licenses.txt`](../../licenses/PureBASIC_Applications_Licenses.txt) file, which doesn’t contain the *full* copyright notice for PCRE.

Info About PB’s PCRE Lib
========================

PureBASIC documentation doesn’t offer any information about the version of the built-in PCRE library, nor the compiler settings used for building it. Most users can do well without these extra info, but advanced users might be interested in these details.

Knowing the exact library version in use is important for knowing which PCRE package we should look for in order to get the documentation for the right version. Through PCRE API documentation is possible to access advanced fucntionality. For example, the [`Get_PCRE_Info.pb`](Get_PCRE_Info.pb) tool uses advanced PCRE API functions to get info about the library’s build-time options – functions which are not mentioned in PureBASIC’s documentation.

PCRE Version
------------

In the [`Get_PCRE_Version.pb`](Get_PCRE_Version.pb) file (inside this folder) you’ll find this code hack to extract the version number and release date of the PCRE lib used by PureBASIC:

``` purebasic
; PureBASIC 5.50
; Code provided by Fred (Oct 05, 2016): 
; http://www.purebasic.fr/english/viewtopic.php?f=13&t=66707

ImportC ""
  pb_pcre_version(void);
EndImport

regex = CreateRegularExpression(#PB_Any, "")
pcre_version = pb_pcre_version(0)
Debug PeekS(pcre_version, -1, #PB_Ascii)
```

Running it produces the following output in the Debugger:

    8.30 2012-02-04

Which means that PureBASIC 5.50 is using PCRE libary version 8.30, released on February 4th, 2012.

PCRE Build-Time Options
-----------------------

The following Table resumes the technical details of the compiler-options used for building PureBASIC’s built-in PCRE component. It was automatically generated with the [`Get_PCRE_Info.pb`](Get_PCRE_Info.pb) tool found in this folder (by @tajmone).

| Feature Name                         | Value            | Description                           |
|--------------------------------------|------------------|---------------------------------------|
| PCRE Version                         | 8.30             | PCRE lib used by PureBASIC 5.50.      |
| `PCRE_CONFIG_UTF8`                   | True             | UTF-8 support.                        |
| `PCRE_CONFIG_UNICODE_PROPERTIES`     | True             | Unicode property support.             |
| `PCRE_CONFIG_NEWLINE`                | `LF`             | Default “newline” sequence.           |
| `PCRE_CONFIG_BSR`                    | All Unicode EOLs | Default EOLs matched by `\R`.         |
| `PCRE_CONFIG_STACKRECURSE`           | heap             | Heap-based recursion (data-blocks).   |
| `PCRE_CONFIG_LINK_SIZE`              | 2 bytes          | RegExs internal link size.            |
| `PCRE_CONFIG_POSIX_MALLOC_THRESHOLD` | 10               | POSIX API threshold for `malloc()`.   |
| `PCRE_CONFIG_MATCH_LIMIT`            | 38528            | Default internal resource limit.      |
| `PCRE_CONFIG_MATCH_LIMIT_RECURSION`  | 38528            | Internal recursion depth limit.       |
| `PCRE_CONFIG_JIT`                    | False            | Availability of JIT compiler support. |
| `PCRE_CONFIG_JITTARGET`              | NULL             | Target architecture for JIT compiler. |

For an in-depth explanation of these features and their values, refer to PCRE’s documentation:

-   [`pcre_config.html`](pcre_config.html) (brief description)
-   [`pcreapi.html`](pcreapi.html#SEC10) (longer explanation)

Documents
=========

The following documents were taken from the **PCRE 8.30 package**; they were selected with a criteria of usefulness in PureBASIC software developement (PCRE compiling, C and C++ usage, and other documents with no immediate relevance for PB users were left out). They are licensed under the [New BSD license](PCRE_License):

-   [`pcre.html`](pcre.html) – Introductory page.
-   [`pcre_config.html`](pcre_config.html) – Information about the installation configuration.
-   [`pcreapi.html`](pcreapi.html) – PCRE’s native API.
-   [`pcrecompat.html`](pcrecompat.html) – Compability with Perl.
-   [`pcrepattern.html`](pcrepattern.html) – Specification of the regular expressions supported by PCRE.
-   [`pcreperform.html`](pcreperform.html) – Some comments on performance.
-   [`pcresyntax.html`](pcresyntax.html) – Syntax quick-reference summary.
-   [`pcreunicode.html`](pcreunicode.html) – Discussion of Unicode and UTF-8 support.

