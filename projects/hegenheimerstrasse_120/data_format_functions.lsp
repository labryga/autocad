; formatting data functions

; add key values to split layer entity names
(defun extend_instert_data_by_key_values (insert_entities_data
                                          /
                                          bezeichnung_keys
                                         )

  (setq bezeichnung_keys (list 
                             "ebkp-nr"
                             "ebkp-bezeichnung"
                             "phase"
                             "bkp-nr"
                             "bkp-bezeichnung"
                             "wandstaerke"
                             "wandtyp"
                         );list
  );setq

  ; set key values for each name item in naming section
  (foreach eintrag insert_entities_data
           (setq insert_entities_data
             (subst 
                  (subst 
                     (mapcar 'list bezeichnung_keys (nth 0 eintrag))
                     (nth 0 eintrag)
                     eintrag
                  );subst
                  eintrag
                  insert_entities_data
             );subst
           )
  );foreach

  ; set instances key value for inserts number attributes
  (foreach eintrag insert_entities_data
           (setq insert_entities_data
                 (subst 
                     (subst 
                       (list "exemplare" (nth 1 eintrag))
                       (nth 1 eintrag)
                       eintrag
                     );subst
                     eintrag
                     insert_entities_data
                 );subst
           );setq
  );foreach

  ; return inster data extended by keys
  insert_entities_data
);defun
