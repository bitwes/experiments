;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
   (global-font-lock-mode t))

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

;; add emacs folder to load path
(add-to-list 'load-path "~/emacs")

;(require 'linum)
;(setq linum-mode t)

(load-file "~/emacs/cedet-1.0/common/cedet.el")
(semantic-load-enable-excessive-code-helpers)

;; [Home] & [End] key should take you to beginning and end of lines..
(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)

;; ===== Set the highlight current line minor mode =====
;; In every buffer, the line which contains the cursor will be fully
;; highlighted
;(global-hl-line-mode 1)
;(set-face-background 'highlight "#330")  ;; Emacs 21 Only
;(set-face-background 'hl-line "#330")


;; ========== Line by line scrolling ==========
;; This makes the buffer scroll by only a single line when the up or
;; down cursor keys push the cursor (tool-bar-mode) outside the
;; buffer. The standard emacs behaviour is to reposition the cursor in
;; the center of the screen, but this can make the scrolling confusing
(setq scroll-step 1)


;; ========== Support Wheel Mouse Scrolling ==========
(mouse-wheel-mode t) 

;; ===== Set standard indent to 2 rather that 4 ====
(setq standard-indent 4)

;;Highlight selection
(transient-mark-mode t)


;;Turns off the indenter logic.
(require 'cc-mode)
  (add-to-list 'c-mode-common-hook
      (lambda () (setq c-syntactic-indentation nil)))


;;; cperl-mode is preferred to perl-mode                                        
;;; "Brevity is the soul of wit" <foo at acm.org>                               
(defalias 'perl-mode 'cperl-mode)
(setq cperl-indent-level 4)
(setq cperl-continued-statement-offset 4)
(setq cperl-brace-offset -4)
(setq cperl-label-offset -4)
(setq cperl-invalid-face (quote off))

;; Spaces for tabs
(setq-default indent-tabs-mode nil)

;; Scroll without moving cursor
;; assigned to function keys later.
(defun gcm-scroll-down ()
   (interactive)
   (scroll-up 1))
(defun gcm-scroll-up ()
   (interactive)
   (scroll-down 1))

;;Add diff option
(defun command-line-diff (switch)
   (let ((file1 (pop command-line-args-left))
         (file2 (pop command-line-args-left)))
         (ediff file1 file2)))
(add-to-list 'command-switch-alist '("diff" . command-line-diff))

;;Function keys---------------------
;; F5 to refresh file
(defun refresh-file ()
  (interactive)
  (revert-buffer t t t))
(global-set-key [f5] 'refresh-file)
(global-set-key [f6] 'toggle-truncate-lines)
;; toggle syntax highlighting
(global-set-key [f8] 'font-lock-mode)
(global-set-key [f11] 'gcm-scroll-down)
(global-set-key [f12] 'gcm-scroll-up)
;;----------------------------------