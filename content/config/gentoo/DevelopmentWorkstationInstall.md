---
title: Development Workstation Install 
summary: Installation and configuration of a development workstation running Gentoo Linux
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/" }
created: 2014-11-13
modified: 2015-01-24
reviewed: 2015-01-24
changes:
 - { date: 2015-01-24, description: "Moved from docs to erpetu and updated metadata" }
---


Configure Disks
=======================================================================


Remove old md raid config
-----------------------------------------------------------------------

```bash
mdadm --detail /dev/md127
#    /dev/md127:
#            Version : 1.2
#      Creation Time : Sun Sep 25 00:06:59 2011
#         Raid Level : raid5
#         Array Size : 2930284032 (2794.54 GiB 3000.61 GB)
#      Used Dev Size : 976761344 (931.51 GiB 1000.20 GB)
#       Raid Devices : 4
#      Total Devices : 4
#        Persistence : Superblock is persistent
#
#        Update Time : Thu Nov 13 03:55:11 2014
#              State : clean 
#     Active Devices : 4
#    Working Devices : 4
#     Failed Devices : 0
#      Spare Devices : 0
#
#             Layout : left-symmetric
#         Chunk Size : 512K
#
#        Number   Major   Minor   RaidDevice State
#           4       8       64        0      active sync   /dev/sde
#           6       8       32        1      active sync   /dev/sdc
#           3       8       48        2      active sync   /dev/sdd
#           5       8        0        3      active sync   /dev/sda

mdadm --stop /dev/md127
```

Partition drives using cgdisk
-----------------------------------------------------------------------

```bash
cgdisk /dev/sdb
    * New
        - 2048 (default)
        - 4M
        - EF02
        - grub2biosboot
    * New 
        - 10240 (default)
        - 234431375 (default)
        - 8300 (default)
        - root
    * Write

gdisk /dev/sdb
    GPT fdisk (gdisk) version 0.8.10

    Partition table scan:
      MBR: protective
      BSD: not present
      APM: not present
      GPT: present

    Found valid GPT with protective MBR; using GPT.

    Command (? for help): p
    Disk /dev/sdb: 234441648 sectors, 111.8 GiB
    Logical sector size: 512 bytes
    Disk identifier (GUID): 287FEB34-C8F0-4223-B73E-03B101DD3EF1
    Partition table holds up to 128 entries
    First usable sector is 34, last usable sector is 234441614
    Partitions will be aligned on 2048-sector boundaries
    Total free space is 2014 sectors (1007.0 KiB)

    Number  Start (sector)    End (sector)  Size       Code  Name
       1            2048           10239   4.0 MiB     EF02  grub2biosboot
       2           10240       234441614   111.8 GiB   8300  root

    Command (? for help): q

cgdisk /dev/sda
    * New
        - 2048 (default)
        - 16G
        - 8200
        - swap
    * New 
        - 33556480 (default)
        - 1919968655 (default)
        - 8300
        - btrfsraid

    * Backup
        - /tmp/raid.part
    * Write
    * Quit

cgdisk /dev/sdc
    * Load
        - /tmp/raid.part
    * Write
    * Quit

cgdisk /dev/sdd
    * Load
        - /tmp/raid.part
    * Write
    * Quit

cgdisk /dev/sde
    * Load
        - /tmp/raid.part
    * Write
    * Quit

gdisk /dev/sda 
    GPT fdisk (gdisk) version 0.8.10

    Partition table scan:
      MBR: protective
      BSD: not present
      APM: not present
      GPT: present

    Found valid GPT with protective MBR; using GPT.

    Command (? for help): print
    Disk /dev/sda: 1953525168 sectors, 931.5 GiB
    Logical sector size: 512 bytes
    Disk identifier (GUID): 0505A724-5723-4E3A-B4A2-09DACFCD7A8A
    Partition table holds up to 128 entries
    First usable sector is 34, last usable sector is 1953525134
    Partitions will be aligned on 2048-sector boundaries
    Total free space is 2014 sectors (1007.0 KiB)

    Number  Start (sector)    End (sector)  Size       Code  Name
       1            2048        33556479   16.0 GiB    8200  swap
       2        33556480      1953525134   915.5 GiB   8300  btrfsraid

    Command (? for help): q
```


Setup swap
-----------------------------------------------------------------------
```bash
mkswap /dev/sda1 --label swap1
mkswap /dev/sdc1 --label swap2
mkswap /dev/sdd1 --label swap3
mkswap /dev/sde1 --label swap4
swapon -L swap1
swapon -L swap2
swapon -L swap3
swapon -L swap4
swapon --summary
#    Filename                                Type        Size    Used     Priority
#    /dev/sda1                               partition   16777212        0       -1
#    /dev/sdc1                               partition   16777212        0       -2
#    /dev/sdd1                               partition   16777212        0       -3
#    /dev/sde1                               partition   16777212        0       -4
```


Make file systems
-----------------------------------------------------------------------
```bash
mkfs.btrfs -L SSD /dev/sdb2
mkfs.btrfs -m raid10 -d raid10 -L RAID /dev/sda2 /dev/sdc2 /dev/sdd2 /dev/sde2

mkdir /mnt/ssd
mount /dev/sdb2 /mnt/ssd
btrfs filesystem df /mnt/ssd

mkdir -p /mnt/raid
mount  /dev/sda2 /mnt/raid
btrfs filesystem df /mnt/raid

btrfs subvol create /mnt/ssd/root
btrfs subvol create /mnt/ssd/root/boot
btrfs subvol create /mnt/ssd/root/usr
btrfs subvol create /mnt/ssd/root/etc
btrfs subvol create /mnt/ssd/root/var
btrfs subvol list   /mnt/ssd

btrfs subvol create /mnt/raid/home
btrfs subvol create /mnt/raid/data
btrfs subvol create /mnt/raid/share
btrfs subvol create /mnt/raid/opt

mount -t btrfs -osubvol=root,noatime,autodefrag,ssd --label SSD /mnt/gentoo

mkdir -p /mnt/gentoo/home
mkdir -p /mnt/gentoo/data
mkdir -p /mnt/gentoo/usr/share
mkdir -p /mnt/gentoo/opt

mount -t btrfs -osubvol=home,noatime,autodefrag --label RAID /mnt/gentoo/home
mount -t btrfs -osubvol=data,noatime,autodefrag --label RAID /mnt/gentoo/data
mount -t btrfs -osubvol=share,noatime,autodefrag --label RAID /mnt/gentoo/usr/share
mount -t btrfs -osubvol=opt,noatime,autodefrag --label RAID /mnt/gentoo/opt
```


