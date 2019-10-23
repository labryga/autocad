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
tt
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
                (while (and
                         (setq raum_item (entnext raum_item))
                         (= "ATTRIB" (cdr (assoc 0 (entget raum_item))))
                         ; (= "WOHNUNG_NUMMER" (cdr (assoc 2 (entget raum_item))))
                       )
                       (print (cdr (assoc 2 (entget raum_item))))
                       (print (cdr (assoc 1 (entget raum_item))))
                       (print "ja...")
                       (princ)
                )
                (princ)
         )

  )

  (print (sslength raum_selection))
  (princ)
)
