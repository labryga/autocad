
(defun my_loop (/ insert
                  block_name
                  block_entity
                  property_method

                  next_entget
                  next_vla_object

                  next_layer_name
                  next_layer_name_to_list
                  next_property_method
                  next_layer_data_list

                  next_data
                  next_property_type
                  next_type
                  next_entity_list)

  (setq insert (car (entsel))
        block_name  (cdr (assoc 2 (entget insert)))
        block_entity  (tblobjname "block" block_name)
        items (list)
        property_method (list
                          (list "umfang" vla-get-length)
                          (list "flaeche" vla-get-volume)
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

        (setq next_property_method (assoc (last next_layer_name_to_list)))

        (setq next_layer_name_to_list (list (layer_name_to_string next_layer_name)))

        (if (not (assoc next_layer_name next_layer_data_list))

           (setq next_layer_data_list
                (cons
                  (cons next_layer_name next_layer_name_to_list)
                  next_layer_data_list
                )
           )
        )
  )

  (foreach entity next_entity_list
           (setq next_entget (entget entity) 
                 next_layer_name (cdr (assoc 8 next_entget))
                 next_data (assoc next_layer_name next_layer_data_list)
                 next_property_type (last (cadr next_data))
           )

           ; (foreach eintrag (list
           ;                    (list "volumen" vla-get-volume)
           ;                    (list "flaeche" vla-get-length)
           ;                  ) 
           ;
           ; )
           (print next_property_type)
  )


  (print (last (cadr (nth 1 next_layer_data_list))))
  (princ)
)

