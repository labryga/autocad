
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

  (setq

    ; write insert name, insert instances numbers and insert block attributes per insert to list
    insert_entities_data (write_insert_data_to_list
                           insert_selection_set
                           block_next_entity_layer_names_list)

    ; split insert names to list in each insert entry
    insert_entities_data  (split_insert_name_to_list insert_entities_data)

    ; replace "$" and "&" by corresponding "." and "\s" symbols in insert names
    insert_entities_data  (format_characters_in_inserts_data insert_entities_data)

    ; add key values to layer entity names
    insert_entities_data  (extend_instert_data_by_key_values insert_entities_data)
  )

  (write_insert_data_to_json insert_entities_data)

  (princ)

);defun


; iterate over inserts selection and return a list of all corresponding block entities
(defun get_list_of_insert_block_entities ( insert_selection_set
                                           /
                                           insert_selection_iterator

                                           insert_entity
                                           insert_entity_block_name
                                           insert_entity_block_entity
                                           insert_entities_block_list
                                         )
  (setq 
    insert_selection_iterator 0
  );setq

  (repeat (sslength insert_selection_set)
          (setq 
            insert_entity               (ssname insert_selection_set
                                                insert_selection_iterator
                                        );ssname
            insert_entity_block_name    (cdr (assoc 2 (entget insert_entity))) 
            insert_entity_block_entity  (tblobjname "block" insert_entity_block_name)
            insert_selection_iterator   (1+ insert_selection_iterator)
          );setq

          (if (not (member insert_entity_block_entity insert_entities_block_list))
              (setq insert_entities_block_list (cons insert_entity_block_entity
                                                     insert_entities_block_list
                                               );cons
              );setq
          );if

  );repeat

  insert_entities_block_list
);defun


; return a list of all corresponding layers of each block entity
(defun get_list_of_next_block_entities_layer_names ( block_entities_list
                                                     /
                                                     next_entity_entget
                                                     block_entities_layer_names_list
                                                    )

  (foreach next_entity block_entities_list

           (while (setq next_entity            (entnext next_entity)) ; block entity converted to next item

                  (setq next_entity_entget     (entget next_entity)
                        block_entity_layer_name (cdr (assoc 8 next_entity_entget))
                  );setq

                  (if (not (member block_entity_layer_name block_entities_layer_names_list))
                      (setq block_entities_layer_names_list (cons block_entity_layer_name
                                                                  block_entities_layer_names_list
                                                            );cons
                      );setq
                  );if
           );while
  );foreach

  ; return list of next entities layers
  block_entities_layer_names_list
);defun


; create variables for all block entity layers and set/reset to zero
(defun set_next_entity_layer_names_to_variables ( block_next_entity_layer_names_list /)
  (foreach layer_name block_next_entity_layer_names_list
           (set (read layer_name)  0);set
  );foreach
);defun


; iterate over each block entity item and sum corresponding properties to corresponding variables
; set by layer names
(defun write_next_block_entities_to_variables ( insert_block_entities_list 
                                               /
                                               next_type_methods_list

                                               next_entity
                                               next_entity_layer_name
                                               next_entity_vla_object

                                               method_attribute
                                               method_function
                                               method_factor
                                             )

  (setq 
    next_type_methods_list  (list  
                              (list "breite"  vla-get-measurement 1)
                              (list "hoehe"   vla-get-measurement 1)
                              (list "umfang"  vla-get-length      0.01)
                              (list "flaeche" vla-get-area        0.0001)
                              (list "laenge"  vla-get-length      0.01)
                              (list "volumen" vla-get-volume      0.000001)
                            );list
  );setq

  (foreach next_entity insert_block_entities_list

   (while (setq next_entity (entnext next_entity))

          (setq next_entity_layer_name (cdr (assoc 8 (entget next_entity)))
                next_entity_vla_object (vlax-ename->vla-object next_entity)
          );setq

          (foreach method_data next_type_methods_list
             (setq method_attribute (nth 0 method_data)
                   method_function  (nth 1 method_data)
                   method_factor    (nth 2 method_data)
             );setq

             (if (wcmatch next_entity_layer_name (strcat "*_" method_attribute))
                 (progn 
                   (set (read next_entity_layer_name)
                        (+
                          (eval (read next_entity_layer_name))
                          (* method_factor (method_function next_entity_vla_object))
                        )
                   );set
                 );progn
             );if
          );foreach
   );while
  );foreach
);defun


