
(defun my_loop (/ insert
                  block_name
                  block_entity
                  next_entget
                  next_vla_object
                  next_layer
                  next_type
                  next_layer_list
                  next_entity_list)

  (setq insert (car (entsel))
        block_name  (cdr (assoc 2 (entget insert)))
        block_entity  (tblobjname "block" block_name)
        items (list)
  )

  (while (setq block_entity (entnext block_entity))
         (setq next_entget (entget block_entity)
               next_layer  (cdr (assoc 8 next_entget))
               next_entity_list (cons block_entity next_entity_list)
         )
         (if (not (member next_layer next_layer_list))
             (progn
               (setq next_layer_list (cons next_layer next_layer_list))
             )
          )
  )


  (princ)
)

(defun my_test (/ f_list
                  s_list)

  (setq f_list (list (list "erste-variable" 444) 
                     (list "zweite-variable" 888)
               )
  )

  (foreach eintrag f_list
           (set (read (car eintrag)) (cadr eintrag))
  )

  (foreach eintrag f_list
           (print (eval (read (car eintrag))))
  )

  (princ)
)
