(vl-load-com)
(load "01_main")
(load "02_dimensions")
(load "03_views")
(load "04_layouts")
(load "05_modify")
(load "06_layer")
; (load "09_project_related_lisp")

(setq 
    abbruch (list "yellow" 0.60)
    bestand (list "8" 0.60)
    neu (list "red" 0.60)
    ekgliste (list
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
            )
)

(defun ekgloop( ekg-nummer
                bauphase ; Liste Bestand/Abbruch/Neu
                bkp-nummer ; Liste BKP-Nummern
                projektionstyp ; Liste Schnitt/Ansicht
                objekttyp ) ; Linientyp/Schraffur/Text)

  (foreach ekg ekg-nummer
    (foreach phase bauphase
      (foreach bkp bkp-nummer
        (foreach projektion projektionstyp
          (foreach objekt objekttyp
            (setq ekgt (list (strcat "-" ekg "-" phase "-" bkp "-" projektion "-" objekt)))
            (setq ekgl (append ekgl ekgt))
           )
         )
       )
     )
   )
  (print ekgl)
  (princ)
)
