
(defun get_block_attributes(block_entity
                            block_attribute_tag /
                            block_attribute
                            entity_next)
  (if 
    (and 
      (setq block_entity (entnext block_entity))
      (= "ATTRIB" 
         (cdr 
          (assoc 0 (
            setq entity_next 
              (entget block_entity))
          )
        )
      )
    )

    (if (= (strcase block_attribute_tag)
           (strcase (cdr (assoc 2 entity_next)))
        )
        (progn
          (cdr (assoc 1 entity_next))
        )
        (xsa block_entity block_attribute_tag)
    )      
  )
)

(defun c:project_example_one( / myblock
                                attribute
                                mylist
                                myfile
                                mywert)

  (setq myblock (car(entsel)))
  (setq attribute (list "wandhoehe" 
                        "wandbreite"
                        "wandvolumen"
                        "wandflaeche"
                        "oeffnung_hoehe"
                        "oeffnung_breite"))

  (foreach item attribute
    (setq mylist (append (list (list item (xsa myblock item))) mylist))
  )

  (setq myfile 
        (open "c:\\Users\\topos\\autocad\\wohnung.csv" "w"))

  (foreach item mylist
           (setq mywert (strcat 
                          (car item) 
                          "\t"
                          (cadr item)
                        )
           )

           (write-line mywert myfile)
  )
)

(defun c:set_attribute(/ object_entitiy 
                         object_vla_entity
                         att_name
                         att_value
                         att_point) 

  (setq att_name "volume")
  (setq object_entitiy (car (entsel)))
  (setq object_vla_entity (vlax-ename->vla-object object_entitiy))
  (setq att_value (vla-get-volume object_vla_entity))
  (setq att_value (* 0.000001 att_value))
  (setq att_value (rtos att_value 2 2))
  (command "-ATTDEF" "" att_name "" att_value (getpoint) "")
  (princ)
 )

(defun c:dump_vla_object( / object_example)

  (setq object_example      (entsel)
        object_example_name (car object_example)
        object_example_vla  (vlax-ename->vla-object object_example_name))

  (print (vlax-dump-object object_example_vla))
  (princ)
)

(defun c:write_layer_names_to_csv( / entity
                                     entities
                                     entities_length
                                     counter)

  (setq entities        (ssget)
        entities_length (sslength entities)
        counter 0
        myfile (open "c:\\Users\\m.labryga\\Documents\\acad\\myfile.txt" "w"))

  (while (< counter entities_length)
          (setq entity (ssname entities counter)
                entity (entget entity)
                entity (assoc 8 entity))
          (print (cdr entity))
          (write-line (strcat (cdr entity) "\t" "wert") myfile)
          (princ)
          (setq counter (1+ counter))
         )
  (close myfile)
)

(defun c:get_block_name (/ entity
                          entity_name)

  (setq entity (car (entsel)))
  (setq entity_name (assoc 2 (entget entity)))
  (print (cdr entity_name))
  (princ)
)

; (defun c:get_tag_string(myblock mytag)
;   (setq mytag (strcase mytag))
;   (vl-some 
;     '(lambda (att))
;       (if (= mytag (strcase (vla-get-tagstring)))
;         (vla-get-tagstring att)
;       )
;   )
;
; )

(defun c:get_entget()
  (entget (car(entsel)))
)

