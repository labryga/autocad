
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

(defun rename_layer ( /
                      collection_layer
                      layer_name
                      layer_replace
                      layer_ebpk_nummer
                      layer_name_rest
                      ebkp_nummer_wert
                    )

  (setq
    collection_layer (vla-get-layers (vla-get-activedocument (vlax-get-acad-object)))
    layer_replace (list
                    (list "G22" "-Unterkonstruktion_fertiger_Bodenbelag")
                    (list "G23" "-Fertiger_Bodenbelag")
                    (list "G14" "-Innetür")
                  )
  )

  (vlax-for eintrag collection_layer

            (setq layer_name        (vla-get-name eintrag)
                  layer_ebpk_nummer (substr layer_name  1 3)
                  layer_name_rest   (substr layer_name 4)
                  ebkp_nummer_wert  (cadr (assoc layer_ebpk_nummer layer_replace))
            )

            (if ebkp_nummer_wert
              (vla-put-name eintrag
                (strcat layer_ebpk_nummer ebkp_nummer_wert layer_name_rest)
              )
            )
  )

  (princ)
)
