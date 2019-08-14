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

; function to switch on autosnap and osmode
(defun fangan()
  (setvar "autosnap" 63) 
  (setvar "osmode" 35)
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
(defun c:xq()
  (command "-visualstyles" "c" "w" "" "")
  (princ)
 )

; set -visualstyle to shaded 
(defun c:xw()
  (command "-visualstyles" "c" "s" "" "")
  (princ)
)

; set -visualstyle to conceptual
(defun c:xe()
  (command "-visualstyles" "c" "c" "" "")
  (princ)
)

; set -visualstyles to x-ray
(defun c:xt()
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

; set snap and invoke dimlinear
(defun c:cd()
  (fangan)
  (command "dimlinear")
  (princ)
)

; set snap and invoke dimaligned
(defun c:cf()
  (fangan)
  (command "dimaligned")
  (princ)
)


; set dimstyle to mst 050 [m] and invokte dimaligned
(defun c:cfa()
  (fangan)
  (command "-dimstyle" "r" "MST 050 [m]")
  (command "dimaligned")
  (princ)
)

; set dimstyle to mst 050 [cm] and invokte dimaligned
(defun c:cfs()
  (fangan)
  (command "-dimstyle" "r" "MST 050 [cm]")
  (command "dimaligned")
  (princ)
)

; set dimstyle to mst 100 [m] and invokte dimaligned
(defun c:cfq()
  (fangan)
  (command "-dimstyle" "r" "MST 100 [m]")
  (command "dimaligned")
  (princ)
)

; set dimstyle to mst 100 [cm] and invokte dimaligned
(defun c:cfw()
  (fangan)
  (command "-dimstyle" "r" "MST 100 [cm]")
  (command "dimaligned")
  (princ)
)


; set dimstyle to mst 050 [m] and invokte dimlinear
(defun c:cda()
  (fangan)
  (command "-dimstyle" "r" "MST 050 [m]")
  (command "dimlinear")
  (princ)
)

; set dimstyle to mst 050 [cm] and invokte dimlinear
(defun c:cds()
  (fangan)
  (command "-dimstyle" "r" "MST 050 [cm]")
  (command "dimlinear")
  (princ)
)

; set dimstyle to mst 100 [m] and invokte dimlinear
(defun c:cdq()
  (fangan)
  (command "-dimstyle" "r" "MST 100 [m]")
  (command "dimlinear")
  (princ)
)

; set dimstyle to mst 100 [cm] and invokte dimlinear
(defun c:cdw()
  (fangan)
  (command "-dimstyle" "r" "MST 100 [cm]")
  (command "dimlinear")
  (princ)
)

