
(defun my_loop (/ insert
                  block_name
                  block_entity
                  block_inner_item_types
                  temp_list)

  (setq insert (car (entsel))
        block_name  (cdr (assoc 8 (entget insert)))
        block_entity  (tblobjname "block" block_name)
  )

  (while (setq block_entity (entnext block_entity))
         (if (not (assoc (cdr (assoc 8 (entget block_entity))) block_inner_item_types))
             (progn
               (setq block_inner_item_types 
                 (cons 
                  (list
                    (foreach x (list 0 8)
                             (cdr (assoc 8 (entget block_entity)))
                    )
                  )
                  block_inner_item_types
                 )
               )
             )
         )
  )

  (foreach item block_inner_item_types
           (foreach typus item (print typus))
  )

  (princ)
)
