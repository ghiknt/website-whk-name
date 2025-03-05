
# Switch to Zotero 5.0 from using zotero firefox plugin

Cause: https://www.zotero.org/blog/a-unified-zotero-experience/

* Download version: https://www.zotero.org/download/
* tar -tjvf Zotero-5.0.54_linux-x86_64.tar.bz2 
* expand directory "Zotero_linux-x86_64" does not include version so do it manually
mkdir Zotero_linux-x86_64-5.0.54
cd Zotero_linux-x86_64-5.0.54/
tar -xjvf ../Zotero-5.0.54_linux-x86_64.tar.bz2 
sudo mv Zotero_linux-x86_64 /opt/
# install firefox plugin from autoopened window
# install libreoffice plugin from dialog window
# Setup syncing - Question how is password stored?
Edit | Preferences | Sync
Username: WKnight
Password: XXXXXXXXXXXXXXXX
Press "Set Up Syncing"
Manually Sync

Add launcher src: https://www.zotero.org/support/installation
cd /opt/Zotero_linux-x86_64 
./set_launcher_icon 
ln -s /opt/Zotero_linux-x86_64/zotero.desktop ~/.local/share/applications/

# Desktop file not launching as written so hard code path

--- zotero.desktop.orig	2018-08-05 14:58:54.467845757 -0500
+++ zotero.desktop	2018-08-05 15:12:19.248158695 -0500
@@ -1,6 +1,6 @@
 [Desktop Entry]
 Name=Zotero
-Exec=bash -c "$(dirname $(readlink -f %k))/zotero -url %U"
+Exec=bash -c "/opt/Zotero_linux-x86_64/zotero -url %U"
 Icon=/opt/Zotero_linux-x86_64/chrome/icons/default/default256.png
 Type=Application
 Terminal=false



