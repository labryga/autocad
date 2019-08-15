; set dimensions by alias including style and alignment

; list with template dimstyles
(setq dimstyles (list
        "MST 050 [m]" 
        "MST 050 [cm]" 
        "MST 100 [m]"
        "MST 100 [cm]"
        ))


; set snap on 
(defun set_snap()
  (command "autosnap" 63)
  (command "osmode" 35)
)

; get dimension style and set
(defun set_dimension_style(dimstyle)
  (command "-dimstyle" "r" (nth dimstyle dimstyles))
  (set_snap)
)


; linear dimensions

; set style and invoke linear dimesion
(defun dimension_linear(dimstyle)
  (set_dimension_style dimstyle)
  (command "dimlinear")
)

; set aligned dimensions
(defun c:cda()
  (dimension_linear 0)
)

(defun c:cds()
  (dimension_linear 1)
)

(defun c:cdq()
  (dimension_linear 2)
)

(defun c:cdw()
  (dimension_linear 3)
)


; aligned dimensions

; set style and invoke aligned dimesion
(defun dimension_aligned(dimstyle)
  (set_dimension_style dimstyle)
  (command "dimaligned")
)

; set aligned dimensions
(defun c:cfa()
  (dimension_aligned 0)
)

(defun c:cfs()
  (dimension_aligned 1)
)

(defun c:cfq()
  (dimension_aligned 2)
)

(defun c:cfw()
  (dimension_aligned 3)
)
