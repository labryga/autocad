; module to retrieve all data from corresponding insert items


; iterate over inserts selection and return a list of all corresponding block entities
(defun get_list_of_insert_block_entities ( insert_selection_set
                                           /
                                           insert_selection_iterator

                                           insert_entity
                                           insert_entity_block_name
                                           insert_entity_block_entity
                                           insert_entities_block_list
                                           *error*
                                         )

  (defun *error* (msg)
    (princ "\n
           error in function: get_list_of_insert_block_entities
           module:            01_data_extraction_functions \n")
    (princ msg)
    (princ)
  );defun

  (setq 
    insert_selection_iterator 0
  );setq

  (repeat (sslength insert_selection_set)

          (setq 
            insert_entity               (ssname insert_selection_set
                                                insert_selection_iterator
                                        );ssname

            insert_entity_block_name    (cdr (assoc 2 (entget insert_entity))) 
            insert_entity_block_entity  (tblobjname "block" insert_entity_block_name)
            insert_selection_iterator   (1+ insert_selection_iterator)
          );setq

          (if (not (member insert_entity_block_entity insert_entities_block_list))
              (setq insert_entities_block_list (cons insert_entity_block_entity
                                                     insert_entities_block_list
                                               );cons
              );setq
          );if

  );repeat

  insert_entities_block_list


);defun


; return a list of all corresponding layers of each block entity
(defun get_list_of_next_block_entities_layer_names ( block_entities_list
                                                     /
                                                     next_entity_entget
                                                     block_entities_layer_names_list
                                                     *error*
                                                    )

  (defun *error* (msg)
    (princ "\n
           error in function: get_list_of_next_block_entities_layer_names
           module:            data_extraction_functions \n")
    (princ msg)
    (princ)
  );defun

  (foreach next_entity block_entities_list

           (while (setq next_entity            (entnext next_entity)) ; block entity converted to next item

                  (setq next_entity_entget     (entget next_entity)
                        block_entity_layer_name (cdr (assoc 8 next_entity_entget))
                  );setq

                  (if (not (member block_entity_layer_name block_entities_layer_names_list))
                      (setq block_entities_layer_names_list (cons block_entity_layer_name
                                                                  block_entities_layer_names_list
                                                            );cons
                      );setq
                  );if
           );while
  );foreach

  ; return list of next entities layers
  block_entities_layer_names_list
);defun


; create variables for all block entity layers and set/reset to zero
(defun set_next_entity_layer_names_to_variables ( block_next_entity_layer_names_list /
                                                  *error*)

  (defun *error* (msg)
    (princ (strcat
             "\n
             error in function: set_next_entity_layer_names_to_variables
             module:            data_extraction_functions \n"
             msg)
    ) 
    (princ)
  );defun

  (foreach layer_name block_next_entity_layer_names_list
           (set (read layer_name)  0);set
  );foreach
);defun


; iterate over each block entity item and sum corresponding properties to corresponding variables
; set by layer names
(defun write_next_block_entities_to_variables ( insert_block_entities_list 
                                               /
                                               next_type_methods_list

                                               next_entity
                                               next_entity_layer_name
                                               next_entity_vla_object

                                               method_attribute
                                               method_function
                                               method_factor
                                             )
  (defun *error* (message) 
    (princ "\n
           error in function: write_next_block_entities_to_variables
           module:            01_data_extraction_functions"
    )
    (princ message)
    (princ)
  );defun

  (setq 
    next_type_methods_list  (list  
                              (list "breite"  vla-get-measurement 1)
                              (list "hoehe"   vla-get-measurement 1)
                              (list "umfang"  vla-get-length      0.01)
                              (list "flaeche" vla-get-area        0.0001)
                              (list "laenge"  vla-get-length      0.01)
                              (list "volumen" vla-get-volume      0.000001)
                            );list
  );setq

  (foreach next_entity insert_block_entities_list

   (while (setq next_entity (entnext next_entity))

          (setq next_entity_layer_name (cdr (assoc 8 (entget next_entity)))
                next_entity_vla_object (vlax-ename->vla-object next_entity)
          );setq

          (foreach method_data next_type_methods_list
             (setq method_attribute (nth 0 method_data)
                   method_function  (nth 1 method_data)
                   method_factor    (nth 2 method_data)
             );setq

             (if (wcmatch next_entity_layer_name (strcat "*_" method_attribute))
                 (progn 
                   (set (read next_entity_layer_name)
                        (+
                          (eval (read next_entity_layer_name))
                          (* method_factor (method_function next_entity_vla_object))
                        )
                   );set
                 );progn
             );if
          );foreach
   );while
  );foreach
);defun


; write insert name, insert instances numbers and insert block attributes per insert to list
(defun write_insert_data_to_list (insert_selection
                                  block_next_entity_layer_names_list
                                  / 
                                  iterator
                                  insert_next_dimensions
                                  insert_data
                                  inserts_data
                                  *error*)
  (setq iterator  0
  );setq

  (defun *error* (message) 
    (princ "\n
           error in function: write_insert_data_to_list
           module:            01_data_extraction_functions"
    )
    (princ message)
    (princ)
  );defun

  (repeat (sslength insert_selection)

          (setq 
            insert_entity       (ssname insert_selection iterator)
            iterator            (1+ iterator)
            insert_entity_name  (cdr (assoc 2 (entget insert_entity)))

                                ; sub-function to read the insert number attribute
            insert_nummer       (get_insert_entity_nummer_attribute insert_entity)
          );setq


          ; write insert type data to inserts_data if not yet done
          (if (not (assoc insert_entity_name inserts_data))

              (progn 
                (setq 
                  insert_next_dimensions (list (list "breite")
                                               (list "hoehe")
                                               (list "flaeche")
                                               (list "umfang")
                                               (list "volumen")
                                         );list
                );setq

                ; iterate over insert entities and filter corresponding layer/values variables
                ; extend dimensions attributes list by corresponding values
                (foreach block_value insert_next_dimensions
                         (foreach next_layer block_next_entity_layer_names_list
                                  (if (wcmatch next_layer (strcat insert_entity_name "*" (nth 0 block_value)))
                                      (progn 
                                        (setq insert_next_dimensions
                                                (subst (list 
                                                         (nth 0 block_value)
                                                         (rtos (eval (read next_layer)))
                                                       );list
                                                       block_value
                                                       insert_next_dimensions
                                              );subst
                                        );setq
                                      );progn
                                  );if
                         );foreach
                );foreach

                ; append insert type as name, instance numbers and dimensions to inserts_data list
                (setq 
                  inserts_data  (cons (list
                                                  insert_entity_name
                                                  (list insert_nummer)
                                                  insert_next_dimensions
                                      );list
                                      inserts_data
                                );cons
                );setq
              );progn

              ; if insert tye in inserts_data list already, extend instance number by corresponding "nummer" value
              (setq 
                insert_data   (assoc insert_entity_name inserts_data)
                inserts_data  (subst
                                  (list (nth 0 insert_data)
                                        (vl-sort
                                         (cons insert_nummer
                                               (nth 1 insert_data))
                                         '<)
                                        (nth 2 insert_data)
                                  );list
                                  insert_data
                                  inserts_data
                               );subst
              );setq
          );if
  );repeat
  inserts_data
);defun

; subfunction of write_insert_data_to_list
; read insert number attribute
(defun get_insert_entity_nummer_attribute (insert_entity /
                                           attributes_array
                                           iterator
                                           instance_nummer
                                           *error*)

  (defun *error* (message) 
    (princ "\n
           error in subfunction: get_insert_entity_nummer_attribute
           module:               01_data_extraction_functions"
    )
    (princ message)
    (princ)
  );defun

  (setq attributes_array  (vlax-variant-value 
                            (vla-getattributes 
                              (vlax-ename->vla-object insert_entity)
                            );vla-getattributes
                          );vlax-variant-value
        iterator          0
  );setq

  (while (>= (vlax-safearray-get-u-bound attributes_array 1) iterator)

         (if (= "NUMMER"
                (vla-get-tagstring 
                  (vlax-safearray-get-element 
                    attributes_array iterator
                  );vlax-safearray-get-element
                );vla-get-tagstring
             )

              (setq instance_nummer (vla-get-textstring 
                                      (vlax-safearray-get-element 
                                        attributes_array iterator
                                      );vlax-safearray-get-element
                                    );vla-get-textstring
              );setq
         );if

         (setq iterator (1+ iterator))

  );while

  instance_nummer
);defun

