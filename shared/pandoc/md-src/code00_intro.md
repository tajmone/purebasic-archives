Source Code Highlighting
========================

Source code highlighting is achieved through a custom **Higlighlight.js** (PureBASIC mod version) build.

Languages are added to the bundle on a per-need basis: when a new html document in the PureBASIC archives requires a language missing in the current HLJS-PB bundle, it gets added. This is done to keep the weight of the HLJS file to the bare minimum required for the project.

Currently, the bundled languages are:

-   [PureBASIC](#purebasic)
-   [FASM](#fasm)
-   [Bash](#bash)
-   [DOS](#dos)
-   [ini](#ini)
-   [Markdown](#markdown)
-   [XML](#xml)
-   [CSS](#css)
-   [YAML](#yaml)

The goal is to have each language employ a custom CSS color theme. Practically, this has been achieved only for some languages; the others use a fallback theme (monokai-sublime) in the meantime.