Install stage 3
=======================================================================

* Download stage3-amd64-hardened-20141113.tar.bz2 

* Install the stage 3 tar ball

    ```bash
    cd /mnt/gentoo
    tar -xvjpf /tmp/stage3-amd64-hardened-20141113.tar.bz2 
    ```

* /mnt/gentoo/etc/portage/make.conf

    * Set compiler flags

        ```bash
        cd etc/portage
        cp make.conf make.conf.orig
        vi make.conf
        ```

        ```diff
        --- make.conf.orig      2014-11-15 21:05:37.228825741 +0000
        +++ make.conf   2014-11-15 21:08:56.249822275 +0000
        @@ -2,8 +2,11 @@
         # built this stage.
         # Please consult /usr/share/portage/config/make.conf.example for a more
         # detailed example.
        -CFLAGS="-O2 -pipe"
        +CFLAGS="-march=native -O2 -pipe"
         CXXFLAGS="${CFLAGS}"
        +# Increase number of parallel compilations
        +MAKEOPTS="-j7"
        +
         # WARNING: Changing your CHOST is not something that should be done lightly.
         # Please consult http://www.gentoo.org/doc/en/change-chost.xml before changing.
         CHOST="x86_64-pc-linux-gnu"
        ```

    * Add mirrors

        ```bash
        cp make.conf make.conf.compiler
        mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
        mirrorselect -i -r -o >> /mnt/gentoo/etc/portage/make.conf
        ```

        ```diff
        --- make.conf.compiler  2014-11-15 21:12:26.000818622 +0000
        +++ make.conf   2014-11-15 21:16:57.413813895 +0000
        @@ -16,3 +16,7 @@
         PORTDIR="/usr/portage"
         DISTDIR="${PORTDIR}/distfiles"
         PKGDIR="${PORTDIR}/packages"
        +
        +GENTOO_MIRRORS="rsync://mirror.mcs.anl.gov/gentoo/ rsync://rsync.gtlib.gatech.edu/gentoo http://gentoo.osuosl.org/"
        +
        +SYNC="rsync://rsync.us.gentoo.org/gentoo-portage"
        ```

* Enter chroot environment and configure

    ```bash
    cp -L /etc/resolv.conf /mnt/gentoo/etc/

    mount -t proc proc /mnt/gentoo/proc
    mount --rbind /sys /mnt/gentoo/sys
    mount --rbind /dev /mnt/gentoo/dev

    cp /etc/mtab /mnt/gentoo/etc/mtab
    vi /mnt/gentoo/etc/mtab

    /dev/sdb2 / btrfs rw,noatime,subvol=root,autodefrag,ssd 0 0
    /dev/sda2 /home btrfs rw,noatime,subvol=home,autodefrag 0 0
    /dev/sda2 /data btrfs rw,noatime,subvol=data,autodefrag 0 0
    /dev/sda2 /usr/share btrfs rw,noatime,subvol=share,autodefrag 0 0
    /dev/sda2 /opt btrfs rw,noatime,subvol=opt,autodefrag 0 0
    proc /proc proc rw 0 0
    /sys /sys none rw,bind,rbind 0 0
    /dev /dev none rw,bind,rbind 0 0


    chroot /mnt/gentoo /bin/bash
    source /etc/profile
    export PS1="(chroot) $PS1"

    emerge-webrsync
    emerge --sync
    eselect news list
    eselect news read
    eselect profile list

    cp make.conf make.conf.portage
    ```

    ```diff
    --- make.conf.portage   2014-11-15 21:34:29.491795573 +0000
    +++ make.conf   2014-11-15 21:43:16.750786391 +0000
    @@ -12,7 +12,7 @@
     CHOST="x86_64-pc-linux-gnu"
     # These are the USE flags that were used in addition to what is provided by the
     # profile used for building.
    -USE="bindist mmx sse sse2"
    +USE="bindist mmx sse sse2 acpi bash-completion branding crypt git gpm gzip hardened lm_sensors"
     PORTDIR="/usr/portage"
     DISTDIR="${PORTDIR}/distfiles"
     PKGDIR="${PORTDIR}/packages"
    ```

    ```bash
    echo "UTC" >/etc/timezone
    emerge --config sys-libs/timezone-data

    cd /etc
    cp locale.gen locale.gen.orig
    ```

    ```diff
    -- locale.gen.orig     2014-11-15 21:49:07.267780287 +0000
    +++ locale.gen  2014-11-15 21:49:37.439779761 +0000
    @@ -15,8 +15,8 @@
     # rebuilt for you.  After updating this file, you can simply run `locale-gen`
     # yourself instead of re-emerging glibc.
     
    -#en_US ISO-8859-1
    -#en_US.UTF-8 UTF-8
    +en_US ISO-8859-1
    +en_US.UTF-8 UTF-8
     #ja_JP.EUC-JP EUC-JP
     #ja_JP.UTF-8 UTF-8
     #ja_JP EUC-JP
    ```

    ```bash
    locale-gen

    eselect locale list
    Available targets for the LANG variable:
      [1]   C
      [2]   en_US
      [3]   en_US.iso88591
      [4]   en_US.utf8
      [5]   POSIX
      [ ]   (free form)

    eselect locale set 4
    Setting LANG to en_US.utf8 ...
    Run ". /etc/profile" to update the variable in your shell.

    env-update && source /etc/profile
    export PS1="(chroot) $PS1"

    emerge vim

    ```

Kernel
=======================================================================

Create sane kernel based on livedvd
-----------------------------------------------------------------------

