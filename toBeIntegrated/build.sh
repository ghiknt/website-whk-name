#!/bin/bash
mkdir -p gitrepos
git2markdown.pl --project git2markdown \
                --repository=$HOME/src/git2markdown \
                --license=agpl \
                --description="Convert git repo to markdown" \
                gitrepos/tools/git2markdown
git2markdown.pl --project whk.name \
                --repository=$HOME/web/whk-name \
                --license=ccbysa \
                --description="Source for https://whk.name/" \
                gitrepos/websites/whk.name
git2markdown.pl --project gentoo-base \
                --repository=$HOME/docker/containers/gentoo-base \
                --license=agpl \
                --description="Base container with GENTOO OS to use for other containers" \
                gitrepos/containers/gentoo-base
git2markdown.pl --project lang-haskell-unstable \
                --repository=$HOME/docker/containers/lang-haskell-unstable \
                --license=agpl \
                --description="Latest haskell build on top of gentoo-base container" \
                gitrepos/containers/lang-haskell-unstable
git2markdown.pl --project base-pandoc \
                --repository=$HOME/docker/containers/base-pandoc \
                --license=agpl \
                --description="Pandoc built on top of lang-haskell-unstable for use with other containers" \
                gitrepos/containers/base-pandoc
git2markdown.pl --project lang-ruby-23 \
                --repository=$HOME/docker/containers/lang-ruby-23 \
                --license=agpl \
                --description="Ruby v2.3 built on top of base-pandoc" \
                gitrepos/containers/lang-ruby-23
git2markdown.pl --project tool-nanoc \
                --repository=$HOME/docker/containers/tool-nanoc \
                --license=agpl \
                --description="Nanoc Static Site Builder built on top of lang-ruby-23" \
                gitrepos/containers/tool-nanoc
git2markdown.pl --project service-lighttpd \
                --repository=$HOME/docker/containers/service-lighttpd \
                --license=agpl \
                --description="Basic lighttpd instalation for a backend server" \
                gitrepos/containers/service-lighttpd
nanoc compile

