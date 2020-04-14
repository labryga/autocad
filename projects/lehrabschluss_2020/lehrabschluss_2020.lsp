(defun c:txtshxremove ( / selection_set
                          iterator
                          selection_entity
                          entity_entget
                          entity_content
                          entity_content_new)

  (setq selection_set (ssget "x" '((0 . "MTEXT")))
        iterator      0
  );setq

  (repeat (sslength selection_set)
          (setq selection_entity (ssname selection_set iterator) 
                entity_entget    (entget selection_entity)
                entity_content   (cdr (assoc 1 (entget selection_entity))) 
                entity_content_new (vl-string-subst "" "\\Ftxt.shx;" entity_content)
                iterator         (1+ iterator)
          );setq

          (while (wcmatch entity_content_new "*\\Ftxt.shx;*")
                 (setq entity_content_new (vl-string-subst "" "\\Ftxt.shx;" entity_content_new)
                 );setq
          );while

          (while (wcmatch entity_content_new "*\\Ftxt.shx|c2;*")
                 (setq entity_content_new (vl-string-subst "" "\\Ftxt.shx|c2;" entity_content_new)
                 );setq
          );while

          (entmod
            (subst 
              (cons 1 entity_content_new)
              (assoc 1 entity_entget)
              entity_entget
            );subst
           )
  );repeat

  (princ)
);defun


(defun c:lehrscale ( / selection_set)

  (setq selection_set (ssget "_A"));setq
  (command "scale" selection_set "" 0.0 100 "")
);defun