```bash
emerge gentoo-sources
cd /usr/src/linux
# Accept defaults for (NEW) items
make localyesconfig
```

Customize kernel
-----------------------------------------------------------------------

```bash
make menuconfig
```

* General setup
    + Initramfs source file(s)
        - /usr/src/linux/initramfs/initramfs_list
* Device Drivers
    + Generic Driver Optins
        - Automount devtmpfs at /dev, after the kernel mounted the rootfs
    + Network Device support
        + Ethernet driver suppot
            - Realtek 8169 gigabit ethernet support
    + Input device support
        + Event interface    --- needed for Xorg
    + Graphics Support
        + Console display driver support
	    + Framebuffer Console support
        + Direct Rendering Manager
	    + Nouveau (nVidia) cards
* File Systems
    + Btrfs filesystem support
        + Btrfs POSIX Access Control Lists
	+ Btrfs will run sanity tests upon loading

* TODO: find a nice printy print for linux config file

Configure initramfs files
-----------------------------------------------------------------------

```bash
chmod +x usr/gen_init_cpio scripts/gen_initramfs_list.sh 
mkdir initramfs
```

* initramfs/initramfs_list

    ```text
    # directory structure
    dir /proc       755 0 0
    dir /usr        755 0 0
    dir /bin        755 0 0
    dir /sys        755 0 0
    dir /var        755 0 0
    dir /lib64      755 0 0
    dir /sbin       755 0 0
    dir /mnt        755 0 0
    dir /mnt/root   755 0 0
    dir /mnt/boot   755 0 0
    dir /etc        755 0 0
    dir /root       700 0 0
    dir /dev        755 0 0

    # Required devices
    nod /dev/console 0622 0 0 c 5 1
    nod /dev/tty0    0622 0 0 c 4 0

    # busybox
    file /bin/busybox               /bin/busybox            755 0 0

    #
    # fsck deps
    #
    file /sbin/fsck                 /sbin/fsck              755 0 0
    file /lib64/libmount.so.1       /lib64/libmount.so.1    755 0 0
    file /lib64/libblkid.so.1       /lib64/libblkid.so.1    755 0 0
    file /lib64/libc.so.6           /lib64/libc.so.6        755 0 0
    file /lib64/libuuid.so.1        /lib64/libuuid.so.1     755 0 0
    file /lib64/ld-linux-x86-64.so.2  /lib64/ld-linux-x86-64.so.2 755 0 0

    #
    #  fsck.ext3 and added deps
    #
    file /sbin/fsck.ext3            /sbin/fsck.ext3         755 0 0
    file /lib64/libext2fs.so.2      /lib64/libext2fs.so.2   755 0 0
    file /lib64/libcom_err.so.2     /lib64/libcom_err.so.2  755 0 0
    file /lib64/libe2p.so.2         /lib64/libe2p.so.2      755 0 0
    file /lib64/libpthread.so.0     /lib64/libpthread.so.0  755 0 0

    #
    # btrfs utils and added deps
    #
    file /sbin/btrfs                /sbin/btrfs             755 0 0
    file /sbin/btrfs-convert        /sbin/btrfs-convert     755 0 0
    file /sbin/btrfs-debug-tree     /sbin/btrfs-debug-tree  755 0 0
    file /sbin/btrfs-find-root      /sbin/btrfs-find-root   755 0 0
    file /sbin/btrfs-image          /sbin/btrfs-image       755 0 0
    file /sbin/btrfs-map-logical    /sbin/btrfs-map-logical 755 0 0
    file /sbin/btrfs-show-super     /sbin/btrfs-show-super  755 0 0
    file /sbin/btrfs-zero-log       /sbin/btrfs-zero-log    755 0 0
    file /sbin/btrfsck              /sbin/btrfsck           755 0 0
    file /sbin/btrfstune            /sbin/btrfstune         755 0 0
    file /sbin/mkfs.btrfs           /sbin/mkfs.btrfs        755 0 0
    file /lib64/libz.so.1           /lib64/libz.so.1        755 0 0
    file /lib64/liblzo2.so.2        /usr/lib64/liblzo2.so.2 755 0 0

    #
    # Nano editor and added deps
    #
    file /sbin/nano                 /usr/bin/nano           755 0 0
    file /lib64/libncursesw.so.5    /lib64/libncursesw.so.5 755 0 0
    file /lib64/libdl.so.2          /lib64/libdl.so.2       755 0 0

    #
    #  mknod and added deps
    #
    file /sbin/mknod                /bin/mknod              755 0 0

    #
    #  more viewer
    #
    file /sbin/more                 /bin/more               755 0 0

    #
    #  init script
    #
    file    /init                   /usr/src/linux/initramfs/init             755 0 0

    #
    #  fstab
    #
    file    /etc/fstab              /usr/src/linux/initramfs/fstab  644 0 0
    ```

* initramfs/init

    ```bash
    #!/bin/busybox sh

    rescue_shell() {
        echo "$@"
        echo "Something went wrong. Dropping you to a shell."
        busybox --install -s
        exec /bin/sh
    }

    mount_root() {
        echo "scanning for btrfs filesystems.... will take about 5-10 seconds"
    #
    #  earlier versions of btrfs required devices on scan.  As of around 0.19.11 or so 
    #  this now is a syntax error.  Also specifying the device= options in the fstab for
    #  the root subvolume probably make this unnecessary now
    #
    #    /sbin/btrfs device scan /dev/sda /dev/sdb
        /sbin/btrfs device scan
        echo "mounting /mnt/root"
        mount /mnt/root
        mount /mnt/root/usr/share
    }

    # temporarily mount proc and sys
    mount -t proc none /proc
    mount -t sysfs none /sys
    mount -t devtmpfs none /dev

    # disable kernel messages from popping onto the screen
    echo 0 > /proc/sys/kernel/printk

    # clear the screen
    clear

    # mounting rootfs on /mnt/root
    mount_root || rescue_shell "Error with uuidlabel_root"

    cat /proc/mounts >/mnt/root/root/mounts.txt
    ls -l / >/mnt/root/root/lsroot.txt
    ls -l /dev >/mnt/root/root/lsdev.txt
    env >/mnt/root/root/env.txt
    echo "All done. Switching to real root."

    # clean up. The init process will remount proc sys and dev later
    umount /proc
    umount /sys
    umount /dev

    # switch to the real root and execute init
    exec switch_root /mnt/root /sbin/init
    ```

