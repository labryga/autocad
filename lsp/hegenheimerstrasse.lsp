
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
                        )
  (setq 
    insert_selection_set    (ssget "x" '((0 . "INSERT")))
    insert_selection_set_iterator 0

    next_type_methods_list  (list 
                             (list "flaeche"  (list vla-get-area 0.0001))
                             (list "umfang"   (list vla-get-length 0.01))
                             (list "laenge"   (list vla-get-length 0.01))
                             (list "volumen"  (list vla-get-volume 0.000001))
                            );list

    model_space             (vla-get-modelspace
                              (vla-get-activedocument (vlax-get-acad-object)))
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

                  (set (read next_entity_layer_name) 0);set
           );while
  );foreach

  (foreach next_entity insert_selection_block_entities_list
           (while (setq next_entity (entnext next_entity))
                  (setq next_entity_entget      (entget next_entity)
                        next_entity_layer_name  (cdr (assoc 8 next_entity_entget))
                  );setq

                  (foreach eintrag next_type_methods_list
                           (if (wcmatch next_entity_layer_name (strcat "*-" (car eintrag)))
                               (progn 
                                 (setq next_type_method (car (cadr eintrag))
                                       next_type_factor (cadr (cadr eintrag))
                                       next_entity_vla-object (vlax-ename->vla-object next_entity)
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

  (foreach eintrag next_entity_layer_names_list
    (vla-addattribute 
      model_space
      (getvar 'textsize)
      acattributemodelockposition
      ""
      (vlax-3d-point 0 0 0)
      eintrag
      (eval (read eintrag))
    );vla-addattribute
  );foreach

  
  (princ)
);defun
