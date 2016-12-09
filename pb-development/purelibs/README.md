PureLibraries
=============

<!-- #toc -->
-   [3rd Party Components](#3rd-party-components)
    -   [Scintilla](#scintilla)
    -   [RegularExpression (PCRE)](#regularexpression-pcre)
-   [Folders Organization](#folders-organization)

<!-- /toc -->

------------------------------------------------------------------------

3rd Party Components
====================

Many (most? all?) PureLibraries are built on top of third party libaries (aka “components”). PureBASIC transparently binds/wraps these components into the language, providing the user with native PureBASIC commands to access their functionality. The presence of these components is the reason why you have to include a licenses file (or 2 if you used the 3D engine) when you distribute applications built with PureBASIC.

The full list of libraries used by PureBASIC can be found in these licenses files:

-   [`PureBASIC_Applications_Licenses.txt`](../licenses/PureBASIC_Applications_Licenses.txt)
-   [`PureBASIC_Applications_Licenses_3D-engine.txt`](../licenses/PureBASIC_Applications_Licenses_3D-engine.txt)

For most PureLibs, PureBASIC’s help contains all the information needed for using them. For some PureLibs, PB’s help provides inks to the library’s online documentation, which is required for taking full advantage of the component.

In some cases – like the **WinAPI** – the list of functions and constants is huge, and the user only needs to know the interfacing scheme adopted by PureBASIC, and then learn more about that component’s API from its official documentation.

In other cases, like Regular Expressions, merely knowing a component’s set of commands is not sufficient to master its use: the user needs introductiory documents and tutorials which are beyond the scope of PureBASIC’s reference documentation.

This folder gathers reference documents for using/learning PureLibraries and the libraries/components they are built from. They are selected documents taken from the components’ official websites, or from their release packages, or relevant documents found around the web. Efforts are made to select the documentation for the same version of the component used by PureBASIC, but this is not always an easy task since PureBASIC is opaque about the release version of the third party libraries it embodies.

Scintilla
---------

-   [`/scintilla/`](./scintilla/)

Scintilla is a free source code editing component.

RegularExpression (PCRE)
------------------------

-   [`/regex/`](./regex/)

From [PureBASIC documentation](http://www.purebasic.com/documentation/regularexpression/index.html):

> Regular expressions allow to do advanced pattern matching to quickly match, extract or replace an arbitrary information in a string. These kind of expressions are often difficult to read an write, but once you master them it makes a lot of things easier.

«**RegularExpression**» PureLib uses the **PCRE** (Perl Compatible Regular Expressions) library component, an open source implementation of the Perl regular expressions.

Folders Organization
====================

PureLibraries are organized according to their names as they appear in PB’s documentation – eg: «**Scintilla**» will be in the `/scintilla/` folder.

This approach should make it easier to locate PureLibs resources, and can handle neatly those cases in which a PureLib has more than one third party component. For example, the «**Database**» PureLib relies on **SQLite** and **PostgreSQL** (**libpq**); so it will have a `/database/` folder with two subfolders: `/sqlite/` and `/libpq/`.

Wherever feasible, shorter folder names will be adopted – eg: `/regex/` instead of `/regularexpression/`. It’s intuitive, easier to read, type and manage.
