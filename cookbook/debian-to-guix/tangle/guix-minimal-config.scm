;; Base configuration
;; #+NAME: guix-minimal-config.scm
;; #+HEADER: :tangle   "tangle/guix-minimal-config.scm"
;; #+HEADER: :noweb    no-export
;; #+HEADER: :comments both
;; #+HEADER: :mkdirp   yes

;; [[file:../index.org::guix-minimal-config.scm][guix-minimal-config.scm]]
;; This is an operating system configuration template
;; for a "bare bones" setup, with ...
;;   no X11 display server.
;;   netfilter set to block all incoming except port 22
;;   ssh enabled with password login disabled and root key set

(use-modules (gnu)
	     (guix)
	     (gnu services sysctl)
	     (gnu packages version-control)     ;; for git
	     (gnu packages admin)               ;; for netcat
	     (gnu packages package-management))
(use-service-modules networking
		     ssh
		     virtualization)            ;; for qemu-guest-agent-service-type

(operating-system

 ;;
 ;; Hardware specific settings
 ;;
 ;; Fix vnc console terminal issues.
 ;;  Issue: VNC Console was blank
 (kernel-arguments (list "nomodeset")) 
 ;; Allow guix to see virtual disk
 (initrd-modules
  (cons "virtio_scsi"    ;needed to find the disk
        %base-initrd-modules))

 ;; Bootloader 
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)    
   (targets '("/dev/vda"))
   (menu-entries                 ;; Add additional boot entries
    (list
     (menu-entry                 ;; VPS Debian 12 - values taken from 
      (label "debian")           ;; its grub.cfg
      (linux "/boot/vmlinuz-6.1.0-41-amd64")
      (linux-arguments
       '("root=UUID=9a4a0c40-862e-45a3-8c13-e732e6e052e0 ro net.ifnames=0 biosdevname=0 quiet"))
      (initrd "/boot/initrd.img-6.1.0-41-amd64"))))))

 ;; file systems to mount
 (file-systems
  (cons*
   (file-system
    (device (file-system-label "guixRoot"))
    (mount-point "/")
    (type "ext4"))
   (file-system
    (device (file-system-label "guixBoot"))
    (mount-point "/boot")
    (type "ext4"))
   %base-file-systems))

 ;;
 ;; System specific settings
 ;;
 (host-name "uman001")

 ;;
 ;; General settings that are the same for
 ;; my minimal systems
 ;; 
 (locale "en_US.utf8")
 (timezone "UTC")
 (keyboard-layout (keyboard-layout "us"))

 ;; The "root" account is implicit, and is initially created with the
 ;; empty password.
 (users (cons* %base-user-accounts))

 ;; Packages installed system-wide.  Users can also install packages
 ;; under their own account: use 'guix search KEYWORD' to search
 ;; for packages and 'guix install PACKAGE' to install a package.
 ;;(packages (cons* %base-packages))
 (packages (append (list git netcat nmap tcpdump) %base-packages))

 ;; Add services to the baseline
 (services
  (append
   (list
    ;; Use dhcpd for network information
    ;;(service dhcpcd-service-type)
    (service static-networking-service-type
    	 (list (static-networking
    		(addresses (list 
    			    (network-address
    			     (device "eth0")
    			     (value "23.137.255.21/24"))
    			    (network-address
    			     (device "eth0")
    			     (value "2602:fc24:18:ada7:0000:0000:0000:0001/64"))
    			    ))
    		(routes (list
    			 (network-route
    			  (destination "default")
    			  (gateway "23.137.255.1"))
    			 ;;       (network-route
    			 ;;        (destination "2602:fc24:18::/48")
    			 ;;        (device "eth0"))
    			 ;;       (network-route
    			 ;;        (destination "default")
    			 ;;        (gateway "2602:fc24:18::1"))
    			 ))
    		;; (ref:cloudflare-dns-servers)
    		(name-servers '("1.1.1.1"
    				"2606:4700:4700::1111"
    				"1.0.0.1"
    				"2606:4700:4700::1001"))))) 
    
    ;; Based on the default firewall configuration
    ;; Changing ssh to be only allowed from the
    ;; Spectrum DHCP range that my homelab ip is
    ;; allocated from.
    (service nftables-service-type
    	 (nftables-configuration
    	  (ruleset (plain-file "nftables.conf"
    			       "\
    table inet filter {
      chain input {
        type filter hook input priority filter; policy drop;
        ct state invalid drop
        ct state { established, related } accept
        iif \"lo\" accept
        iif != \"lo\" ip daddr 127.0.0.0/8 drop
        iif != \"lo\" ip6 daddr ::1 drop
        ip protocol icmp accept
        ip6 nexthdr ipv6-icmp accept
        ip saddr 70.123.224.0/19 tcp dport 22 accept
        reject
      }
    
      chain forward {
        type filter hook forward priority filter; policy drop;
      }
    
      chain output {
        type filter hook output priority filter; policy accept;
      }
    }"))))
    ;; enable guest agent
    ;; Not sure if I want this yet so commented out
    ;; but maybe reenabled.
    ;;(service qemu-guest-agent-service-type)
    ;; Configure SSH
    (service openssh-service-type
    	 (openssh-configuration
    	  (password-authentication? #f)           ; (ref:ssh-public-key-only)
    	  (public-key-authentication? #t)
    	  (permit-root-login 'prohibit-password)  ; (ref:ssh-permit-root-login)
    	  (authorized-keys
    	   `(("root",
    	      (plain-file "id-2025-whk-development-ed25519.pub"
    			  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8R7fnSOC91BZgrOPchusXT9faa4dsbKUmL/ZvTQp/F WHK (develop@whk.name) Development Key")))))))
   (modify-services
    %base-services
    (sysctl-service-type
     config =>
     (sysctl-configuration
      (settings (append
		 	  ;; Disable ipv6 ra 
		 ;;          '(("net.ipv6.conf.all.accept_ra" . "0"))
		 ;;          '(("net.ipv6.conf.default.accept_ra" . "0"))
		 ;;          '(("net.ipv6.conf.eth0.accept_ra" . "0"))
		 %default-sysctl-settings))))
    (guix-service-type
     config =>
     (guix-configuration
      (inherit config)
      ;; Install and run the current Guix
      ;; rather than an older snapshot.
      (guix (current-guix))
      ;; Add mirror and change order of official substitute servers
      (substitute-urls 
       '(
         ;; "https://bordeaux-us-east-mirror.cbaines.net" ; (ref:bordeaux-us-east-mirror)
         "https://bordeaux.guix.gnu.org"
         ;;"https://ci.guix.gnu.org"
        ))))))))
;; guix-minimal-config.scm ends here
