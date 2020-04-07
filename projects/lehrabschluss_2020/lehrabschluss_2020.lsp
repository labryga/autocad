(defun c:mytest ( / selection_set
                    iterator
                    selection_entity)

  (setq selection_set (ssget "x" '(0 . "MTEXT"))
        iterator      0
  );setq

  (repeat (sslength selection_set)
          (setq iterator (1+ iterator)
          );setq
  );repeat

);defun

