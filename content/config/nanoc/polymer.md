---
title: Using Polymer Web Components
summary: >
 Configuring the project to use polymer web components
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2015-03-07
modified: 2015-03-07
reviewed: 2015-03-07
changes:
  -
    date: 2015-03-07
    description: Initial creation 

---

Initial project setup [@PolymerAuthors]
==============================================

```bash
cd whk.name/static
# On final site components are referenced as /assets/webcomponents/...
mkdir webcomponents
cd webcomponents
bower init

    [?] May bower anonymously report usage statistics to improve the tool over time? Yes
    ? name: webcomponents
    ? version: 0.0.1
    ? description: The webcomponents used by whk.name
    ? main file: 
    ? what types of modules does this package expose?: 
    ? keywords: 
    ? authors: https://whk.name/about/me/ (whk) <no-reply@whk.name>
    ? license: AGPL
    ? homepage: 
    ? set currently installed components as dependencies?: Yes
    ? add commonly ignored files to ignore list?: Yes
    ? would you like to mark this package as private which prevents it from being accidentally published to the registry?: Yes

    {
      name: 'webcomponents',
      version: '0.0.1',
      authors: [
        'https://whk.name/about/me/ (whk) <no-reply@whk.name>'
      ],
      description: 'The webcomponents used by whk.name',
      license: 'AGPL',
      private: true,
      ignore: [
        '**/.*',
        'node_modules',
        'bower_components',
        'test',
        'tests'
      ]
    }

    ? Looks good?: Yes

bower install --save Polymer/polymer

```

Install referenced components
=======================================

```bash
cd .../whk.name/static/webcomponents/
bower install --save Polymer/core-elements
bower install --save Polymer/paper-elements
```

References
============================================================
