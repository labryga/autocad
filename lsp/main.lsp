; function to toggle autosnap and osmode by "df" command
(defun c:df() 
  (if 
    (and 
     (= (getvar "autosnap") 63)
     (= (getvar "osmode") 35)) 

    (progn
      (setvar "autosnap" 0) 
      (setvar "osmode" 0)
      )

    (progn
      (setvar "autosnap" 63) 
      (setvar "osmode" 35)
      )
  )
)

; function to toggle selection cycling
(defun c:dq()
  (if
    (= (getvar "selectioncycling") -2)
      (setvar "selectioncycling" 2)
      (setvar "selectioncycling" -2)
  )
)

; function to set saved views
(defun c:sv() 
  (setq view (getstring 1))
  (command "-view" "r" view "" "")
  (princ)
)


; set visualstyle to wireframe

(defun c:xa()
  (command "-visualstyles" "c" "w" "" "")
  (princ)
 )


; set -visualstyle to shaded 

(defun c:xs()
  (command "-visualstyles" "c" "s" "" "")
  (princ)
)

; set -visualstyle to conceptual

(defun c:xd()
  (command "-visualstyles" "c" "c" "" "")
  (princ)
)

; set -visualstyles to x-ray

(defun c:xf()
  (command "-visualstyles" "c" "x" "" "")
  (princ)
)

; set -visualstyles to realistic

(defun c:xr()
  (command "-visualstyles" "c" "r" "" "")
)

; toggle perspective view

(defun c:xe()
  (if
    (= (getvar "perspective") 0)
    (setvar "perspective" 1)
    (setvar "perspective" 0)
   )
  (princ)
 )

; function for multiple visualstyle options

(defun c:x()
  (setvar "wireframe")
  (setvar "shaded")
  (setvar "x-ray")
)

(defun c:cd()
  (setvar "autosnap" 63) 
  (setvar "osmode" 35)
  (command "dimlinear")
  (princ)
)
