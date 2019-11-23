
  ; write insert name, insert instances and insert block attributes to list

(defun write_insert_data_to_list (insert_selection
                                  block_next_entity_layer_names_list
                                  / 
                                  iterator
                                  insert_next_dimensions
                                  inserts_data)
  (setq iterator  0
  );setq

  (repeat (sslength insert_selection)
          (setq 
            insert_entity                   (ssname insert_selection iterator)
            iterator                        (1+ iterator)
            insert_entity_name              (cdr (assoc 2 (entget insert_entity)))
                                            ; sub-function to read insert number attribute
            insert_nummer                   (get_insert_entity_nummer_attribute insert_entity)
          );setq


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

              (setq 
                selection_insert_data (assoc insert_entity_name inserts_data)
                inserts_data (subst (list (nth 0 selection_insert_data)
                                                    (vl-sort
                                                     (cons insert_nummer
                                                           (nth 1 selection_insert_data))
                                                     '<)
                                                    (nth 2 selection_insert_data)
                                              );list
                                              selection_insert_data
                                              inserts_data
                                       );subst
              );setq
          );if
  );repeat
);defun



; sub-function to read insert number attribute

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



