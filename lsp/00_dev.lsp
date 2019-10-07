
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


(defun c:xe()
  (entget (car(entsel)))
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

(defun c:xsa( / myfile)
   (setq myfile (open "c:\\Users\\m.labryga\\Documents\\acad\\myfile.txt" "w"))
  (repeat 10
    (write-line "meine zeile \t und eintraag" myfile)
   )
  (close myfile)
)

(defun  c:xss( / objekte)
  (setq objekte 
        (ssget "x" '((0 . "INSERT")))
        )
  (print (sslength objekte))
  (princ)
)
