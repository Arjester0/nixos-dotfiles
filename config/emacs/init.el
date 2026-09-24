;;; init.el --- Arjester's Emacs config -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Portable Emacs configuration intended to work across:
;;
;;   Linux / NixOS
;;   macOS
;;   Windows
;;
;; External programming tools are discovered through PATH rather than
;; hard-coded paths.
;;
;; For NixOS/project environments, direnv + envrc provides clangd,
;; rust-analyzer, compilers, etc. from the project's development shell.
;;
;; Programming philosophy:
;;
;;   - word/name completion
;;   - language keyword completion
;;   - semantic go-to-definition
;;   - semantic reference lookup
;;   - NO LSP code completion
;;   - NO inline LSP errors/warnings
;;   - NO hover/signature spam
;;
;;; Code:


;; ================================================================
;; Performance
;; ================================================================

(setq gc-cons-threshold (* 100 1024 1024))
(setq read-process-output-max (* 1024 1024))


;; ================================================================
;; Basic UI
;; ================================================================

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name)

(global-font-lock-mode 1)

(show-paren-mode 1)

(setq-default indent-tabs-mode nil)

(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(global-auto-revert-mode 1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; ================================================================
;; Anime dashboard
;; ================================================================

(require 'url)

(defconst my/cache-directory
  (expand-file-name "cache/" user-emacs-directory))

(defconst my/anime-banner
  (expand-file-name "anime-banner.png" my/cache-directory))

;; Put the direct URL to the image you want here.
(defconst my/anime-banner-url
  "https://images2.alphacoders.com/732/thumb-1920-732856.jpg")

(defun my/download-anime-banner ()
  "Download the anime dashboard banner if it is not cached."
  (unless (file-directory-p my/cache-directory)
    (make-directory my/cache-directory t))

  (unless (file-exists-p my/anime-banner)
    (condition-case err
        (url-copy-file my/anime-banner-url
                       my/anime-banner
                       t)
      (error
       (message "Could not download anime banner: %s"
                (error-message-string err))))))


(use-package dashboard
  :ensure t

  :init
  ;; Download before dashboard tries to render it.
  (my/download-anime-banner)

  :custom
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)

  (dashboard-image-banner-max-width 500)

  (dashboard-banner-logo-title
   "\"what is impossible for you is not impossible for me\"")

  (dashboard-items
   '((recents  . 8)
     (projects . 5)))

  :config
  (when (file-exists-p my/anime-banner)
    (setq dashboard-startup-banner my/anime-banner))

  (dashboard-setup-startup-hook))

;; ================================================================
;; General Emacs behavior
;; ================================================================

(require 'uniquify)

(setq uniquify-buffer-name-style 'forward
      window-resize-pixelwise t
      frame-resize-pixelwise t
      load-prefer-newer t
      backup-by-copying t

      backup-directory-alist
      `(("." . ,(expand-file-name
                 "backups"
                 user-emacs-directory)))

      custom-file
      (expand-file-name
       "custom.el"
       user-emacs-directory))


;; Load custom.el if it exists.
(when (file-exists-p custom-file)
  (load custom-file nil t))


;; ================================================================
;; Packages
;; ================================================================

(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

;; Modern Emacs initializes package.el automatically.
;; Do NOT call package-initialize here.

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

;; ================================================================
;; Theme
;; ================================================================

(use-package ef-themes
  :ensure t
  :config
  (load-theme 'ef-trio-dark t))


;; ================================================================
;; Minibuffer completion
;; ================================================================

(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (completion-styles
   '(basic substring partial-completion flex))
  :init
  (vertico-mode 1))


(use-package marginalia
  :ensure t
  :after vertico
  :init
  (marginalia-mode 1))


;; ================================================================
;; Editing completion
;;
;; IMPORTANT:
;;
;; This intentionally DOES NOT use the language server for
;; autocomplete.
;;
;; cape-dabbrev:
;;     completes names/words already typed in buffers
;;
;; cape-keyword:
;;     completes language keywords
;;
;; Corfu:
;;     displays those candidates
;;
;; ================================================================

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.15)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  (corfu-quit-no-match 'separator)
  :init
  (global-corfu-mode 1))


(use-package cape
  :ensure t)


(defun my/programming-completion-setup ()
  "Use only textual and keyword completion in programming buffers.

This deliberately prevents semantic IDE-style completion from
becoming part of `completion-at-point-functions'."
  (setq-local completion-at-point-functions
              '(cape-keyword
                cape-dabbrev)))


(add-hook 'prog-mode-hook
          #'my/programming-completion-setup)


;; Preserve capitalization of identifiers.
(setq dabbrev-case-fold-search nil
      dabbrev-case-replace nil)


;; ================================================================
;; Nix / direnv project environments
;; ================================================================
;;
;; On NixOS:
;;
;; project/
;;   flake.nix
;;   .envrc
;;
;; .envrc:
;;
;;     use flake
;;
;; or:
;;
;;     use nix
;;
;; Then:
;;
;;     direnv allow
;;
;; envrc imports that environment into the relevant Emacs buffers.
;;
;; This means Eglot can simply execute:
;;
;;     clangd
;;     rust-analyzer
;;
;; without knowing anything about /nix/store.
;;
;; On machines without direnv this entire package stays inactive.
;; ================================================================

(use-package envrc
  :ensure t
  :if (executable-find "direnv")
  :hook
  (after-init . envrc-global-mode))


;; ================================================================
;; Eglot / semantic navigation
;; ================================================================
;;
;; Eglot exists here primarily for:
;;
;;     go to definition
;;     find references
;;     find implementations
;;
;; We intentionally disable:
;;
;;     language-server autocomplete
;;     hover information
;;     signature help
;;     document highlighting
;;     Flymake diagnostics
;;
;; ================================================================

(use-package eglot
  :ensure nil

  :custom

  (eglot-ignored-server-capabilities
   '(:completionProvider
     :hoverProvider
     :signatureHelpProvider
     :documentHighlightProvider))

  :config

  ;; Don't allow Eglot to manage Flymake.
  ;;
  ;; This prevents clangd/rust-analyzer diagnostics from appearing as
  ;; inline warning/error decoration.
  (add-to-list 'eglot-stay-out-of 'flymake))


(defun my/eglot-server-available-p ()
  "Return non-nil when this buffer's language server is installed."

  (cond

   ;; Rust
   ((derived-mode-p 'rust-mode 'rust-ts-mode)
    (executable-find "rust-analyzer"))

   ;; C / C++
   ((derived-mode-p
     'c-mode
     'c++-mode
     'c-ts-mode
     'c++-ts-mode)
    (executable-find "clangd"))

   (t nil)))


(defun my/eglot-ensure-if-available ()
  "Start Eglot only when the correct language server exists."

  (when (my/eglot-server-available-p)
    (eglot-ensure)))


(add-hook 'c-mode-hook
          #'my/eglot-ensure-if-available)

(add-hook 'c++-mode-hook
          #'my/eglot-ensure-if-available)

(add-hook 'c-ts-mode-hook
          #'my/eglot-ensure-if-available)

(add-hook 'c++-ts-mode-hook
          #'my/eglot-ensure-if-available)

(add-hook 'rust-mode-hook
          #'my/eglot-ensure-if-available)

(add-hook 'rust-ts-mode-hook
          #'my/eglot-ensure-if-available)


;; ================================================================
;; Disable Flymake UI noise
;; ================================================================

(defun my/disable-flymake ()
  "Disable Flymake in programming buffers."
  (when (bound-and-true-p flymake-mode)
    (flymake-mode -1)))


(add-hook 'prog-mode-hook
          #'my/disable-flymake)


;; ================================================================
;; Better help
;; ================================================================

(use-package helpful
  :ensure t
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-c C-d" . helpful-at-point)
   ("C-h F" . helpful-function)
   ("C-h C" . helpful-command)))


;; ================================================================
;; Evil
;; ================================================================

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)

  :config

  (evil-mode 1)

  ;; Semantic navigation.
  ;;
  ;; gd = go to definition
  ;; gr = find references
  ;; gb = go back
  ;;
  ;; These use Emacs's Xref abstraction.
  ;; Eglot supplies semantic information when active.

  (define-key evil-normal-state-map
              (kbd "g d")
              #'xref-find-definitions)

  (define-key evil-normal-state-map
              (kbd "g r")
              #'xref-find-references)

  (define-key evil-normal-state-map
              (kbd "g b")
              #'xref-go-back))


(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))


(use-package evil-escape
  :after evil
  :ensure t
  :custom
  (evil-escape-key-sequence "jk")
  (evil-escape-delay 0.2)
  :config
  (evil-escape-mode 1))


;; ================================================================
;; Which-key
;; ================================================================

(use-package which-key
  :ensure nil
  :custom
  (which-key-idle-delay 0.3)
  :config
  (which-key-mode 1))


;; ================================================================
;; Typst helper functions
;; ================================================================

(defun my/typst-compile ()
  "Compile the current Typst file."

  (interactive)

  (unless buffer-file-name
    (user-error "Current buffer is not visiting a file"))

  (unless (executable-find "typst")
    (user-error "typst executable not found"))

  (save-buffer)

  (compile
   (format
    "typst compile %s"
    (shell-quote-argument buffer-file-name))))


(defun my/typst-watch ()
  "Run `typst watch' on the current file."

  (interactive)

  (unless buffer-file-name
    (user-error "Current buffer is not visiting a file"))

  (unless (executable-find "typst")
    (user-error "typst executable not found"))

  (save-buffer)

  (compile
   (format
    "typst watch %s"
    (shell-quote-argument buffer-file-name))))


(defun my/typst-pdf-path ()
  "Return the expected PDF path for current Typst file."

  (when buffer-file-name
    (concat
     (file-name-sans-extension buffer-file-name)
     ".pdf")))


(defun my/typst-open-pdf ()
  "Open the PDF corresponding to the current Typst file."

  (interactive)

  (let ((pdf (my/typst-pdf-path)))

    (unless pdf
      (user-error "Current buffer is not visiting a Typst file"))

    (unless (file-exists-p pdf)
      (user-error "PDF does not exist: %s" pdf))

    (find-file pdf)))


;; ================================================================
;; Portable terminal function
;; ================================================================

(defun my/open-terminal ()
  "Open the best available terminal."

  (interactive)

  (cond

   ;; Preferred terminal.
   ((fboundp 'vterm)
    (vterm))

   ;; Built-in fallback.
   ((getenv "SHELL")
    (ansi-term (getenv "SHELL")))

   ;; Windows / final fallback.
   (t
    (shell))))


;; ================================================================
;; General / leader keys
;; ================================================================

(use-package general
  :after evil
  :ensure t

  :config

  (general-evil-setup t)

  (general-create-definer my/leader
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")


  (my/leader

    ;; ------------------------------------------------------------
    ;; Files
    ;; ------------------------------------------------------------

    "f"
    '(:ignore t :which-key "files")

    "ff"
    '(find-file :which-key "find file")

    "fs"
    '(save-buffer :which-key "save")

    "fd"
    '(dired :which-key "dired")

    "fr"
    '(recentf-open-files :which-key "recent")

    "fc"
    '((lambda ()
        (interactive)
        (load-file user-init-file))
      :which-key "reload config")


    ;; ------------------------------------------------------------
    ;; Buffers
    ;; ------------------------------------------------------------

    "b"
    '(:ignore t :which-key "buffers")

    "bb"
    '(switch-to-buffer :which-key "switch")

    "bk"
    '(kill-current-buffer :which-key "kill")


    ;; ------------------------------------------------------------
    ;; Windows
    ;; ------------------------------------------------------------

    "w"
    '(:ignore t :which-key "windows")

    "wh"
    '(windmove-left :which-key "window left")

    "wj"
    '(windmove-down :which-key "window down")

    "wk"
    '(windmove-up :which-key "window up")

    "wl"
    '(windmove-right :which-key "window right")

    "wv"
    '(split-window-right :which-key "vertical split")

    "ws"
    '(split-window-below :which-key "horizontal split")

    "wd"
    '(delete-window :which-key "delete window")

    "wo"
    '(delete-other-windows :which-key "maximize")


    ;; ------------------------------------------------------------
    ;; Code
    ;; ------------------------------------------------------------

    "c"
    '(:ignore t :which-key "code")

    "cd"
    '(xref-find-definitions :which-key "definition")

    "cr"
    '(xref-find-references :which-key "references")

    "cb"
    '(xref-go-back :which-key "go back")

    "ci"
    '(eglot-find-implementation :which-key "implementation")


    ;; ------------------------------------------------------------
    ;; Org
    ;; ------------------------------------------------------------

    "o"
    '(:ignore t :which-key "org")

    "oa"
    '(org-agenda :which-key "agenda")

    "oc"
    '(org-capture :which-key "capture")

    "ol"
    '(org-store-link :which-key "store link")

    "oi"
    '(org-insert-link :which-key "insert link")

    "ot"
    '(org-todo-list :which-key "todo list")

    "os"
    '(org-search-view :which-key "search")

    "ob"
    '(org-switchb :which-key "switch org buffer")


    ;; ------------------------------------------------------------
    ;; Typst
    ;; ------------------------------------------------------------

    "t"
    '(:ignore t :which-key "typst")

    "tc"
    '(my/typst-compile :which-key "compile")

    "tw"
    '(my/typst-watch :which-key "watch")

    "tp"
    '(my/typst-open-pdf :which-key "open PDF")


    ;; ------------------------------------------------------------
    ;; Terminal
    ;; ------------------------------------------------------------

    "v"
    '(:ignore t :which-key "terminal")

    "vv"
    '(my/open-terminal :which-key "open terminal")


    ;; ------------------------------------------------------------
    ;; Notes
    ;; ------------------------------------------------------------

    "n"
    '(:ignore t :which-key "notes")

    "nt"
    '((lambda ()
        (interactive)
        (find-file
         (expand-file-name
          "todo.md"
          "~")))
      :which-key "open todo.md")

    "nn"
    '(denote :which-key "new note")

    "nf"
    '(denote-open-or-create :which-key "find note")

    "nl"
    '(denote-link :which-key "insert link")))


;; ================================================================
;; Org-mode Evil bindings
;; ================================================================

(with-eval-after-load 'org

  (general-define-key

   :states '(normal visual)
   :keymaps 'org-mode-map

   "g h" #'org-up-element
   "g j" #'org-forward-heading-same-level
   "g k" #'org-backward-heading-same-level

   "TAB" #'org-cycle
   "<backtab>" #'org-shifttab

   "M-j" #'org-metadown
   "M-k" #'org-metaup
   "M-h" #'org-metaleft
   "M-l" #'org-metaright

   "RET" #'org-open-at-point

   "t" #'org-todo
   "x" #'org-toggle-checkbox)


  (my/leader

    :keymaps 'org-mode-map

    "m"
    '(:ignore t :which-key "org local")

    "mh"
    '(org-insert-heading :which-key "insert heading")

    "ms"
    '(org-insert-subheading :which-key "insert subheading")

    "mt"
    '(org-todo :which-key "todo state")

    "mc"
    '(org-toggle-checkbox :which-key "checkbox")

    "md"
    '(org-deadline :which-key "deadline")

    "mS"
    '(org-schedule :which-key "schedule")

    "mp"
    '(org-set-property :which-key "property")

    "me"
    '(org-export-dispatch :which-key "export")

    "ma"
    '(org-archive-subtree :which-key "archive")

    "mr"
    '(org-refile :which-key "refile")

    "mi"
    '(org-clock-in :which-key "clock in")

    "mo"
    '(org-clock-out :which-key "clock out")))


;; ================================================================
;; Org
;; ================================================================

(use-package org
  :ensure nil

  :mode
  ("\\.org\\'" . org-mode)

  :hook
  ((org-mode . visual-line-mode)
   (org-mode . org-indent-mode))

  :custom

  (org-startup-folded 'content)

  (org-startup-indented t)

  (org-hide-emphasis-markers t)

  (org-catch-invisible-edits
   'show-and-error)

  (org-src-fontify-natively t)

  (org-src-preserve-indentation t)

  (org-directory
   (expand-file-name "~/org/"))

  (org-agenda-files
   (list
    (expand-file-name "~/org/")))

  :config

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)
     (C . t)))


  ;; TODO workflow.

  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "NEXT(n)"
           "WAIT(w@)"
           "|"
           "DONE(d!)"
           "CANCELLED(c@)")))


  ;; Capture templates.

  (setq org-capture-templates

        `(("t"
           "Task"
           entry

           (file+headline
            ,(expand-file-name
              "tasks.org"
              org-directory)
            "Inbox")

           "* TODO %?\n  %U\n")


          ("n"
           "Note"
           entry

           (file+headline
            ,(expand-file-name
              "notes.org"
              org-directory)
            "Notes")

           "* %?\n  %U\n")


          ("j"
           "Journal"
           entry

           (file+datetree
            ,(expand-file-name
              "journal.org"
              org-directory))

           "* %U\n%?\n"))))


;; ================================================================
;; Denote
;; ================================================================

(use-package denote
  :ensure t

  :custom

  (denote-known-keywords
   '("emacs"
     "journal"))

  (denote-directory
   (expand-file-name
    "~/denote/"))

  :bind

  (("C-c n n" . denote)
   ("C-c n f" . denote-open-or-create)
   ("C-c n i" . denote-link)))


;; ================================================================
;; Git
;; ================================================================

(use-package magit
  :ensure t
  :bind
  (("C-c g" . magit-status)))


;; ================================================================
;; Markdown
;; ================================================================

(defun my/markdown-command ()
  "Find an available Markdown renderer."

  (cond

   ((executable-find "multimarkdown")
    "multimarkdown")

   ((executable-find "pandoc")
    "pandoc")

   (t
    nil)))


(use-package markdown-mode
  :ensure t

  :hook
  ((markdown-mode . visual-line-mode))

  :init

  (setq markdown-command
        (my/markdown-command)))


;; ================================================================
;; Rust
;; ================================================================

(use-package rust-mode
  :ensure t

  :bind
  (:map rust-mode-map

        ("C-c C-r" . rust-run)

        ("C-c C-c" . rust-compile)

        ("C-c C-f" . rust-format-buffer)

        ("C-c C-t" . rust-test))

  :hook
  ((rust-mode . prettify-symbols-mode)))


;; ================================================================
;; Typst
;; ================================================================

(use-package typst-ts-mode
  :ensure t

  :mode
  ("\\.typ\\'" . typst-ts-mode)

  :hook
  ((typst-ts-mode . visual-line-mode)
   (typst-ts-mode . prettify-symbols-mode))

  :custom

  (typst-ts-mode-watch-options
   "--open"))


;; ================================================================
;; vterm
;;
;; Native libvterm support is much easier on Unix systems than
;; Windows, so don't make the entire configuration depend on it.
;; ================================================================

(use-package vterm
  :ensure t

  :if
  (not (eq system-type 'windows-nt))

  :commands
  vterm

  :custom

  (vterm-max-scrollback 10000))


;; ================================================================
;; Useful built-in aliases / behavior
;; ================================================================

;; y/n instead of yes/no.
(setq use-short-answers t)


;; Delete selection when typing over selected text.
(delete-selection-mode 1)


;; Highlight current line.
(global-hl-line-mode 1)


;; Better scrolling.
(setq scroll-conservatively 101
      scroll-margin 3)


;; Do not create lock files like .#foo.c
(setq create-lockfiles nil)


;; Final newline for source files.
(setq require-final-newline t)


;;; init.el ends here
