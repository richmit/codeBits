# Code templates & Snippets

This repo houses various bits of code I use with Emacs to automate
things when I'm programming.

For example the templates and license files are used by Emacs via a
function called MJR-prepend-header-der.  This function can figure out
what header and/or template to apply to a buffer.  While doing that it
will also expand macros in the header template to current values.  It
will even add an appropriately formatted license/copyright notice.
This function can operate on one file or many via dired.

The cheaderSTD.txt file has a list of headers and the comment I like
to include on them.  I have an Emacs function called
MJR-fix-c-includes-der that finds includes, and updates them so they
look like the include lines in cheaderSTD.txt -- i.e. it formats them
and adds the comment.  This function can operate on one file or many
via dired.

Lastly the bin directory contains some scripts I use within Emacs
org-mode to generate web pages.  One can pull out various bits of
header information for inclusion into web pages.  In particular this
script can pull out the "filedetails" section from the header and
transform some Doxygen markdown into org-mode markdown.  The other
script pulls out the code itself and edits it for inclusion in
org-mode documents as source blocks.

-mitch
