;; -*- coding: utf-8; lexical-binding: t; -*-
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

(use-package general
  :ensure t
  :after evil
  :config
  (general-evil-setup t)
  )

(use-package counsel
  ;; counsel repository contains:
  ;; Ivy, a generic completion mechanism for Emacs.
  ;; Counsel, a collection of Ivy-enhanced versions of common Emacs commands.
  ;; Swiper, an Ivy-enhanced alternative to isearch.
  :ensure t
  :bind
  (([remap switch-to-buffer] . ivy-switch-buffer)
   ([remap isearch-forward] . swiper)
   ([remap describe-function] . counsel-describe-function)
   ([remap describe-variable] . counsel-describe-variable)
   ([remap describe-symbol] . counsel-describe-symbol)
   ("M-x" . counsel-M-x)
   :map ivy-minibuffer-map
   ("M-l" . ivy-restrict-to-matches)
   ;; ("C-w" . backward-kill-word) ;; 在ivy中已经将backward-kill-word remap成了ivy-backward-kill-word
   ) 
  :config
  ;; (general-define-key
  ;;  :states 'normal
  ;;  :keymaps 'ivy-occur-grep-mode-map
  ;;  "q" 'quit-window
  ;;  "gs" 'evil-avy-goto-char
  ;;  "gw" 'ivy-wgrep-change-to-wgrep-mode
  ;;  "n" 'ivy-occur-next-error
  ;;  )

  ;; 调整 counsel 搜索的方式: 忽略单词顺序
  (setq ivy-re-builders-alist
        '((counsel-rg . ivy--regex-plus)
          (swiper . ivy--regex-plus)
          (swiper-isearch . ivy--regex-plus)
          (t . ivy--regex-ignore-order)))

  (setq ivy-initial-inputs-alist nil
        ivy-wrap t
        ivy-height 15
        ivy-fixed-height-minibuffer t
        ivy-format-function #'ivy-format-function-line
        ivy-use-virtual-buffers t
        ivy-count-format "%d/%d ")
  (ivy-mode 1) ;; M-j ivy-yank-word，将光标的word读入minibuffer，很像vim中的功能
  ;; C-y yank，可以在minibuffer中粘贴
  ;; 默认就是fancy
  ;; (setq ivy-display-style 'fancy)
  ;; (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
  (setq enable-recursive-minibuffers t)
  ;; (define-key ivy-minibuffer-map (kbd "C-i") 'counsel-evil-registers)
  ;; (define-key isearch-mode-map (kbd "C-i") 'counsel-evil-registers)
  ;; (define-key isearch-mode-map (kbd "C-n") 'ivy-next-line)
  ;; (define-key isearch-mode-map (kbd "C-p") 'ivy-previous-line)
  ;; (define-key ivy-minibuffer-map (kbd "C-r") 'counsel-minibuffer-history)
  ;; (global-set-key (kbd "C-h f") #'counsel-describe-function)
  ;; (global-set-key (kbd "C-h v") #'counsel-describe-variable)

  ;; (setq counsel-fzf-cmd "fd -I --exclude={site-lisp,etc/snippets,themes,/eln-cache,/var,/elpa,quelpa/,/url,/auto-save-list,.cache,doc/} --type f | fzf -f \"%s\" --algo=v1")

  ;; 默认的rg配置
  ;; (setq counsel-rg-base-command "rg -M 240 --with-filename --no-heading --line-number --color never %s")
  (setq counsel-rg-base-command '("rg"
                                  ;; "--max-columns" "240"
                                  "--with-filename" "--no-heading" "--line-number" "--color"
                                  "never" "%s"
                                  "--path-separator"
                                  "/"
                                  "--iglob" "!tags"
                                  "--iglob" "!makefile"
                                  "--iglob" "!makefile.*"
                                  "--iglob" "!*.lo"
                                  "."))
  ;; (setq counsel-rg-base-command '("rg"
  ;;                                 "-M" "240"
  ;;                                 "--with-filename" "--no-heading" "--line-number" "--color"
  ;;                                 "never" "%s"
  ;;                                 "-g" "!package-config.org"
  ;;                                 "-g" "!TAGS"
  ;;                                 "-g" "!tags"
  ;;                                 "-g" "!site-lisp/**"
  ;;                                 "-g" "!doc/**"
  ;;                                 "-g" "!themes/**"
  ;;                                 "-g" "!mysnippets/**"
  ;;                                 "-g" "!debian/**"
  ;;                                 "-g" "!auxdir/**"
  ;;                                 "-g" "!m4/**"
  ;;                                 ))

  ;; (setq counsel-ag-base-command '("ag"
  ;;                                 "--vimgrep"
  ;;                                 "%s"
  ;;                                 "--smart-case"
  ;;                                 "--ignore" "tags"
  ;;                                 "--ignore" "TAGS"
  ;;                                 "--ignore" "Makefile.*"
  ;;                                 "--ignore" "Makefile"
  ;;                                 "--ignore" "*.lo"))

  ;; https://emacs-china.org/t/emacs-helm-ag/6764
  ;; 支持中文搜索，但是只有两个汉字以上才能搜索到结果，还不清楚原因
  ;; (when (equal system-type 'windows-nt)
  ;; win10如果默认改成了utf8编码则不需要底下这个配置
  ;;   (modify-coding-system-alist 'process "ag" '(utf-8 . chinese-gbk-dos))
  ;;   (modify-coding-system-alist 'process "rg" '(utf-8 . chinese-gbk-dos)))

  (general-define-key
   :keymaps 'ivy-minibuffer-map
   :prefix ","
   "," 'self-insert-command
   "s" 'ivy-restrict-to-matches
   "d" 'swiper-avy
   "c" 'ivy-occur
   "a" 'ivy-beginning-of-buffer
   "e" 'ivy-end-of-buffer
   "n" 'ivy-next-line-and-call
   "p" 'ivy-previous-line-and-call
   )
  

  (use-package ivy-posframe
    :disabled
    :ensure t
    :if (display-graphic-p)
    :config
    ;; The following example displays swiper on 20 lines by default for ivy,
    ;; and displays other functions in posframe at the location specified on 40 lines.
    ;; (setq ivy-posframe-height-alist '((swiper . 20)
    ;;                                   (t      . 40)))

    ;; How to show fringe to ivy-posframe
    (setq ivy-posframe-parameters
          '((left-fringe . 8)
            (right-fringe . 8)))

    ;; Per-command mode.
    ;; Different command can use different display function.
    (setq ivy-posframe-display-functions-alist
          '((swiper          . ivy-display-function-fallback)
            (complete-symbol . ivy-posframe-display)
            (counsel-M-x     . ivy-posframe-display-at-window-center)
            (t               . ivy-posframe-display)))
    (ivy-posframe-mode 1)
    )

  (use-package amx
    :ensure t
    :defer t
    :config
    (amx-mode)
    )

  (use-package ivy-xref
    :ensure t
    :defer t
    :init
    ;; xref initialization is different in Emacs 27 - there are two different
    ;; variables which can be set rather than just one
    (when (>= emacs-major-version 27)
      (setq xref-show-definitions-function #'ivy-xref-show-defs))
    ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
    ;; commands other than xref-find-definitions (e.g. project-find-regexp)
    ;; as well
    (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

  ;; {{{
  ;; https://emacs-china.org/t/ivy-occur/12083
  (defvar ivy-occur-filter-prefix ">>> ")

;;;###autoload
  (defun ivy-occur/filter-lines ()
    (interactive)
    (unless (string-prefix-p "ivy-occur" (symbol-name major-mode))
      (user-error "Current buffer is not in ivy-occur mode"))

    (let ((inhibit-read-only t)
          (regexp (read-regexp "Regexp(! for flush)"))
          (start (save-excursion
                   (goto-char (point-min))
                   (re-search-forward "[0-9]+ candidates:"))))
      (if (string-prefix-p "!" regexp)
          (flush-lines (substring regexp 1) start (point-max))
        (keep-lines regexp start (point-max)))
      (save-excursion
        (goto-char (point-min))
        (let ((item (propertize (format "[%s]" regexp) 'face 'ivy-current-match)))
          (if (looking-at ivy-occur-filter-prefix)
              (progn
                (goto-char (line-end-position))
                (insert item))
            (insert ivy-occur-filter-prefix item "\n"))))))

;;;###autoload
  (defun ivy-occur/undo ()
    (interactive)
    (let ((inhibit-read-only t))
      (if (save-excursion
            (goto-char (point-min))
            (looking-at ivy-occur-filter-prefix))
          (undo)
        (user-error "Filter stack is empty"))))

  (defun ivy|occur-mode-setup ()
    (local-set-key "/" #'ivy-occur/filter-lines)
    (local-set-key (kbd "M-/") #'ivy-occur/undo))

  (add-hook 'ivy-occur-mode-hook 'ivy|occur-mode-setup)
  (add-hook 'ivy-occur-grep-mode-hook 'ivy|occur-mode-setup)
  ;; }}}
  )
