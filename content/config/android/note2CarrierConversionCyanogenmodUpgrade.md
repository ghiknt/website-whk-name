---
title: Conversion of Note 2 from AT&T to T-Mobile and upgrade of Cyanogenmod
summary: >
 Steps needed to unlock and move a Note 2 phone from AT&T to T-Mobile, switch from Clockworkmod ROM Manager to TWRPi, and upgrade flash from CyanogenMod 11 to CyanogenMod 12
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2015-04-16
modified: 2015-04-16
reviewed: 2015-04-16
changes:
  -
    date: 2016-04-16
    description: Initial creation 

---

Caveats
============================================================

* Based on phone configured using [Note 2 Root](../note2_root/) procedures

Carrier Unlock
============================================================
* Request unlock code from AT&T

    * See [Unlock your AT&T wireless phone or tablet](https://www.att.com/esupport/article.jsp?sid=KB414532&cv=820) for details

    * Make request from the [Consumer Device Unlock Portal](https://www.att.com/deviceunlock/)

* Revert to Stock ROM (i317-ucamh3-stock-cwm).  Code failed using CyanogenMod 11

* Insert new sim card and enter unlock code when prompted

Clockworkmod to TWRPi
============================================================
* Install using [teamwin instructions](http://teamw.in/devices/samsunggalaxynote2att.html)

    * Install TWRP Manager App since already rooted

    * Start TWRP Manager and select "Install TWRP"

    * Select device name

        * Samsung Galaxy Note II ATT (t0lteatt)

    * Select Recovery Version to Install

        * Pick latest (2.8.5.0) from bottom of list

    * Select Install Recovery

Cyanogenmod 12
============================================================

* Download latest cyanogenmod snapshot

    * <http://download.cyanogenmod.org/?device=t0lte>

* Download latest Google Apps [@Multiplea]

* Move both to sdcard0/0 so they will be available to TWRPi

* Reboot into recovery mode

   * &lt;Up Vol>-&lt;Home>-&lt;Power>

* Select "Wipe"

    * Select swipe "Factory Reset"

* Select Install

    * Select /sdcard/cm-12-*

    * Add more zips

    * Select /sdcard/gapps-lp-*

    * Swipe to Confirm Flash

    * Select Reboot System



References
============================================================
