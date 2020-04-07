(defun c:wytest ( / selection_set
                    iterator
                    selection_entity
                    entity_content
                    entity_content_new)

  (setq selection_set (ssget "x" '((0 . "MTEXT")))
        iterator      0
  );setq

  (repeat (sslength selection_set)
          (setq selection_entity (ssname selection_set iterator) 
                entity_content   (cdr (assoc 1 (entget selection_entity))) 
                entity_content_new (vl-string-subst "" "\\Ftxt.shx;" entity_content)
                iterator         (1+ iterator)
          );setq
          (print entity_content_new)
  );repeat

  (princ)
);defun
