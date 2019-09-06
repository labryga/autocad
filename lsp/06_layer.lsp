; create layer list with arguments
(defun layerGenerator(ekg-nummern       ; Liste EKG-Nummer
                      bauphasen         ; Liste Bestand/Abbruch/Neu
                      bkp-nummern       ; Liste BKP-Nummern
                      projektionstypen  ; Liste Schnitt/Ansicht
                      objekttypen       ; Linientyp/Schraffur/Text)
                      / layerliste)

  (setq layerlist '())

  ; function to append layer name to list
  (defun  appendToLayerList( ekg
                             phase
                             bkp
                             projektion
                             objekt)

    (setq layerlist 
      (append layerlist
        (list (strcat "A" "-"
                      ekg "-" 
                      phase "-" 
                      bkp "-" 
                      projektion "-"
                      objekt))
      )
    )
  )

  ; function to convert argument to list type
  (defun castArgumentToList(argument)
   (if (/= (type argument) 'LIST)
     (progn
       (setq argument (list argument))
       argument
     )
     argument
    ) 
   )

  ; function to filter layer condition
  (defun filterLayer( ekg
                      phase
                      bkp
                      projektion
                      objekt)
    (cond

      (; drawing condition
       (and
         (or
           (= projektion "sc")
           (= projektion "an")
           )
         (or
           (= objekt "co")
           (= objekt "sh")
           )
         ); and

       (appendToLayerList ekg phase bkp projektion objekt)
       ); drawing condition

      (; text condition
       (and
         (= projektion "tx")
         (or
           (= objekt "100")
           (= objekt "050")
           (= objekt "020")
           (= objekt "200")
         )
       ); and
       (appendToLayerList ekg phase bkp projektion objekt)
      ); text condition

    ); cond
  ); defun

  (foreach ekg (castArgumentToList ekg-nummern)
    (foreach phase (castArgumentToList bauphasen)
      (foreach bkp (castArgumentToList bkp-nummern)
        (foreach projektion (castArgumentToList projektionstypen)
          (foreach objekt (castArgumentToList objekttypen)

            (filterLayer ekg phase bkp projektion objekt)

          ); objekttypen
        ); projektionstypen
      ); bkp-nummern
    ); bauphasen
  ); ekg-nummern

  layerlist ; return generated layer list

)

; create layer set using layer name generating function
(defun createLayerSet( ekg-nummern
                       bauphasen
                       bkp-nummern
                       projektionstypen
                       objekttypen / 
                       layerlist
                       phase
                       color)

  (setq layerlist (layerGenerator ekg-nummern
                                  bauphasen
                                  bkp-nummern
                                  projektionstypen
                                  objekttypen))


  (foreach layer layerlist
    (setq phase (substr layer 7 1))
    (cond
      ((= phase "a") (setq color "yellow"))
      ((= phase "b") (setq color "8"))
      ((= phase "n") (setq color "red"))
      (t (prompt "no phase matching"))
    )

    (command "-layer" "n" layer "c" color layer "" "" "")
  )

  (princ)
)

(defun c:sml()
  (createLayerSet (list "E41" "E42")
                  (list "a" "b" "n")
                  (list "211.5" "211.6")
                  (list "sc" "an" "tx")
                  (list "co" "sh" "050" "100"))
  (princ)
)
