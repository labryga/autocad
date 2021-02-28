; data format functions


; split insert names to list in each insert entry
(defun split_insert_name_to_list (inserts_data /
                                  *error*)

  (defun *error* (message)
    (princ "\n
           error in function: split_insert_name_to_list
           module:            02_data_format_functions \n")
    (princ message)
    (princ)
  );defun

  (foreach insert_entry inserts_data
           (setq inserts_data
                 (subst 
                   (subst 
                     ; subfunction to split name string to list by "-" delimiter
                     (split_string_to_list (nth 0 insert_entry))
                     (nth 0 insert_entry)
                     insert_entry
                   );subst
                   insert_entry
                   inserts_data
                 );subst
           );setq
  );foreach

  inserts_data
);defun


; subfunction split name string to list by "_" delimiter
(defun split_string_to_list ( string_value /
                              delimiter_position
                              *error*)

  (defun *error* (message)
    (princ "\n
           error in subfunctionfunction: split_string_to_list
           module:                      02_data_format_functions \n")
    (princ message)
    (princ)
  );defun

  (if (setq delimiter_position (vl-string-search "_" string_value))
      (setq string_value
        (cons
          (substr string_value 1 delimiter_position)
          (split_string_to_list (substr string_value (+ delimiter_position 2)))
        );cons
      );setq
      (list string_value)
  );if
);defun


; replace "$" and "&" by corresponding "." and "\s" symbols in insert names
(defun format_characters_in_inserts_data (inserts_data /
                                          insert_name
                                          *error*)
  (defun *error* (message)
    (princ "\n
           error in function: format_characters_in_inserts_data
           module:            02_data_format_functions \n")
    (princ message)
    (princ)
  );defun

  (foreach eintrag inserts_data
           (setq inserts_data
                 (subst 
                   (subst 
                     (foreach bezeichnung (setq insert_name (nth 0 eintrag))
                              (setq insert_name
                                (subst 
                                  (vl-string-subst "." "$"
                                                   (vl-string-subst " " "&" bezeichnung))
                                  bezeichnung
                                  insert_name
                                );subst
                              );setq
                     );foreach
                     (nth 0 eintrag)
                     eintrag
                   );subst
                   eintrag
                   inserts_data
                 );subst
           );setq
  );foreach

  inserts_data
);defun


; add key values to layer entity names
(defun extend_instert_data_by_key_values (inserts_data
                                          /
                                          bezeichnung_keys
                                          *error*
                                         )

  (defun *error* (message)
    (princ "\n
           error in function: extend_instert_data_by_key_values
           module:            02_data_format_functions \n")
    (princ message)
    (princ)
  );defun

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
  (foreach eintrag inserts_data
           (setq inserts_data
             (subst 
                  (subst 
                     (mapcar 'list bezeichnung_keys (nth 0 eintrag))
                     (nth 0 eintrag)
                     eintrag
                  );subst
                  eintrag
                  inserts_data
             );subst
           )
  );foreach

  ; set instances key value for inserts number attributes
  (foreach eintrag inserts_data
           (setq inserts_data
                 (subst 
                     (subst 
                       (list "exemplare" (nth 1 eintrag))
                       (nth 1 eintrag)
                       eintrag
                     );subst
                     eintrag
                     inserts_data
                 );subst
           );setq
  );foreach

  ; return inster data extended by keys
  inserts_data
);defun