* initramfs/fstab

    ```text
    LABEL=SSD              /mnt/root               btrfs subvol=root,noatime,autodefrag,ssd   0 0
    LABEL=RAID             /mnt/root/usr/share     btrfs subvol=share,noatime,autodefrag     0 0
    ```

* btrfs

    ```bash
    emerge btrfs-progs
    ```

Make the kernel
-----------------------------------------------------------------------

```bash
make && make modules_install
cp .config /boot/config-3.16.5-gentoo
cp System.map /boot/System.map-3.16.5-gentoo
cp arch/x86_64/boot/bzImage /boot/kernel-3.16.5-gentoo
```


Configure the machine
=======================================================================
* /etc/fstab

    ```text
    LABEL=SSD               /               btrfs subvol=root,noatime,autodefrag,ssd   0 1
    LABEL=RAID              /home           btrfs subvol=home,noatime,autodefrag      1 2
    LABEL=RAID              /data           btrfs subvol=data,noatime,autodefrag      1 2
    LABEL=RAID              /usr/share      btrfs subvol=share,noatime,autodefrag     0 2
    LABEL=RAID              /opt            btrfs subvol=opt,noatime,autodefrag       0 2
    LABEL=swap1             none            swap            sw              0 0
    LABEL=swap2             none            swap            sw              0 0
    LABEL=swap3             none            swap            sw              0 0
    LABEL=swap4             none            swap            sw              0 0
    ```

* /etc/conf.d/hostname

    ```text
    # Set to the hostname of this machine
    hostname="cerberus"
    ```

* /etc/conf.d/net

    ```text
    dns_domain_lo="umbisag.local"
    ```

```bash
emerge --noreplace netifrc
```

* /etc/conf.d/net

    ```text
    dns_domain_lo="umbisag.local"
    config_enp3s0="dhcp"
    ```

```bash
cd /etc/init.d
ln -s net.lo net.enp3s0
rc-update add net.enp3s0 default

# set root password
passwd

emerge syslog-ng
rc-update add syslog-ng default

emerge cronie
rc-update add cronie default

emerge dhcpcd

emerge sys-boot/grub
emerge gptfdisk

mkdir -p /boot/grub
grub2-mkconfig -o /boot/grub/grub.cfg

grub2-install /dev/sdb

```

Some other packages
=======================================================================

Console mouse
-----------------------------------------------------------------------

```bash
emerge sys-utils/gpm
```


Reboot and install X and LXDE
=======================================================================

* Reboot

    ```bash
    shutdown -r now
    ```

* /etc/portage/package.use

    ```text
    # Required for 
    x11-base/xorg-server udev
    =dev-libs/libxml2-2.9.1-r4 python
    # required by sys-auth/polkit-0.112-r2[-systemd]
    # required by lxde-base/lxsession-0.4.9.2-r1
    # required by lxde-base/lxde-meta-0.5.5-r3
    # required by lxde-meta (argument)
    =sys-auth/consolekit-0.4.6 policykit
    # required by x11-wm/openbox-3.5.2-r1
    # required by lxde-base/lxde-meta-0.5.5-r3
    # required by lxde-meta (argument)
    =x11-libs/pango-1.36.5 X
    # required by x11-libs/gtk+-2.24.24
    # required by lxde-base/lxterminal-0.1.11
    # required by lxde-base/lxde-meta-0.5.5-r3
    # required by lxde-meta (argument)
    =x11-libs/cairo-1.12.16 X
    # required by virtual/libgudev-215-r1[-systemd]
    # required by gnome-base/gvfs-1.20.2
    # required by x11-libs/libfm-1.1.4[automount,-udisks]
    # required by x11-misc/pcmanfm-1.1.2
    # required by lxde-base/lxde-meta-0.5.5-r3
    # required by lxde-meta (argument)
    =sys-fs/udev-216 gudev
    ```

* /etc/portage/make.conf

    ```diff
    --- make.conf.before_xorg       2014-11-23 02:17:28.037959193 +0000
    +++ make.conf   2014-11-23 02:19:00.861954004 +0000
    @@ -19,3 +19,5 @@
     GENTOO_MIRRORS="rsync://mirror.mcs.anl.gov/gentoo/
     rsync://rsync.gtlib.gatech.edu/gentoo http://gentoo.osuosl.org/"

      SYNC="rsync://rsync.us.gentoo.org/gentoo-portage"
      +# XORG Config
      +VIDEO_CARDS="nouveau"
    ```

* Install xorg-server and LXDE

    ```bash
    emerge --ask xorg-server
    emerge -av lxde-meta
    echo "exec startlxde" >>~/.xinitrc
    startx
    # <CTRL>-<ALT>-<BACKSPACE> nor logout allowed me to get back to console.  Had
    # to hard reboot.  Need to find lxde setting for keys
    ```

* slim

   * install

    ```bash
    emerge --ask x11-misc/slim
    ```

    * set xdm to use as display manager in /etc/conf.d/xdm

        ```diff
        --- /etc/conf.d/xdm.orig        2014-11-23 18:24:58.941996910 +0000
        +++ /etc/conf.d/xdm     2014-11-23 18:25:13.202996806 +0000
        @@ -7,4 +7,4 @@

         # What display manager do you use ?  [ xdm | gdm | kdm | gpe | entrance ]
          # NOTE: If this is set in /etc/rc.conf, that setting will override this one.
          -DISPLAYMANAGER="xdm"
          +DISPLAYMANAGER="slim"
        ```

    * Configure to start

        ```bash
        rc-update add xdm default
        ```

* Configure slim to start lxde by default
    * /etc/env.d/90xsession

        ```text
        XSESSION="lxde"
        ```
    * Update environment

        ```bash
        env-update
        ```

