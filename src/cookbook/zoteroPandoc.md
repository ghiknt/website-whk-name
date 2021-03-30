---
title: Zotero/Pandoc Integration
summary: >
 A Zotero exporter with fixed citation keys used in conjuction with a pandoc filter allows easy integration of citations in 
 pandoc's markdown format
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2014-10-05
modified: 2018-08-05
reviewed: 2019-08-05
changes:
 - { date: 2015-01-25, description: "Moved from docs to erpetu and updated metadata" }
 - { date: 2018-08-05, description: "Updated zotero-better-bibtex instructions for using zotero desktop rather than old firefox plugin" }
---
---
nocite: |
 @Zotero2013, @MacFarlaneJohna
---

Exporter options
================================

I have found two of the exporters useful.  For me the primary definition of useful is that it provides a way to have a consistent reference tag.

* [zotero-better-bibtex](https://github.com/ZotPlus/zotero-better-bibtex#zotero-better-biblatex-bbt-) requires the export from Zotero to biblatex (.bib) file.  For my purposes this one is better since the bibliography can be included in the websites git repo. 
* [zotxt](https://bitbucket.org/egh/zotxt) by Erick Hetzner gives real time access to your Zotero database but required that Firefox be up when exporting

zotero-better-bibtex [@ZotPlus]
-----------------------------------

### Installation into Zotero Desktop on Linux [@BetterBibTeXZotero]

* Download latest xpi file from <https://github.com/retorquere/zotero-better-bibtex/releases/latest> by right clicking and doing "save link as".  Otherwise Firefox tries to install
* Install into Zotero Desktop
    * Tools | Add-ons | Extensions | Install Add-on From file
    * Select .xpi and Install
    * restart Zotero

* Configure dialog
    * Selected "I have used BBT before"
    * Leave selected "Enable drag-and-drop citations"

### Usage

* Set a fixed tag

    * In Zotero Desktop right-click on reference
    * Better BibTeX | Pin BibTeX Key
    * Key is available from "Extras" field on right

* Export library

    * In Zotero Desktop right-click on the collection to export
    * Select "Export Collection"
    * Set Format to "Better BibLaTex" and select "OK"
    * Name file and select "Save"

* Manually Applying bibliography

    ```bash
    pandoc --filter pandoc-citeproc --bibliography **EXPORTEDFILE**.bib document.md
    ```

* example nanoc rule to apply bibliography to all markdown files

    ```ruby
    ...

    when 'md'
      opts = {:to => :html5,
              'base-header-level' => 2,
              :filter => 'pandoc-citeproc',
              'data-dir' => 'content/bibliography/',
              :bibliography => 'content/bibliography/erpetu.bib',
              :csl => 'content/bibliography/elsevier-with-titles.csl'}
      filter :pandoc, opts  
    ...
    ```


zotxt option [@Hetzner]
----------------------------------

### These instructions are probably obsolete.  Zotero had to move to only desktop program due to Firefox add-on changes.  Please check zotxt's site for any updates.

### Additional Requirements
* [Python - pip package manager](/cookbook/packagemanagers#python---pip)

### Installation
* Firefox add-on
    * In firefox go to <https://addons.mozilla.org/en-US/firefox/addon/zotxt/> 
    * Select "Add to Firefox"
    * Restart Firefox so Zotero picks up Easy CiteKey
* Zotero configuration
    * Select the Actions Menu (Gear Icon)
    * Select Preferences
    * Select the Export Tab
    * Set the Default Output Format to "Easy Citekey"
* pandoc-zotxt

    ```bash
    sudo pip install pandoc-zotxt
    ```

### Usage

* To run the filter manually

    ```bash
    pandoc -F pandoc-zotxt -F pandoc-citeproc document.md
    ```



References
================================
<!-- Auto filled in by Pandoc's citeproc -->
