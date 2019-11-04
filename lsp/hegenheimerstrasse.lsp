
(defun write_attributes (/
                          insert_selection_set
                          insert_selection_counter

                          insert_entity
                          insert_entity_block_name
                          insert_entity_list
                        )

  (setq insert_selection_set (ssget "x" '((0 . "INSERT")))
        insert_entity_counter 0
  );setq


  ; get insert items into list filterd by corresponding ebkp numbetr
  (repeat (sslength insert_selection_set)

          (setq insert_entity (ssname insert_selection_set insert_entity_counter)
                insert_entity_block_name (cdr (assoc 2 (entget insert_entity)))
                insert_entity_counter (1+ insert_entity_counter)
          );setq

          (if (wcmatch insert_entity_block_name "[G]##*")
              (setq insert_entity_list (cons insert_entity insert_entity_list))
          );if

  );repeat

  (print insert_entity_list)
  (princ)
);defun

