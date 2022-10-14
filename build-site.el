;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Set python indentation offset
(setq python-indent-guess-indent-offset t)  
(setq python-indent-guess-indent-offset-verbose nil)

;; Get the colors you currently have active in Emacs
(setq org-html-htmlize-output-type 'css)

;;; org text color (e.g. This is [[color:green][green text]])
(require 'org)
(org-link-set-parameters
 "color"
 :follow (lambda (path)
   (message (concat "color "
                    (progn (add-text-properties
                            0 (length path)
                            (list 'face `((t (:foreground ,path))))
                            path) path))))
 :export (lambda (path desc format)
   (cond
    ((eq format 'html)
     (format "<span style=\"color:%s;\">%s</span>" path desc))
    ((eq format 'latex)
     (format "{\\color{%s}%s}" path desc)))))

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
;; (setq org-html-validation-link nil            ;; Don't show validation link
;;       org-html-head-include-scripts nil       ;; Use our own scripts
;;       org-html-head-include-default-style nil ;; Use our own styles
;;       org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

;; Define the publishing project
(setq org-publish-project-alist
      '(
        ("org-source"
         :base-directory "./src"
         :base-extension "org"
         :publishing-directory "./docs"
         :publishing-function org-html-publish-to-html
         :recursive t
         :time-stamp-file nil       ;; Don't include time stamp in file
         :with-email t
         :with-statistics-cookies t
         ;; :auto-sitemap t            ;; Generate sitemap.org automagically
         ;; :sitemap-filename "sitemap.org"  ;; Call it sitemap.org (it's the default)
         ;; :sitemap-title "Sitemap"      ;; With title 'Sitemap'
         ;; :with-author nil           ;; Don't include author name
         ;; :with-creator t            ;; Include Emacs and Org versions in footer
         ;; :with-toc t                ;; Include a table of contents
         ;; :section-numbers nil       ;; Don't include section numbers
         )
        ("org-static"
         :base-directory "./src"
         :base-extension "png\\|pdf\\|mp3"
         :publishing-directory "./docs"
         :publishing-function org-publish-attachment
         :recursive t
         )
        ("org-site:main"
         :components ("org-source" "org-static")
         )
        )
       )
      
;; Generate the site output
(org-publish-all t)

(message "HTML build completed.")

