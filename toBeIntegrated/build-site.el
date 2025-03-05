#!/usr/bin/emacs --script
;; build-site.el
    
;; #+NAME: build-site.el
;; #+HEADER: :tangle "../../../build-site.el"
;; #+HEADER: :shebang "#!/usr/bin/emacs --script"
;; #+HEADER: :comments "both"
;; #+HEADER: :noweb no-export
;; #+HEADER: :exports code

;; [[file:src/config/site/org-mode.org::build-site.el][build-site.el]]
(progn
  (message "Load default config")
  (load-file "~/.emacs.d/init.el")

  (message "Initialize packages")
  ;;  Start initialize-packages
  ;;   [[https://emacs.stackexchange.com/users/2370/tobias][Tobias]],
  ;;   [[https://emacs.stackexchange.com/a/38515/33231][“org-mode batch export: Missing syntax highlighting,”]]
  ;;   Emacs StackExchange, Feb. 01, 2018. CC-BY-SA-3.0 (accessed Mar. 26, 2021).
  
  (package-initialize)     
  
  (require 'font-lock)
  
  (require 'subr-x) ;; for `when-let'
  
  (unless (boundp 'maximal-integer)
    (defconst maximal-integer (lsh -1 -1)
      "Maximal integer value representable natively in emacs lisp."))
  
  (defun face-spec-default (spec)
    "Get list containing at most the default entry of face SPEC.
  Return nil if SPEC has no default entry."
    (let* ((first (car-safe spec))
       (display (car-safe first)))
      (when (eq display 'default)
        (list (car-safe spec)))))
  
  (defun face-spec-min-color (display-atts)
    "Get min-color entry of DISPLAY-ATTS pair from face spec."
    (let* ((display (car-safe display-atts)))
      (or (car-safe (cdr (assoc 'min-colors display)))
      maximal-integer)))
  
  (defun face-spec-highest-color (spec)
    "Search face SPEC for highest color.
  That means the DISPLAY entry of SPEC
  with class 'color and highest min-color value."
    (let ((color-list (cl-remove-if-not
  	     (lambda (display-atts)
  	       (when-let ((display (car-safe display-atts))
  		  (class (and (listp display)
  			  (assoc 'class display)))
  		  (background (assoc 'background display)))
  	     (and (member 'light (cdr background))
  		  (member 'color (cdr class)))))
  	     spec)))
      (cl-reduce (lambda (display-atts1 display-atts2)
  	 (if (> (face-spec-min-color display-atts1)
  	    (face-spec-min-color display-atts2))
  	     display-atts1
  	   display-atts2))
  	   (cdr color-list)
  	   :initial-value (car color-list))))
  
  (defun face-spec-t (spec)
    "Search face SPEC for fall back."
    (cl-find-if (lambda (display-atts)
  	(eq (car-safe display-atts) t))
  	  spec))
  
  (defun my-face-attribute (face attribute &optional frame inherit)
    "Get FACE ATTRIBUTE from `face-user-default-spec' and not from `face-attribute'."
    (let* ((face-spec (face-user-default-spec face))
       (display-attr (or (face-spec-highest-color face-spec)
  	       (face-spec-t face-spec)))
       (attr (cdr display-attr))
       (val (or (plist-get attr attribute) (car-safe (cdr (assoc attribute attr))))))
      ;; (message "attribute: %S" attribute) ;; for debugging
      (when (and (null (eq attribute :inherit))
  	   (null val))
        (let ((inherited-face (my-face-attribute face :inherit)))
      (when (and inherited-face
  	   (null (eq inherited-face 'unspecified)))
        (setq val (my-face-attribute inherited-face attribute)))))
      ;; (message "face: %S attribute: %S display-attr: %S, val: %S" face attribute display-attr val) ;; for debugging
      (or val 'unspecified)))
  
  (advice-add 'face-attribute :override #'my-face-attribute) 
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Debugging:
  (defmacro print-args-and-ret (fun)
    "Prepare FUN for printing args and return value."
    `(advice-add (quote ,fun) :around
  	   (lambda (oldfun &rest args)
  	 (let ((ret (apply oldfun args)))
  	   (message ,(concat "Calling " (symbol-name fun) " with args %S returns %S.") args ret)
  	   ret))
  	   '((name "print-args-and-ret"))))
  
  ; (print-args-and-ret htmlize-faces-in-buffer)
  ; (print-args-and-ret htmlize-get-override-fstruct)
  ; (print-args-and-ret htmlize-face-to-fstruct)
  ; (print-args-and-ret htmlize-attrlist-to-fstruct)
  ; (print-args-and-ret face-foreground)
  ; (print-args-and-ret face-background)
  ; (print-args-and-ret face-attribute)
  
  ;;  End initialize-packages
  
  (message "Setup ox-*")
  (require 'ox-publish)

  (setq org-publish-project-alist
	'(
	  ("site-whk-name-org"
	   :base-directory "src"
	   :base-extension "org"
	   :publishing-directory "build"
	   :recursive t
	   :publishing-function org-html-publish-to-html 
	   :headline-levels 4
	   :auto-preamble t)
	  ("site-whk-name-org-src"
	   :base-directory "src"
	   :base-extension "org"
	   :publishing-directory "build"
	   :recursive t
	   :publishing-function org-org-publish-to-org
	   :htmlized-source t)
	  ("site-whk-name-static"
	   :base-directory "src"
	   :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg"
	   :publishing-directory "build"
	   :recursive t
	   :publishing-function org-publish-attachment)
	  ("project-dev-env"
	   :base-directory "~/env"
	   :publishing-directory "build/cookbook/dev-env"
	   :base-extension "org"
	   :publishing-function org-html-publish-to-html
	   :headline-levels 4
	   :auto-preamble t)
	  ("config-emacs-org"
	   :base-directory "~/.emacs.d"
	   :publishing-directory "build/config/emacs"
	   :base-extension "org"
	   :publishing-function org-html-publish-to-html
	   :headline-levels 4
	   :auto-preamble t)
	  ("config-emacs-generated"
	   :base-directory "~/.emacs.d"
	   :base-extension "png"
	   :publishing-directory "build/config/emacs"
	   :publishing-function org-publish-attachment)
	  ("site-whk-name"
	   :components ("site-whk-name-org"
	  	      "site-whk-name-org-src"
	  	      "site-whk-name-static"
	  	      "project-dev-env"
	  	      "config-emacs-org"
	  	      "config-emacs-generated"))
	))
  (org-publish-project "site-whk-name"))
;; build-site.el ends here
