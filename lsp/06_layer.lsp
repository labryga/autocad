

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
        (foreach projektion (castArgumentToList projektionstypen)
              (setq layerlist 
                (append layerlist
                  (list (strcat ekg "-" abschnitt "-" bkp "-" projektion))
                )
              )
        )
      )
    )
  )

  (princ layerlist)
  (princ)

)
