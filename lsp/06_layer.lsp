


; create layer list with arguments
(defun ekgloop( ekg_nummern
                bauphasen         ; Liste Bestand/Abbruch/Neu
                bkp_nummern       ; Liste BKP-Nummern
                projektionstypen  ; Liste Schnitt/Ansicht
                objekttypen       ; Linientyp/Schraffur/Text)
                / layerliste
                ) 

  (setq layerlist '())


  (defun  appendToLayerList( ekg
                             abschnitt
                             bkp
                             projektion
                             objekt)

    (setq layerlist 
      (append layerlist
        (list (strcat "A" "-"
                      ekg "-" 
                      abschnitt "-" 
                      bkp "-" 
                      projektion "-"
                      objekt))
      )
    )
  )


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
    (foreach phase (castArgumentToList bauphasen)
      (foreach bkp (castArgumentToList bkp_nummern)
        (foreach projektion (castArgumentToList projektionstypen)
          (foreach objekt (castArgumentToList objekttypen)

               (if
                 (and
                   (or
                     (= projektion "sc")
                     (= projektion "an")
                   )
                   (or
                     (= objekt "co")
                     (= objekt "sh")
                   )
                 )

                 (appendToLayerList ekg phase bkp projektion objekt)
               )
          )
        )
      )
    )
  )


  (princ layerlist)
  (princ)

)
