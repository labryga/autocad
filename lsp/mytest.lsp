
(defun c:xy( / object_example)

  (setq object_example (entsel))
  (setq object_example_name (car object_example))
  (setq object_example_vla (vlax-ename->vla-object object_example_name))
  (vlax-dump-object object_example_vla)

 )


(defun c:xd()
  (entget (car(entsel)))
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


(defun  c:xf( / objekte)
  (setq objekte 
        (ssget "x" '((0 . "INSERT")))
        )
  (sslength objekte)
)
