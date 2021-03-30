---
title: Kernel configurations
summary: >
 Common actions and configurations for setting up the kernel on Gentoo
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

Based on Configurations
============================================================
* [Config](/config/) | [Gentoo](/config/gentoo/) | [Development Workstation Install](/config/gentoo/developmentWorkstationInstall/)
* [Config](/config/) | [Gentoo](/config/gentoo/) | [Docker on Development machine](/config/gentoo/docker/)


TODO
============================================================
* Compare "make tinyconfig" to default hardend gentoo kernel config and see what else can be removed.  Base kernel settings below on delta
  from tinyconfig to used config


Build Settings
============================================================

* Binary blobs[@Multiple2015]

    * Remove freedist from ACCEPT_LICENSE

        * /etc/portage/make.conf

            ```ini
            ACCEPT_LICENSE="-* @FREE"
            ```

    * Deblog kernel sources on extraction

        * /etc/portage/package.use

            ```text
            # Deblob kernel sources
            sys-kernel/gentoo-sources deblob
            ```
            
Kernel settings
============================================================
The linux kernel has a myriad of settings.  Below are the settings
that I either

* make sure are turned on
* turn off all the time
* have selected based on the specified conditions

All other settings have been left on default

* General setup
    + Local Version - **YYYYMMDD-##** where ## is one up number when building more than one version a day
    + Control Group Support
        - Freezer cgroup subsystem - **built-in** - required by app-emulation/docker
        - Device controller for cgroups - **built-in** - required by app-emulation/docker
        - Resource counters - **built-in** - Optional for Docker 
            - Memory Resource Controller for Control Groups - **built-in** - for below dep
                - Memory Resource Controller Swap Extension - **built-in** - optional for app-emulation/docker
        - Enable perf_event per-cpu per-container group (cgroup) monitoring - **built-in** - optional for app-emulation/docker
        - Group CPU scheduler
            - Group scheduling for SCHED_OTHER
                - CPU bandwidth provisioning for FAIR_GROUP_SCHED - **built-in** - optional for app-emulation/docker
    + Initial RAM filesystem and RAM disk (initramfs/initrd) support
        + Initramfs source file(s):  **/usr/src/linux/initramfs/initramfs_list** - Builds intramfs with the specified list

* Processor type and features
    * Linux Guest support  - **CHOOSE**: Enable if VM kernel, off otherwise
    * Supported processor vendors
        * Support Intel processors - **CHOOSE** if intel processor
        * Support AMD processors   - **CHOOSE** if amd processor
        * ~~Support Centaur processors~~
    * ~~IBM Calgary IOMMU support~~
    * Intel MCE features - **CHOOSE** if intel processor
    * ~~Dell laptop support~~
    * Intel microcode loading support - **CHOOSE** if intel processor

* Power management and ACPI options
    + ACPI (Advanced Configuration and Power Interface) Support - **built-in**: Allow linux to control power

* Bus options
    * ~~PCCard (PCMCIA/CardBus) support~~

* Networking support
    * Networking options
        * 802.1d Ethernet Bridging - **module**: required by app-emulation/docker
        * Network packet filtering framework (Netfilter)
            * Core Netfilter Configuration
                * Netfilter connection tracking support - **Module**: required by "IPv4 connection tracking support"
                * Netfilter Xtables support
                    * "addrtype" address type match support - **Module**: required by app-emulation/docker
                    * "conntrack" connection tracking match support - **Module**: required by app-emulation/docker
            * IP: Netfilter Configuration
                * IPv4 connection tracking support - **Module**:  required by "IPv4 NAT"
                * IPv4 NAT - **Module** - required by app-emulation/docker
                * IP tables support
                    * Packet filtering - **Module**: required by app-emulation/docker
                    * iptables NAT suppoort
                        * MASQUERADE target support - **Module**: required by app-emulation/docker
    * ~~Wireless~~

* Device Drivers
    + Generic Driver Options
        - Automount devtmpfs at /dev, after the kernel mounted the rootfs - **built-in**
    * ~~Macintosh device drivers~~
    + Network Device support
        + Ethernet driver suppot
            - Realtek 8169 gigabit ethernet support - **CHOOSE** if realtek 8169 card
        + MAC-VLAN support - **module**: required by app-emulation/docker
        + Virtual ethernet pair device - **module**: required by app-emulation/docker
    + Input device support
        + Event interface    - **built-in**: needed for Xorg
    * Character devices
        * Support multiple instances of devpts - **ON** - required by app-emulation/docker
    + Graphics Support
        + Direct Rendering Manger
            + Nouveau (nVidia) cards - **CHOOSE** if nVidia card
    * Sound Card support
        * Advanced Linux Sound Architecture
            * HD-Audio
                * Pre-Allocated buffer size for HD-audio driver - **2048** - recommend by media-sound/pulseaudio
    * ~~Ultra Wideband devices~~
    * ~~LED Support~~
    * ~~Accessibility support~~
    * ~~InfiniBand support~~

* File Systems
    + The Extended 4 (ext4) filesystem -**module**: Not needed on boot
    + Reiserfs support -**module**: Not needed on boot
    + JFS filesystem support -**module**: Not needed on boot
    + XFS filesystem support -**module**: Not needed on boot
    + Btrfs filesystem support - **built-in**: btrfs used as primary filesystem
        + Btrfs POSIX Access Control Lists - **built-in**
        + Btrfs will run sanity tests upon loading - **built-in**
    * ~~Quota support~~
    * Network File Systems
        * ~~NFS client support~~
        * Ceph distributed file system - **module**: Going to be experimenting with ceph as backend

* Library routines
    * ~~PowerPC BCJ filter decoder~~
    * ~~ARM BCJ filter decoder~~
    * ~~ARM-Thumb BCJ filter decoder~~
    * ~~SPARC BCJ filter decoder~~


Building an updated kernel
============================================================
* Make sure system is up to date

    * Do first half of [Cookbook](/cookbook/) | [Gentoo Recipes](/cookbook/gentoo/) | [Update Install](/cookbook/gentoo/updateInstall/) stopping before "Clean obsolete".  Since the clean will remove old kernel source.

* (Optional) If just rebuilding the existing version then backup just in case

    ```bash
    # Backup existing
    cd /usr/src
    # See current version
    ls -ld linux
    cp -a <CURRENT Kernel> <CURRENT Kernel>.YYYYMMDD
    ```


* Select desired kernel

    ```bash
    eselect kernel list
    eselect kernel set 1
    ```

* Start with current settings and update

    ```bash
    cd /usr/src/linux
    # Current running kernel config
    zcat /proc/config.gz > /usr/src/linux/.config
    # Accept defaults for any new kernel settings
    make oldconfig
    # Copy previous initramfs config to new kernel
    cp -a ../<PREVIOUS Kernel>/initramfs/ .
    ```

* Build and install

    ```bash
    KERNELVER=#.##.# based on kernel being built
    EXTENSION=YYYMMDD-##      - Set to the value of "General setup | Local version" from kernel config
    make modules_prepare
    make && make modules_install
    cp .config /boot/config-${KERNELVER}-gentoo-gnu${EXTENSION}
    cp System.map /boot/System.map-${KERNELVER}-gentoo-gnu${EXTENSION}
    cp arch/x86_64/boot/bzImage /boot/kernel-${KERNELVER}-gentoo-gnu${EXTENSION}
    grub2-mkconfig -o /boot/grub/grub.cfg
    cp -a .config ../${KERNELVER}-${EXTENSION}.config.bk
    ```







References
============================================================
