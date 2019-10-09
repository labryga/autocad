
(defun nested_block(entity)
  (if
      (setq entity (entnext entity))
      (progn
        (foreach number (list 0 2 1 8)
        (print (assoc number (entget entity)))
        (princ)
        )
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

  (setq myitems (ssget "x" (list (cons 8 myitem_layer)))
        counter 0
  )

  (repeat (sslength myitems)
      (setq item (cdr (car (entget (ssname myitems counter)))))
      (nested_block item)
      (setq counter (1+ counter))
  )

  (princ)
)


(defun get_attribute(entity /
                     entity_entget)
  (if

    (and
       (setq entity (entnext entity))
       (= 
         "ATTRIB"
         (cdr (assoc 0 (setq entity_entget (entget entity))))
       )
       (= "BAUTEIL_NUMMER" (cdr (assoc 2 entity_entget)))
    )

    (progn
      (entmod (subst (cons 1 888) (assoc 1 entity_entget)) entity_entget)
      (entup entity)
      (princ)
    )
    (get_attribute entity)
  )
)

(defun c:get_att()
  (get_attribute (car (entsel)))
 )
