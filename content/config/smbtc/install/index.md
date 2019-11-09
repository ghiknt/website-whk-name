---
title: Install tool chains
summary: >
 Steps to install on a fresh machine
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2018-01-16
modified: 2018-01-16
reviewed: 2018-01-16
changes:
  -
    date: 2018-01-16
    description: Initial creation 

---

## Assumptions

* Docker configured for running os
* Git configured for running os

## Chain to build

![Tool Chain](containers.png)

## build

```bash
# Pull the official base gentoo image
#  TODO: Figure out way to control this to get fixed image but still get updates
#        at appropriate times
docker pull gentoo/stage3-amd64-hardened

# Build our base container which is used to generate all the other containers
git clone https://whk.name/src/containers/gentoo-base/gentoo-base.git/
cd gentoo-base
#  Verify "From" tag in Dockerfile since origin changes at times
vi Dockerfile
# Build
./build.sh




References
============================================================
