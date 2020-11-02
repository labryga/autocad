(defun c:olp( /
             insert_selection_set
             insert_selection_iterator
             insert_entity
             insert_entity_block_name
             insert_entity_block_entity
             insert_entities_block_list
            )
  (setq 
    insert_selection_set  (ssget "x" '((0 . "INSERT")))
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


  (print insert_selection_set)
  (print insert_entities_block_list)
  (princ)
);defun
