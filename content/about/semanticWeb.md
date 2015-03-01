---
title: Metadata standards used for Semantic Web 
summary: >
 Various techniques to include metadata both in web pages and source
 code to simplify autogeneration, licensing, etc
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2013-03-23
modified: 2015-03-01
reviewed: 2015-03-01
changes:
  -
    date: 2015-03-01
    description: Transfered from old doc repo and converted to markdown 

---


Metadata standards used
======================================================================

RDFa Lite 1.1
----------------------------------------------------------------------
RDFa Lite is a light weight microdata format for HTML5 created by the
[W3C](http://www.w3.org/)

* title tag add: property="dc:title"
* add created date
* add last modified date

Schema.org
------------------------------------------------------------------------
The Schema.org microdata schema is sponsored by Google, Inc., Yahoo, Inc., and Microsoft Corporation.
It allows search engines to better identify the content. 

Standard settings for every page
======================================================================
* Define usage
    * html tag add: version="HTML+RDFa 1.1"
    * body tag add: prefix="dc: http://purl.org/dc/terms/ schema: http://schema.org/"
    * Set license
        * Specify license at end with:  property="dc:license" in anchor pointing to license

Settings used for article pages
=======================================================================
* Add the following attributes to the div surrounding all the content:
    * ```resource="%span=@item.path"```
    * ``` typeof="schema:Article"```
* Set the article title with: property="dc:title schema:name"
* Set the created/copywrite date with: property="dc:dateCopyrighted schema:dateCreated"
* Set the last update date with: property="dc:modified schema:dateModified"
* Tag the summary with: property="dc:abstract schema:description"
* Put a div around the actual article with: property="schema:articleBody"



References
============================================================
