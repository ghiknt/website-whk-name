#!/bin/bash
mkdir -p gitrepos
git2markdown.pl --project git2markdown --repository=$HOME/src/git2markdown gitrepos/tools/git2markdown
git2markdown.pl --project whk.name --repository=$HOME/web/whk-name gitrepos/websites/whk.name
nanoc compile

