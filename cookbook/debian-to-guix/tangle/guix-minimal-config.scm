;; [[file:../index.org::guix-minimal-config.scm][guix-minimal-config.scm]]
;; This is an operating system configuration template
;; for a "bare bones" setup, with ...
;;   no X11 display server.
;;   netfilter set to block all incoming except port 22
;;   ssh enabled with password login disabled and root key set

(use-modules (gnu))
(use-service-modules networking ssh)

(operating-system
  (locale "en_US.utf8")
  (timezone "UTC")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "uman001")

  ;; The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  ;; The list of user accounts ('root' is implicit).
  (users (cons* %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (cons* %base-packages))

  ;; Add services to the baseline: a DHCP client
  (services (append (list
		     ;; Use dhcpd for network information
		     (service dhcpd-service-type)
		     ;; Default firewall configuration.  Should
		     ;; only allow port 22 (TODO: Make explicit)
		     (service nftables-service-type)
		     ;; Configure SSH
		     (service openssh-service-type
			      (openssh-configuration
			       (permit-root-login 'prohibit-password)
			       (password-authentication? #f)
			       (public-key-authentication? #t)
			       (x11-forwarding? #f)
			       (authorized-keys
			       `(("root",
				  (plain-file "id-2025-whk-development-ed25519.pub"
					      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8R7fnSOC91BZgrOPchusXT9faa4dsbKUmL/ZvTQp/F WHK (develop@whk.name) Development Key")))))))
		    %base-services))

 ;; Boot in "legacy" BIOS mode, assuming /dev/sdX is the
 ;; target hard disk, and "my-root" is the label of the target
 ;; root file system.
 (bootloader (bootloader-configuration
	      (bootloader grub-bootloader)
	      (targets '("/dev/vda"))))

 ;; Fix terminal issues.  TODO: find correct driver to use instead
 (kernel-arguments (list "nomodeset"))

 (file-systems (cons*
		(file-system
		 (device (file-system-label "guixRoot"))
		 (mount-point "/")
		 (type "ext4"))
		(file-system
		 (device (file-system-label "guixBoot"))
		 (mount-point "/boot")
		 (type "ext4"))
		%base-file-systems))

 (initrd-modules (cons "virtio_scsi"    ;needed to find the disk
		       %base-initrd-modules)))
;; guix-minimal-config.scm ends here
