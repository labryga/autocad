
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
                        )
  (setq 
    insert_selection_set (ssget "x" '((0 . "INSERT")))
    insert_selection_set_iterator 0
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
           );while
  );foreach

  (princ)
);defun