* Configure lxde to rotate monitors on startup

    *  Add to /etc/xdg/lxsession/LXDE/autostart

        xrandr --output DVI-I-2 --rotate left --primary --left-of DVI-I-1 --output DVI-I-1 --rotate left

* Install xscreensaver so lock screen works

    ```bash
    emerge --ask x11-misc/xscreensaver
    ```

Accounts
=======================================================================
* whk
```bash
useradd -m -G users,wheel,audio,cdrom,usb,video -s /bin/bash whk
passwd whk
```

PAM and sudo
=======================================================================
* gentoolkit to get revdep-rebuild
    * Add to /etc/portage/make.conf

        USE_PYTHON='2.7 3.3'

    * Update python

        ```bash
        python-updater
        emerge --ask gentoolkit
        ```
* /etc/portage/make.conf

    ```diff
    --- make.conf.before.pam	2014-11-23 21:41:13.849833433 +0000
    +++ make.conf	2014-11-23 21:41:46.811830790 +0000
    @@ -11,7 +11,7 @@
     CHOST="x86_64-pc-linux-gnu"
     # These are the USE flags that were used in addition to what is provided by the
     # profile used for building.
    -USE="bindist mmx sse sse2 acpi bash-completion branding crypt git gpm gzip hardened lm_sensors"
    +USE="bindist mmx sse sse2 acpi bash-completion branding crypt git gpm gzip hardened lm_sensors pam"
     PORTDIR="/usr/portage"
     DISTDIR="${PORTDIR}/distfiles"
     PKGDIR="${PORTDIR}/packages"
    ```

* Rebuild everything necessary with pam

    ```bash
    emerge --sync
    emerge --ask --update --deep --newuse --with-bdeps=y @world
    # Check what would be removed
    emerge -p --depclean
    # If happy then remove them
    emerge --ask --depclean
    revdep-rebuild
    ```

* sudo

    ```bash
    emerge sudo
    ```

* /etc/sudoers

    ```diff
    --- /etc/sudoers.orig	2014-11-24 03:25:49.009992038 +0000
    +++ /etc/sudoers	2014-11-24 03:26:02.742991604 +0000
    @@ -73,7 +73,7 @@
     root ALL=(ALL) ALL
     
     ## Uncomment to allow members of group wheel to execute any command
    -# %wheel ALL=(ALL) ALL
    +%wheel ALL=(ALL) ALL
     
     ## Same thing without a password
     # %wheel ALL=(ALL) NOPASSWD: ALL
    ```


Free Software (Mostly)
=======================================================================

* Set to only install free software.  Keeping binary blobs for now

    ```diff
    --- /etc/portage/make.conf.before.free	2014-11-23 21:46:07.801809858 +0000
    +++ /etc/portage/make.conf	2014-11-23 21:59:26.566745796 +0000
    @@ -21,3 +21,5 @@
     SYNC="rsync://rsync.us.gentoo.org/gentoo-portage"
     # XORG Config
     VIDEO_CARDS="nouveau"
    +# Only accept FSF & OSI marked Free licenses and for now accept binary blobs
    +ACCEPT_LICENSE="-* @FREE freedist"
    ```


Clean up kernel
=======================================================================

Experiment with removing a few things from the kernel.  This will be an
ongoing tuning until prefered settings are determined

* Size changes after doing following
    * Original 

        ```bash
        ls -l /boot/kernel-3.16.5-gentoo 
          -rw-r--r-- 1 root root 9192224 Nov 23 00:16 /boot/kernel-3.16.5-gentoo
        ```

    * New 
        

        ```bash
        ls -l /boot/kernel-3.16.5-gentoo 
          -rw-r--r-- 1 root root 8237936 Nov 24 04:22 /boot/kernel-3.16.5-gentoo
        ```

* Original driver support

    ```text
    00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 Northbridge only single slot PCI-e GFX Hydra part (rev 02)
	    Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RD890 Northbridge only single slot PCI-e GFX Hydra part
    00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (PCI express gpp port B)
	    Kernel driver in use: pcieport
    00:05.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (PCI express gpp port E)
	    Kernel driver in use: pcieport
    00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (PCI express gpp port G)
	    Kernel driver in use: pcieport
    00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode] (rev 40)
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: ahci
    00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: ohci-pci
    00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: ehci-pci
    00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: ohci-pci
    00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: ehci-pci
    00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller (rev 42)
    00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 IDE Controller (rev 40)
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: pata_atiixp
    00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 Azalia (Intel HDA) (rev 40)
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: snd_hda_intel
    00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
    00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to PCI Bridge (rev 40)
    00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: ohci-pci
    00:16.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: ohci-pci
    00:16.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: ehci-pci
    00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
    00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
    00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
    00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
	    Kernel driver in use: k10temp
    00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
    02:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: xhci_hcd
    03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7640
	    Kernel driver in use: r8169
    04:00.0 VGA compatible controller: NVIDIA Corporation GF110 [GeForce GTX 580] (rev a1)
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 2550
	    Kernel driver in use: nouveau
    04:00.1 Audio device: NVIDIA Corporation GF110 High Definition Audio Controller (rev a1)
	    Subsystem: Micro-Star International Co., Ltd. [MSI] Device 2550
	    Kernel driver in use: snd_hda_intel
    ```

* Items to turn off
    * Processor type and features
        * Supported processor vendors
            * Support Intel processors
            * Support Centaur processors
        * IBM Calgary IOMMU support
        * Intel MCE features
        * Dell laptop support
        * Intel microcode loading support
    * Power management and ACPI options
        * ACPI (Advanced Configuration and Power Interface) Support
    * Bus options
        * PCCard (PCMCIA/CardBus) support
    * Device Drivers
        * Macintosh device drivers
        * Ultra Wideband devices
        * LED Support
        * Accessibility support
        * InfiniBand support
    * File Systems
        * Quota support
        * Network File Systems
            * NFS clOBient support
    * Library routines
        * PowerPC BCJ filter decoder
        * ARM BCJ filter decoder
        * ARM-Thumb BCJ filter decoder
        * SPARC BCJ filter decoder


