
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

