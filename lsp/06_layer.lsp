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


; renaming layers 01
(defun my_test_eins ( / object_acad
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


; renaming layers by search pattern to set pattern
(defun rename_layers ( string_search
                       string_replace / 
                       active_document_object
                       layers_collection
                       entity_layer_name)

  (setq active_document_object (get_active_document_object); function defined in 01_main.lsp
        layers_collection      (vla-get-layers active_document_object)
  )

  (vlax-for collection_object layers_collection

      (setq entity_layer_name (vla-get-name collection_object))

      (if (vl-string-search string_search entity_layer_name)
          (progn 
            (setq entity_layer_name (vl-string-subst
                                      string_replace 
                                      string_search entity_layer_name))
            (vla-put-name collection_object entity_layer_name)
          );progn
       );if
  );vlax-for
  (princ)
)


; rename wall layer names
(defun rename_wall (/
                     layer_name
                     layer_rename
                   )

  (setq collection_layers (vla-get-layers
                            (vla-get-activedocument (vlax-get-acad-object)))
  );setq

  (vlax-for layer_vla_object collection_layers
            (setq layer_name (vla-get-name layer_vla_object))

            (if (vl-string-search "Holztafelbau" layer_name )

                (progn 
                  (setq layer_rename (vl-string-subst "Holzelementbau" "Holztafelbau" layer_name)
                  );setq 
                  (vla-put-name layer_vla_object layer_rename)
                );progn

            );if
  );vlax-for

  (princ)
);defun


; split string to list function
(defun string_to_list (string_value delimiter / delimiter_position)

  (if (setq delimiter_position (vl-string-search delimiter string_value))

      (cons (substr string_value 1 delimiter_position)
            (string_to_list (substr string_value (+ 2 delimiter_position)) delimiter)
      )

      (list string_value)
  )
)

(defun remove_attdef (/
                       activedocument
                       ssget_attdef
                       ssget_attdef_iterator
                       attdef_entity
                       attdef_vla_object
                       attdef_vla_objects_list
                     )
  (setq activedocument (vla-get-activedocument (vlax-get-acad-object))
        ssget_attdef (ssget "x" '((0 . "ATTDEF")))
        ssget_attdef_iterator 0
  );setq

  (repeat (sslength ssget_attdef)

          (setq 
            attdef_entity (ssname ssget_attdef ssget_attdef_iterator)
            attdef_vla_object (vlax-ename->vla-object attdef_entity)
            ssget_attdef_iterator (1+ ssget_attdef_iterator)
          );setq

          (if (not (member attdef_vla_object attdef_vla_objects_list))
              (setq attdef_vla_objects_list
                    (cons attdef_vla_object attdef_vla_objects_list)
              );setq
          );if
  );repeat

  (foreach attdef_vla attdef_vla_objects_list
           (vla-delete attdef_vla)
  );foreach

  (print attdef_vla_objects_list)
  (vla-regen activedocument acAllViewports)
  (princ)
);defun

(defun create_layers (string_prefix /
                      collection_layers
                      attribute_list
                      layer_name
                      layer_vla_object
                     )

  (setq 
    collection_layers (vla-get-layers
                        (vla-get-activedocument
                          (vlax-get-acad-object)))

    attribute_list (list (list "umfang"   "6")
                         (list "breite"   "7")
                         (list "hoehe"    "7")
                         (list "volumen"  "140")
                         (list "flaeche"  "3")
                         (list "nummer"   "5")
                   );list
  );setq

  (vla-add collection_layers string_prefix)

  (foreach attribute attribute_list

           (setq layer_name (strcat
                              string_prefix
                              "-"
                              (car attribute)
                            );strcat

                 layer_vla_object (vla-add collection_layers
                                           layer_name
                                  );vla-add
           );setq

           (vla-put-color layer_vla_object (cadr attribute))
  );foreach

  (princ)
);defun

(defun rename_layer ( /
                      collection_layers
                      layer_name
                      kategorie
                      layer_name_tmp
                    )

  (setq 
    collection_layers (vla-get-layers (vla-get-activedocument (vlax-get-acad-object)))
  );setq

  (vlax-for layer collection_layers
            (setq layer_name  (vla-get-name layer)
            );setq

            (if (wcmatch layer_name "*C11-*")
              (progn 
                (setq 
                  layer_name (vl-string-subst "C11-" "C21-" layer_name)
                );setq
                (vla-put-name layer layer_name)
              );progn
            );if
  );vlax-for

  (princ)
);defun
 
(defun rename_blocks (/ collection_blocks
                        block_name)
  (setq 
    collection_blocks (vla-get-blocks (vla-get-activedocument
                                        (vlax-get-acad-object))
                      )
  );setq

  (vlax-for block_item collection_blocks
            (setq block_name (vla-get-name block_item)
            );setq
            (if (wcmatch block_name "*&0*")
                (progn 
                  (setq
                    block_name (vl-string-subst "$0" "&0" block_name)
                  );setq
                  (vla-put-name block_item block_name)
                );progn
            );if
  );vlax-for

  (princ)
);defun
