(load "examples/88_test")

(print_me)

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

  ; (print (reverse attributes_list))
  (princ)
);defun
