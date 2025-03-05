---
title: Semantic Web 
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
  - 
    date: 2015-03-01
    description: Update with current configuration
---


Markup
======================================================================

This site currently uses three standards to convey semantic information
about the pages


HTML5 Semantic Elements [@w3schools]
----------------------------------------------------------------------
The new HTML5 semantic elements help to convey information about the 
content in the page.  To the greatest extent possible each page will
utilized the semantic tags instead of the non-semantic ones.

* The [W3C Markup Validation Service](http://validator.w3.org/) can be used
  to verify HTML5 compliance


RDFa Lite 1.1 [@W3Ca]
----------------------------------------------------------------------
[RDFa Lite](http://www.w3.org/TR/rdfa-lite/) is a light weight microdata format for HTML5 created by the
[W3C](http://www.w3.org/). It is my prefered method for marking up semantic
information and will be used by default

* The [W3C RDFa Validator](http://www.w3.org/2012/pyRdfa/Validator.html) can be used
  to verify RDFa compliance

Meta
---------------------------------------------------------------------
The HTML meta tag is used to convey some information that appears to be
standardly parsed and also to convey non-visible RDFa Lite information


Ontologies
=======================================================================

Schema.org
-----------------------------------------------------------------------
The Schema.org microdata schema is sponsored by Google, Inc., Yahoo, Inc., and Microsoft Corporation.

* It allows search engines to better identify the content.
* Its site is laid out in a an easy to understand manner with plenty of examples
* Proper markup can be tested from the [Google Testing Tool](https://developers.google.com/structured-data/testing-tool/) 

* declaration (default): ```<html vocab="http://schema.org/" ...>```{.html}

foaf (Friend of a Friend)
-----------------------------------------------------------------------
* declaration: ```<html ... prefix="foaf: http://xmlns.com/foaf/0.1/ ...">```{.html}

wot (Web of Trust)
-----------------------------------------------------------------------
* declaration: ```<html ... prefix="... wot: http://xmlns.com/wot/0.1/">```{.html}

data-vocabulary.org
-----------------------------------------------------------------------
* Appears to be slowly replaced by Schema.org
    > Since June 2011, several major search engines have been collaborating on a new common data vocabulary called schema.org. [@zotero-2125552-544]
* Still needed for at least BreadCrumbs by Google
* declaration: ```<div ... prefix="v: http://rdf.data-vocabulary.org/#">```{.html}


MetaData Used
======================================================================

Every page
----------------------------------------------------------------------

* Formatting
    * Character Representation is UTF-8: ```<meta charset="utf-8"/>```{.html}
    * Mobile Friendly[@Multipled]
        - ```<meta name="HandheldFriendly" content="true" />```{.html}
        - ```<meta name="viewport" content="width=device-width, height=device-height, user-scalable=yes,minimum-scale=0.5" />```{.html}
* Web Page information
    * Generator: ```<meta name="generator"  content="CurrentGeneratorAndVersion"/>```{.html}
    * Only put origin in referrer on cross origin reqeusts[@W3C]: ```<meta name="referrer" content="origin-when-crossorigin"/>```{.html}
    * Description: ```<meta name="description" content="YAMLSummary"/>```{.html}
    * Authors: ```<meta property="foaf:maker" content="YAMLAuthorURL">```{.html}
    * Title: ```<title property="foaf:name">YAMLTitle</title>```{.html}
    * Breadcrumbs: Used by Google for Rich Snippet breadcrumb display[@Google]
        ```html
        <div id="breadcrumb" prefix="v: http://rdf.data-vocabulary.org/#" >
          <span typeof="v:Breadcrumb">
            <meta property="v:title" content="CrumbYAMLTitle">
            <a property="v:url" href="CrumbURL">CrumbYAMLTitle</a>
          <span>
          ... Repeat for each breadcrumb ...
        </div>
        ```

* HTML5 Semantic Structure
    ```html
    <head>
      <meta.../>
      <title.../>
    </head>
    <body>
      <header>
        <div id="google"/>       <!-- Google ads and Custom search -->
        <nav id="menu"/>         <!-- Top level navigation menu -->
        <div id="breadcrumb">    
         ... Breadcrumbs ...
        </div>
      </header>
      <main id="content">
         ... Different content described below ...
      </main>
      <footer/>
    </body>
    ```


Tech Article
------------------------------------------------------------------------
TBS

Blog
------------------------------------------------------------------------
TBS

Person
------------------------------------------------------------------------
TBS

References
============================================================

