
(defun my_items (/ insertion
                   block_name
                   block_entity
                   werte)

  (setq insertion (car (entsel))
        block_name (cdr (assoc 8 (entget insertion)))
        block_entity  (tblobjname "block" block_name)
  )

  (setq werte
   (list
     '("44" . "444")
     '("99" . "999")
     )
   )

  (print (assoc "999" werte))
  (princ)

)
