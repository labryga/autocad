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

  (get_attribute insert_entitiy)


  ; (defun get_block_entities (block_item)
  ;   (if 
  ;     (setq block_item (entnext block_item))
  ;
  ;     (progn
  ;       (print (assoc 0 (entget block_item)))
  ;       (print (assoc 2 (entget block_item)))
  ;       (print (assoc 1 (entget block_item)))
  ;       (princ)
  ;       (get_block_entities block_item)
  ;     );progn
  ;   );if
  ; );defun

  ; (print insert_name)
  ; (princ)
  ; (get_block_entities block_name)
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
       (print (assoc 1 (entget my_insert)))
       (princ)
       (get_block_attribute my_insert)
      )
    );if
  );defun

  (get_block_attribute insert_object)
);defun

(defun create_attributes ( / vla_acad_object
                             vla_document
                             vla_model_space
                             vla_blocks
                             insert_object_entity
                             insert_object_entget
                             insert_object_name
                             vla_block
                             vla_blocks
                             block_entitiy
                             object_types
                             attribute_y_position)

  (setq vla_acad_object       (vlax-get-acad-object)
        vla_document          (vla-get-activedocument vla_acad_object)
        vla_model_space       (vla-get-modelspace vla_document)
        vla_blocks            (vla-get-blocks vla_document) 
        insert_object_entity  (car (entsel))
        insert_object_entget  (entget insert_object_entity)
        insert_object_name    (cdr (assoc 2 insert_object_entget))
        vla_block             (vla-item vla_blocks insert_object_name)
        block_entitiy         (tblobjname "block" insert_object_name)
        object_types          (list "3DSOLID" "DIMENSION" "LWPOLYLINE")
        attribute_y_position  (getvar 'textsize)
  );setq


  (defun set_block_attributes (item_entity / block_entitiy_entget
                                             block_entitiy_vla_object)
    (if
      (setq item_entity (entnext item_entity))

      (progn
        (setq block_entitiy_entget (entget item_entity)
              block_entitiy_vla_object (vlax-ename->vla-object item_entity)
        )

        (cond

          ((= "3DSOLID" (cdr (assoc 0 block_entitiy_entget)))
           (setq attribute_y_position (+ (* 1.5 (getvar 'textsize)) attribute_y_position))
           (vla-addattribute
             vla_block
             (getvar 'textsize)
             acattributemodelockposition
             ""
             (vlax-3D-point 0 attribute_y_position 0)
             "wandvolumen"
             (rtos (* 0.000001 (vla-get-volume block_entitiy_vla_object)) 2 2)
           );vla-addattribute
          );cond 3DSOLID

          ((= "LWPOLYLINE" (cdr (assoc 0 block_entitiy_entget)))
           (setq attribute_y_position (+ (* 1.5 (getvar 'textsize)) attribute_y_position))
           (vla-addattribute
             vla_block
             (getvar 'textsize)
             acattributemodelockposition
             ""
             (vlax-3D-point 0 attribute_y_position 0)
             "wandflaeche"
             (rtos (* 0.0001 (vla-get-area block_entitiy_vla_object)) 2 2)
           );vla-addattribute
          );cond LWPOLYLINE

        );cond

        (set_block_attributes item_entity)

      );progn
    );if

    (command "_.attsync" "_N" insert_object_name)
  );defun set_block_attributes 

  (set_block_attributes block_entitiy)

  ; (set_insert_attributes insert_object_entity)

);defun create_attribute

(defun set_insert_attributes ( / insert_entity
                                 insert_attribute
                                 block_name
                                 model_space)

  (setq insert_entity    (car (entsel))
        block_name       (cdr (assoc 2 (entget insert_entity)))
        insert_attribute (entnext insert_entity)
        model_space      (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object)))
  )

  (while 
    (and
      insert_attribute
      (= "ATTRIB" (cdr (assoc 0 (entget insert_attribute))))
    )
    (vla-addattribute
      model_space
      (getvar 'textsize)
      acattributemodelockposition
      ""
      (vlax-3D-point 0 0 0)
      (strcat block_name "__" (cdr (assoc 2 (entget insert_attribute))))
      (cdr (assoc 1 (entget insert_attribute)))
    )
    ; (print (assoc 2 (entget insert_attribute)))
    ; (print block_name)
    ; (princ)
    (setq insert_attribute (entnext insert_attribute))
  )  

);defun


(defun delete_attributes (/ vla_acad_object
                            vla_document
                            vla_model_space
                            insert_entitiy
                            block_name
                            block_entity
                            block_entity_entget
                            block_vla_object
                            attdef_list)

  (setq vla_acad_object          (vlax-get-acad-object)
        vla_document             (vla-get-activedocument vla_acad_object)
        vla_model_space          (vla-get-modelspace vla_document)
        insert_entitiy           (car (entsel))
        block_name               (cdr (assoc 2 (entget insert_entitiy)))
        block_entity             (tblobjname "block" block_name)
        block_vla_object         (vla-item (vla-get-blocks vla_document) block_name)
  )

  (while block_entity
    (setq block_entity_entget (entget block_entity))
    (if
      (= "ATTDEF" (cdr (assoc 0 block_entity_entget)))
      (progn
        (setq attdef_list (cons (vlax-ename->vla-object block_entity) attdef_list))
      )
    )
    (setq block_entity (entnext block_entity))
  )

  (foreach item attdef_list
           (vla-delete item)
  )
  ; (command "_.attsync" "_N" block_entity)
  (princ)

);defun delete_attributes


(defun my_string_list (string_value string_delimiter / string_position)
  (if (setq string_position (vl-string-search string_delimiter string_value))

      (cons  (substr string_value 1 string_position)
             (my_string_list (substr string_value (+ 1 string_position (strlen string_delimiter))) string_delimiter)
      )

      (list string_value)
  )
)

(defun my_test()
  (my_string_list "das,war,eins" ",")
)


(defun os_string_list ( str del / pos )
    (if (setq pos (vl-string-search del str))

        (cons 
          (substr str 1 pos) 
          (os_string_list (substr str (+ pos 1 (strlen del))) del)
        )

        (list str)
    )
)
