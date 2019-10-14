(defun c:xfa( / block_entitiy
                block_entity_name
                block_entity_hex)

  (setq block_entitiy (car (entsel))
        block_entity_name (cdr (assoc 2 (entget block_entitiy)))
        block_entity_hex (tblobjname "block" block_entity_name)
  )

  (defun get_next_item(block_item)
    (if block_item
        (progn
          (setq block_item (entnext block_item))
          (print (assoc 2 (entget block_item)))
          (get_next_item block_item)
        )
    )
  )

  (get_next_item block_entity_hex)
  ; (print (entget block_entity_hex))
  (princ)
)

(defun c:xda( / myitem
                myitem_layer
                myitems
                counter
                item
                item_vla
                entity)

  
  (setq myitem (entget (car (entsel)))
        myitem_layer (cdr (assoc 8 myitem))
        myitems (ssget "x" (list (cons 8 myitem_layer)))
        counter 0 
  );setq



  (repeat (sslength myitems)

    (setq entity (ssname myitems counter))

    (defun get_attribute (cur_entity)
      (if
        (and
           (setq entity (entnext entity))
           (= 
             "ATTRIB"
             (cdr (assoc 0 (setq entity_entget (entget entity))))
           ; )
           ; (= "BAUTEIL_NUMMER" (cdr (assoc 2 entity_entget)))
           )
        );and

        (progn
          (print (assoc 1 entity_entget))
          (princ)
          (get_attribute cur_entity)
        );progn
      );if
    );defun

    (get_attribute entity)
    (setq counter (1+ counter))
    (princ)

  );repeat
);defun

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
      (setq entity_entget 
            (subst (cons 1 "9999") (assoc 1 entity_entget) entity_entget))
      (entmod entity_entget)
      (princ)
    )

    (get_attribute entity)
  )
)

(defun c:get_att()
  (get_attribute (car (entsel)))
 )


(defun c:get_attributes_of_insert( / insert_object_entitiy
                                     insert_object_name
                                     insert_block_name)

  (setq insert_object_entitiy (car (entsel))
        insert_object_name (cdr
                           (assoc 2 
                           (entget insert_object_entitiy)))
        insert_block_name (tblobjname "block" insert_object_name)
  );setq

  (defun get_attribute (entity)
    (if
      (and
        (setq entity (entnext entity))
        (= "ATTRIB" (cdr (assoc 0 (entget entity)))) 
      );and

      (progn
        (print (cdr (assoc 2 (entget entity))))
        (princ)
        (get_attribute entity)
      )
    );if
  );defun

  (defun get_block_entities (block_item)
    (if 
      (setq block_item (entnext block_item))

      (progn
        (print "ja...")
        (get_block_entities block_item)
      )
    );if
  );defun

  (get_block_entities insert_block_name)
  ; (get_attribute insert_object_entitiy)
  ; (print (assoc 0 (entget (entnext insert_block_name))))
  (princ)
  
);defun
