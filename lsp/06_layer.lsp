; create layer list with arguments
(defun layerGenerator( ekg_nummern
                bauphasen         ; Liste Bestand/Abbruch/Neu
                bkp_nummern       ; Liste BKP-Nummern
                projektionstypen  ; Liste Schnitt/Ansicht
                objekttypen       ; Linientyp/Schraffur/Text)
                / layerliste
                ) 

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

  (foreach ekg (castArgumentToList ekg_nummern)
    (foreach phase (castArgumentToList bauphasen)
      (foreach bkp (castArgumentToList bkp_nummern)
        (foreach projektion (castArgumentToList projektionstypen)
          (foreach objekt (castArgumentToList objekttypen)

            (filterLayer ekg phase bkp projektion objekt)

          ); objekttypen
        ); projektionstypen
      ); bkp_nummern
    ); bauphasen
  ); ekg_nummern

  layerlist ; return generated layer list

)

(defun cl( / layerlist
             layername
             ekg-nummer
             bauphase
             bkp-nummmer
             projektion
             objekt)

  ()
  (princ)
)
