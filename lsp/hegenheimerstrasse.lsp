
(defun write_attributes (/
                          insert_selection_set
                          insert_selectin_set_entity
                          insert_selection_set_iterator
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
    insert_selection_set    (ssget "x" '((0 . "INSERT")))
    insert_selection_set_iterator 0

    next_type_methods_list  (list 
                               (list "flaeche"  (list vla-get-area 0.0001))
                               (list "umfang"   (list vla-get-length 0.01))
                               (list "laenge"   (list vla-get-length 0.01))
                               (list "volumen"  (list vla-get-volume 0.000001))
                               (list "breite"   (list vla-get-measurement 1))
                               (list "hoehe"    (list vla-get-measurement 1))
                            );list

    model_space             (vla-get-modelspace
                              (vla-get-activedocument (vlax-get-acad-object)))
    csv_file                (open "c:\\Users\\topos\\Documents\\hegenheimerstrasse.csv" "w")
  );setq

  ; write insert block entities to list
  (repeat (sslength insert_selection_set)
          (setq insert_selectin_set_entity          (ssname insert_selection_set insert_selection_set_iterator)
                insert_selection_set_iterator       (1+ insert_selection_set_iterator)
                insert_selection_entity_block_name  (cdr (assoc 2 (entget insert_selectin_set_entity)))
                insert_selection_entity_block       (tblobjname "block" insert_selection_entity_block_name)
          );setq

          (if (not (member insert_selection_entity_block insert_selection_block_entities_list))
              (setq insert_selection_block_entities_list (cons insert_selection_entity_block
                                                               insert_selection_block_entities_list
                                                         );cons
              );setq
          );if
  );repeat

  ; write set of next block entity layer names
  (foreach next_entity insert_selection_block_entities_list
           (while (setq next_entity             (entnext next_entity))
                  (setq next_entity_entget      (entget next_entity)
                        next_entity_layer_name  (cdr (assoc 8 next_entity_entget))
                  );setq

                  (if (not (member next_entity_layer_name next_entity_layer_names_list))
                    (setq next_entity_layer_names_list (cons next_entity_layer_name
                                                             next_entity_layer_names_list
                                                       );cons
                    );setq
                  );if
           );while
  );foreach

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
                           (if (wcmatch next_entity_layer_name (strcat "*-" (car eintrag)))
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
  ; (foreach eintrag next_entity_layer_names_list
  ;          (write-line (strcat
  ;                   eintrag "\t"
  ;                   (rtos (eval (read eintrag)))
  ;             ) csv_file)
  ; );foreach


  (setq wall_data (my_test insert_selection_set)) 

  (foreach  item insert_selection_block_entities_list
            (write-line (cdr (assoc 2 (entget item))) csv_file)
            ; (princ)

            (foreach eintrag wall_data
                     (if  (vl-string-search (cdr (assoc 2 (entget item))) (car eintrag))
                          (progn 
                              (write-line (strcat
                                            (nth 0 eintrag)
                                            "-"
                                            (nth 2 eintrag)
                                            )
                                          csv_file)

                              (foreach wand_attribut next_entity_layer_names_list
                                  (if (and
                                         (vl-string-search (cdr (assoc 2 (entget item))) wand_attribut)
                                         (not (wcmatch wand_attribut "*-nummer"))
                                      );and
                                      (write-line (strcat 
                                                    wand_attribut
                                                    "---"
                                                    (nth 2 eintrag)
                                                    "---"
                                                    (rtos (eval (read wand_attribut)))
                                                  );strcat
                                                  csv_file)
                                  );if
                               );foreach
                              (write-line "\n" csv_file)
                          );progn
                     );if

                     ;foreach

                     ; (setq wall_data_entry_name (strcat (car eintrag)))
                     ; (foreach layer_name next_entity_layer_names_list
                     ;          (if (vl-string-search (cdr (assoc 2 (entget item))) layer_name)
                     ;              (print (strcat layer_name "--" (last eintrag)))
                     ;          );if
                     ; );foreach
            );foreach
  );foreach

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
