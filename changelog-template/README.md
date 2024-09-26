# Template For Changelog File

This is *not* a changelog for this project, but a template I
use when starting new projects.  

For me the changelog file is part of both my push and release process.
For each release I add a section with a high level summary of changes
since the previous release.  That high level summary in turn comes
from a section at the top of the changelog where I document headline
changes as I make commits to the repository.  In this way the "changes
since the last release" section I update over time becomes the summary
when I decide to make a release.

Part of my release process is to create a git tag for each release
with the git-make-release.rb script.  That script uses the contents of
a file named 'next-tag.org' in the root of the git repository as the
tag comment.  That file contains a title line and the contents of the
changelog section named "Changes On HEAD Since Last Release".  The
changelog file has some code at the bottom that automates updating
that next-tag.org file.

Note that template is an org-mode file, not a markdown file.  I
normally put it in the docs directory, and expose it via github.io --
here is an example of what one looks like:

   https://richmit.github.io/mraster/changelog.html

Have Fun!
-mitch
