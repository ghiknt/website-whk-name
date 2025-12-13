#!/usr/bin/bash
# [[file:../index.org::bin-debian-12-xfce-dev/create.sh][bin-debian-12-xfce-dev/create.sh]]
# WARNING: This script is intended to be run in DOM0
#          Only use if you understand what it does

# Configuration Variables
SRC_TEMPLATE=debian-12-xfce
DEST_TEMPLATE_USE=dev
GPG_TAG="developGPG"  # Tag used by GPG split proxy
		      # policy to allow access to GPG key
GPG_DEST="whk-sys-gpg-develop"

# Derived Configuration Variables
# [[[[file:~/config/os-qubes-os/os-R4.2.2+/index.org::createTemplateName][createTemplateName]]][createTemplateName]]
createTemplateName () {
    local SRCNAME=$1
    local TEMPLATEUSE=$2
    local DATE=`/usr/bin/date +%Y%m%d%H%M%S`
    local FULLQUBENAME="${SRCNAME}-${TEMPLATEUSE}-${DATE}"
    # QUBENAME must be less than 32 characters
    echo -n "${FULLQUBENAME:0:31}"
}
# createTemplateName ends here
QUBENAME=`createTemplateName ${SRC_TEMPLATE} ${DEST_TEMPLATE_USE}`

# Clone SRC Template
echo "Creating Template \"$QUBENAME\" from \"${SRC_TEMPLATE}\""
qvm-clone ${SRC_TEMPLATE} ${QUBENAME}

# Set tag on template to allow access to appropriate split GPG qube
echo "Tag ${QUBENAME} with ${GPG_TAG} to allow split gpg access"
qvm-tags ${QUBENAME} add ${GPG_TAG}

# [[[[file:~/config/os-qubes-os/os-R4.2.2+/index.org::installPackagesIntoQube][installPackagesIntoQube]]][installPackagesIntoQube]]
# Helper routine to install a list of packages into a Qube (usually template)
# $1  = The QUBENAME to install
# $2+ = The Packages to install 
installPackagesIntoQube () {
    QUBENAME=$1
    shift;
    echo "  Running /usr/bin/apt-get -q -y install $@"
    /usr/bin/qvm-run --verbose --pass-io --user root ${QUBENAME} \
      "DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -q -y install $*"    
    }

# installPackagesIntoQube ends here

# [[[[file:~/config/os-qubes-os/os-R4.2.2+/index.org::removePasswordlessSudo][removePasswordlessSudo]]][removePasswordlessSudo]]
# KLUDGE: Workaround packages normally installed by qubes-vm-recommended
#         by marking them as manually installed
#         This will have inconsistent resultes if/when qubes-vm-recommended
#         is modified by maintainer.  Current list captured 2024-10-23
installPackagesIntoQube $QUBENAME \
			fwupd-qubes-vm \
			qubes-core-agent-dom0-updates \
			qubes-gpg-split \
			qubes-img-converter \
			qubes-input-proxy-sender \
			qubes-mgmt-salt-vm-connector \
			qubes-pdf-converter \
			qubes-repo-templates \
			qubes-usb-proxy

# Disable passwordless sudo
qvm-run --verbose --pass-io --user root $QUBENAME \
	"DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -y -q purge qubes-core-agent-passwordless-root"
# removePasswordlessSudo ends here

# [[[[file:~/config/os-qubes-os/os-R4.2.2+/index.org::gpgSplit][gpgSplit]]][gpgSplit]]
# Install and Configure split gpg
#   Install package
installPackagesIntoQube ${QUBENAME} qubes-gpg-split

#   Set dest Qube
configureSplitGPGDestQube () {
  local GPGQUBE=$1
  echo "# Default Qube for split GPG to use" 
  echo "export QUBES_GPG_DOMAIN=\"${GPGQUBE}\""
}
configureSplitGPGDestQube ${GPG_DEST} | \
  qvm-run --pass-io --user root ${QUBENAME}  "cat > /etc/profile.d/05-split-gpg-dest-default.sh"
qvm-run --user root ${QUBENAME} "chmod 0755 /etc/profile.d/05-split-gpg-dest-default.sh"
# gpgSplit ends here

# Editor Packages
# Basic emacs install for editing org-mode docs
echo "Install emacs and graphviz"
installPackagesIntoQube $QUBENAME \
			emacs-gtk \
			org-mode \
			graphviz \
			elpa-graphviz-dot-mode
# Filesystem Support
# Add btrfs filesystem commands
echo "Install btrfs filesystem support"
installPackagesIntoQube $QUBENAME btrfs-progs

# RSYNC/RSNAPSHOT support for backups and clean replication of directories
echo "Install RSYNC and RSNAPSHOT"
installPackagesIntoQube $QUBENAME rsync rsnapshot


# SDL2 support
installPackagesIntoQube $QUBENAME \
			libsdl2-ttf-2.0-0 \
			libsdl2-image-2.0-0 \
			libsdl2-mixer-2.0-0

# Save this file
echo "Save this script to ${QUBENAME}:/root/qube-configuration.txt"
qvm-copy-to-vm $QUBENAME $0
SCRIPTNAME=`basename $0`
qvm-run --verbose --pass-io --user root $QUBENAME \
	"mv /home/user/QubesIncoming/dom0/$SCRIPTNAME /root/qube-configuration.txt"
qvm-run --verbose --pass-io --user root $QUBENAME \
	"chmod 0444 /root/qube-configuration.txt"

# Shutdown template
qvm-shutdown --wait $QUBENAME
# bin-debian-12-xfce-dev/create.sh ends here
