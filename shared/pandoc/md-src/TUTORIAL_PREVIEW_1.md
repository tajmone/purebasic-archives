Typography
==========

This section offers a quick preview of how CSS styles are rendered via the **Tutorial** pandoc template.

Inline styles
-------------

This is paragraph, with some **bold words**, some *italic words*, and a ~~striked out sentence~~. Now a sample of `inline code`.

Extra features: <mark>highlighted text</mark>, and keystrokes: <kbd>Ctrl</kbd><kbd>C</kbd> — for these, you’ll need to use raw html tags in markdown sources:

-   `<mark>`<mark>highlighted text</mark>`</mark>`
-   `<kbd>`<kbd>keyname</kbd>`</kbd>`.

Headers
-------

This is how headers are rendered:

<p class="fake-h1">Header 1</p>
<p class="fake-h2">Header 2</p>
<p class="fake-h3">Header 3</p>
<p class="fake-h4">Header 4</p>
<p class="fake-h5">Header 5</p>
<p class="fake-h6">Header 6</p>
Lists
-----

Ordered (numbered) list:

1.  fruits
    1.  oranges
    2.  apples
    3.  bananas
2.  vegetables
    1.  cabbage
    2.  peas
    3.  potatos

Unordered (bullet) list:

-   fruits
    -   oranges
    -   apples
    -   bananas
-   vegetables
    -   cabbage
    -   peas
    -   potatos

Block Elements
==============

Blockquotes
-----------

> This is a `<blockquote>` quotation. Pellentesque **habitant** *morbi* tristique senectus et netus et ~~malesuada fames~~ ac turpis egestas. <mark>Vestibulum tortor quam</mark>, feugiat vitae, `ultricies eget`, tempor sit amet, ante. <kbd>SHIT</kbd><kbd>R</kbd>
>
> Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.
>
> > **A NESTED QUOTE**. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.

Tables
------

| HEADER 1            | HEADER 2 |
|---------------------|----------|
| First Row — Cell 1  | Cell 2   |
| Second Row — Cell 1 | Cell 2   |
| Third Row — Cell 1  | Cell 2   |

Alerts
------

Alerts are an extra feature to display boxed contents intended to catch the user’s attention. In Markdown, you’ll need raw html div tags to enable alerts.

<div class="alert">
**NOTE**: This is a basic alert box, intended for **Notes**.

Markdown contents is wrapped in a `<div class="alert">`. </div>

<div class="alert alert-info">
**TIP**: This is an info alert box, intended for **Information** notes, **Tips**, ecc.

Markdown contents is wrapped in a `<div class="alert alert-info">`. </div>

<div class="alert alert-warn">
**WARNING**: This is a warning alert box.

Markdown contents is wrapped in a `<div class="alert alert-warn">`. </div>

<div class="alert alert-error">
**WRONG**: This is an error alert box to warn users about anything that is wrong, negative, risky, ecc.

Markdown contents is wrapped in a `<div class="alert alert-error">`. </div>

<div class="alert alert-success">
**RIGHT**: This is a success alert box to warn users about anything that is positive, correct, working, ecc.

Markdown contents is wrapped in a `<div class="alert alert-success">`. </div>
