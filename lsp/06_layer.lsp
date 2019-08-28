
(defun getLayerE41(layer / E41 abbruch bestand neu)

  (setq 
      abbruch (list "yellow" 0.60)
      bestand (list "8" 0.60)
      neu (list "red" 0.60)
      E41 (list
            (list 00 "A-E41-a-211.5-sc-co" abbruch)
            (list 01 "A-E41-a-211.5-sc-sh" abbruch)
            (list 02 "A-E41-a-211.5-an-co" abbruch)
            (list 03 "A-E41-a-211.5-an-sh" abbruch)
            (list 04 "A-E41-b-211.5-sc-co" bestand)
            (list 05 "A-E41-b-211.5-sc-sh" bestand)
            (list 06 "A-E41-b-211.5-sc-co" bestand)
            (list 07 "A-E41-b-211.5-sc-sh" bestand)
            (list 08 "A-E41-n-211.5-sc-co" neu)
            (list 09 "A-E41-n-211.5-sc-sh" neu)
            (list 10 "A-E41-n-211.6-sc-co" neu)
            (list 11 "A-E41-n-211.6-sc-sh" neu)
                ))
  (cdr (nth layer E41))
)

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


(defun c:asdf()
  (setCurrentLayer 8)
  (princ)
)
