
(defun write_attributes (/
                          insert_selection_set
                          insert_selectin_set_entity
                          insert_selection_entity_block_name
                          insert_selection_entity_block
                          insert_selection_block_entities_list

                          next_entity_layer_name
                          next_entity_layer_names_list

                          model_space
                          csv_file
                          insert_entities_data
                          wall_data_entry_name
                        )
  (setq 
    insert_selection_set                  (ssget "x" '((0 . "INSERT")))
    insert_entities_data                  (get_insert_entities_data insert_selection_set) 
    insert_selection_block_entities_list  (get_list_of_insert_block_entities insert_selection_set)
    next_entity_layer_names_list          (get_list_of_next_block_entities_layers
                                            insert_selection_block_entities_list)
    ; csv_file                (open "c:\\Users\\affe\\Documents\\hegenheimerstrasse.csv" "w")
  );setq

  ; set/reset each next entity layer name variable to zero
  (set_next_entity_layer_names_to_variables next_entity_layer_names_list)

  ; sum up each next block entities and write to corresponding variable
  (write_next_block_entity_to_variable insert_selection_block_entities_list) 

  (write_data_to_csv_file insert_entities_data)

  (princ)
  ; (close csv_file)  
);defun

(defun get_insert_entities_data (insert_selection /
                                 insert_selection_iterator

                                 selection_entity 
                                 selection_entity_entget
                                 selection_entity_layer_name
                                 selection_entity_vla_object
                                 selection_entity_attributes
                                 selection_entity_variant
                                 selection_entity_variant_iterator
                                 selection_entity_tagstring
                                 selection_entity_data
                                 selection_entity_data_attributes
                                 selection_entity_data_new

                                 selection_inserts_data
                               )

  (setq insert_selection_iterator 0);setq

  (repeat (sslength insert_selection)

          (setq 
            selection_entity                  (ssname insert_selection insert_selection_iterator)
            selection_entity_entget           (entget selection_entity)
            selection_entity_layer_name       (cdr (assoc 8 selection_entity_entget))
            insert_selection_iterator         (1+ insert_selection_iterator)
            selection_entity_vla_object       (vlax-ename->vla-object selection_entity)
            selection_entity_attributes       (vla-getAttributes selection_entity_vla_object)
            selection_entity_variant          (vlax-variant-value selection_entity_attributes)
            selection_entity_variant_iterator 0
          );setq

          (while (>=
                   (vlax-safearray-get-u-bound selection_entity_variant 1)
                   selection_entity_variant_iterator
                 )

                 (setq selection_entity_tagstring (vla-get-textstring
                                                    (vlax-safearray-get-element
                                                      selection_entity_variant
                                                      selection_entity_variant_iterator
                                                    );vlax-safearray-get-element
                                                  );vla-get-tagstring
                 );setq

                 (if (not (assoc selection_entity_layer_name selection_inserts_data))
                     (progn 
                       (setq selection_inserts_data (cons (list selection_entity_layer_name
                                                                (list selection_entity_tagstring)
                                                          );list
                                                          selection_inserts_data
                                                    );cons
                       );setq
                     );progn

                     (progn 
                       (setq selection_entity_data (assoc selection_entity_layer_name selection_inserts_data)
                             selection_entity_data_attributes (vl-sort 
                                                                (cons selection_entity_tagstring
                                                                      (nth 1 selection_entity_data)
                                                                );cons
                                                                '<
                                                              );vl-sort
                             selection_entity_data_new  (list selection_entity_layer_name
                                                              selection_entity_data_attributes
                                                        );list

                             selection_inserts_data     (subst selection_entity_data_new selection_entity_data
                                                               selection_inserts_data
                                                        );subst
                       );setq
                     );progn
                 );if

                 (setq selection_entity_variant_iterator (1+ selection_entity_variant_iterator))
          );while
  );repeat

  selection_inserts_data
)

(defun get_list_of_insert_block_entities ( insert_selection_set
                                           /
                                           insert_selection_iterator

                                           insert_entity
                                           insert_entity_entget
                                           insert_entity_block_name
                                           insert_entity_block_entity
                                           insert_entities_block_list
                                         )
  (setq 
    insert_selection_iterator 0
  );setq

  (repeat (sslength insert_selection_set)
          (setq 
            insert_entity               (ssname insert_selection_set
                                                insert_selection_iterator
                                        );ssname
            insert_entity_entget        (entget insert_entity)
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

  ; return block entitites list
  insert_entities_block_list
)

(defun get_list_of_next_block_entities_layers ( block_entities_list
                                                /
                                                block_entity_entget
                                                block_entities_layer_names_list
                                              )

  (foreach block_entity block_entities_list

           (while (setq block_entity            (entnext block_entity))
                  (setq block_entity_entget     (entget block_entity)
                        block_entity_layer_name (cdr (assoc 8 block_entity_entget))
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

(defun set_next_entity_layer_names_to_variables ( next_entity_layer_names_list /)
  (foreach layer_name next_entity_layer_names_list
           (set (read layer_name)  0);set
  );foreach
);defun

(defun write_next_block_entity_to_variable ( insert_block_entities_list 
                                             /
                                             next_type_methods_list

                                             next_entity
                                             next_entity_entget
                                             next_entity_layer_name
                                             next_entity_vla_object

                                             method_attribute
                                             method_function
                                             method_factor
                                           )

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
          (setq next_entity_entget     (entget next_entity)
                next_entity_layer_name (cdr (assoc 8 next_entity_entget))
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

(defun write_data_to_csv_file ( insert_entities_data
                                /
                                insert_name
                                insert_instances
                              )

  (foreach insert_data insert_entities_data
           (setq insert_name      (nth 0 insert_data)
                 insert_instances (nth 1 insert_data)
           );setq
           (print insert_name)

           (foreach insert_instance insert_instances
                    (print (strcat insert_name "-"
                                   insert_instance
                           );strcat
                    )
           );foreach

           (princ) 
  );foreach

);defun



