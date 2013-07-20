;; .emacs
;;

;; common customization
(setq inhibit-startup-message t)
(fset 'yes-or-no-p 'y-or-n-p)
(column-number-mode t)
(show-paren-mode t)
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq transient-mark-mode t) ;; enable visual feedback on selections
(setq auto-save-default nil) ;; disable autosave
(setq frame-title-format
      (concat  "%b - emacs@" (system-name))) ;; default to better frame titles
(setq diff-switches "-u") ;; default to unified diffs
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
      (progn
        ;; use 120 char wide window for largeish displays
        ;; and smaller 80 column windows for smaller displays
        ;; pick whatever numbers make sense for you
        (if (> (x-display-pixel-width) 1280)
            (add-to-list 'default-frame-alist (cons 'width 120))
          (add-to-list 'default-frame-alist (cons 'width 80)))
        ;; for the height, subtract a couple hundred pixels
        ;; from the screen height (for panels, menubars and
        ;; whatnot), then divide by the height of a char to
        ;; get the height we want
        (add-to-list 'default-frame-alist 
                     (cons 'height (/ (- (x-display-pixel-height) 200)
                                      (frame-char-height)))))))
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (when (equal system-type 'darwin)
    (setenv "PATH" (concat "/opt/local/bin:/usr/local/bin:" (getenv "PATH")))
    (push "/opt/local/bin" exec-path))
  (set-frame-size-according-to-resolution))

