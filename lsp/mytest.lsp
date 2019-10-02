
(defun c:xa( / object_app
               object_document
               object_model_space
               object_example
               object_example_name
               object_example_vla
               object_custom_data)

  (setq object_app (vlax-get-acad-object))
  (setq object_document (vla-get-ActiveDocument object_app))
  (setq object_model_space (vla-get-ModelSpace object_document))

  (setq object_example (entsel))
  (setq object_custom_data (list "eins" "zwei"))
  (setq object_example (append object_example object_custom_data))
  (entmod object_example)
  (print (cdr object_example))
  (princ)
  ; (setq object_example_vla (vlax-ename->vla-object object_example_name))
  ; (vlax-dump-object object_example_vla T)

 )


(defun c:xy( / object_example)

  (setq object_example (entsel))
  (setq object_example_name (car object_example))
  (setq object_example_vla (vlax-ename->vla-object object_example_name))
  (vlax-dump-object object_example_vla)

 )


(defun c:xd(/ myblock)
  (setq myblock (vlax-ename->vla-object (car (entsel))))
  (vla-get-TagString myblock)
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
