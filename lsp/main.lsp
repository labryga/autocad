; set SECURELOAD and TRUSTEDPATH variables accordingly

; function to toggle autosnap and osmode by "df" command
; (defun c:df() 
;   (if 
;     (and 
;      (= (getvar "autosnap") 63)
;      (= (getvar "osmode") 35)) 
;
;     (progn
;       (setvar "autosnap" 0) 
;       (setvar "osmode" 0)
;       )
;
;     (progn
;       (setvar "autosnap" 63) 
;       (setvar "osmode" 35)
;       )
;   )
; )
;
;
; ; set snap on 
; (defun set_snap()
;   (setvar "autosnap" 63)
;   (setvar "osmode" 35)
; )
;
;
; ; set snap off 
; (defun set_snap_off()
;   (setvar "autosnap" 0)
;   (setvar "osmode" 0)
; )
;
;
; ; toggle selection cycling
; (defun c:dq()
;   (if
;     (= (getvar "selectioncycling") -2)
;       (setvar "selectioncycling" 2)
;       (setvar "selectioncycling" -2)
;   )
; )
;
; (defun c:rw()
;   (command "solidedit" "f" "m")
; );defun
