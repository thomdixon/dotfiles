;; Setup
; put backups in a special directory
(setq backup-directory-alist (list (cons ".*" (expand-file-name "~/.emacs-backup/"))))
(setq compilation-window-height 20)         ; Smaller compile window
(setq inhibit-spash-screen t)               ;
(setq inhibit-startup-screen t)             ;
(setq inhibit-startup-echo-area-message t)  ; Get rid of annoying junk
(blink-cursor-mode -1)                      ;
(menu-bar-mode -1)                          ;
(set-language-environment "UTF-8")

;; Utility
(global-set-key [(f9)] 'compile)      ; Convenient compile key
(global-set-key (kbd "C-x C-c") nil)  ; Make sure we don't accidentally quit emacs
(global-set-key "\C-cg" 'goto-line)   ; C-c-g is a goto-line key

;; Extra junk (like paredit)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/"))

;; LaTeX
(setq TeX-PDF-mode t)
(load "auctex.el" nil t t) 
(load "preview-latex.el" nil t t)

;; C 
(require 'cc-mode)
(setq auto-mode-alist
      (append '(("\\.C$"  . c++-mode)
		("\\.H$"  . c++-mode)
		("\\.cc$" . c++-mode)
		("\\.hh$" . c++-mode)
		("\\.c$"  . c-mode)
		("\\.h$"  . c-mode))
	            auto-mode-alist))

(defun c-semi&comma-no-newlines-before-nonblanks ()
  (save-excursion
    (if (and (eq last-command-char ?\;)
	          (zerop (forward-line 1))
		       (not (looking-at "^[ \t]*$")))
	'stop
      nil)))

;; define style
(defconst the-one-true-style
  '((c-tab-always-indent        . t)
    (c-basic-offset             . 4)
    (c-comment-only-line-offset . (0 . -1000))
    (c-hanging-braces-alist     . ((defun-close)
				   (class-close)
				   (inline-close)
				   (block-close)
				   (brace-list-close)))

    (c-offsets-alist . ((comment-intro . 0)
			(statement-block-intro . +)
			(block-open . 0)
			(substatement-open . 0)
			(arglist-close . c-lineup-arglist-intro-after-paren)
			(case-label . +)
			(label . -1000)))
    (c-echo-syntactic-information-p . nil)
    (c-indent-comments-syntactically-p . nil)
    (c-block-comments-indent-p . t)
    (c-recognize-knr-p . nil)
    )
  "(c) Robert Smith, 2007-13")

(defun tots-hook ()
  ;; add style and set it for the current buffer
  (c-add-style "TOTS" the-one-true-style t)

  ;; offset customizations not in my-c-style
  (c-set-offset 'member-init-intro '++)

  ;; other customizations
  (setq tab-width 8 ; this will make sure spaces are used instead of tabs
	indent-tabs-mode nil)
  ;; we like auto-newline and hungry-delete
  (c-toggle-auto-hungry-state 1)
  ;; keybindings for C, C++, and Objective-C.  We can put these in
  ;; c-mode-map because c++-mode-map and objc-mode-map inherit it
  (define-key c-mode-map "\C-m" 'newline-and-indent)

  ;; make delete work forward
  ;; (define-key global-map [delete]"\C-d")
  ;; (define-key global-map [(meta delete)]"\M-d")

  ;; for backslashify
  (setq c-backslash-column 72)
)

;; hook in TOTS...
(add-hook 'c-mode-common-hook 'tots-hook)

(setq minibuffer-max-depth nil)

;; Use spaces to indent
(defun my-build-tab-stop-list (width)
  (let ((num-tab-stops (/ 80 width))
	(counter 1)
	(ls nil))
    (while (<= counter num-tab-stops)
      (setq ls (cons (* width counter) ls))
      (setq counter (1+ counter)))
    (set (make-local-variable 'tab-stop-list) (nreverse ls))))
(defun my-c-mode-common-hook ()
  (setq tab-width 4) 
  (my-build-tab-stop-list tab-width)
  (setq c-basic-offset tab-width)
  (setq indent-tabs-mode nil)) ;; force only spaces for indentation
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; Common Lisp
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(slime-setup '(slime-fancy slime-banner slime-asdf))
(font-lock-add-keywords
 'lisp-mode
 '(("\\<\\(t\\|nil\\)\\>" . font-lock-constant-face)
))
(custom-set-variables '(inferior-lisp-program "sbcl"))
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'lisp-mode-hook (lambda () (paredit-mode +1)))
(setq slime-net-coding-system 'utf-8-unix)

;;(setq exec-path
;;    '(
;;     "/home/thomas/bin/texlive/2008/bin/x86_64-linux"
;;      "/bin"
;;      "/usr/bin"
;;      "/usr/local/bin"
;;    ))

;; Theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-charcoal-black)

