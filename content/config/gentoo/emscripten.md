---
title: Configure emscripten
summary: >
 Configure emscripten and dependencies on Gentoo
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2015-03-06
modified: 2015-03-06
reviewed: 2015-03-06
changes:
  -
    date: 2015-03-06
    description: Initial creation 

---

* Emerge nodejs

    ```bash
    emerge --ask net-libs/nodejs
    ```
* Install emscripten sdk [@EmscriptenContributorsa]

    * Download  latest "Portable Emscripten SDK for Linux and OS X"
    * Expand, update, activate and configure environment

        ```bash
        tar -xzvf Downloads/emsdk-portable.tar.gz 
        cd emsdk_portable/
        ./emsdk update
        ./emsdk install latest
        ./emsdk activate latest
        source ./emsdk_env.sh 
        ```

     * Verify it works

         ```
         cd emscripten/master
         emcc tests/hello_world.c
         node a.out.js
         emcc tests/hello_world.c -o hello.html
         # Test in browser
         emcc tests/hello_world_sdl.cpp -o hello.html
         # Test DSL in browser
         python tests/runner.py 
         ```


References
============================================================
