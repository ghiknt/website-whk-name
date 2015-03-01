---
title: Note 2 Root
license: ccbysa
summary: >
 Rooting AT&amp;T Note 2 (older ubuntu instructions)
type: article
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2013-04-06
modified: 2015-02-14
reviewed: 2015-02-14
changes:
  -
    date: 2015-02-14
    description: "Moved from old docs, reformated from haml to markdown"
---

My Install notes
========================================================================

```bash
#Put into develop mode and enable usb 
adb push ~/Downloads/UPDATE-SuperSU-v1.25.zip /storage/sdcard0/Download
# Move file to sdcard

sudo apt-get install libusb-1.0-0-dev
sudo apt-get install checkinstall
sudo apt-get install qt4-qmake qt4-dev-tools
unzip Heimdall-1.3.2.zip
cd Heimdall-1.3.2/
# Libpit
cd libpit; ./configure; make
# Heimdall
cd ../heimdall; ./configure; make
sudo checkinstall --pkgversion 1.3.2
# Heimdall frontend
cd ../heimdall-frontend; qmake heimdall-frontend.pro
make
sudo checkinstall --pkgname heimdall-frontend --pkgversion 1.3.2

# Check for phone
heimdall detect
# Does not see phone so try Heimdall 1.4.1 rc2 (https://github.com/Benjamin-Dobell/Heimdall/tags)
tar -xzvf Heimdall-1.4.1RC2.tar.gz
cd Heimdall-1.4.1rc2/libpit; ./configure; make
cd ../heimdall; ./configure
make
sudo checkinstall -pkgversion 1.4.1rc2
cd ../heimdall-frontend
qmake-qt4 heimdall-frontend.pro
make
sudo checkinstall --pkgname heimdall-frontend --pkgversion 1.4.1rc2

# Check for phone
heimdall detect
# Try to get pit
# Home - Down Vol - Power
heimdall print-pit
# ERROR: Failed to access device. libusb error: -3
sudo heimdall print-pit
# Yeah!!! that works
# Home - Down Vol - Power
# Get the pit file for the phone
#  Just in case we have to recover massively later
sudo heimdall download-pit --output /home/whk/Downloads/note2.pit
# Flash (and cross fingers)
sudo heimdall flash --verbose --no-reboot --recovery ~/Downloads/recovery-clockwork-touch-6.0.3.0-t0lte.img

# After install phone will remain on download screen.
# It appears that IF I let the phone boot up then the recovery partition
# is reverted back to DEFAULT
# so...
# pull battery...
# put in battery...
# Vol Up - Home - Power to go into clockworkmod recovery

# Install SuperSU from recovery
# Select to reboot and to DISABLE the revert to stock recovery

# Phone is now rooted
# Cleanup...
#  Upgrade to SuperSU Pro to support Chainfire
#  Reboot
#   Set pin on SuperSU
#  Donate for Heimdall on Glass Echidna
#  Install ROM Manager and ROM Manager (Premium) to get more functionallity tand to support Clockworkmod
# Backup current rom with ROM Manager before doing anything else and transfer to Linux ws
# Install busybox
# Install Titanium Backup Pro
```


References
===================================================================
* xdadevelopers cwm install instructions - http://forum.xda-developers.com/showthread.php?t=1988785
* heimdall - http://www.glassechidna.com.au/products/heimdall/
* clockworkmod rom - http://www.clockworkmod.com/rommanager
* supersu - http://forum.xda-developers.com/showthread.php?t=1538053


