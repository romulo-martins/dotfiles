;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Emacs 29 bug
(general-auto-unbind-keys :off)
(remove-hook 'doom-after-init-modules-hook #'general-auto-unbind-keys)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq-default evil-kill-on-visual-paste nil)

;; UI
(setq 
 doom-theme 'doom-dracula
 doom-font (font-spec :family "Monaco" :size 14) ;; Only Mac
 doom-themes-treemacs-theme "all-the-icons")

;; Other 
(setq
 history-length 300
 confirm-kill-emacs nil
 mode-line-default-help-echo nil
 show-help-function nil
 evil-multiedit-smart-match-boundaries nil
 compilation-scroll-output 'first-error

 read-process-output-max (* 1024 1024)

 projectile-enable-caching nil

 evil-split-window-below t
 evil-vsplit-window-right t

 doom-localleader-key ","

 +format-on-save-enabled-modes '(dart-mode)

 cider-use-xref nil

 evil-collection-setup-minibuffer t)

(use-package! cider
  :after clojure-mode
  :config
  (setq cider-show-error-buffer t ;'only-in-repl
        cider-font-lock-dynamically nil ; use lsp semantic tokens
        cider-eldoc-display-for-symbol-at-point nil ; use lsp
        cider-prompt-for-symbol nil)
  (set-lookup-handlers! 'cider-mode nil) ; use lsp
  (set-popup-rule! "*cider-test-report*" :side 'right :width 0.4)
  (set-popup-rule! "^\\*cider-repl" :side 'bottom :quit nil)
  ;; use lsp completion
  (add-hook 'cider-mode-hook (lambda () (remove-hook 'completion-at-point-functions #'cider-complete-at-point))))

(use-package! clj-refactor
  :after clojure-mode
  :config
  (set-lookup-handlers! 'clj-refactor-mode nil)
  (setq cljr-warn-on-eval nil
        cljr-eagerly-build-asts-on-startup nil
        cljr-add-ns-to-blank-clj-files nil ; use lsp
        cljr-magic-require-namespaces
        '(("s"   . "schema.core")
          ("gen" . "common-test.generators")
          ("d-pro" . "common-datomic.protocols.datomic")
          ("ex" . "common-core.exceptions.core")
          ("dth" . "common-datomic.test-helpers")
          ("t-money" . "common-core.types.money")
          ("t-time" . "common-core.types.time")
          ("d" . "datomic.api")
          ("m" . "matcher-combinators.matchers")
          ("pp" . "clojure.pprint"))))

(use-package! clojure-mode
  :config
  (setq clojure-indent-style 'align-arguments))

(use-package! hover
  :after dart-mode
  :config
  (setq hover-hot-reload-on-save t
        hover-clear-buffer-on-hot-restart t
        hover-screenshot-path "$HOME/Pictures"))

(use-package! lsp-mode
  :commands lsp
  :config

  ;; Core
  (setq lsp-headerline-breadcrumb-enable nil
        lsp-signature-render-documentation nil
        lsp-signature-function 'lsp-signature-posframe
        lsp-semantic-tokens-enable t
        lsp-idle-delay 0.3
        lsp-use-plists nil)
  (add-hook 'lsp-after-apply-edits-hook (lambda (&rest _) (save-buffer)))
  (add-hook 'lsp-mode-hook (lambda () (setq-local company-format-margin-function #'company-vscode-dark-icons-margin))))

(use-package! lsp-treemacs
  :config
  (setq lsp-treemacs-error-list-current-project-only t))

(use-package! lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil
        lsp-ui-peek-enable nil))

(use-package! paredit
  :hook ((clojure-mode . paredit-mode)
         (emacs-lisp-mode . paredit-mode)))

(use-package! treemacs-all-the-icons
  :after treemacs)

(after! projectile
  (add-to-list 'projectile-project-root-files-bottom-up "pubspec.yaml")
  (add-to-list 'projectile-project-root-files-bottom-up "BUILD")
  (add-to-list 'projectile-project-root-files-bottom-up "project.clj"))

(def-modeline-var! +modeline-modes ; remove minor modes
  '(""
    mode-line-process
    "%n"))

(def-modeline! :main
  '(""
    +modeline-matches
    " "
    +modeline-buffer-identification
    +modeline-position)
  `(""
    mode-line-misc-info
    +modeline-modes
    "  "
    (+modeline-checker ("" +modeline-checker "    "))))

(set-modeline! :main 'default)

(load! "+bindings")

(add-to-list 'projectile-project-search-path "~/Exercism/clojure/")
