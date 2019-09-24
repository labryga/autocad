(vl-load-com)
(load "mytest")
(load "01_main")
(load "02_dimensions")
(load "03_views")
(load "04_layouts")
(load "05_modify")
(load "06_layer")
; (load "09_project_related_lisp")

(defun createLayer()
  (setq mylayers (layerGenerator 
                   (list "E41" "E42")
                   (list "a" "b")
                   (list "211.5" "211.6")
                   (list "sc" "an" "tx")
                   (list "co" "an" "050" "100")))

  (foreach x mylayers
     (command "-layer" "n" x "" "" "")
  )
 )
