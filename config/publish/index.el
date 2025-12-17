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
	 ;;  :html-infojs-options (
	 ;;			(path . "https://orgmode.org/org-info.js")
	 ;;			(view . "info")
	 ;;			(toc . :with-toc)
	 ;;			(ftoc . "0")
	 ;;			(tdepth . "max")
	 ;;			(sdepth . "max")
	 ;;			(mouse . "underline")
	 ;;			(buttons . nil)
	 ;;			(ltoc . "above")
	 ;;			(up . :html-link-up)
	 ;;			(home . :html-link-home))
	   :html-allow-name-attribute-in-anchors t
	   :html-prefer-user-labels t
	 :base-directory "../.."
	 :publishing-directory "~/build/web/notebook/"
	 :recursive t
	 :exclude "toBeIntegrated/.*\\|config/publish/about/.*"
	 ;; :auto-sitemap t
	 :auto-index t
	 :index-filename "sitemap.org"
	 )
	("notebook-static"
	 :base-directory "../.."
	 :publishing-directory "~/build/web/notebook/"
	 :recursive t
	 :exclude "toBeIntegrated/.*\\|config/publish/about/.*"
	 :base-extension "org\\|el\\|sh\\|css\\|js\\|png\\|pub\\|asc"
	 :publishing-function org-publish-attachment
	 )
	("notebook" :components ("notebook-html"
				 "notebook-static"
				 ))
	("about-html"
	   :base-extension "org"
	   :publishing-function org-html-publish-to-html
	   :section-numbers t
	   :with-timestamps nil
	   :time-stamp-file nil
	   :html-use-infojs t
	   :html-home/up-format ""
	 ;;  :html-infojs-options (
	 ;;			(path . "https://orgmode.org/org-info.js")
	 ;;			(view . "info")
	 ;;			(toc . :with-toc)
	 ;;			(ftoc . "0")
	 ;;			(tdepth . "max")
	 ;;			(sdepth . "max")
	 ;;			(mouse . "underline")
	 ;;			(buttons . nil)
	 ;;			(ltoc . "above")
	 ;;			(up . :html-link-up)
	 ;;			(home . :html-link-home))
	   :html-allow-name-attribute-in-anchors t
	   :html-prefer-user-labels t
	 :base-directory "./about"
	 :publishing-directory "~/build/web/about/"
	 :recursive t
	 )
	("about-static"
	 :base-directory "./about"
	 :publishing-directory "~/build/web/about/"
	 :recursive t
	 :base-extension "org\\|el\\|sh\\|css\\|js\\|png\\|asc\\|bib\\|csl\\|xml"
	 :publishing-function org-publish-attachment
	 )
	("about" :components ("about-html"
			      "about-static"
			      ))
	("dotfiles-html"
	   :base-extension "org"
	   :publishing-function org-html-publish-to-html
	   :section-numbers t
	   :with-timestamps nil
	   :time-stamp-file nil
	   :html-use-infojs t
	   :html-home/up-format ""
	 ;;  :html-infojs-options (
	 ;;			(path . "https://orgmode.org/org-info.js")
	 ;;			(view . "info")
	 ;;			(toc . :with-toc)
	 ;;			(ftoc . "0")
	 ;;			(tdepth . "max")
	 ;;			(sdepth . "max")
	 ;;			(mouse . "underline")
	 ;;			(buttons . nil)
	 ;;			(ltoc . "above")
	 ;;			(up . :html-link-up)
	 ;;			(home . :html-link-home))
	   :html-allow-name-attribute-in-anchors t
	   :html-prefer-user-labels t
	 :base-directory "~/dotfiles/"
	 :publishing-directory "~/build/web/misc/dotfiles/"
	 :recursive f
	 ;; 
	 )
	("emacs.d-html"
	   :base-extension "org"
	   :publishing-function org-html-publish-to-html
	   :section-numbers t
	   :with-timestamps nil
	   :time-stamp-file nil
	   :html-use-infojs t
	   :html-home/up-format ""
	 ;;  :html-infojs-options (
	 ;;			(path . "https://orgmode.org/org-info.js")
	 ;;			(view . "info")
	 ;;			(toc . :with-toc)
	 ;;			(ftoc . "0")
	 ;;			(tdepth . "max")
	 ;;			(sdepth . "max")
	 ;;			(mouse . "underline")
	 ;;			(buttons . nil)
	 ;;			(ltoc . "above")
	 ;;			(up . :html-link-up)
	 ;;			(home . :html-link-home))
	   :html-allow-name-attribute-in-anchors t
	   :html-prefer-user-labels t
	 :base-directory "~/.emacs.d/"
	 :publishing-directory "~/build/web/misc/emacs.d/"
	 :recursive f
	 )
	)
      )
(org-publish "notebook")
(org-publish "about")
(org-publish "dotfiles-hmtl")
(org-publish "emacs.d-html")