(defun c:count_inserted_blocks ( / objekte)
  (setq objekte 
        (ssget "x" '((0 . "INSERT")))
        )
  (print (sslength objekte))
  (princ)
)

(defun c:write_list_to_csv ( / mylist
                               myfile
                               mywert
                               mywerte_length
                               counter
                               geschoss
                               geschoss_prefix
                               wohnung
                               wohnung_nummer
                               raum_nummer
                               wohnung_1_2
                               raum_06
                               wohnung_1_1)

  (setq wohnung_1_2 (list
                        (list "Korridor" "01")
                        (list "Bad" "02")
                        (list "Kueche" "03")
                        (list "Wohnen" "04")
                        (list "Zimmer" "05")
                      )
       raum_06        (list (list "Zimmer" "06"))
       wohnung_1_1  (append wohnung_1_2 raum_06)
  )


  (setq myfile 
        (open "c:\\Users\\m.labryga\\Documents\\acad\\next.csv" "w")
        ; (open "c:\\Users\\topos\\autocad\\next.csv" "w") 
        ; (open ".\\next.csv" "w")
        )

  (setq counter 1
        geschoss 1
        wohnung_nummer 1
        raum_nummer 1)

  (while (< geschoss 15)

    (cond
       ((= (strlen (itoa geschoss)) 1)
        (setq geschoss_prefix (strcat "0" (itoa geschoss)))
        )

       ((= (strlen (itoa geschoss)) 2)
        (setq geschoss_prefix (itoa geschoss))
       )
    )

    (while (< wohnung_nummer 5)

           (cond ((or (= wohnung_nummer 1) (= wohnung_nummer 2))
                  (foreach raum wohnung_1_1
                          (write-line (strcat geschoss_prefix
                                              (itoa wohnung_nummer) "."
                                              (cadr raum) "\t"
                                              (car raum)
                                      ) myfile)
                          (setq raum_nummer (1+ raum_nummer))
                  )
                 ); Bedingung Wohnung Typ 1

                 ((or (= wohnung_nummer 3) (= wohnung_nummer 4))
                  (foreach raum wohnung_1_2
                          (write-line (strcat geschoss_prefix
                                              (itoa wohnung_nummer) "."
                                              (cadr raum) "\t"
                                              (car raum)
                                      ) myfile)
                          (setq raum_nummer (1+ raum_nummer))
                  )
                 ); Bedingung Wohnung Typ 2
           )

           (setq raum_nummer 1)
           (setq wohnung_nummer (1+ wohnung_nummer))
    );while


    (setq wohnung_nummer 1)
    (setq geschoss (1+ geschoss))
  )

  (close myfile)
  (princ)
)

(defun mytest( / raum_entget 
                 raum_insert_name
                 raum_selection
                 wohnung_nummer
                 ssget_counter
                 raum_item)

  (setq raum_entget (entget (car (entsel))) 
        raum_insert_name (cdr (assoc 2 raum_entget))
        raum_selection (ssget "x" (list (cons 2 raum_insert_name)))
        wohnung_nummer 0
        ssget_counter -1
  )

  (while (< (setq wohnung_nummer (1+ wohnung_nummer)) 5)

         (while (setq raum_item (ssname raum_selection (setq ssget_counter (1+ ssget_counter))))

                (while 
                  (and
                    (setq raum_item (entnext raum_item))
                    (= "ATTRIB" (cdr (assoc 0 (entget raum_item))))
                  )

                  (if
                    (and
                     (= "WOHNUNG_NUMMER" (cdr (assoc 2 (entget raum_item))))
                     (= (itoa wohnung_nummer) (cdr (assoc 1 (entget raum_item))))
                    )
                    (progn
                      (print (assoc 2 (entget raum_item)))
                      (print (assoc 1 (entget raum_item)))
                      (princ)
                    )
                  )

                )
         )
         (setq ssget_counter -1)
  )

)

(defun get_solid_volume (/ solid_entity
                           solid_vla_object
                           solid_volume) 

  (setq solid_entity      (car (entsel))
        solid_vla_object  (vlax-ename->vla-object solid_entity)
        solid_volume      (vla-get-volume solid_vla_object)
  )
  
  (print (* 0.000001 solid_volume))
  (princ)
)

(defun get_surface_area(/ entity
                          entity_entget
                          entity_vla_object)

  (setq entity (car (entsel))
        entity_entget (entget entity)
        entity_vla_object (vlax-ename->vla-object entity)
  )

  (print (vla-get-area entity_vla_object))
  (princ)
)

(defun get_sum_of_volumes (/ soild_layer
                             solid_selection_set
                             solid_selection_set_length
                             counter
                             solid_entity
                             solid_vla_object
                             volumen_summe)

  (setq solid_layer                (cdr (assoc 8 (entget (car (entsel)))))
        solid_selection_set        (ssget "x" (list (cons 8 solid_layer)))
        solid_selection_set_length (- (sslength solid_selection_set) 1)
        counter -1
        volumen_summe 0
  )

  (while (< counter solid_selection_set_length)
         (setq solid_entity     (ssname solid_selection_set (setq counter (1+ counter)))
               solid_vla_object (vlax-ename->vla-object solid_entity)
               volumen_summe    (+ volumen_summe (* 0.000001 (vla-get-volume solid_vla_object)))
         )
  )

  (print volumen_summe)
  (princ)
)

(defun print_block_entity_layers(/ insert
                                   insert_entget
                                   insert_name
                                   block_entitiy)

  (setq insert        (car (entsel))
        insert_entget (entget insert)
        insert_name   (cdr (assoc 2 insert_entget))
        block_entitiy (tblobjname "block" insert_name)
  )

  (print insert_name)
  (princ)

  (while (setq block_entitiy (entnext block_entitiy))
         (print (assoc 8 (entget block_entitiy)))
         (princ)
  )

)

(defun x_test ( /
                x_selection_set
                x_block_entities_list
              )

  (setq x_selection_set (ssget "x" '((0 . "INSERT")))
        x_block_entities_list (get_list_of_insert_block_entities x_selection_set)
  );setq

  (get_list_of_next_block_entities_layers x_block_entities_list)

);defun

(defun y_test ( / )
);defun
