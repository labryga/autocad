; set dimensions including style and alignment by alias
; keep sure to adjust the acad.pgp file accordingly

; list with template dimstyles
(setq dimstyles (list
        "MST 050 [m]" 
        "MST 050 [cm]" 
        "MST 100 [m]"
        "MST 100 [cm]"
        "MST 020 [m]" 
        "MST 020 [cm]" 
        ))



; get dimension style and set
(defun set_dimension_style(dimstyle)
  (command "-dimstyle" "r" (nth dimstyle dimstyles))

  ; set current layer to dimension style layer
  (command "-layer" "s" (nth dimstyle dimstyles) "")

  ; set snap mode
  (set_snap)
)


; linear dimensions

; set style and invoke linear dimesion
(defun dimension_linear(dimstyle)
  (set_dimension_style dimstyle)
  (command "dimlinear")
)

; set linear dimensions

(defun c:cds()
  (dimension_linear 0)
)

(defun c:cda()
  (dimension_linear 1)
)

(defun c:cdw()
  (dimension_linear 2)
)

(defun c:cdq()
  (dimension_linear 3)
)

(defun c:cdx()
  (dimension_linear 4)
)

(defun c:cdy()
  (dimension_linear 5)
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
(defun c:cfy()
  (dimension_aligned 4)
)

(defun c:cfx()
  (dimension_aligned 5)
)

; set linear dimension with opening
(defun c:cdxd()
  (setq a (getpoint))
  (setq b (getpoint))
  (command "-dimstyle" "r" (nth 5 dimstyles))
  (command "dimlinear" a b "m" "<>\\X 2.20")
)
