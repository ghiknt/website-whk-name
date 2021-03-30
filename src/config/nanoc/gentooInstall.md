---
title: Gentoo install and basic configuration 
summary: Installation steps for installing nanoc on Gentoo Linux
type: article
license: ccbysa
author:
 - 
  name: "whk"
  url: "https://whk.name/about/me/#id"
created: 2015-01-11
modified: 2015-03-09
reviewed: 2015-03-09
changes:
  - 
    date: 2015-01-31
    description: "Switched references to pull from zotero"
  - 
    date: 2015-02-11
    description: "Added builder gem"
  - 
    date: 2015-03-08
    description: "Added static data source config and updated title"

---
---
nocite: |
 @Defreynea, @Defreyneb, @zotero-null-399, @zotero-null-401 
---


Installation
=======================================================================

* Install dependencies
    * Ruby
        * /etc/portage/make.conf - Add support for Ruby 2.0

            ```
            RUBY_TARGETS="ruby20"
            ```

        * Install

            ```{.bash .numberLines}
            emerge --ask dev-lang/ruby
            ```

        * Select 2.0 as default

            ```{.bash .numberLines}
            eselect ruby set ruby20
            ```
    * Pandoc
        * /etc/portage/package.accept_keywords

            Inorder to get both app-text/pandoc and dev-haskell/pandoc-citeproc to install I need to accept unstable haskell packages

            ```text
            # accept unstable haskell and pandoc since it is a moving target
            dev-haskell/* ~amd64
            dev-lang/ghc ~amd64
            app-text/pandoc ~amd64
            ```

        * Install

            ```{.bash .numberLines}
            # Haskell <https://wiki.haskell.org/Gentoo/HaskellPlatform> and Pandoc
            emerge --ask emerge haskell-platform app-text/pandoc dev-haskell/pandoc-citeproc
            ```

* Install nanoc using rubygems

    ```{.bash .numberLines}
    gem install nanoc
    # md pandoc rendering
    gem install pandoc-ruby
    # scss to css rendering
    gem install sass
    # all nanoc view
    gem install adsf
    # builder for XMLSitemap
    gem install builder
    ```

Create site shell
=======================================================================

```bash
cd ~/web
nanoc create_site whk.name
```



Configure static directory for static data source [@Defreyne Solution #2: Using the static data source]
==========================================================================================================

* Create the static dir

    ```bash
    cd .../whk.name
    mkdir static
    ```

* Add to nanoc.yaml

    ```yaml
    data_sources:
    # ... filesystem data source here ...
    -
      type: static
      items_root: /assets/

    ```

* Update Rules

    ```ruby
    passthrough '/assets/*'
    ```

References
=======================================================================

