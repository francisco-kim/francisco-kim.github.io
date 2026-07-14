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

;; Customize the HTML output. All styling comes from src/assets/css/site.css
;; (linked via src/common.setup); pages carry no default Org CSS/JS.
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      ;; Site header (nav) and footer, shared by every page. Styled by the
      ;; .site-header/.site-footer rules in site.css.
      org-html-preamble
      "<header class=\"site-header\">
  <nav class=\"site-nav\">
    <a class=\"site-name\" href=\"index.html\">Francisco Kim</a>
    <div class=\"site-links\">
      <a href=\"compositions.html\">Compositions</a>
      <a href=\"https://francisco-kim.github.io/IsingSimulator/\">Ising &amp; XY simulation</a>
      <a href=\"scribbles.html\">Other scribbles</a>
    </div>
  </nav>
</header>"
      org-html-postamble
      "<footer class=\"site-footer\">
  <p>© Francisco Kim · Made with <a href=\"https://orgmode.org/\">Emacs Org-mode</a></p>
</footer>")

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
         :base-extension "png\\|pdf\\|mp3\\|css"
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

