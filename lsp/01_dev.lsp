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

(defun set_attribute(entity /
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

    (set_attribute entity)
  )
)

(defun c:get_att()
  (set_attribute (car (entsel)))
 )

(defun c:get_attributes_of_insert( / insert_entitiy
                                     insert_name
                                     block_name)

  (setq insert_entitiy (car (entsel))
        insert_name (cdr
                           (assoc 2 
                           (entget insert_entitiy)))
        block_name (tblobjname "block" insert_name)
  );setq

  (defun get_attribute (entity)
    (if
      (and
        (setq entity (entnext entity))
        (= "ATTRIB" (cdr (assoc 0 (entget entity)))) 
      );and

      (progn
        (print (cdr (assoc 2 (entget entity))))
        (print (cdr (assoc 1 (entget entity))))
        (princ)
        (get_attribute entity)
      )
    );if
  );defun

  (defun get_block_entities (block_item)
    (if 
      (setq block_item (entnext block_item))

      (progn
        (print (assoc 0 (entget block_item)))
        (print (assoc 2 (entget block_item)))
        (print (assoc 1 (entget block_item)))
        (princ)
        (get_block_entities block_item)
      );progn
    );if
  );defun

  (print insert_name)
  (princ)
  (get_block_entities block_name)
  ; (get_attribute insert_entitiy)
  ; (print (assoc 0 (entget (entnext block_name))))
  (princ)
  
);defun

(defun my_length( / item
                    item_vla)

  (setq item (car (entsel))
        item_vla (vlax-ename->vla-object item)
  )

  (print (* 0.0001 (vla-get-area item_vla)))
  (print (* 0.01 (vla-get-length item_vla)))
  (princ)

);defun

(defun set_attributes(/ items
                        items_length
                        counter)

  (setq items (ssget "x")
        items_length (sslength items)
        counter 0
  );setq

  (while (counter > items_length)

  );while

  (command "-ATTDEF" "" att_name "" att_value (getpoint) "")
);defun

(defun get_block_attributes ( / insert_object)
  (setq insert_object (car (entsel)))

  (defun get_block_attribute (my_insert)
    (if
      (and
        (setq my_insert (entnext my_insert))
        ; (= "ATTRIB" (cdr afone_lastschrift_28_06_2019ssoc 0 (entget my_insert))))
      )

      (progn
       (print (assoc 2 (entget my_insert)))
       (princ)
       (get_block_attribute my_insert)
      )
    );if
  );defun

  (get_block_attribute insert_object)
);defun

(defun create_attribute (/ vla_acad_object
                           vla_document
                           vla_blocks
                           insert_object_entity
                           insert_object_entget
                           insert_object_name
                           vla_block
                           block_entitiy
                           object_types)

  (setq vla_acad_object (vlax-get-acad-object)
        vla_document (vla-get-activedocument vla_acad_object)
        vla_blocks (vla-get-blocks vla_document) 
        insert_object_entity (car (entsel))
        insert_object_entget (entget insert_object_entity)
        insert_object_name (cdr (assoc 2 insert_object_entget))
        vla_block (vla-item vla_blocks insert_object_name)
        block_entitiy (tblobjname "block" insert_object_name)
        object_types (list "3DSOLID" "DIMENSION" "LWPOLYLINE")
  );setq

  ; (vla-addattribute
  ;   vla_block
  ;   (getvar 'textsize)
  ;   acattributemodelockposition
  ;   "wert_01"
  ;   (vlax-3D-point 0
  ;                  (* 1.5 (getvar 'textsize))
  ;                  0)
  ;   "wert_01"
  ;   "der wert 01"
  ; )

  (defun get_block_items (block_entitiy / block_entitiy_entget
                                          block_entitiy_vla_object)
    (if
      (setq block_entitiy (entnext block_entitiy))

      (progn
        (setq block_entitiy_entget (entget block_entitiy)
              block_entitiy_vla_object (vlax-ename->vla-object block_entitiy)
        )

        (cond
          ((= "3DSOLID" (cdr (assoc 0 block_entitiy_entget)))
           (print (vla-get-volume block_entitiy_vla_object))
           (princ)
          )
          ((= "LWPOLYLINE" (cdr (assoc 0 block_entitiy_entget)))
           (print (vla-get-length block_entitiy_vla_object))
           (princ)
          )
        );cond

        (get_block_items block_entitiy)
      )
    );if

  );defun

  (get_block_items block_entitiy)
  (princ)

);defun
