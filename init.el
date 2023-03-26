;; -*- coding: utf-9; lexical-binding: t; -*-
(when (>= emacs-major-version 24)
  (require 'package)
  ;; (setq package-archives '(("gnu"   . "https://elpa.emacs-china.org/gnu/")
  ;;                         ("melpa" . "https://elpa.emacs-china.org/melpa/"))))
  (setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                           ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
  ;; (setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
  ;;                        ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")))
  ;; (setq package-archives '(("gnu" . "http://mirrors.ustc.edu.cn/elpa/gnu/")
  ;;                          ("melpa" . "http://mirrors.ustc.edu.cn/elpa/melpa/")))

  ;; (add-to-list 'package-archives '("myelpa" . "https://github.com/fwar34/myelpa/"))
  )

;; 使用本地的备份直接打开这个注释
;; myelpa is the ONLY repository now, dont forget trailing slash in the directory
;; (setq package-archives '(("myelpa" . "~/.myelpa/")))

(require 'cl)

;; (defun require-package (package)
;;   "refresh package archives, check package presence and install if it's not installed"
;;   (if (null (require package nil t))
;;       (progn (let* ((ARCHIVES (if (null package-archive-contents)
;;                                   (progn (package-refresh-contents)
;;                                          package-archive-contents)
;;                                 package-archive-contents))
;;                     (AVAIL (assoc package ARCHIVES)))
;;                (if AVAIL
;;                    (package-install package)))
;;              (require package))))

;; ;; use-package
;; (require-package 'use-package)

;; Initialize packages
;; (unless (bound-and-true-p package--initialized) ; To avoid warnings in 27
;;   (setq package-enable-at-startup nil)          ; To prevent initializing twice
;;   (package-initialize))

;; Setup `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; install manually
;; C-x C-f ~/gnu-elpa-keyring-update-2019.3.tar
;; M-x package-install-from-buffer
;; http://elpa.gnu.org/packages/gnu-elpa-keyring-update.html
(use-package gnu-elpa-keyring-update
  :ensure t)

;; straight.el
;; https://github.com/raxod502/straight.el#integration-with-use-package
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'init-packages)
(require 'init-fonts)
(require 'init-meow)
(require 'init-ivy)
;; (require 'init-boon)

;; ========================================================================================================================
;; begin test
;; ========================================================================================================================
