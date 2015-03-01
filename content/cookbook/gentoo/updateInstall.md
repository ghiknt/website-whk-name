---
title: Update Install
summary: Commands to make sure everything is updated and consistent
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2015-01-25
modified: 2015-02-28
reviewd: 2015-02-29
changes:
  -
    date: 2015-02-28
    description: update haskell if it breaks update

---

* Update index

    ```bash
    emerge --sync
    ```

* Rebuild if broken packages block updates

    * Haskell

        ```bash
        haskell-updater
        ```

* Update the world

    ```bash
    emerge --ask --update --deep --newuse --with-bdeps=y @world
    ```

    * If there are "Detected broken packages" issues with haskell packages during update. Then fix
      and repeat update

        ```bash
        revdep-rebuild
        haskell-updater
        emerge --ask --update --deep --newuse --with-bdeps=y @world
        ```

* Clean obsolete

    ```bash
    # Check what would be removed
    emerge -p --depclean
    # If happy then remove them
    emerge --ask --depclean
    ```

* Update dependencies

    ```bash
    # I think revdep-rebuild show take care of it all
    revdep-rebuild
    # python just in case
    python-updater
    # haskell just in case
    haskell-updater
    # verify java is good
    java-check-environment
    # ruby?
    # ???
    # perl?
    # ???
    ```
