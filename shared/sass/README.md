About Sass Configuration
========================

    /shared/sass/

A few notes on how the Sass workflow is organized here, and some reminders about basic Sass/Compass rules…

------------------------------------------------------------------------

<!-- #toc -->
-   [Introduction](#introduction)
-   [Project Files](#project-files)
-   [Usage](#usage)
    -   [Development](#development)
    -   [Production](#production)
-   [Workflow](#workflow)
-   [Credits](#credits)
    -   [github-markdown-css](#github-markdown-css)
    -   [primer-alerts](#primer-alerts)
-   [Memos on Sass/Compass Rules](#memos-on-sasscompass-rules)
    -   [General](#general)
        -   [Paths](#paths)
    -   [Sass](#sass)
        -   [Comments](#comments)
        -   [Partials](#partials)
    -   [Compass](#compass)

<!-- /toc -->

------------------------------------------------------------------------

Introduction
============

This Sass project is used to create and maintain the various CSS files shared among the repo resources. The built CSS files are compiled directly in the destination folder intended for production use (`../css`):

    /shared/css/

This project uses third party source files, readapted and modified to suit the project needs (see [Credits section](#credits) below):

-   [`github-markdown-css`](#github-markdown-css) — by Sindre Sorhus «@sindresorhus», MIT License.
-   [`primer-alerts`](#primer-alerts) — by GitHub Inc., MIT License.

Project Files
=============

-   [`/hljs/`](./hljs/) — Highlight.js lang-themes Sass source files (split by lang name).
-   `config.rb` — the configuration file.
-   `build-css.bat` — batch script for production build.
-   [`LICENSE`](./LICENSE) --- Licenses file.

For the various `*.scss` Sass files, look inside them for a description.

Usage
=====

Development
-----------

When developing, you should use the `compass watch` command: it will auto-detected changed files and re-compile in real time your CSS files with development-friendly settings (nested output, line comments).

``` dos
compass watch
```

Production
----------

For production stage, either use the `build-css.bat` batch script, or type in CDM prompt:

``` dos
compass compile -e production --force
```

(same compass command found inside `build-css.bat`)

Workflow
========

*Under construction…*

Credits
=======

github-markdown-css
-------------------

-   <https://github.com/sindresorhus/github-markdown-css>

The `_github-markdown.scss` file is a built upon Sindre Sorhus’ ([**@sindresorhus**](https://github.com/sindresorhus)) `github-markdown.css` file taken from the **github-markdown-css** project, released under the terms of the MIT License:

    The MIT License (MIT)

    Copyright (c) Sindre Sorhus <sindresorhus@gmail.com> (sindresorhus.com)

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

primer-alerts
-------------

-   <https://github.com/primer/primer-alerts>

The `_alerts.scss` file is a derivative work based on [GitHub Incorporation](https://github.com)’s `flash.scss` file, taken from the **primer-alerts** repository, released under the terms of the MIT License:

    The MIT License (MIT)

    Copyright (c) 2016 GitHub Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

**Primer-alerts** is part of the **Primer CSS** project:

-   <http://primercss.io/>
-   <https://github.com/primer/primer-css>

------------------------------------------------------------------------

Memos on Sass/Compass Rules
===========================

General
-------

### Paths

Use forward slashes (`/`) in paths so they will work cross-platform (Windows accpets both `\` and `/`).

If you really need to use backslashes within quoted strings, escape them (`\\`).

Sass
----

-   <http://primercss.io/guidelines/#scss>

### Comments

Sass supports standard multiline CSS comments (`/* */`), as well as single-line comments (`//`).

-   Multiline comments are preserved in the CSS output where possible.
-   Single-line comments are removed.
-   When the first letter of a multiline comment is `!`, the comment will always rendered into css output (even in compressed output modes).

### Partials

A partial Sass file is a file named with a leading underscore (eg: `_file.scss`), it’s intended for inclusion into other files through the `@import` directive, so Sass won’t generate a CSS file counterpart for a partial.

Compass
-------

-   [Compass configuration reference](http://compass-style.org/help/documentation/configuration-reference/)
-   [Compass: Sass-based configuration options](http://compass-style.org/help/documentation/sass-based-configuration-options/)

