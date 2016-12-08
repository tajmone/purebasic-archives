PureLibraries
=============

<!-- #toc -->
-   [3rd Party Components](#3rd-party-components)
    -   [Scintilla](#scintilla)

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
