
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

(defun c:xda( / myitem
                myitem_layer
                myitems)
  (setq myitem (entget (car (entsel))))
  (setq myitem_layer (cdr (assoc 8 myitem)))
  ; (print myitem_layer)
  ; (princ)
  (setq myitems (ssget "x" (list (cons 8 myitem_layer))
                )
  )
  (sslength myitems)
)