; write insert name, insert instances numbers and insert block attributes per insert to list
(defun write_insert_data_to_list (insert_selection
                                  block_next_entity_layer_names_list
                                  / 
                                  iterator
                                  insert_next_dimensions
                                  insert_data
                                  inserts_data)
  (setq iterator  0
  );setq

  (repeat (sslength insert_selection)
          (setq 
            insert_entity       (ssname insert_selection iterator)
            iterator            (1+ iterator)
            insert_entity_name  (cdr (assoc 2 (entget insert_entity)))

                                ; sub-function to read the insert number attribute
            insert_nummer       (get_insert_entity_nummer_attribute insert_entity)
          );setq


          ; write insert type data to inserts_data if not yet done
          (if (not (assoc insert_entity_name inserts_data))
              (progn 
                (setq 
                  insert_next_dimensions (list (list "breite")
                                               (list "hoehe")
                                               (list "flaeche")
                                               (list "umfang")
                                               (list "volumen")
                                         );list
                );setq

                ; iterate over insert entities and filter corresponding layer/values variables
                ; extend dimensions attributes list by corresponding values
                (foreach block_value insert_next_dimensions
                         (foreach next_layer block_next_entity_layer_names_list
                                  (if (wcmatch next_layer (strcat insert_entity_name "*" (nth 0 block_value)))
                                      (progn 
                                        (setq insert_next_dimensions
                                                (subst (list 
                                                         (nth 0 block_value)
                                                         (rtos (eval (read next_layer)))
                                                       );list
                                                       block_value
                                                       insert_next_dimensions
                                              );subst
                                        );setq
                                      );progn
                                  );if
                         );foreach
                );foreach

                ; append insert type as name, instance numbers and dimensions to inserts_data list
                (setq 
                  inserts_data  (cons (list
                                                  insert_entity_name
                                                  (list insert_nummer)
                                                  insert_next_dimensions
                                                );list
                                                inserts_data
                                          );cons
                );setq
              );progn

              ; if insert tye in inserts_data list already, extend instance number by corresponding "nummer" value
              (setq 
                insert_data   (assoc insert_entity_name inserts_data)
                inserts_data  (subst
                                  (list (nth 0 insert_data)
                                        (vl-sort
                                         (cons insert_nummer
                                               (nth 1 insert_data))
                                         '<)
                                        (nth 2 insert_data)
                                  );list
                                  insert_data
                                  inserts_data
                               );subst
              );setq
          );if
  );repeat
  inserts_data
);defun


; read insert number attribute
(defun get_insert_entity_nummer_attribute (insert_entity /
                                           attributes_array
                                           iterator
                                           instance_nummer)

  (setq attributes_array  (vlax-variant-value 
                            (vla-getattributes 
                              (vlax-ename->vla-object insert_entity)
                            );vla-getattributes
                          );vlax-variant-value
        iterator          0
  );setq

  (while (>= (vlax-safearray-get-u-bound attributes_array 1) iterator)

         (if (= "NUMMER"
                (vla-get-tagstring 
                  (vlax-safearray-get-element 
                    attributes_array iterator
                  );vlax-safearray-get-element
                );vla-get-tagstring
             )

              (setq instance_nummer (vla-get-textstring 
                                      (vlax-safearray-get-element 
                                        attributes_array iterator
                                      );vlax-safearray-get-element
                                    );vla-get-textstring
              );setq
         );if

         (setq iterator (1+ iterator))

  );while

  instance_nummer
);defun


; split insert names to list in each insert entry
(defun split_insert_name_to_list (inserts_data /)

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


; subfunction split name string to list by "-" delimiter
(defun split_string_to_list ( string_value / delimiter_position)
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


; add key values to layer entity names
(defun extend_instert_data_by_key_values (inserts_data
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


; format inserts data to csv and write to file
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


; format data to json and write to file
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
