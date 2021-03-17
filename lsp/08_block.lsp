
(defun rename_blocks (/ collection_blocks
                        block_name)
  (setq 
    collection_blocks (vla-get-blocks (vla-get-activedocument
                                        (vlax-get-acad-object))
                      )
  );setq

  (vlax-for block_item collection_blocks
            (setq block_name (vla-get-name block_item)
            );setq
            (if (wcmatch block_name "*&0*")
                (progn 
                  (setq
                    block_name (vl-string-subst "$0" "&0" block_name)
                  );setq
                  (vla-put-name block_item block_name)
                );progn
            );if
  );vlax-for

  (princ)
);defun

; scale action parameter
(defun c:vg()
  (command-s "bactiontool" "scale")
);defun


; stretch action parameter
(defun c:vf()
  (command-s "bactiontool" "stretch")
);defun


; move action parameter
(defun c:vd()
  (command-s "bactiontool" "move")
);defun


; create linear parameter
(defun c:vs()
  (command-s "bparameter" "linear")
);defun


; savall and publish
(defun c:ae()
  (command "saveall")
  (command "publish")
);defun


(defun c:toggle_bvmode (/)
  (if (= (getvar "bvmode") 0)
    (command-s "bvmode" 1)
    (command-s "bvmode" 0)
  );if
);defun

(defun c:purge_blocks (/)
  (command-s "-purge" "b" "*" "n")
);defun
