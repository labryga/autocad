(setq ebkp
      (list
        (list "flaeche" vla-get-area)
        (list "umfang"  Vla-get-length)
        (list "volumen" vla-get-volume)
      )
)

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
                    (cdr (assoc 8 (entget block_entity)))
                    (cdr (assoc 0 (entget block_entity)))
                  )
                  block_inner_item_types
                 )
               )
             )
         )
  )

  (foreach item block_inner_item_types
           (foreach typus item
                    (if (member typus (list "3DSOLID" "LWPOLYLINE"))
                        (print typus)
                    )
           )
  )

  (princ)
)

(defun my_ebkp ()
  (foreach item ebkp
     (print (last item))
  )
  (princ)
)
