---
title: IOSafe Solo
summary: >
 Ubuntu backup configuration to IOSafe Solo 
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2013-03-17
modified: 2015-03-01 
reviewed: 2015-03-01
changes: 
  -
    date: 2015-03-01
    description: Transfer from old repo and conversion to markdown

---

Setup 
====================================================================

```bash
# Install zfs
apt-get install zfs-fuse
# Install smbfs to allow mount
apt-get install smbfs
# Build drive
# Poweron and plug in drive.  It is initially installed with ntfs. 
# Us df to determine the device assigned
# Use parted to remove ntfs partition and label drive
root@Cerberus:~# parted /dev/sde
(parted) p                                                                
(parted) rm 1                                                             
(parted) quit                                                             
# Create a zpool out of the entire disk
zpool create backup sde
# Turn off atime
zfs set atime=off backup
# Create primary backup dir
zfs create backup/primary
```

On future times just mount drive
=====================================================================

```bash
# Plug in USB
# Import the backup if properly exported otherwise clear errors
zfspool import
zfspool import backup
# commands to clear errors if needed
zfspool list
zfspool clear -F backup
# mount the drive
zfs mount -a
# Mount drobo-fs
mkdir /mnt/drobo-fs
mount -t smbfs drobo-fs:/files /mnt/drobo-fs -ouser=knight
# Backup from drobo-fs to backup/primary/files
rsync -av --delete /mnt/drobo-fs/ /backup/primary/files
# Unmount files
umount /mnt/drobo-fs
# Mount family drive
mount -t smbfs drobo-fs:/family /mnt/drobo-fs -ouser=knight
# Backup from drobo-fs to backup/primary/family
rsync -av --delete /mnt/drobo-fs/ /backup/primary/family
# Unmount family
umount /mnt/drobo-fs
# Backup home drive
rsync -av --delete /home/whk/ /backup/primary/whk

#Snapshot the current data
zfs snapshot -r backup/primary@`date +%Y%m%d_%H%M%S`
# Unmount the iosafe zfs
zfs unmount backup
# Export pool so it is no longer used (hopefully)
zfspool export backup
# Take device offline
zfs offline backup sde
```


Recover from snapshots
========================================================================

```bash
# List all current zfs items (including snapshots)
zfs list -t all
# Create a clone of a snapshot to recover
zfs clone backup/primary@20120916_161851 backup/temp
# Remove the clone when done
zfs destroy backup/temp
# Unmount the iosafe zfs
zfs unmount backup
```

