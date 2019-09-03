(vl-load-com)
(load "01_main")
(load "02_dimensions")
(load "03_views")
(load "04_layouts")
(load "05_modify")
(load "06_layer")
; (load "09_project_related_lisp")


; create layer list with arguments
(defun ekgloop( ekg_nummern
                bauphasen         ; Liste Bestand/Abbruch/Neu
                bkp_nummern       ; Liste BKP-Nummern
                projektionstypen  ; Liste Schnitt/Ansicht
                objekttypen       ; Linientyp/Schraffur/Text)
                / layerliste
                ) 

  (setq layerlist '())

  (defun castArgumentToList(argument)
   (if (/= (type argument) 'LIST)
     (progn
       (setq argument (list argument))
       argument
     )
     argument
    ) 
   )

  (foreach ekg (castArgumentToList ekg_nummern)
    (foreach abschnitt (castArgumentToList bauphasen)
      (foreach bkp (castArgumentToList bkp_nummern)

              (setq layerlist 
                (append layerlist
                  (list (strcat ekg "-" abschnitt "-" bkp))
                )
              )
      )
    )
  )

  (princ layerlist)
  (princ)

)
