Registry Module (windows only)
==============================

A small Module to use the Registry on Windows.

by Thomas Schulz «**ts-soft**», unrestriced free license. Version 1.5.0 (2015-09-04).

Posted on PureBASIC Forums:

-   <http://www.purebasic.fr/english/viewtopic.php?p=422572#p422572>

------------------------------------------------------------------------

<!-- #toc -->
-   [License](#license)
-   [Features](#features)
    -   [Functions:](#functions)
    -   [Supports for Read and Write:](#supports-for-read-and-write)
-   [File History:](#file-history)
    -   [Version 1.5.0, Sep 04, 2015](#version-150-sep-04-2015)
    -   [Version 1.4.2, Jun 27, 2014](#version-142-jun-27-2014)
    -   [Version 1.4.1, Sep 02, 2013](#version-141-sep-02-2013)
    -   [Version 1.4, Sep 02, 2013](#version-14-sep-02-2013)
    -   [Version 1.3.3, Sep 01, 2013](#version-133-sep-01-2013)
    -   [Version 1.3.2, Aug 31, 2013](#version-132-aug-31-2013)
    -   [Version 1.3.1, Aug 30, 2013](#version-131-aug-30-2013)
    -   [Version 1.3, Aug 30, 2013](#version-13-aug-30-2013)
    -   [Version 1.2.1, Aug 25, 2013](#version-121-aug-25-2013)
    -   [Version 1.2, Aug 25, 2013](#version-12-aug-25-2013)
    -   [Version 1.1, Aug 25, 2013](#version-11-aug-25-2013)

<!-- /toc -->

------------------------------------------------------------------------

License
=======

From the source code:

    Free, unrestricted, no warranty whatsoever.
    Use at your own risk.

Features
========

Functions:
----------

-   Delete Value or Key.  
-   Read Entry.  
-   Write Entrys.

Supports for Read and Write:
----------------------------

-   `#REG_BINARY` (requires the `*Ret.RegValue` parameter)  
-   `#REG_DWORD`  
-   `#REG_QWORD`  
-   `#REG_SZ`  
-   `#REG_EXPAND_SZ` (auto expanded on read)  
-   `#REG_MULTI_SZ` (the result is a String with `#LF$` as separator, the same for value)

Wow6432Node is supported as flag!

x86, x64, ascii and unicode supported.

File History:
=============

Version 1.5.0, Sep 04, 2015
---------------------------

-   fixed for Use with **PB5.40** and higher

Version 1.4.2, Jun 27, 2014
---------------------------

-   fixed `WriteValue`

Version 1.4.1, Sep 02, 2013
---------------------------

-   fixed `XP_DeleteTree()`

Version 1.4, Sep 02, 2013
-------------------------

-   fixed Clear Resultstructure
-   Added compatibility to WinXP

Version 1.3.3, Sep 01, 2013
---------------------------

-   Added Clear Resultstructure

Version 1.3.2, Aug 31, 2013
---------------------------

-   fixed a Bug with `WriteValue` and Unicode

Version 1.3.1, Aug 30, 2013
---------------------------

-   Added `DeleteTree()` ; Deletes the subkeys and values of the specified key recursively.

Version 1.3, Aug 30, 2013
-------------------------

-   Added `Errorstring` to `RegValue` Structure
-   Added `RegValue` to all Functions
-   `RegValue` holds `Errornumber` and `Errorstring`!
-   Renamed `CountValues` to `CountSubValues`

Version 1.2.1, Aug 25, 2013
---------------------------

-   source length reduced with macros

Version 1.2, Aug 25, 2013
-------------------------

-   Added `CountSubKeys()`
-   Added `CountValues()`
-   Added `ListSubKey()`
-   Added `ListSubValue()`
-   Added updated example ;

Version 1.1, Aug 25, 2013
-------------------------

-   Added `ReadValue` for `#REG_BINARY` returns a comma separate string with hexvalues (limited to 2096 bytes)
-   Added small example

