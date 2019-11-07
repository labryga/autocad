
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
    csv_file                (open "c:\\Users\\affe\\Documents\\hegenheimerstrasse.csv" "w")
  );setq

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

  (foreach next_entity insert_selection_block_entities_list
           (while (setq next_entity (entnext next_entity))

                  (setq next_entity_entget      (entget next_entity)
                        next_entity_layer_name  (cdr (assoc 8 next_entity_entget))
                        next_entity_vla-object (vlax-ename->vla-object next_entity)
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

  (foreach eintrag next_entity_layer_names_list
           (write-line (strcat
                    eintrag "\t"
                    (rtos (eval (read eintrag)))
              ) csv_file)
  );foreach

  (close csv_file)  
  (princ)
);defun

(defun write_csv (/
                   the_file
                 )
  (setq the_file
        (open "c:\\Users\\affe\\Documents\\the_file.csv" "w")
  );setq

  (repeat 10
    (write-line "meine datei" the_file)
  );repeat

  (close the_file)

  (princ)
);defun

(defun my_test (/
                 insert_entity
                 insert_entity_entget
                 insert_entity_name
                 insert_selection
                 insert_selection_iterator

                 selection_entity 
                 selection_entity_entget
                 selection_entity_layer_name
                 selection_entity_vla_object
                 selection_entity_attributes
                 selection_entity_variant
                 selection_entity_variant_iterator
               )

  (setq insert_entity                 (car (entsel))
        insert_entity_entget          (entget insert_entity)
        insert_entity_name            (cdr (assoc 2 insert_entity_entget))
        insert_selection              (ssget "x" (list (cons 2 insert_entity_name)))
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
                 (print 
                   (vla-get-TextString (vlax-safearray-get-element selection_entity_variant selection_entity_variant_iterator))
                 )
                 (setq selection_entity_variant_iterator (1+ selection_entity_variant_iterator))
          );while
          
          (print selection_entity_variant)

  );repeat

  (princ)
);defun
