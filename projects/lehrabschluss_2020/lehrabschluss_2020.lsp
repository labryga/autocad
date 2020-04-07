(defun c:mytest ( / selection_set
                    iterator
                    selection_entity
                    entity_content)

  (setq selection_set (ssget "x" '(0 . "MTEXT"))
        iterator      0
  );setq

  (repeat (sslength selection_set)
          (setq selection_entity (ssname selection_set iterator) 
                iterator (1+ iterator)
          );setq
  );repeat

);defun

