---
title: Flashing Cyanogenmod on Nexus 6
summary: >
 Procedures to flash Cyanogenmod nightly onto Nexus 6
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/" }
created: 2015-02-14
modified: 2015-02-14
reviewed: 2015-02-14

---

Based on instruction from cyanogenmod wiki[@Multiple]


Install Android tools [@GentooProject]
============================================================

```bash
sudo emerge --ask dev-util/android-tools
```

Unlock the device
============================================================
* Enable USB debugging [@Kingoapp]
 
    * Enable Developer mode: DEVICE: Settings | About Phone

        * Tap "Build Number" 7 times

    * Enable USB debugging: DEVICE: Settings | Developer Options | USB debugging

* Connect device to computer through USB

* Go into fastboot

    * DEVICE: Power down

    * Boot into boot loader DEVICE: Hold down <VOL DOWN>+<POWER> for ~5 seconds

* Unlock

    ```bash
    # Verify device is recognized
    fastboot devices
    # unlock
    fastboot oem unlock
    ```
   
   * Device: Highlight "Yes" with volume keys

   * Device: Select with power key

Install TWRPi [@TeamWinProjects]
============================================================
* Download the latest openrecovery twrp image from <http://techerrata.com/browse/twrp2/shamu>

* Verify MD5 checksum

    ```bash
    md5sum ~/Downloads/openrecovery-twrp-2.8.5.0-shamu.img
    ```
* Go into fastboot (as above)

* Install recovery

    ```bash
    fastboot devices
    fastboot flash recovery ~/Downloads/openrecovery-twrp-2.8.5.0-shamu.img
    ```

* Verify

    * Shutdown with vol keys and power

    * Go into fastboot (as above)

    * Select "Recovery Mode" 

Install CyanogenMod from Recovery
============================================================

* Download latest cyanogenmod [@Cyanogen]

* Download latest Google Apps [@Multiplea]

* Go into recovery mode (per above)

* Push to sdcard

    ```bash
    adb push ~/Downloads/cm-12-20150213-NIGHTLY-shamu.zip /sdcard/
    adb push ~/Downloads/gapps-lp-20141212-signed.zip /sdcard/
    ```

* Select "Backup"

    * Partitions: System, Data, Boot

    * Swipe to backup

* Select "Wipe"

    * Select swipe "Factory Reset"

* Select Install

    * Select /sdcard/cm-12-20150213-NIGHTLY-shamu.zip

    * Add more zips

    * Select /sdcard/gapps-lp-20141212-signed.zip

    * Swipe to Confirm Flash

    * Select Reboot System

References
============================================================
