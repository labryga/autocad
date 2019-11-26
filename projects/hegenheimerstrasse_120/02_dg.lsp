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


(defun change_name (/)
  (setq my_layers (vla-get-layers
                    (vla-get-activedocument
                      (vlax-get-acad-object)))

  );setq

  (vlax-for layer my_layers
            (setq my_layer_name (vla-get-name layer))
            (if (wcmatch my_layer_name "C1*")
                (vla-put-name layer
                  (vl-string-subst "C21" "C1" my_layer_name)
                )
            );if
  );vlax-for
  (princ)
);defun
