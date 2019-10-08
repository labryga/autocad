
(defun nested_block(entity)
  (if
      (setq entity (entnext entity))
      (progn
        (print (assoc 0 (entget entity)))
        (princ)
        (nested_block entity)
      )
      (print "ende..")
    )
 )

(defun c:xda( / myblock)
  (setq myblock (car (entsel)))
  (nested_block myblock)
)