* Items to turn to modules
    * File Systems
        * The Extended 4 (ext4) filesystem
        * Reiserfs suppot
        * JFS filesystem support
        * XFS filesystem support

* Build

    ```bash 
    make && make modules_install
    cp .config /boot/config-3.16.5-gentoo
    cp System.map /boot/System.map-3.16.5-gentoo
    cp arch/x86_64/boot/bzImage /boot/kernel-3.16.5-gentoo
    ```


Applications
=======================================================================

Chromium
-----------------------------------------------------------------------

* Add to /etc/portage/package.use

    ```text
    # required by www-client/chromium-38.0.2125.101
    # required by www-client/chromium (argument)
    >=sys-libs/zlib-1.2.8-r1 minizip
    # required by www-client/chromium-38.0.2125.101
    # required by www-client/chromium (argument)
    =media-libs/harfbuzz-0.9.28 icu
    # required by www-client/chromium-38.0.2125.101
    # required by www-client/chromium (argument)
    =dev-libs/libxml2-2.9.1-r4 icu
    # required by www-client/chromium-39.0.2171.65
    # required by @selected
    # required by @world (argument)
    >=dev-libs/libxml2-2.9.2 icu
    ```

* Build

    ```bash
    emerge www-client/chromium
    ```

CUPS
-----------------------------------------------------------------------

* /etc/portage/package.use

    ```text
    # required by net-print/cups-1.7.5
    # required by net-print/cups-filters-1.0.53
    =app-text/ghostscript-gpl-9.10-r2 cups
    ```

* Build

    ```bash
    emerge net-print/cups
    ```


* /etc/portage/make.conf
    * Add "cups" to USE Flags


* Configure

    TBD

Graphviz
-----------------------------------------------------------------------


* /etc/portage/package.use

    ```text
    # required by media-gfx/graphviz-2.26.3-r4
    # required by graphviz (argument)
    >=media-libs/gd-2.0.35-r4 jpeg png fontconfig truetype
    ```

* Build

    ```bash
    emerge media-gfx/graphviz
    ```

Pandoc
-----------------------------------------------------------------------


* Build

    ```bash
    emerge app-text/pandoc
    ```

lsscsi
-----------------------------------------------------------------------

* Build
    ```bash
    emerge --ask sys-fs/lsscsi
    ```

video
-----------------------------------------------------------------------

* Build
    ```bash
    emerge --ask virtual/ffmpeg
    ```

Free Software (continued) - Deblob Kernel
=======================================================================
System appears to be working ok so configure the kernel to not require 
proprietary blobs

* Update system

    ```bash
    emerge --sync
    emerge --ask --update --deep --newuse --with-bdeps=y @world
    # Check what would be removed
    emerge -p --depclean
    # If happy then remove them
    emerge --ask --depclean
    revdep-rebuild
    ```

* Add deblob to /etc/portage/package.use

    ```text
    # Deblob kernel sources
    sys-kernel/gentoo-sources deblob
    ```

*  Remove freedist from /etc/portage/make.conf

    ```diff
    --- make.conf.before.free	2014-12-20 22:11:31.881901838 +0000
    +++ make.conf	2014-12-20 22:11:40.351901613 +0000
    @@ -22,6 +22,6 @@
     # XORG Config
     VIDEO_CARDS="nouveau"
     # Only accept FSF & OSI marked Free licenses and for now accept binary blobs
    -ACCEPT_LICENSE="-* @FREE freedist"
    +ACCEPT_LICENSE="-* @FREE"
     # Python
     USE_PYTHON='2.7 3.3'
    ```

* Reemerge sources

    ```bash
    emerge --sync
    emerge --ask --update --deep --newuse --with-bdeps=y @world
    # Check what would be removed
    emerge -p --depclean
    # If happy then remove them
    emerge --ask --depclean
    revdep-rebuild
    ```

* Build the new kernel

    ```bash
    eselect kernel list
    eselect kernel set 1
    cd /usr/src
    cp linux-3.16.5-gentoo/.config 3.16.5.config.bk
    cd linux
    zcat /proc/config.gz > /usr/src/linux/.config
    cp -a ../linux-3.16.5-gentoo/initramfs/ .
    make oldconfig
    make modules_prepare
    make && make modules_install
    KERNELVER=3.17.7
    cp .config /boot/config-${KERNELVER}-gentoo
    cp System.map /boot/System.map-${KERNELVER}-gentoo
    cp arch/x86_64/boot/bzImage /boot/kernel-${KERNELVER}-gentoo
    grub2-mkconfig -o /boot/grub/grub.cfg
    ```


Sound
=======================================================================

* /etc/portage/make.conf

    * add "pulseaudio" to USE flags

* Rebuild everything with support for sound

    ```bash
    emerge --sync
    emerge --ask --update --deep --newuse --with-bdeps=y @world
    # Check what would be removed
    emerge -p --depclean
    # If happy then remove them
    emerge --ask --depclean
    revdep-rebuild
    ```

* Enable consolekit on boot

    ```bash
    rc-update add consolekit default
    ```

Don't use prebuilt reference implementations
=======================================================================

* /etc/portage/make.conf

    * change "bindist" to "-bindist" in USE flags

* Rebuild everything that is affected

    ```bash
    emerge --sync
    emerge --ask --update --deep --newuse --with-bdeps=y @world
    # Check what would be removed
    emerge -p --depclean
    # If happy then remove them
    emerge --ask --depclean
    revdep-rebuild
    ```



Customize Kernel
=======================================================================
Update and Clean up kernel a few settings at a time

* Make sure system is up to date

    ```bash
    emerge --sync
    emerge --ask --update --deep --newuse --with-bdeps=y @world
    # Check what would be removed
    emerge -p --depclean
    # If happy then remove them
    emerge --ask --depclean
    revdep-rebuild
    ```

* Backup working config

    ```bash
    cd /usr/src
    cp linux-3.17.7-gentoo/.config 3.17.7.config.bk
    cd linux
    ```

