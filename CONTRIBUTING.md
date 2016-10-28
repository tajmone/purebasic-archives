Contributing to PureBASIC Archives
==================================

Before contributing to this project you should read these guidelines, especially the [Licenses section](#licenses).

<!-- #toc -->
-   [Licenses](#licenses)
    -   [No License = No Reuse-Rights](#no-license--no-reuse-rights)
        -   [Your work need a license too…](#your-work-need-a-license-too)
        -   [Assume others’ work is always copyrighted…](#assume-others-work-is-always-copyrighted)
        -   [If in doubt, provide links instead of code…](#if-in-doubt-provide-links-instead-of-code)
-   [READMEs And Other MD Files](#readmes-and-other-md-files)

<!-- /toc -->
Licenses
========

Before submitting resources to this repo, you must check carefully their license terms, and include each resource’s license along with it.

No License = No Reuse-Rights
----------------------------

### Your work need a license too…

If you are contributing resources which are your creation, then you should decide under which license terms to release them. Unless you provide a license for your contributed work, people won’t be able to legally benefit from it:

> When you make a creative work (which includes code), the work is under exclusive copyright by default. Unless you include a license that specifies otherwise, nobody else can use, copy, distribute, or modify your work without being at risk of take-downs, shake-downs, or litigation. Once the work has other contributors (each a copyright holder), “nobody” starts including you.
>
> http://choosealicense.com/no-license

If you’re not sure how licenses work, and which license would better serve your intentions, try visiting these links:

-   http://choosealicense.com
-   https://opensource.org/licenses

If you wish to waive all claims on you work, and release it under the public domain, consider using the Unlicense:

-   http://unlicense.org

Stating that your work is public domain might not suffice, because “public domain” is not legally binding in all countries. A proper license, like the Unlicense document, will ensure that your work will be treated as public domain world-wide.

### Assume others’ work is always copyrighted…

If you want to contribute resources found around the web — code examples found on forums, code and resources found on other repositories —, then you must check that the code/resources in question come with a statement regarding their license terms:

> If you find software that doesn’t have a license, that generally means you have no permission from the creators of the software to use, modify, or share the software. Although a code host such as GitHub may allow you to view and fork the code, this does not imply that you are permitted to use, modify, or share the software for any purpose.
>
> http://choosealicense.com/no-license/\#for-users

Just because someone posted some code on a forum — maybe to exemplify an answer during a discussion — it doesn’t mean that that code is in the public domain — it only means the author allowed others to *read* it, not to use it.

In lack of evidence to the contrary, always assume the work of others is protected by copyright — only because some source code is out there in the open, it doesn’t mean it’s free and open source. When unsure, always contact the author and ask.

### If in doubt, provide links instead of code…

Whenever you are unable to ascertain the license terms of any resource, stay on the safe path and contribute a link to it and/or a review, instead of the actual resource.

The goal of PureBASIC Archives is to provide a place where resources can be *legitimately* and *legaly* accessed and shared. If a resource can be included in the repository, so much the better — all those sharing a local copy of it will find the new resources on their harddrive —; if not, a link to follow will still be a precious resource in itself — sparing our users time-consuming searches around the web.

READMEs And Other MD Files
==========================

To preserve consistency across markdown files in the repo — especially for the README files — you’ll find some useful scripts in the [`/repo-maintainance-tools/`](./repo-maintainance-tools/) folder.

These scripts will handle auto-generation of a Table Of Content, to be placed somewhere at the beginning of a MD document. If you peek into the markdown sources, you’ll notice two HTML comment tags enclosing the TOC:

    <!-- #toc -->
          ...
    <!-- /toc -->

… these hidden tags (invisible in HTML previews) are needed for the autogeneration of the TOC (which is handled by a Node.js tool called **gfmtoc**).

Also, these scripts will reformat and cleanup markdown sources (via **Pandoc**), enforcing a standard over markdown syntax variants — apart from providing consistency, this prevents markdown diffing nightmares when resolving merge conflicts.

So make sure that:

1.  You don’t accidentally remove the TOC-tags;
2.  You don’t use a markdown editor which removes these tags (for example, current version of the [**Texts**](http://www.texts.io/) editor removes them, but the issue should be soon fixed);
3.  Before making a pull request, you run these scripts on any edited MD document, to ensure its TOC is up to date with the contents, and it source well formatted.

More info on how the scripts work is found in the [`/repo-maintainance-tools/`](./repo-maintainance-tools/) folder’s README file.
