(defun set_walls (/)
  (setq
    collection_lyer (vla-get-layers 
                      (vla-get-activedocument
                        (vlax-get-acad-object)))
    daten (list 
            (list "C1_Aussenwandkonstruktion_neu_214$3_Holzelementbau_35$0&cm_" (list "WO" "N" "S"))
            (list
                  (list ""           7)
                  (list "_breite"   30)
                  (list "_flaeche"   3)
                  (list "_hoehe"    40)
                  (list "_nummer"    5)
                  (list "_umfang"  220)
                  (list "_volumen" 140)
             );list
           );list

  );setq


  (princ)
);defun


(defun my_test (/)
  (setq my_blocks (vla-get-blocks
                    (vla-get-activedocument
                      (vlax-get-acad-object)))

        my_inserts  (ssget "x" '((0 . "INSERT")))
        iterator    0
  );setq

  (repeat (sslength my_inserts) 
          (setq my_insert (vlax-ename->vla-object
                            (ssname my_inserts iterator))
                iterator  (1+ iterator)
          );setq

          (print (strcat (vla-get-layer my_insert) "_nummer"))
  );repeat


  (princ)
);defun:


(defun get_blocks (/
                   insert_vla_object
                   my_insert_coordinates)

  (setq collection_blocks (vla-get-blocks
                            (vla-get-activedocument
                              (vlax-get-acad-object)))

        my_inserts        (ssget "x" '((0 . "INSERT")))
        iterator          0
  );setq

  (repeat (sslength my_inserts)
          (setq my_insert_coordinates (cons 
                                        (cdr (assoc 10 (entget (ssname my_inserts iterator))))
                                        my_insert_coordinates
                                      );cons
          );setq
          (setq iterator (1+ iterator))
  );repeat

  (foreach item my_insert_coordinates
           (setq my_insert_coordinates
                 (subst (cdr (reverse item))
                        item
                        my_insert_coordinates
                 );subst
           );setq
  );foreach

  (foreach item my_insert_coordinates
           (setq my_insert_coordinates
                 (subst (list (atoi (rtos (nth 1 item) 2))
                              (atoi (rtos (nth 0 item) 2))
                        );list
                        item
                        my_insert_coordinates
                 );subst
           );setq
  );foreach

  (print my_insert_coordinates)

  (setq my_insert_coordinates
        (vl-sort my_insert_coordinates
                 '(lambda (ieins izwei)
                    (if (= (car ieins) (car izwei))
                        (< (cadr ieins) (cadr izwei))
                        (< (car ieins) (car izwei))
                    );if
                  )
        );vl-sort
  );setq

  (print my_insert_coordinates)
  (princ)
);defun
