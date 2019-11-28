
; create project specific layers
(defun create_project_layers (/)

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


; add "NUMMER" attribute to each corresponding element
(defun add_number_attribute ( /
                              activedocument
                              collection_blocks
                              collection_layers
                              insert_selection
                              block_names
                              black_name
                              new_layer)

  (setq activedocument      (vla-get-activedocument (vlax-get-acad-object))
        collection_layers   (vla-get-layers activedocument)
        collection_blocks   (vla-get-blocks activedocument)
        insert_selection    (ssget "x" '((0 . "INSERT")))
        selection_iterator  0
  );setq

  (repeat (sslength insert_selection)

          (setq block_name  (cdr (assoc 2
                                 (entget (ssname insert_selection selection_iterator))))
          );setq

          (if (not (member block_name block_names))
              (setq block_names (cons block_name
                                      block_names
                                );cons
              );setq
          );if

          (setq selection_iterator (1+ selection_iterator))
  );repeat

  ; create corresponding number attribute layers of each block by extending the block name
  (foreach block_name block_names
           (setq new_layer (vla-add
                             collection_layers
                             (strcat block_name "_nummer")
                           );vla-add
           );setq
           (vla-put-color new_layer 5)
           (vla-put-activelayer activedocument new_layer)

           (vla-addattribute (vla-item collection_blocks block_name)
                             (getvar "textsize")
                             acAttributeModeLockPosition
                             ""
                             (vlax-3d-point 0 0 0)
                             "NUMMER"
                             "00"
           );vla-addattribute
  );foreach
  (princ)
);defun


; set "NUMMER" attributes by iteration over corresponding element type
(defun set_number_attributes ( /
                               insert_selection
                               insert_entitiy
                               block_name
                               block_list

                               collection_blocks
                               insert_list
                               insert_attributes
                               number_attribute
                             )

  (setq insert_selection    (ssget "x" '((0 . "INSERT")))
        selection_iterator  0
        activedocument      (vla-get-activedocument (vlax-get-acad-object))
        collection_blocks   (vla-get-blocks activedocument)
  );setq

  (repeat (sslength insert_selection)
          (setq insert_entitiy      (ssname insert_selection selection_iterator)
                block_name          (cdr (assoc 2 (entget insert_entitiy)))
                selection_iterator  (1+ selection_iterator)
          );setq
          
          (if (not (member block_name block_list))
              (setq block_list (cons block_name
                                     block_list
                               );cons
              );setq
          );if
  );repeat

  (foreach block_name block_list
           (setq insert_list        (get_insert_list block_name)
                 attribute_iterator 0
           )
           (foreach instance insert_list
                    (setq insert_attributes   (vlax-variant-value
                                                (vla-getattributes (car instance)))
                          number_attribute    (vlax-safearray-get-element insert_attributes 0)
                          attribute_iterator  (1+ attribute_iterator)
                    );setq
                    (vla-put-textstring number_attribute (itoa attribute_iterator))
                    (print (vla-get-tagstring number_attribute))
                    (print (vla-get-textstring number_attribute))
           );foreach
  );foreach

  (princ)
);defun


; get insert list of each block instance
(defun get_insert_list (block_name /
                        insert_selection
                        insert_entitiy
                        selection_iterator
                        insert_list)

           (setq insert_selection   (ssget "x" (list (cons 2 block_name) (cons 0 "INSERT")))
                 selection_iterator 0
                 insert_list        (list)
           );setq

           (repeat (sslength insert_selection)
                   (setq insert_entitiy     (ssname insert_selection selection_iterator)
                         selection_iterator (1+ selection_iterator)
                         insert_list        (cons (list (vlax-ename->vla-object insert_entitiy)
                                                        (cdr (assoc 10 (entget insert_entitiy)))
                                                  );list
                                                  insert_list
                                            );cons
                   );setq

                   (setq insert_list
                     (vl-sort insert_list
                              '(lambda (i1 i2)

                                 (if (= (car (last i1)) (car (last i2)))

                                     (< (cadr (last i1))
                                        (cadr (last i2))
                                     )

                                     (< (car (last i1))
                                        (car (last i2))
                                     )
                                 );if

                               )
                     )
                   )

           );repeat

           insert_list
           ; (princ)
);defun
