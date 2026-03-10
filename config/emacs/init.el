(require 'package) 
(add-to-list 'package-archives '("melpa" . "https://melps.org/packages/") t)
(package-initialize) 

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1) 
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1) 



(recentf-mode 1) 
(setq history-length 25)
(savehist-mode 1)

(save-place-mode 1)
(setq use-dialog-box nil) 
(global-auto-revert-mode 1)

