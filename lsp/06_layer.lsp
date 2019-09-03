

(defun setHatch(pattern scale annotative)
  (command "-hatch")
)

; switch to layer otherwise create if does not exist

(defun setCurrentLayer(layernumber /)
  
  (setq layer (getLayerE41 layernumber))

  (if (tblsearch "layer" (nth 0 layer))
    (command "-layer" "s" (car layer) "")
    (command "-layer" "m" (car layer) 
    "c" (nth 0 (nth 1 layer)) "" 
    "lw" (nth 1 (nth 1 layer)) "" 
    "")
  )
  (princ)
)


(defun c:afdf()
  (setCurrentLayer 0)
  (princ)
)

(defun c:afsf()
  (setCurrentLayer 1)
  (princ)
)


(defun c:addf()
  (setCurrentLayer 4)
  (princ)
)
