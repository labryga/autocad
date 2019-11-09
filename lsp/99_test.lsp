(defun get_insert_entities_data (insert_selection /
                                 insert_selection_iterator

                                 selection_entity 
                                 selection_entity_entget
                                 selection_entity_layer_name
                                 selection_entity_vla_object
                                 selection_entity_attributes
                                 selection_entity_variant
                                 selection_entity_variant_iterator
                                 selection_entity_tagstring
                                 selection_entity_data
                                 selection_entity_data_attributes

                                 selection_entity_attributes_data
                               )

  (setq insert_selection_iterator 0);setq

  (repeat (sslength insert_selection)

          (setq 
            selection_entity                  (ssname insert_selection insert_selection_iterator)
            selection_entity_entget           (entget selection_entity)
            selection_entity_layer_name       (cdr (assoc 8 selection_entity_entget))
            insert_selection_iterator         (1+ insert_selection_iterator)
            selection_entity_vla_object       (vlax-ename->vla-object selection_entity)
            selection_entity_attributes       (vla-getAttributes selection_entity_vla_object)
            selection_entity_variant          (vlax-variant-value selection_entity_attributes)
            selection_entity_variant_iterator 0
          );setq

          (while (>=
                   (vlax-safearray-get-u-bound selection_entity_variant 1)
                   selection_entity_variant_iterator
                 )

                 (setq selection_entity_tagstring (vla-get-textstring
                                                    (vlax-safearray-get-element
                                                      selection_entity_variant
                                                      selection_entity_variant_iterator
                                                    );vlax-safearray-get-element
                                                  );vla-get-tagstring
                 );setq

                 (if (not (assoc selection_entity_layer_name selection_entity_attributes_data))
                     (progn 
                       (setq selection_entity_attributes_data (cons (list selection_entity_layer_name
                                                                          (list selection_entity_tagstring)
                                                                    );list
                                                                    selection_entity_attributes_data
                                                              );cons
                       );setq
                     );prog

                     (progn 
                       (setq selection_entity_data            (assoc selection_entity_layer_name
                                                                     selection_entity_attributes_data
                                                              );assoc
                             selection_entity_data_attributes (cons selection_entity_tagstring
                                                                    (nth 1 selection_entity_data)
                                                              );cons
                       );setq

                       (subst (list selection_entity_layer_name
                                    selection_entity_data_attributes
                              );list
                              selection_entity_data
                              selection_entity_attributes_data
                       );subst

                     );progn
                 );if

                 (setq selection_entity_variant_iterator (1+ selection_entity_variant_iterator))
          );while
  );repeat

  (print selection_entity_attributes_data)
)
