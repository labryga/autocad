
(defun getLayerE41(layer / E41 abbruch bestand neu)

  (setq 
      abbruch (list "yellow" 0.6)
      bestand (list "8" 0.6)
      neu (list "red" 0.6)
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


; switch to layer otherwise create if does not exist

(defun c:afdf( / layer)

  (setq layer (getLayerE41 1))

  (command "-layer" "m" (nth 0 layer) "" "c" (car (nth 1 layer)) "" "")
  (princ)
)

