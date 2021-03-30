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

Excluding Kernel Sources from being deleted[@Kazantsev2009]
====================================================================================
TODO: Verify that this doesn't block getting new kernel sources


```bash
cat <<EOF >> /etc/portage/sets.conf
# Exclude kernel sources from being purged by "emerge --depclean"
# https://archives.gentoo.org/gentoo-user/message/05119579cc8ab2b1030ee6eb74bf65a3
[kernels]
class = portage.sets.dbapi.OwnerSet
world-candidate = False
files = /usr/src
EOF

cat <<EOF >> /var/lib/portage/world_sets
@kernels
EOF

```


Doing an update
====================================================================================

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

References
==============================================================
