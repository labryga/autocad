
(defun write_attributes (/
                          insert_selection_set
                          insert_selection_block_entities_list
                          block_next_entity_layer_names_list
                          insert_entities_data
                        )
  (setq 
    insert_selection_set                  (ssget "x" '((0 . "INSERT")))
    insert_selection_block_entities_list  (get_list_of_insert_block_entities insert_selection_set)
    block_next_entity_layer_names_list          (get_list_of_next_block_entities_layer_names
                                            insert_selection_block_entities_list)
  );setq

  ; set/reset each next entity layer name variable to zero
  (set_next_entity_layer_names_to_variables block_next_entity_layer_names_list)

  ; sum up each next block entities and write to corresponding variable
  (write_next_block_entities_to_variables insert_selection_block_entities_list) 

  (setq insert_entities_data (get_insert_entities_data
                               insert_selection_set
                               block_next_entity_layer_names_list))

  ; (write_data_to_csv insert_entities_data)


  (data_to_json insert_entities_data)
  (princ)
);defun

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

(defun set_next_entity_layer_names_to_variables ( block_next_entity_layer_names_list /)
  (foreach layer_name block_next_entity_layer_names_list
           (set (read layer_name)  0);set
  );foreach
);defun

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

(defun get_insert_entities_data ( insert_selection 
                                  block_next_entity_layer_names_list
                                  /
                                 insert_selection_iterator

                                 insert_entity
                                 insert_selection_iterator
                                 insert_entity_name

                                 insert_next_values

                                 insert_entity_attribute_variant
                                 attribute_variant_iterator
                                 attribute_value

                                 selection_insert_data
                                 selection_inserts_data
                                 selection_inserts_data_csv
                                 list_of_layer_name_split
                                 eintrag_neu
                                 list_of_layer_name_split_neu
                                 bezeichnung_neu
                               )

  (setq 
    insert_selection_iterator 0
  );setq

  (repeat (sslength insert_selection)
          (setq 
            insert_entity                   (ssname insert_selection insert_selection_iterator)
            insert_selection_iterator       (1+ insert_selection_iterator)
            insert_entity_name              (cdr (assoc 2 (entget insert_entity)))
            insert_entity_attribute_variant (vlax-variant-value
                                              (vla-getAttributes
                                                (vlax-ename->vla-object insert_entity))
                                            )
            attribute_variant_iterator      0
          );setq

          (while (>=  (vlax-safearray-get-u-bound insert_entity_attribute_variant 1)
                      attribute_variant_iterator
                 )
                 (setq 
                    attribute_value             (vla-get-textstring
                                                  (vlax-safearray-get-element
                                                    insert_entity_attribute_variant
                                                    attribute_variant_iterator)
                                                );vla-get-textstring
                    attribute_variant_iterator  (1+ attribute_variant_iterator)
                 );setq
          );while

          (if (not (assoc insert_entity_name selection_inserts_data))
              (progn 
                (setq 
                  insert_next_values (list (list "breite")
                                           (list "hoehe")
                                           (list "flaeche")
                                           (list "umfang")
                                           (list "volumen")
                                      );list
                );setq

                (foreach block_value insert_next_values
                         (foreach next_layer block_next_entity_layer_names_list
                                  (if (wcmatch next_layer (strcat insert_entity_name "*" (nth 0 block_value)))
                                      (progn 
                                        (setq insert_next_values
                                                (subst (list 
                                                         (nth 0 block_value)
                                                         (rtos (eval (read next_layer)))
                                                       );list
                                                       block_value
                                                       insert_next_values
                                              );subst
                                        );setq
                                      );progn
                                  );if
                         );foreach
                );foreach

                (setq 
                  selection_inserts_data  (cons (list
                                                  insert_entity_name
                                                  (list attribute_value)
                                                  insert_next_values
                                                );list
                                                selection_inserts_data
                                          );cons
                );setq
              );progn

              (setq 
                selection_insert_data (assoc insert_entity_name selection_inserts_data)
                selection_inserts_data (subst (list (nth 0 selection_insert_data)
                                                    (vl-sort
                                                     (cons attribute_value
                                                           (nth 1 selection_insert_data))
                                                     '<)
                                                    (nth 2 selection_insert_data)
                                              );list
                                              selection_insert_data
                                              selection_inserts_data
                                       );subst
              );setq
          );if
  );repeat

  (defun split_name_to_list (name_string / delimiter_position)
    (if (setq delimiter_position (vl-string-search "_" name_string))
        (setq name_string (cons (substr name_string 1 delimiter_position)
                          (split_name_to_list (substr name_string (+ 2 delimiter_position)))
                          );cons
        );setq
        (list name_string)
    );if
  );defun

  (foreach eintrag selection_inserts_data
           (setq selection_inserts_data
                 (subst (list 
                           (split_name_to_list (nth 0 eintrag))
                           (nth 1 eintrag)
                           (nth 2 eintrag)
                        );list
                        eintrag
                        selection_inserts_data
                 );subst
           );setq
  );foreach

  (foreach eintrag selection_inserts_data
           (setq list_of_layer_name_split (nth 0 eintrag)
                 list_of_layer_name_split_neu list_of_layer_name_split
           );setq
           (foreach bezeichnung list_of_layer_name_split
                    (setq bezeichnung_neu bezeichnung
                    );setq
                    (foreach zeichen (list 
                                       (list "$" ".")
                                       (list "&" " ")
                                     );list

                              (if (wcmatch bezeichnung (strcat "*" (nth 0 zeichen) "*"))
                                  (progn 
                                    (setq bezeichnung_neu
                                          (vl-string-subst
                                             (nth 1 zeichen)
                                             (nth 0 zeichen)
                                             bezeichnung_neu
                                           )
                                    );setq
                                  );progn
                              );if
                    );foreach

                    (setq list_of_layer_name_split_neu
                          (subst bezeichnung_neu
                                 bezeichnung
                                 list_of_layer_name_split_neu
                          );subst
                    );setq
           );foreach
           (setq eintrag_neu
                 (subst list_of_layer_name_split_neu
                        list_of_layer_name_split
                        eintrag
                 );subst
           );setq
           (setq selection_inserts_data_csv
                 (cons eintrag_neu selection_inserts_data_csv
                 );cons
           );setq

  );foreach
  selection_inserts_data_csv
);defun

(defun write_data_to_csv (insert_entities_data /
                          documents_directory
                          data_file

                          name_list
                          instances_list
                          values_list

                          name
                         )

  (setq documents_directory (getvar "userprofile")
        data_file (open "c:\\Users\\m.labryga\\Documents\\hegenheimerstrasse.csv" "w")
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

(defun data_to_json (insert_entities_data
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

  (foreach item insert_entities_data
           (print item)
  );foreach
  (princ)
);defun
