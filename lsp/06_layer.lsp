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

; renaming layers


(defun my_test ( / object_acad
                   object_document
                   object_layers
                   entity_layer)

  (setq object_acad     (vlax-get-acad-object)
        object_document (vla-get-activedocument object_acad)
        object_layers   (vla-get-layers object_document)
  )

  (vlax-for objekt object_layers

            (setq entity_layer (vla-get-name objekt))

            (if (vl-string-search "_" entity_layer)

               (progn
                  (while (vl-string-search "_" entity_layer)
                         (setq entity_layer (vl-string-subst "" "_" entity_layer))
                  )

                  (vla-put-name objekt entity_layer)
               )

            )
  )

  (princ)
)

; split string to list function

(defun string_to_list (string_value delimiter / delimiter_position)
  (if (setq delimiter_position (vla-string-position delimiter string_value))
    (cons (substr 1 delimiter_position string_value)
          (string_to_list (substr (+ 2 delimiter_position)))
    )
    string_value
  )
)
