
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
    insert_selection_block_entities_list  (get_list_of_insert_block_entities insert_selection_set)
    next_entity_layer_names_list          (get_list_of_next_block_entities_layers
                                            insert_selection_block_entities_list)
    insert_entities_data                  (get_insert_entities_data insert_selection_set) 
    model_space                           (vla-get-modelspace (vla-get-activedocument
                                                                  (vlax-get-acad-object)))

    ; csv_file                (open "c:\\Users\\affe\\Documents\\hegenheimerstrasse.csv" "w")
  );setq

  ; set/reset each next entity layer name variable to zero
  (set_next_entity_layer_names_to_variables next_entity_layer_names_list)

  ; sum up each next block entities and write to corresponding variable
  (write_next_block_entity_to_variable insert_selection_block_entities_list) 


  ; (foreach  item insert_selection_block_entities_list
  ;           (write-line (cdr (assoc 2 (entget item))) csv_file)
  ;
  ;           (foreach wall_data_item insert_entities_data
  ;                    (if (wcmatch (car wall_data_item) (cdr (assoc 2 (entget item))))
  ;                        (progn 
  ;                          (setq wall_data_entry_name (strcat 
  ;                                                       (nth 0 wall_data_item)
  ;                                                       "-"
  ;                                                       (nth 2 wall_data_item)
  ;                                                     )
  ;                          );setq
  ;
  ;                          (foreach eintrag next_entity_layer_names_list
  ;                                   (if 
	; 				(wcmatch eintrag
  ;                                                (strcat "*" (cdr (assoc 2 (entget item))) "*")
  ;                                       )
  ;
	; 				(setq wall_data_entry_name (strcat
	; 							     wall_data_entry_name
	; 							     " "
	; 							     (rtos (eval (read eintrag)))
	; 							   )
	; 				);setq
  ;                                   );if
  ;                          );foreach
  ;
  ;                        (write-line wall_data_entry_name csv_file)
  ;                        );progn
  ;                    );if
  ;           );foreach
  ;
  ;           (write-line "\n" csv_file)
  ; );foreach

  (write_data_to_csv_file insert_entities_data)

  (princ)
  ; (close csv_file)  
);defun


(defun get_insert_entities_data (insert_selection /
                                 insert_entity
                                 insert_entity_entget
                                 insert_entity_name
                                 insert_selection_iterator

                                 selection_entity 
                                 selection_entity_entget
                                 selection_entity_layer_name
                                 selection_entity_vla_object
                                 selection_entity_attributes
                                 selection_entity_variant
                                 selection_entity_variant_iterator
                                 selection_entity_attributes_data
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
                  
                 (setq selection_entity_attributes_data
                   (cons 
                     (list 
                       selection_entity_layer_name

                       (vla-get-tagstring 
                         (vlax-safearray-get-element 
                           selection_entity_variant
                           selection_entity_variant_iterator
                         );vlax-safearray-get-element
                       );vla-get-tagstring

                       (vla-get-textstring 
                         (vlax-safearray-get-element 
                           selection_entity_variant
                           selection_entity_variant_iterator
                         );vlax-safearray-get-element
                       );vla-get-textstring

                     );list

                     selection_entity_attributes_data
                   );cons
                 );setq

                 (setq selection_entity_variant_iterator (1+ selection_entity_variant_iterator))
          );while
  );repeat

  ; (foreach eintrag selection_entity_attributes_data
  ;          (print eintrag)
  ; );foreach
  selection_entity_attributes_data
);defun

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
                                insert_entget
                                insert_block_name
                                insert_layer_name
                              )

  (foreach insert_data insert_entities_data

           (print insert_data)
           (princ) 
  );foreach

);defun
