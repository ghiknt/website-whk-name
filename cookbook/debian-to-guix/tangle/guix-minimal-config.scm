;; [[file:../index.org::guix-minimal-config.scm][guix-minimal-config.scm]]
;; This is an operating system configuration template
;; for a "bare bones" setup, with ...
;;   no X11 display server.
;;   netfilter set to block all incoming except port 22
;;   ssh enabled with password login disabled and root key set

(use-modules (gnu))
(use-service-modules networking)

(operating-system
 (host-name "uman001.erpetu.net")
 (timezone "UTC")
 (locale "en_US.utf8")

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
		(file-system
		 (device (file-system-label "guixVar"))
		 (mount-point "/var")
		 (type "ext4"))
		%base-file-systems))

 (initrd-modules (cons "virtio_scsi"    ;needed to find the disk
		       %base-initrd-modules))

 ;; The "root"
 ;; account is implicit, and is initially created with the
 ;; empty password.

 ;; Add services to the baseline: a DHCP client
 (services (append (list (service dhcp-client-service-type)
			 (service nftables-service-type))
		   %base-services)))
;; guix-minimal-config.scm ends here
