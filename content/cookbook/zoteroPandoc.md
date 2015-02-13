---
title: Zotero/Pandoc Integration
summary: >
 The zotxt firefox addon used in conjuction with pandoc-zotxt allows easy integration of citations in 
 pandoc's markdown format
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/" }
created: 2014-10-05
modified: 2015-01-25
reviewed: 2015-01-25
changes:
 - { date: 2015-01-25, description: "Moved from docs to erpetu and updated metadata" }
---
---
nocite: |
 @Zotero2013, @MacFarlaneJohna
---

Requirements 
================================
* Firefox 
* Zotero Firefox add-on 

Exporter option
================================

I have found two of the exporters useful.  For me the primary definition of useful is that it provides a way to have a consistent reference tag.

* [zotxt](https://bitbucket.org/egh/zotxt) by Erick Hetzner gives real time access to your Zotero database but requires that Firefox be up when exporting
* [zotero-better-bibtex](https://github.com/ZotPlus/zotero-better-bibtex#zotero-better-biblatex-bbt-) requires the export from Zotero to biblatex (.bib) file.  For my purposes this one is better since the bibliography can be included in the websites git repo. 

zotxt option [@Hetzner]
----------------------------------

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

zotero-better-bibtex [@ZotPlus]
-----------------------------------

### Installation

* Firefox add-on
    * In firefox go to <https://github.com/ZotPlus/zotero-better-bibtex#installation-one-time> and install the latest xpi

### Usage

* Set a fixed tag

    * In firefox right-click on reference
    * select "Generate BibTeX Key"
    * Key is available from "Extras" field on right

* Export library

    * In firefox right-click on the collection to export
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




References
================================
<!-- Auto filled in by Pandoc's citeproc -->
