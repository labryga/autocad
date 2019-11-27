(defun set_walls (/)
  (setq
    collection_lyer (vla-get-layers 
                      (vla-get-activedocument
                        (vlax-get-acad-object)))
    daten (list 
            (list "C22_Innenwandkonstruktion_neu_214$3_Holzelementbau"
            );list (nth 0)

            (list 

                (list "_17$5&cm"
                      (list 
                          (list "_NZ" (list "-01"))
                          (list "_TH" (list "-01" "-02" "-03"))
                      );list
                );list (nth 0 (nth 1))

                (list "_10$0&cm"
                      (list 
                          (list "_WT" (list "-01"))
                          (list "_NZ" (list "-02"))
                      );list
                );list (nth 1 (nth 1))
            );list (nth 1)

            (list
                  (list ""           7)
                  (list "_breite"   30)
                  (list "_flaeche"   3)
                  (list "_hoehe"    40)
                  (list "_nummer"    5)
                  (list "_umfang"  220)
                  (list "_volumen" 140)
             );list (nth 2)
           );list
  );setq

  (foreach eintrag (nth 1 daten)
           (setq staerke (nth 0 eintrag))
           (foreach typen (nth 1 eintrag)
                    (setq typ (nth 0 typen))
                    (foreach nummer (nth 1 typen)
                             (foreach attribute (nth 2 daten)
                                       (setq my_layername
                                         (strcat (nth 0 (nth 0 daten))
                                                 staerke
                                                 typ
                                                 nummer
                                                 (nth 0 attribute)
                                         );strcat
                                       )
                                       (print my_layername)
                                       (print (nth 1 attribute))
                             );foreach
                    );foreach
           );foreach
  );foreach

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
