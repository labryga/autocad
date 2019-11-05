
(defun write_attributes (/
                          insert_selection_set
                          insert_selection_set_iterator
                          insert_selection_entity_entget
                          insert_block_name
                          insert_block_entity
                        )
  (setq 
    insert_selection_set (ssget "x" '((0 . "INSERT")))
    insert_selection_set_iterator 0
  );setq

  (repeat (sslength insert_selection_set)
          (setq 
            insert_selection_entity_entget (entget (ssname insert_selection_set insert_selection_set_iterator))
            insert_block_name (cdr (assoc 2 insert_selection_entity_entget))
            insert_block_entity (tblobjname "block" insert_block_name)
            insert_selection_set_iterator (1+ insert_selection_set_iterator)
          );setq
          (print (assoc 2 insert_selection_entity_entget))
  );repeat

  (princ)
);defun
