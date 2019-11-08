
(defun write_attributes (/
                          insert_selection_set
                          insert_selectin_set_entity
                          insert_selection_entity_block_name
                          insert_selection_entity_block
                          insert_selection_block_entities_list

                          next_entity
                          next_entity_entget
                          next_entity_layer_name
                          next_entity_layer_names_list
                          next_entity_vla-object

                          next_type_methods_list
                          next_type_method
                          next_type_factor
                          next_type_result

                          model_space
                          csv_file
                          wall_data
                          wall_data_entry_name
                        )

  (setq 
    insert_selection_set                  (ssget "x" '((0 . "INSERT")))
    insert_selection_block_entities_list  (get_list_of_insert_block_entities insert_selection_set)

    next_entity_layer_names_list          (get_list_of_next_block_entities_layers
                                            insert_selection_block_entities_list)

    next_type_methods_list  (list 
                               (list "flaeche"  (list vla-get-area 0.0001))
                               (list "umfang"   (list vla-get-length 0.01))
                               (list "laenge"   (list vla-get-length 0.01))
                               (list "volumen"  (list vla-get-volume 0.000001))
                               (list "breite"   (list vla-get-measurement 1))
                               (list "hoehe"    (list vla-get-measurement 1))
                            );list

    model_space                             (vla-get-modelspace (vla-get-activedocument
                                                                  (vlax-get-acad-object)))

    csv_file                (open "c:\\Users\\affe\\Documents\\hegenheimerstrasse.csv" "w")
  );setq


  ; set/reset each next entity layer name variable to zero
  (foreach next_entity_layer_name next_entity_layer_names_list
           (set (read next_entity_layer_name) 0);set
  );foreach

  ; sum up each next block entities and write to corresponding variable
  (foreach next_entity insert_selection_block_entities_list

           (while (setq next_entity (entnext next_entity))
                  (setq next_entity_entget      (entget next_entity)
                        next_entity_layer_name  (cdr (assoc 8 next_entity_entget))
                        next_entity_vla-object  (vlax-ename->vla-object next_entity)
                  );setq

                  (foreach eintrag next_type_methods_list
                           (if (wcmatch next_entity_layer_name (strcat "*_" (car eintrag)))
                               (progn 
                                 (setq next_type_method (car (cadr eintrag))
                                       next_type_factor (cadr (cadr eintrag))
                                       next_type_result (next_type_method next_entity_vla-object)
                                 );setq
                                 (set (read next_entity_layer_name)
                                      (+
                                        (eval (read next_entity_layer_name))
                                        (* next_type_result next_type_factor)
                                      )
                                 );set
                               );progn
                           );if
                  );foreach
           );while
  );foreach

  ; write attributes of each entity variable
  ; (foreach eintrag next_entity_layer_names_list
  ;   (vla-addattribute 
  ;     model_space
  ;     (getvar 'textsize)
  ;     acattributemodelockposition
  ;     ""
  ;     (vlax-3d-point 0 0 0)
  ;     eintrag
  ;     (eval (read eintrag))
  ;   );vla-addattribute
  ; );foreach

  ; write variables to csv
  (foreach eintrag next_entity_layer_names_list
           (write-line (strcat
                    eintrag "\t"
                    (rtos (eval (read eintrag)))
              ) csv_file)
  );foreach

  (setq wall_data (my_test insert_selection_set)) 

  ; (foreach  item insert_selection_block_entities_list
  ;           (write-line (cdr (assoc 2 (entget item))) csv_file)
  ;
  ;           (foreach wall_data_item wall_data
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

  (princ)
  (close csv_file)  
);defun


(defun my_test ( insert_selection /
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

  (setq 
    ; insert_entity                 (car (entsel))
    ; insert_entity_entget          (entget insert_entity)
    ; insert_entity_name            (cdr (assoc 2 insert_entity_entget))
    ; insert_selection              (ssget "x" (list (cons 2 insert_entity_name)))
    insert_selection_iterator     0
  );setq

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
