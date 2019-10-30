
(defun putz( / model_space 
               item_entity
               item_entity_entget
               item_layer
               item_selection_set
               item_selection_set_length
               item_vla_object
               counter
               flaeche
               putzvolumen)

  (setq item_entity               (car (entsel))
        item_entity_entget        (entget item_entity)
        item_layer                (cdr (assoc 8 item_entity_entget))
        item_selection_set        (ssget "x" (list (cons 8 item_layer)))
        item_selection_set_length (- (sslength item_selection_set) 1)
        counter                   -1
        flaeche                   0
        putzvolumen               0
        model_space               (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object)))
  )

  (defun selection_loop(item_var func / )
    (while  (< counter item_selection_set_length)
            (setq item_entity     (ssname item_selection_set (setq counter (1+ counter)))
                  item_vla_object (vlax-ename->vla-object item_entity)
                  item_var        (+ item_var (func item_vla_object))
            )
    )

    (vla-addattribute
      model_space
      (getvar 'textsize)
      acattributemodelockposition
      ""
      (vlax-3D-point 0 0 0)
      item_layer
      (rtos item_var)
    )
   )

  (cond
    ((= "LWPOLYLINE" (cdr (assoc 0 item_entity_entget)))
     (setq flaeche (selection_loop flaeche vla-get-length))
    )

    ((= "3DSOLID" (cdr (assoc 0 item_entity_entget)))
     (setq putzvolumen (selection_loop putzvolumen vla-get-volume))
    )
  )
)
