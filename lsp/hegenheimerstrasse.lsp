
(defun my_loop (/ insert
                  block_name
                  block_entity
                  items
                  temp_list)

  (setq insert (car (entsel))
        block_name  (cdr (assoc 8 (entget insert)))
        block_entity  (tblobjname "block" block_name)
        items (list)
  )

  (while (setq block_entity (entnext block_entity))
         (if (not (assoc (cdr (assoc 8 (entget block_entity))) items))
             (progn
               (setq items 
                 (cons 
                  (cons
                    (cdr (assoc 8 (entget block_entity)))
                    (cdr (assoc 0 (entget block_entity)))
                  )
                  items
                 )
               )
             )
         )
  )

  (print items)
  (princ)
)
