; retrive block attributes
(defun xsa(block_entity
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


(defun c:xxsa( / myblock
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

(defun c:setat(/ object_entitiy 
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

(defun c:xy( / object_example
               volume)

  (setq object_example (entsel))
  (setq object_example_name (car object_example))
  (setq object_example_vla (vlax-ename->vla-object object_example_name))
  (print (vlax-dump-object object_example_vla))
  (princ)

 )

(defun c:xe( / entity
               entities
               entities_length
               counter)

  (setq entities (ssget))

  (setq entities_length (sslength entities))
  (setq counter 0)
  (setq myfile (open "c:\\Users\\m.labryga\\Documents\\acad\\myfile.txt" "w"))

  (while (< counter entities_length)
          (setq entity (ssname entities counter))
          (setq entity (entget entity))
          (setq entity (assoc 8 entity))
          (print (cdr entity))
          (write-line (strcat (cdr entity) "\t" "wert") myfile)
          (princ)
          (setq counter (1+ counter))
         )
  (close myfile)
)

; function to retrieve block name
(defun c:xr(/ entity
              entity_name)

  (setq entity (car (entsel)))
  (setq entity_name (assoc 2 (entget entity)))
  (print (cdr entity_name))
  (princ)
)

(defun  c:ma(myblock mytag)
  (setq mytag (strcase mytag))
  (vl-some 
    '(lambda (att))
      (if (= mytag (strcase (vla-get-tagstring)))
        (vla-get-tagstring att)
      )
  )

)

(defun c:xas()
  (entget (car(entsel)))
)

(defun  c:xss( / objekte)
  (setq objekte 
        (ssget "x" '((0 . "INSERT")))
        )
  (print (sslength objekte))
  (princ)
)

; writing lists to csv file
(defun c:wtf( / mylist
                myfile
                mywert
                mywerte_length
                counter
                geschoss
                geschoss_prefix
                wohnung
                wohnung_nummer
                raum_nummer
                )

  (setq mylist (list '("wandvolumen" . 25) 
                     '("wandbreite" . 5)
                     '("wandhoehe" . 2.5)
               )
  )

  (setq myfile 
        (open "c:\\Users\\topos\\autocad\\next.csv" "w")
        ; (open ".\\next.csv" "w")
        )

  (setq counter 1)
  (setq geschoss 1)
  (setq wohnung_nummer 1)
  (setq raum_nummer 1)

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

           (while (< raum_nummer 7)
                  (write-line (strcat geschoss_prefix (itoa wohnung_nummer) ".0" (itoa raum_nummer)) myfile)
                  (setq raum_nummer (1+ raum_nummer))
           )

           (setq raum_nummer 1)
           (setq wohnung_nummer (1+ wohnung_nummer))
    )


    (setq geschoss (1+ geschoss))
    (setq wohnung_nummer 1)
  )

  (close myfile)
  (princ)
)
