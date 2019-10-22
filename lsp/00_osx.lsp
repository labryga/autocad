
(defun test( / my_item
               my_item_name
               my_selection)

  (setq my_item (car (entsel))
        my_item_name (cdr (assoc 2 (entget my_item)))
        my_selection (ssget "x" (list (cons 2 my_item_name)))
  )
  (print (sslength my_selection))
  (princ)
)
