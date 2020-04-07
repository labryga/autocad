(defun c:mytest ( / selection_set
                    iterator
                    selection_entity
                    entity_content)

  (setq selection_set (ssget "_X" '((0 . "MTEXT")))
        iterator      0
  );setq

  (repeat (sslength selection_set)
          (setq selection_entity (ssname selection_set iterator) 
                entity_content   (cdr (assoc 1 (entget selection_entity))) 
                iterator         (1+ iterator)
          );setq
          (print entity_content)
  );repeat

  (princ)
);defun

