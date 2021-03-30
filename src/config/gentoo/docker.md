---
title: Docker on Development machine
summary: >
 Setting up docker.io to run on development machines
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


* Install based on the "Official way" [@Docker]

    * /etc/portage/package.use

        ```text
        app-emulation/docker btrfs -aufs -device-mapper contrib doc vim-syntax
        ```

    * Attempt to install and get package.accept_keyword mods

        ```bash
        emerge --ask app-emulation/docker
        ```

    * /etc/portage/package.accept_keywords

        ```text
        # Required by docker
        sys-fs/btrfs-progs   ~amd64
        app-emulation/docker ~amd64
        ```

    * Install for real

        ```bash
        emerge --ask app-emulation/docker
        ```

    * Verify all required kernel settings are enabled based on output of package.  In this case
      I need to rebuild kernel with the following.

        ```text
        *   CONFIG_DEVPTS_MULTIPLE_INSTANCES:   is not set when it should be.
        *   CONFIG_CGROUP_DEVICE:   is not set when it should be.
        *   CONFIG_CGROUP_FREEZER:  is not set when it should be.
        *   CONFIG_MACVLAN:     is not set when it should be.
        *   CONFIG_VETH:    is not set when it should be.
        *   CONFIG_BRIDGE:  is not set when it should be.
        *   CONFIG_NF_NAT_IPV4:     is not set when it should be.
        *   CONFIG_IP_NF_FILTER:    is not set when it should be.
        *   CONFIG_IP_NF_TARGET_MASQUERADE:     is not set when it should be.
        *   CONFIG_NETFILTER_XT_MATCH_ADDRTYPE:     is not set when it should be.
        *   CONFIG_NETFILTER_XT_MATCH_CONNTRACK:    is not set when it should be.
        *   CONFIG_NF_NAT:  is not set when it should be.
        *   CONFIG_NF_NAT_NEEDED:   is not set when it should be.
        *   CONFIG_MEMCG_SWAP: is required if you wish to limit swap usage of containers
        *   CONFIG_RESOURCE_COUNTERS: is optional for container statistics gathering
        *   CONFIG_CGROUP_PERF: is optional for container statistics gathering
        ```

    * Rebuild after kernel updated in case anything was excluded due to to kernel

        ```bash
        emerge --ask app-emulation/docker
        ```

    * Update kernel with new optional settings

        ```text
        CONFIG_CFS_BANDWIDTH: is optional for container statistics gathering
        ```

    * Rebuild after kernel updated in case anything was excluded due to to kernel

        ```bash
        emerge --ask app-emulation/docker
        ```

    * Allow me to start containers

        ```bash
        sudo usermod -a -G docker whk
        ```

    * Start docker manually

        ```bash
        sudo service docker start
        ```

* Verify basic functionality[@Dockera]

    ```bash
    # Force docker group on account since already logged in
    newgrp docker
    # Pull busybox layer
    docker pull busybox:latest
    # Verify busybox works
    docker run -it --rm busybox
    ```

* Install Docker Compose

    * /etc/portage/package.accept_keywords

        ```text
        # required by app-emulation/docker-compose-1.2.0-r1::gentoo
        # required by app-emulation/docker-compose (argument)
        dev-python/docker-py ~amd64
        # required by app-emulation/docker-compose (argument)
        app-emulation/docker-compose ~amd64
        # required by app-emulation/docker-compose-1.2.0-r1::gentoo
        # required by app-emulation/docker-compose (argument)
        dev-python/dockerpty ~amd64
        # required by app-emulation/docker-compose-1.2.0-r1::gentoo
        # required by app-emulation/docker-compose (argument)
        dev-python/texttable ~amd64
        ```

    * Install

        ```bash
        emerge app-emulation/docker-compose
        ```


References
============================================================
