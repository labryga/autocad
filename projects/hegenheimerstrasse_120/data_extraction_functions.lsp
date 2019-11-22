; module to retrieve all data from corresponding insert items


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
                                 list_of_layer_name_split_neu
                                 eintrag_neu
                                 bezeichnung_neu
                               )

  (setq 
    insert_selection_iterator 0
  );setq

  ; write insert name, insert instances and insert block attributes to list
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

          ; get attribute values of an insert entity
          (defun get_insert_attribute_values (insert_entity / )
                 
                (setq attributes_variant  (vlax-variant-value 
                                            (vla-getAttributes
                                            vlax-ename->vla-object insert_entity))
                      iterator            0
                );setq

                (while (> (vlax-safearray-get-u-bound attributes_variant 1) iterator)
                       (vla-get-textstring 
                         (vlax-safearray-get-element attributes_variant iterator)
                       )
                       (setq iterator (1+ iterator))
                );while
          );defun

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

  ; function spliting string to list of strings by "-" delimiter
  (defun split_name_to_list (name_string / delimiter_position)
    (if (setq delimiter_position (vl-string-search "_" name_string))
        (setq name_string (cons (substr name_string 1 delimiter_position)
                          (split_name_to_list (substr name_string (+ 2 delimiter_position)))
                          );cons
        );setq
        (list name_string)
    );if
  );defun

  ; replace blockname string with list of strings by applying split_name_to_list function
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

  ; replace $ and & charcters to corresponding . and \s
  (foreach eintrag selection_inserts_data
     (setq selection_inserts_data
           (subst 
             (subst
               (foreach bezeichnung (setq name_neu (nth 0 eintrag))
                        (setq name_neu
                              (subst 
                                 (vl-string-subst
                                   "." "$" (vl-string-subst
                                             "-" "&" bezeichnung))
                                 bezeichnung
                                 name_neu
                              );subst
                        );setq
                );foreach
                (nth 0 eintrag)
                eintrag
             );subst
             eintrag
             selection_inserts_data
           );subst
     );setq
  );foreach

  (princ)
  ; return inserts data
  selection_inserts_data
);defun
