; load modules
; (load "hegenheimerstrasse_120/data_extraction_functions.lsp")

(defun write_attributes ( /
                          insert_selection_set
                          insert_selection_block_entities_list
                          block_next_entity_layer_names_list
                          insert_entities_data
                          insert_entities_data_key_extended
                        )
  (setq 
                                          
    insert_selection_set                  (ssget "x" '((0 . "INSERT")))

    ; iterate over inserts selection and return a list of all corresponding block entities
    ; by a function of data extraction module
    insert_selection_block_entities_list  (get_list_of_insert_block_entities insert_selection_set)

    ; return a list of all corresponding layers of each block entity
    ; by a function of data extraction module
    block_next_entity_layer_names_list    (get_list_of_next_block_entities_layer_names
                                            insert_selection_block_entities_list)
  );setq

  ; create variables for all block entity layers and set/reset to zero
  ; by a function of data extraction module
  (set_next_entity_layer_names_to_variables block_next_entity_layer_names_list)

  ; sum up each next block entities and write to corresponding variable
  (write_next_block_entities_to_variables insert_selection_block_entities_list) 

  (setq insert_entities_data (get_insert_entities_data
                               insert_selection_set
                               block_next_entity_layer_names_list)

        insert_entities_data_key_extended (extend_instert_data_by_key_values
                                            insert_entities_data)
  )

  (write_insert_data_to_json insert_entities_data_key_extended)

  (princ)

);defun

(defun write_data_to_csv (insert_entities_data /
                          user_home_directory
                          data_file

                          name_list
                          instances_list
                          values_list

                          name
                         )

  (setq user_home_directory (getenv "userprofile")
        data_file (open (strcat user_home_directory "\\Documents\\hegenheimerstrasse.csv") "w")
  );setq

  (foreach eintrag insert_entities_data
           (setq name_list      (reverse (nth 0 eintrag))
                 instances_list (nth 1 eintrag)
                 values_list    (reverse (nth 2 eintrag))

                 name           ""
                 values         ""
           );setq

           (foreach name_index (list 0 1 2 3 4 5 6)
                    (setq name  (strcat (nth name_index name_list) ","
                                        name
                                );strcat
                    );setq
           );foreach
           (write-line name data_file)

           (foreach value values_list
                    (setq values  (strcat
                                    (nth 1 value) ","
                                    values
                                  );strcat
                    );setq
           );foreach

           (foreach instance instances_list
                    (write-line (strcat (nth 0 name_list) "-"
                                        instance ","
                                        values
                                );strcat
                                data_file
                    )
           );foreach

  );foreach

  (close data_file)
  (princ)
);defun

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

  ; set exemplare key value for inserts number attributes
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

(defun write_insert_data_to_json  ( insert_data_set
                                    /
                                    json_file
                                    exemplar_nr
                                  )
  (setq
    json_file (open (strcat
                      (getenv "userprofile")
                      "\\Documents\\hegenheimerstrasse.json")
                    "w")
    exemplar_nr ""
  );setq

  (write-line "{\"waende\": [" json_file)

  (foreach item insert_data_set
           (write-line "{" json_file)

           (foreach bezeichnung (nth 0 item)
                    (write-line (strcat "\t\""
                                  (nth 0 bezeichnung) "\": \" "
                                  (nth 1 bezeichnung) "\","
                                );strcat
                                json_file
                    )
           );foreach

           (foreach werte (nth 2 item)
                    (write-line (strcat "\t\""
                                  (nth 0 werte) "\": \" "
                                  (nth 1 werte) "\","
                                );strcat
                                json_file
                    )
           );foreach

           (foreach wert (reverse (nth 1 (nth 1 item)))
                    (setq exemplar_nr (strcat "\"" wert "\"" exemplar_nr
                                      );strcat
                    );setq
           );foreach

           (setq exemplar_nr (vl-string-subst "\" , \""  "\"\""  exemplar_nr))
           (write-line (strcat "\t\"exemplar_nummern\": " "[" exemplar_nr "]") json_file)
           (setq exemplar_nr "")

           (if (=
                 (- (length insert_data_set) 1)
                 (vl-position item insert_data_set))
               (write-line "}" json_file)
               (write-line "}," json_file)
           );if

  );foreach

  (write-line "]}" json_file)
  (close json_file)
  (princ)
);defun