* Size changes after doing following

    ```text
    -rw-r--r-- 1 root root 7.9M Nov 24 04:22 /boot/kernel-3.16.5-gentoo
    -rw-r--r-- 1 root root 7.8M Dec 20 22:19 /boot/kernel-3.17.7-gentoo
    -rw-r--r-- 1 root root 8.0M Jan  4 04:07 /boot/kernel-3.17.7-gentoo-gnu20150104-01
    -rw-r--r-- 1 root root 7.2M Jan  4 21:56 /boot/kernel-3.17.7-gentoo-gnu20150105-01
    ```

* ACPI

    Turn back on ACPI.  It is needed so the OS can fully shutdown the machine.

    * kernel config

        ```bash
        cd /usr/src/linux
        make menuconfig
        ```

    * kernel diff

        ```diff
         ACPI n -> y
         LOCALVERSION "" -> "20150104-01"
        +ACERHDF n
        +ACER_WMI n
        +ACPI_AC y
        +ACPI_APEI n
        +ACPI_BATTERY n
        +ACPI_BUTTON y
        +ACPI_CMPC n
        +ACPI_CONTAINER y
        +ACPI_CUSTOM_DSDT n
        +ACPI_DEBUG n
        +ACPI_DOCK n
        +ACPI_EC_DEBUGFS n
        +ACPI_EXTLOG n
        +ACPI_FAN y
        +ACPI_HED n
        +ACPI_HOTPLUG_CPU y
        +ACPI_I2C_OPREGION y
        +ACPI_INITRD_TABLE_OVERRIDE n
        +ACPI_INT3403_THERMAL n
        +ACPI_LEGACY_TABLES_LOOKUP y
        +ACPI_PCI_SLOT n
        +ACPI_PROCESSOR y
        +ACPI_PROCESSOR_AGGREGATOR n
        +ACPI_PROCFS_POWER n
        +ACPI_REDUCED_HARDWARE_ONLY n
        +ACPI_SBS n
        +ACPI_THERMAL y
        +ACPI_TOSHIBA n
        +ACPI_VIDEO y
        +ACPI_WMI y
        +AMD_IOMMU n
        +APPLE_GMUX n
        +ARCH_MIGHT_HAVE_ACPI_PDC y
        +ASUS_LAPTOP n
        +ATA_ACPI y
        +BACKLIGHT_APPLE n
        +DELL_SMO8800 n
        +DELL_WMI n
        +DELL_WMI_AIO n
        +DMA_ACPI y
        +EFI n
        +FUJITSU_LAPTOP n
        +FUJITSU_TABLET n
        +HAVE_ACPI_APEI y
        +HAVE_ACPI_APEI_NMI y
        +HPET n
        +HP_ACCEL n
        +HP_WIRELESS n
        +HP_WMI n
        +HYPERV n
        +I2C_SCMI n
        +INPUT_ATLAS_BTNS n
        +INTEL_IOMMU n
        +INTEL_IPS n
        +INTEL_MENLOW n
        +INTEL_RST n
        +INTEL_SMARTCONNECT n
        +IRQ_REMAP n
        +ISCSI_IBFT_FIND n
        +MSI_WMI n
        +MXM_WMI y
        +NET_SB1000 n
        +PANASONIC_LAPTOP n
        +PATA_ACPI n
        +PCI_IOAPIC n
        +PCI_MMCONFIG n
        +PNP y
        +PNPACPI y
        +PNP_DEBUG_MESSAGES y
        +PVPANIC n
        +SAMSUNG_Q10 n
        +SENSORS_ACPI_POWER n
        +SENSORS_ATK0110 n
        +SERIAL_8250_PNP y
        +THINKPAD_ACPI n
        +TOPSTAR_LAPTOP n
        +TOSHIBA_BT_RFKILL n
        +TOSHIBA_HAPS n
        +VGA_SWITCHEROO n
        +X86_ACPI_CPUFREQ n
        +X86_INTEL_LPSS n
        +X86_PCC_CPUFREQ n
        +X86_PM_TIMER y
        +X86_SPEEDSTEP_CENTRINO n
        +XEN_ACPI_PROCESSOR m
        +XEN_BACKEND y
        +XEN_BLKDEV_BACKEND n
        +XEN_DOM0 y
        +XEN_MCE_LOG n
        +XEN_NETDEV_BACKEND n
        +XEN_PCIDEV_BACKEND m
        ```

    * Build the new kernel

        ```bash
        make && make modules_install
        KERNELVER=3.17.7
        EXTENSION=20150104-01
        cp .config /boot/config-${KERNELVER}-gentoo-gnu${EXTENSION}
        cp System.map /boot/System.map-${KERNELVER}-gentoo-gnu${EXTENSION}
        cp arch/x86_64/boot/bzImage /boot/kernel-${KERNELVER}-gentoo-gnu${EXTENSION}
        grub2-mkconfig -o /boot/grub/grub.cfg
        cp -a .config ../${KERNELVER}-${EXTENSION}.config.bk
        ```

