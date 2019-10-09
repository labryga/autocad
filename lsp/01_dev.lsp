
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
                myitems
                counter
                item
                item_vla)

  (setq myitem (entget (car (entsel))))
  (setq myitem_layer (cdr (assoc 8 myitem)))
  (setq myitems (ssget "x" (list (cons 8 myitem_layer))
                )
  )

  (setq counter 0)

  (repeat (sslength myitems)
    (setq item (cdr (assoc -1 (entget (ssname myitems counter)))))
    (setq item_vla (vlax-ename->vla-object item))
    ; (print (* 0.000001 (vla-get-volume item_vla)))
    (print (* 0.01 (vla-get-length item_vla)))
    (princ)
    (setq counter (1+ counter))
    (princ)
  )
  (princ)
)
