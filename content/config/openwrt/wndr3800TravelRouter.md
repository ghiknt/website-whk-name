---
title: Configure Netgear wndr3800 with OpenWrt as a travel router
summary: >
 OpenWrt configuration designed to support travel with multiple devices.
 Local devices will
 connect over the 5Ghz radio and bridged lan ports; the 2Ghz radio will be
 used to bridge to public/hotel wifi, the wan port will be used to connect
 to wired internet connections.
type: article
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 2015-04-19 
modified: 2015-04-19
reviewed: 2015-04-19
changes:
  -
    date: 2015-04-19
    description: Initial creation 

---
---
nocite: |
 @Multiplef, @Multipleh
---

Caveats
===============================================================

* The wndr3800 I am using already had an earlier version of 
  OpenWrt installed so this config does not document putting onto a new router

Goals
===============================================================

Configuration goals

* Two VLANs:

    * 10: Trusted - For development and other devices that
      I control the configuration on

         * 5 Ghz SSID "mobileKeep"

         * Lan ports 1 - 3

    * 20: Untrusted - For devices that need network connection
      but are outside of my control (e.g. Roku Stick, guests, etc)

        * 5 Ghz SSID "mobileBailey"

        * Lan port 4

* Separate NAT FW protection between...

    * WAN port <-> VLAN 10

    * 2 Ghz Client mode <-> VLAN 10

    * Cell Phone (USB) Tether <-> VLAN 10 

    * WAN port <-> VLAN 20

    * 2 Ghz Client mode <-> VLAN 20

    * Cell Phone (USB) Tether <-> VLAN 20 

    * VLAN 20 <-> VLAN10 (VLAN10 can reach VLAN 20 devices but not vice versa))

* Port security on VLAN 10 Lan ports to only allow configured mac addresses

* WPA2-PSK AES on SSID "mobileKeep"

* WPA2-PSK AES/TKIP on SSID "mobileBailey"

* Encrypted external hard drive on usb port

    * NFS shared on VLAN 10

* Internal DNS domain
  
    * vlan10: *.keep.local
    * vlan20: *.bailey.local

* Management interface only available on VLAN 10

    * gate.tower.local


Update to latest OpenWrt[@Multiplef]  [@Multipleh] 
=====================================================================

* Download latest Barrier Breaker sysupgrade release

    * openwrt-ar71xx-generic-wndr3800-squashfs-sysupgrade.bin from <https://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/>

* Upgrade using Luci

* **mistake**: I made the mistake of selecting to keep my configuration
    which soft bricked the router.  Performed a Failsafe boot to recover[@Multipleh]


VLAN10 setup
=====================================================================

Set the internal VLAN10 network addresses so they will hopefully not 
conflict with the external assigned address which is often private
also.

```bash
telnet 192.168.1.1
# Remove default lan interface
uci delete network.lan
# Create trusted "keep" interface
uci set network.keep=interface
uci set network.keep.force_link=1
uci set network.keep.type=bridge
uci set network.keep.proto=static
uci set network.keep.netmask=255.255.255.0
uci set network.keep.ipaddr=10.10.37.250
uci set network.keep.ifname=eth0.10
# Setup vlan 10
uci set network.@switch[0].enable_vlan4k=1
uci set network.@switch_vlan[0].vlan=10
# Internal port numbering (3..0) is reversed from physical (1..4)
uci set network.@switch_vlan[0].ports="1 2 3 5t"
# Set dhcp on keep interface
uci delete dhcp.lan
uci set dhcp.keep=dhcp
uci set dhcp.keep.start=100
uci set dhcp.keep.limit=100
uci set dhcp.keep.leasetime=12h
uci set dhcp.keep.ra=server
uci set dhcp.keep.interface=keep
uci commit
reboot
```

Lock down and update
======================================================================

