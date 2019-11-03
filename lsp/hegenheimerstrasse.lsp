
(defun my_loop (/ 
                  activedocument
                  modelspace
                  insert
                  block_name
                  block_entity
                  property_methods

                  next_entget
                  next_vla_object

                  next_layer_name
                  next_layer_name_to_list
                  next_property_method
                  next_property_method_factor
                  next_data_list

                  next_data
                  next_property_type
                  next_type
                  next_entity_list)

  (setq 
        activedocument    (vla-get-activedocument (vlax-get-acad-object))
        modelspace        (vla-get-modelspace activedocument)

        insert            (car (entsel))
        block_name        (cdr (assoc 2 (entget insert)))
        block_entity      (tblobjname "block" block_name)
        property_methods  (list
                            (list "umfang"  (list vla-get-length 0.01))
                            (list "volumen" (list vla-get-volume 0.000001))
                            (list "flaeche" (list vla-get-area 0.0001))
                          )
  )

  ; create data list for each object type
  (while (setq block_entity (entnext block_entity))

         (setq next_entget (entget block_entity)
               next_layer_name  (cdr (assoc 8 next_entget))
               next_entity_list (cons block_entity next_entity_list)
         )

         ; function to split layer name to list
         (defun layer_name_to_string (layer_name / delimiter_position)
           (if (setq delimiter_position (vl-string-search "-" layer_name))
               (progn
                 (cons (substr layer_name 1 delimiter_position)
                       (layer_name_to_string (substr layer_name (+ 2 delimiter_position)))
                 )
               )
               (list layer_name)
           )
         )

        (setq next_layer_name_to_list (layer_name_to_string next_layer_name))

        (setq next_property_method (cadr (assoc (last next_layer_name_to_list) property_methods)))

        (if (not (assoc next_layer_name next_data_list))

           (setq next_data_list
                (cons
                  (list next_layer_name next_layer_name_to_list next_property_method)
                  next_data_list
                )
           )
        )
  )

  ; create variables for each layer name of next_data_list
  (foreach eintrag next_data_list
           (set (read (car eintrag)) 0)
  )


  (foreach eintrag next_entity_list

           (setq next_entget (entget eintrag) 
                 next_layer_name (cdr (assoc 8 next_entget))
                 next_data (assoc next_layer_name next_data_list)
                 next_property_method (car (last next_data))
                 next_property_method_factor (cadr (last next_data))
                 next_vla_object (vlax-ename->vla-object eintrag)
           )

           (set (read next_layer_name)
                (+
                  (eval (read next_layer_name))
                  (* next_property_method_factor (next_property_method next_vla_object))
                )
           )
  )

  (foreach eintrag next_data_list
           (vla-addattribute
             modelspace
             (getvar "textsize")
             acattributemodelockposition
             ""
             (vlax-3D-point 0 0 0)
             (car eintrag)
             (eval (read (car eintrag)))
           )
  )

  (princ)
)

(defun mytest ( / 
                collection_blocks
                block_name
                block_entity

                ebkp_nummern
                ebkp_nummer_eintrag
                ebkp_nummer
                ebkp_bezeichnung
              )
  (setq
    collection_blocks (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object)))
    ebkp_nummern   (list
                        (list "G22" "-Unterkonstruktion_fertiger_Bodenbelag")
                        (list "G23" "-Fertiger_Bodenbelag")
                        (list "G33" "-Wandbekleidung")
                      ) 
  )

  (vlax-for item collection_blocks

            (setq
              block_name (vla-get-name item)
              block_entity (tblobjname "block" block_name)
            )

            (if 
               (wcmatch block_name "[G]##-*")

               (progn
                 (foreach group_code (list 0 8)
                          (print
                            (assoc group_code (entget (entnext block_entity)))
                          )
                 )
                 ; (print (assoc 0 (entget (entnext block_entity))))
               )
            )
  )

  (princ)
)
