---
title: Base Container
summary: >
 A basic Gentoo container to use as the starting point for other services
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2015-05-23
modified: 2015-05-23
reviewed: 2015-05-23
changes:
  -
    date: 2015-05-23
    description: Initial creation 

---

* Trust Gentoo keys

```bash
# Pull Keys
# Expires 2015/11/24 Gentoo Portage Snapshot Signing Key (Automated Signing Key)
gpg  --keyserver pgp.mit.edu --recv-keys 0xDB6B8C1F96D8BF6D
# Expires 2016/08/13 Gentoo Linux Release Engineering (Gentoo Linux Release Signing Key)
gpg --keyserver pgp.mit.edu --recv-keys 0x9E6438C817072058
# Expires 2015/08/24 Gentoo Linux Release Engineering (Automated Weekly Release Key)
gpg --keyserver pgp.mit.edu --recv-keys 0xBB572E0E2D182910
# Verify Fingerprint
gpg --fingerprint
# 0xDB6B8C1F96D8BF6D DCD0 5B71 EAB9 4199 527F 44AC DB6B 8C1F 96D8 BF6D
# 0x9E6438C817072058 D99E AC73 79A8 50BC E47D A5F2 9E64 38C8 1707 2058
# 0xBB572E0E2D182910 13EB BDBE DE7A 1277 5DFD B1BA BB57 2E0E 2D18 2910
# Sign but don't trust them to sign other keys
# since they are group keys and I don't know the control
gpg --edit-key C9189250 sign
trust
1
quit
gpg --edit-key 1415B4ED sign
trust
1
quit
gpg --edit-key 2D182910 sign
trust
1
quit
```


* Start with the stock gentoo amd64 hardened image

    ```bash
    git clone git@github.com:gentoo/gentoo-docker-images.git
    cd gentoo-docker-images/amd65-hardened
    # Start docker service if not running
    sudo service docker start
    # Create the container
    ./build.sh
    # Sanity check
    docker run -it --rm gentoo:latest-hardened bash
    ```

* .../base/Docker

    




References
============================================================