* Remove extra/unused drivers found in dmesg

    * Update local version to 20150105-01

        ```text
        General setup -> Local version 
        ```
 
    * xen - running on real hardware

        ```text
        Processor type and features -> Linux Guest support
        ```

    * Block devices - Uneeded block devices

        ```text
        Device Drivers -> Block devices -> Compaq Smart Array 5xxx support
        Device Drivers -> Block devices -> Mylex DAC960/DAC1100 PCI RAID Controller support
        Device Drivers -> Block devices -> Promise SATA SX8 support
        ```

    * ISCSI

        ```text
        Device Drivers -> SCSI device support -> SCSI low-level drivers -> QLogic NetXtreme II iSCSI support
        Device Drivers -> SCSI device support -> SCSI low-level drivers -> Chelsio T3 iSCSI support
        Device Drivers -> SCSI device support -> SCSI low-level drivers -> Chelsio T4 iSCSI support
        Device Drivers -> SCSI device support -> SCSI low-level drivers -> QLogic ISP4XXX and ISP82XX host adapter family support
        Device Drivers -> SCSI device support -> SCSI low-level drivers -> ServerEngines 10GBps iSCSI - BladeEngine 2
        Device Drivers -> SCSI device support -> SCSI low-level drivers -> iSCSI Boot Sysfs Interface
        Device Drivers -> SCSI device support -> SCSI low-level drivers -> iSCSI Initiator over TCP/IP
        Device Drivers -> SCSI device support -> SCSI Transports -> iSCSI Transport Attributes 
        ```

    * Network device drivers 

        ```text
        Device Drivers -> Network device support -> Fibre Channel driver support
        Device Drivers -> Network device support -> Wireless LAN 
        Device Drivers -> Network device support -> VMware VMXNET3 ethernet driver
        Device Drivers -> Network device support -> Wan interfaces support
        Device Drivers -> Network device support -> USB Network Adapters
        Device Drivers -> Network device support -> Ethernet driver support -> 3Com devices 
        Device Drivers -> Network device support -> Ethernet driver support -> Adaptec devices
        Device Drivers -> Network device support -> Ethernet driver support -> Alteon devices
        Device Drivers -> Network device support -> Ethernet driver support -> AMD devices
        Device Drivers -> Network device support -> Ethernet driver support -> ARC devices
        Device Drivers -> Network device support -> Ethernet driver support -> Atheros devices
        Device Drivers -> Network device support -> Ethernet driver support -> Broadcom devices
        Device Drivers -> Network device support -> Ethernet driver support -> Brocade devices
        Device Drivers -> Network device support -> Ethernet driver support -> Chelsio devices
        Device Drivers -> Network device support -> Ethernet driver support -> Cisco devices 
        Device Drivers -> Network device support -> Ethernet driver support -> Digital Equipment devices
        Device Drivers -> Network device support -> Ethernet driver support -> D-Link devices
        Device Drivers -> Network device support -> Ethernet driver support -> Emulex devices
        Device Drivers -> Network device support -> Ethernet driver support -> Exar devices
        Device Drivers -> Network device support -> Ethernet driver support -> HP devices
        Device Drivers -> Network device support -> Ethernet driver support -> Intel devices
        Device Drivers -> Network device support -> Ethernet driver support -> Marvell devices
        Device Drivers -> Network device support -> Ethernet driver support -> Mellanox devices 
        Device Drivers -> Network device support -> Ethernet driver support -> Micrel devices
        Device Drivers -> Network device support -> Ethernet driver support -> Myricom devices
        Device Drivers -> Network device support -> Ethernet driver support -> National Semi-conductor devices
        Device Drivers -> Network device support -> Ethernet driver support -> NVIDIA Devices 
        Device Drivers -> Network device support -> Ethernet driver support -> OKI Semiconductor devices 
        Device Drivers -> Network device support -> Ethernet driver support -> QLogic devices 
        Device Drivers -> Network device support -> Ethernet driver support -> RDC devices
        Device Drivers -> Network device support -> Ethernet driver support -> Samsung Ethernet devices
        Device Drivers -> Network device support -> Ethernet driver support -> SEEQ devices
        Device Drivers -> Network device support -> Ethernet driver support -> Silan devices
        Device Drivers -> Network device support -> Ethernet driver support -> Silicon Integrated Systems (SiS) devices
        Device Drivers -> Network device support -> Ethernet driver support -> SMC (SMSC)/Western Digital devices
        Device Drivers -> Network device support -> Ethernet driver support -> STMicroelectronics devices 
        Device Drivers -> Network device support -> Ethernet driver support -> Sun devices
        Device Drivers -> Network device support -> Ethernet driver support -> Tehuti devices
        Device Drivers -> Network device support -> Ethernet driver support -> Texas Instruments (TI) devices
        Device Drivers -> Network device support -> Ethernet driver support -> VIA devices
        Device Drivers -> Network device support -> Ethernet driver support -> WIZnet devices
        ```

    * I20 Disk subsystem

        ```text
        Device Drivers -> I2O device support
        ```

    * Fusion MPT

        ```text
        Device Drivers -> Fusion MPT device support
        ```

    * PS/2 support

        ```text
        Device Drivers -> Input device support -> Keyboards -> AT Keyboard
        Device Drivers -> Input device support -> Mice -> PS/2 Mouse
        Device Drivers -> Input device support -> Hardware I/O ports -> i8042 PC Keyboard controller
        Device Drivers -> Input device support -> Hardware I/O ports -> PS/2 driver library
        ```

    * Build the new kernel

        ```bash
        make && make modules_install
        KERNELVER=3.17.7
        EXTENSION=20150105-01
        cp .config /boot/config-${KERNELVER}-gentoo-gnu${EXTENSION}
        cp System.map /boot/System.map-${KERNELVER}-gentoo-gnu${EXTENSION}
        cp arch/x86_64/boot/bzImage /boot/kernel-${KERNELVER}-gentoo-gnu${EXTENSION}
        grub2-mkconfig -o /boot/grub/grub.cfg
        cp -a .config ../${KERNELVER}-${EXTENSION}.config.bk
        ```

* Remove other uneeded devices

    * radeon
    * scsi (remove extra)
    * ipv6

Clean Up
=======================================================================

* Remove old files

    ```bash
    # Check what would be deleted
    eclean --pretend --deep distfiles
    # If removal looks good
    eclean --deep distfiles
    ```



TODO
=======================================================================
* enable validating portage tree snapshots
* (https://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=2&chap=3)


References
=======================================================================
* <https://www.gentoo.org/doc/en/handbook/handbook-amd64.xml>
* <http://wiki.gentoo.org/wiki/Btrfs_native_system_root>
* <http://stackoverflow.com/questions/10437995/initramfs-built-into-custom-linux-kernel-is-not-running>
* <http://en.wikipedia.org/wiki/Consistent_Network_Device_Naming>
* <http://wiki.gentoo.org/wiki/Xorg/Configuration>
* <http://wiki.gentoo.org/wiki/LXDE>
* <http://wiki.gentoo.org/wiki/SLiM>
* <http://wiki.gentoo.org/wiki/Project:Chromium>
* <http://forum.lxde.org/viewtopic.php?t=375&f=1> Configuring lxde autostart
* <http://wiki.gentoo.org/wiki/PulseAudio>

