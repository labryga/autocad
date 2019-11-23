
(defun format_characters_in_inserts_data (inserts_data /
                                          insert_name)
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