```bash
passwd
  <newpasswd>
  <newpasswd>
exit

ssh root@10.10.37.250
/etc/init.d/telnet stop
rm /etc/rc.d/S50telnet
# Required packages to install so we can load config later
opkg update
# SSL support for web server
opkg install uhttpd-mod-tls
opkg install luci-ssl

# Set ssh access only from keep interface
uci set dropbear.@dropbear[0].Interface=keep

# Set httpd server to only listen on internal network
uci set uhttpd.main.listen_http=10.10.37.250:80
uci set uhttpd.main.listen_https=10.10.37.250:443

uci commit
reboot
```

Set Name and default domains
======================================================================

```bash
uci set system.@system[0].hostname=gate
uci set dhcp.@dnsmasq[0].local=/tower.local/
uci set dhcp.@dnsmasq[0].domain=tower.local
uci commit
echo '10.10.37.250 gate gate.' >> /etc/hosts
reboot
```

Allow keep to use wan
======================================================================
Reuse settings from deleted lan

```bash
uci set firewall.@zone[0].name=keep
uci set firewall.@zone[0].network=keep
uci set firewall.@forwarding[0].src=keep
uci commit
reboot
```

VLAN20 setup
=======================================================================

```bash
# Create untrusted "bailey" interface
uci set network.bailey=interface
uci set network.bailey.force_link=1
uci set network.bailey.type=bridge
uci set network.bailey.proto=static
uci set network.bailey.netmask=255.255.255.0
uci set network.bailey.ipaddr=10.20.54.250
uci set network.bailey.ifname=eth0.20

uci add network switch_vlan
uci set network.@switch_vlan[1].device=switch0
uci set network.@switch_vlan[1].vlan=20
# Internal port numbering (3..0) is reversed from physical (1..4)
uci set network.@switch_vlan[1].ports="0 5t"

# Set dhcp on bailey interface
uci set dhcp.bailey=dhcp
uci set dhcp.bailey.start=100
uci set dhcp.bailey.limit=100
uci set dhcp.bailey.leasetime=12h
uci set dhcp.bailey.ra=server
uci set dhcp.bailey.interface=bailey

# Setup firewall to allow out
uci add firewall zone
uci set firewall.@zone[2].input=ACCEPT
uci set firewall.@zone[2].output=ACCEPT
uci set firewall.@zone[2].forward=ACCEPT
uci set firewall.@zone[2].name=bailey
uci set firewall.@zone[2].network=bailey
uci add firewall forwarding
uci set firewall.@forwarding[1].dest=wan
uci set firewall.@forwarding[1].src=bailey

# Allow keep to reach into bailey
uci add firewall forwarding
uci set firewall.@forwarding[2].dest=bailey
uci set firewall.@forwarding[2].src=keep

# Since gate shares the same mac address on vlan10 and vlan20
# We need to explicity block to protect ssh/http/https interfaces
uci add firewall rule
uci set firewall.@rule[5].enabled=1
uci set firewall.@rule[5].name=BlockBailey
uci set firewall.@rule[5].src=bailey
uci set firewall.@rule[5].dest_ip=10.10.37.250
uci set firewall.@rule[5].target=REJECT


uci commit
reboot

```

Attach 5Ghz radio to keep and bailey
========================================================================

```bash
uci set wireless.radio1.channel=auto
uci set wireless.radio1.country=US
uci set wireless.radio1.txpower=17
uci set wireless.@wifi-iface[1].network=keep
uci set wireless.@wifi-iface[1].ssid=keep
uci set wireless.@wifi-iface[1].encryption=psk2+ccmp
uci set wireless.@wifi-iface[1].key="<password here>"

uci add wireless wifi-iface
uci set wireless.@wifi-iface[2].device=radio1
uci set wireless.@wifi-iface[2].mode=ap
uci set wireless.@wifi-iface[2].ssid=bailey
uci set wireless.@wifi-iface[2].network=bailey
uci set wireless.@wifi-iface[2].encryption=psk2
uci set wireless.@wifi-iface[2].key="<different password here>"
```


Setup Multiwan to support different WAN interfaces [@Multiplei]
========================================================================
```bash
opkg update
opkg install multiwan

uci delete multiwan.wan2


/etc/init.d/multiwan enable
/etc/init.d/multiwan start
/etc/init.d/multiwan single







```


References
============================================================
