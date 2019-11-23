

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


