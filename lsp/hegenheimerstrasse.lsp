
(defun putzflaeche(/ item_entity
                     item_entity_entget
                     item_layer
                     item_vla_object
                     counter)

  (setq item_entity (car (entsel))
        item_entity_entget (entget item_entity)
        item_layer (cdr (assoc 8 item_entity_entget))
        item_vla_object (vlax-ename->vla-object item_entity)
        counter -1
  )
)
