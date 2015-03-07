---
title: Package Managers - Install
summary: Each language and sometimes project seems to have it's favorite package manager.  So install the basic ones
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2014-10-05
modified: 2015-01-25
reviewed: 2015-01-25
changes:
 - { date: 2015-01-25, description: "Moved from docs to erpetu, updated metadata, modified from ubuntu to gentoo" }
---

Python - pip
======================================

```bash
# Use python 2.7 for now.  pandoc-zotxt extension doesn't work on python 3.3
eselect python set 1
python-updater
# Install pip
emerge --ask dev-python/pip
```

Nodejs - npm
======================================

```bash
# Installed as part of nodejs
emerge --ask net-libs/nodejs
```

Web - bower
======================================

```bash
# requires npm (see above)
npm install -g bower
```

