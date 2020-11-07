
(defun get_attribute_values (/ attributes_array
                               iterator
                               attribute_object
                               attributes_list)

  (setq attributes_array  (vlax-variant-value 
                              (vla-getattributes 
                                (vlax-ename->vla-object 
                                  (car (entsel))
                                );vlax-ename->vla-object
                              );vla-get-attributes
                            );vlax-variant-value
        iterator            0
  );setq


  (while (>= (vlax-safearray-get-u-bound attributes_array 1) iterator)

         (setq
           attribute_object (vlax-safearray-get-element attributes_array iterator)
           iterator         (1+ iterator)
         );setq

         (if (not (= "NUMMER" (vla-get-tagstring attribute_object)))
             (setq 
               attributes_list  (cons (list (vla-get-tagstring  attribute_object)
                                            (vla-get-textstring attribute_object)
                                      );list
                                      attributes_list
                                );cons
               iterator         (1+ iterator)
             );setq

         );if


  );while

  (print (reverse attributes_list))
  (princ)
);defun

(defun c:dtt(/ objekt_entity objekt_vla)
  (setq entity_object (car (entsel))
        objekt_vla     (vlax-ename->vla-object entity_object)
  );setq
  (print (vla-get-length objekt_vla))
  (princ)
);defun


(defun c:gtt(/ objekt_entities
               objekt_entity
               objekt_vla
               objekt_safearray
               iterator)

  (setq objekt_entities (ssget)
        iterator        0
  );setq

  (repeat (sslength objekt_entities)
          (setq objekt_entity (ssname objekt_entities iterator)
                objekt_vla    (vlax-ename->vla-object objekt_entity)
                objekt_insertposition (vlax-variant-value
                                        (vla-get-insertionpoint objekt_vla))
                iterator      (1+ iterator)
          );setq
          (print (vlax-safearray-get-element objekt_insertposition 0))
          (princ)
  );repeat

);defun

(defun c:gtt( / entity)
  (setq entity (entget (car (entsel)))
  );setq
  (type (cdr (assoc 2 entity)))
);defun