;; Key defination
(global-set-key [f1] 'shell);F1 to go to shelll
;;(global-set-key [f2] 'tcl-mode);F2 to tcl mode
(global-set-key [f6] 'other-window);F6 dump between window
;;(global-set-key [f10] 'split-window-vertically)
(global-set-key [f11] 'delete-other-windows)
(global-set-key "\M-?" 'etags-select-find-tag-at-point)
(global-set-key "\M-." 'etags-select-find-tag)

;; Useful plugins
(add-to-list 'load-path "~/.emacs.d/")
(require 'undo-tree)
(global-undo-tree-mode) ;; undo tree, one of the favorite

;; Replace+
(eval-after-load "replace" '(progn (require 'replace+)))

;; color theme 
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")  
(require 'color-theme)
(add-to-list 'load-path "~/.emacs.d/emacs-color-theme-solarized")  
(require 'color-theme-solarized)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-solarized-dark)))

;; Enable ido-mode
;;(ido-mode t)
;; Insert timestamp after TODO job is done
;; (setq org-log-done 'time)

;; Go-to last changed buffer
(require 'goto-last-change)
(global-set-key "\C-x\C-\\" 'goto-last-change)

;; Emacs shell
(setq shell-file-name "/bin/bash") 
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t) 
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t) 
(global-set-key (kbd "C-c z") 'shell) 
(global-set-key (kbd "<f10>") 'rename-buffer) 
(when (fboundp 'winner-mode) 
  (winner-mode) 
  (windmove-default-keybindings)) 

;; Eshell prompt
(setq eshell-prompt-function (lambda nil
                               (concat
                                (propertize (eshell/pwd) 'face `(:foreground "blue"))
                                (propertize " $ " 'face `(:foreground "green")))))
(setq eshell-highlight-prompt nil)

;; ;; Git support
(add-to-list 'load-path "~/.emacs.d/egg/")
(require 'egg)

;; ;; Tramp support
;; (setq tramp-default-method "scp")
;; (setq tramp-auto-save-directory "~/emacs/tramp")
;; (setq auto-save-file-name-transforms
;;        '(("\\`/[^/]*:\\(.+/\\)*\\(.*\\)" "/tmp/\\2")))
;; (setq tramp-chunksize 328)
;; (require 'ange-ftp)
;; (require 'tramp)

;; ;; w3m
;; (setq browse-url-browser-function 'w3m-browse-url)
;; (autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
;; ;; optional keyboard short-cut
;; (global-set-key "\C-xm" 'browse-url-at-point)
;; (setq w3m-use-cookies t)
;; (add-to-list 'load-path "~/.emacs.d/emacs-testlink/")
;;(require 'testlink)
;;(push "/home/aizhang/Downloads/all_testsuites.xml" rng-schema-locating-files-default)
;;(push (cons (concat "\\." (regexp-opt '("svg" "x3d") t)
;;                    "\\'") 'nxml-mode) auto-mode-alist)


;; Customized config for each lang
(defun my-common-lang-hook-func ()
  (require 'whitespace)   
  (setq whitespace-style '(face empty tabs lines-tail trailing))
  ;; (setq whitespace-style '(face tabs))
  ;; Whitespace, useful for script formating, especially 80 chars limit and wrong tab
  (autoload 'whitespace-mode "whitespace" "Toggle whitespace visualization." t)   
  ;; (global-whitespace-mode t)
  )

;; Tcl mode
(defun set-newline-and-indent ()
  (local-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'tcl-mode-hook 'set-newline-and-indent)
(add-hook 'tcl-mode-hook 'my-common-lang-hook-func)   
(defun my-tcl-mode-common-hook-func ()
  (interactive)
  "Function to be called when entering into tcl-mode."
  (when (and (require 'auto-complete nil t) (require 'auto-complete-config nil t))
    (load-file "~/.emacs.d/tcl-aizhang.el")
    (require 'tcl-inferior)
    (auto-complete-mode t)
    (make-local-variable 'ac-sources)
    (setq ac-auto-start 2)
    (define-key ac-completing-map "\t" 'ac-complete)
    (define-key ac-completing-map "\r" nil)
    (define-key tcl-mode-map "\C-c\C-a" 'tcl-eval-file)
    (define-key tcl-mode-map "\C-c\C-d" 'tcl-eval-region-wdebug)
    (setq ac-sources '(ac-source-words-in-same-mode-buffers
                       ac-source-filename
                       ac-source-functions
                       ac-source-yasnippet
                       ac-source-variables
                       ac-source-symbols
                       ac-source-features
                       ac-source-abbrev
                       ac-source-dictionary))
    (when (require 'auto-complete-etags nil t)
      (add-to-list 'ac-sources 'ac-source-etags)
      (setq tags-file-name "/Users/aaronzhang/Vmware/Mozy/QA/cneptune-qa-auto/TAGS")))) ;; CHANGEME
(add-hook 'tcl-mode-hook 'my-tcl-mode-common-hook-func)
(add-hook 'inferior-tcl-mode-hook 'my-tcl-mode-common-hook-func)
;; (add-hook 'tcl-mode-hook 'flyspell-prog-mode)
;; Hightlight error inferior tcl mode
(add-hook 'inferior-tcl-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(ERROR\\)" 1 font-lock-warning-face t)))))


;; C++ and C mode...
(defun my-c++-mode-hook ()
  (setq tab-width 4)
  (define-key c++-mode-map "\C-m" 'reindent-then-newline-and-indent)
  (define-key c++-mode-map "\C-ce" 'c-comment-edit)
  (setq c++-auto-hungry-initial-state 'none)
  (setq c++-delete-function 'backward-delete-char)
  (setq c++-tab-always-indent t)
  (setq c-continued-statement-offset 4)
  (setq c-indent-tabs-mode t)     ; Pressing TAB should cause indentation
  (setq c-indent-level 4)         ; A TAB is equivilent to four spaces
  (setq c-argdecl-indent 0)       ; Do not indent argument decl's extra
  (setq c-tab-always-indent t)
  (setq backward-delete-function nil) ; DO NOT expand tabs when deleting
  (setq c++-empty-arglist-indent 4))

(c-add-style "my-c-style" '((c-continued-statement-offset 4))) ; If a statement continues on the next line, indent the continuation by 4
(defun my-c-mode-hook ()
  ;; auto-complete
  (when (and (require 'auto-complete nil t) (require 'auto-complete-config nil t))
    (auto-complete-mode t)
    (make-local-variable 'ac-sources)
    (setq ac-auto-start 2)
    (define-key ac-completing-map "\t" 'ac-complete)
    (define-key ac-completing-map "\r" nil)
    (setq ac-sources '(ac-source-words-in-same-mode-buffers
                       ac-source-filename
                       ac-source-functions
                       ac-source-yasnippet
                       ac-source-variables
                       ac-source-symbols
                       ac-source-features
                       ac-source-abbrev
                       ac-source-semantic
                       ac-source-dictionary))
    (when (require 'auto-complete-etags nil t)
      (add-to-list 'ac-sources 'ac-source-etags)
      (setq ac-etags-use-document t)))
  ;;(setq tags-table-list '("/home/aizhang/auto-user/src/ceaa/TAGS"))
  ;;(setq tags-file-name "/home/aizhang/auto-user/src/ceaa/TAGS")))
  (c-set-style "my-c-style")
  (c-set-offset 'substatement-open '0) ; brackets should be at same indentation level as the statements they open
  (c-set-offset 'inline-open '+)
  (c-set-offset 'block-open '+)

  ;; ;; enable cscope
  ;; (require 'cscope)
  
  ;; enable CEDET
  (load-file "~/.emacs.d/cedet-1.0pre7/common/cedet.el")
  (global-ede-mode 1)                      ; Enable the Project management system
  (semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
  (global-srecode-minor-mode 1)            ; Enable template insertion menu
  (global-ede-mode 1)
  (semantic-load-enable-excessive-code-helpers)
  (semantic-load-enable-semantic-debugging-helpers)
  (setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                    global-semanticdb-minor-mode
                                    global-semantic-idle-summary-mode
                                    global-semantic-mru-bookmark-mode))
  (global-semantic-highlight-edits-mode (if window-system 1 -1))
  (global-semantic-show-unmatched-syntax-mode 1)
  (global-semantic-show-parser-state-mode 1)
  ;; semantic to jump
  (global-set-key [f12] 'semantic-ia-fast-jump)

  (c-set-offset 'brace-list-open '+)   ; all "opens" should be indented by the c-indent-level
  (c-set-offset 'case-label '+)       ; indent case labels by c-indent-level, too
  (define-key c-mode-base-map (kbd "RET") 'newline-and-indent))
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'c-mode-hook 'my-common-lang-hook-func)   
(add-hook 'c++-mode-hook 'my-common-lang-hook-func)   

;; Python mode
(defun my-python-mode-hook ()
  (require 'auto-complete)
  (require 'auto-complete-config)
  (global-auto-complete-mode t)
  (setq-default ac-sources '(ac-source-words-in-same-mode-buffers))
  (add-hook 'auto-complete-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-filename)))
  (set-face-background 'ac-candidate-face "lightgray")
  (set-face-underline 'ac-candidate-face "darkgray")
  (set-face-background 'ac-selection-face "steelblue") ;;; 
  (define-key ac-completing-map "\M-n" 'ac-next)  ;;; M-n
  (define-key ac-completing-map "\M-p" 'ac-previous)
  (setq ac-auto-start 2)
  (setq ac-dwim t)
  (define-key ac-mode-map (kbd "M-,") 'auto-complete)
  (autoload 'pymacs-apply "pymacs")
  (autoload 'pymacs-call "pymacs")
  (autoload 'pymacs-eval "pymacs" nil t)
  (autoload 'pymacs-exec "pymacs" nil t)
  (autoload 'pymacs-load "pymacs" nil t)
  (pymacs-load "ropemacs" "rope-")
  (setq ropemacs-enable-autoimport t)
  (require 'python-mode)
  (require 'pycomplete))
(add-hook 'python-mode-hook 'my-python-mode-hook)
;;(require 'pycomplete)
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)
(setq interpreter-mode-alist(cons '("python" . python-mode)
                                  interpreter-mode-alist))
(add-hook 'python-mode-hook 'my-common-lang-hook-func)   

;; Perl mode
(defun my-perl-mode-hook ()
  (setq tab-width 4)
  (define-key c++-mode-map "\C-m" 'reindent-then-newline-and-indent)
  (setq perl-indent-level 4)
  (setq perl-continued-statement-offset 4))

(add-hook 'cperl-mode-hook 'n-cperl-mode-hook t)
(defun n-cperl-mode-hook ()
  (add-to-list 'load-path "~/.emacs.d/pde/")
  (load "pde-load")
  (setq cperl-indent-level 4)
  (setq cperl-continued-statement-offset 0)
  (setq cperl-extra-newline-before-brace 0)
  ;;(set-face-background 'cperl-array-face "wheat")
  ;;(set-face-background 'cperl-hash-face "wheat")
  )
;; Use cperl-mode instead of the default perl-mode
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))
(add-hook 'perl-mode-hook 'my-perl-mode-hook)
(add-hook 'perl-mode-hook 'my-common-lang-hook-func)   

;; Ruby mode
(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(defun my-ruby-mode-common-hook-func ()
  (interactive)
  "Function to be called when entering into tcl-mode."
  (when (and (require 'auto-complete nil t) (require 'auto-complete-config nil t))
    (auto-complete-mode t)
    (make-local-variable 'ac-sources)
    (setq ac-auto-start 2)
    (setq ac-sources '(ac-source-words-in-same-mode-buffers
                       ac-source-filename
                       ac-source-functions
                       ac-source-yasnippet
                       ac-source-variables
                       ac-source-symbols
                       ac-source-features
                       ac-source-abbrev
                       ac-source-dictionary))
    (add-to-list 'ac-sources 'ac-source-etags)
    (require 'inf-ruby)
    ;; (require 'inf-ruby-company)
    ;; (require 'ruby-electric)
    (when (require 'auto-complete-etags nil t)
      (add-to-list 'ac-sources 'ac-source-etags)
      ;;(setq ac-etags-use-document t)
      ;;(setq tags-table-list '("/home/aizhang/auto-user/src/ceaa/TAGS"))
      (setq tags-file-name "/home/aizhang/triton-test/trogdor/TAGS"))))
(add-hook 'ruby-mode-hook 'my-ruby-mode-common-hook-func)
(add-hook 'ruby-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(add-hook 'ruby-mode-hook 'my-common-lang-hook-func)   
;; End of my-ruby-mode-common-hook-func

;; ;; enable tcl mode by default, no more after left cisco
;; (autoload 'tcl-mode "tcl" "Tcl mode." t)
;; (autoload 'inferior-tcl "tcl" "Run inferior Tcl process." t)
;; (add-to-list 'auto-mode-alist '("\\.tcl\\'" . tcl-mode))
;; (setq tcl-application "~/auto-user/ats5.2.0/bin/tclsh")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#042028" :foreground "#708183" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 140 :width normal :foundry "apple" :family "Menlo")))))
