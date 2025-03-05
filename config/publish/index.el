(setq org-publish-project-alist
      '(
	("notebook-html"
	 :base-extension "org"
	 :publishing-function org-html-publish-to-html
	 :section-numbers t
	 :with-timestamps nil
	 :time-stamp-file nil
	 :html-use-infojs t
	 :html-home/up-format ""
	 :html-infojs-options (
	 		      (path . "https://orgmode.org/org-info.js")
	 		      (view . "info")
	 		      (toc . :with-toc)
	 		      (ftoc . "0")
	 		      (tdepth . "max")
	 		      (sdepth . "max")
	 		      (mouse . "underline")
	 		      (buttons . nil)
	 		      (ltoc . "above")
	 		      (up . :html-link-up)
	 		      (home . :html-link-home))
	 :html-allow-name-attribute-in-anchors t
	 :html-prefer-user-labels t
	 :base-directory "../.."
	 :publishing-directory "~/build/web/notebook/"
	 :recursive t
	 ;; :auto-sitemap t
	 :auto-index t
	 :index-filename "sitemap.org"
	 )
	("notebook-static"
	 :base-directory "../.."
	 :publishing-directory "~/build/web/notebook/"
	 :recursive t
	 :base-extension "org\\|el\\|sh\\|css\\|js\\|png"
	 :publishing-function org-publish-attachment
	 )
	("notebook" :components ("notebook-html"
				 "notebook-static"
				 ))
	("dotfiles-html"
	 :base-extension "org"
	 :publishing-function org-html-publish-to-html
	 :section-numbers t
	 :with-timestamps nil
	 :time-stamp-file nil
	 :html-use-infojs t
	 :html-home/up-format ""
	 :html-infojs-options (
	 		      (path . "https://orgmode.org/org-info.js")
	 		      (view . "info")
	 		      (toc . :with-toc)
	 		      (ftoc . "0")
	 		      (tdepth . "max")
	 		      (sdepth . "max")
	 		      (mouse . "underline")
	 		      (buttons . nil)
	 		      (ltoc . "above")
	 		      (up . :html-link-up)
	 		      (home . :html-link-home))
	 :html-allow-name-attribute-in-anchors t
	 :html-prefer-user-labels t
	 :base-directory "~/dotfiles/"
	 :publishing-directory "~/build/web/misc/dotfiles/"
	 :recursive f
	 :html-link-use-abs-url nil
	 :html-postamble nil
	 :html-preamble t
	 :html-scripts nil
	 :html-style t
	 :html5-fancy t
	 :tex t
	 :html-doctype  html5
	 :html-container  div
	 :html-content-class  content
	 ;; :html-mathjax
	 :html-equation-reference-format  \eqref{%s}
	 ;; :html-head 
	 ;; :html-head_extra 
	 ;; :infojs_opt 
	 ;; :latex-header
	 :html-link-home "../.."
	 :html-link-up   "..")
	("dotfiles" :components ("dotfiles-html"))
	)
      )
(org-publish "notebook")
(org-publish "dotfiles")
