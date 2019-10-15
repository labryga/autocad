

(defun z2fd  (x)
 (setvar 'ctab (cdr (assoc 410 (entget x))))
 (not (command-s "._zoom" "_O" x "")))



(defun c:addattribs ( / ss
                        i
                        blk
                        blks
                        def )

  (and
     (setq ss (ssget "X" '((0 . "INSERT"))))
     (setq i (sslength ss))
     (while (> i 0)

            (setq blk (cdr (assoc 2 (entget (ssname ss (setq i (1- i)))))))
            (if (not (vl-position blk blks))
              (setq blks (cons blk blks))
            )
     )
  )

  (foreach blk blks

   (setq def (vla-item 
               (vla-get-blocks
                 (vla-get-activedocument
                   (vlax-get-acad-object))) blk)
   )

   (vla-addattribute def
       (getvar 'textsize)
       acattributemodelockposition
       "New Attribute 1"
       (vlax-3D-point 0 0)
       "NEW_TAG1"
       "New Value 1"
   )

   (vla-addattribute def
       (getvar 'textsize)
       acattributemodelockposition
       "New Attribute 2"
       (vlax-3D-point 0 (- (* 1.5 (getvar 'textsize))))
       "NEW_TAG2"
       "New Value 2"
   )

       (command "_.attsync" "_N" blk)
   )

   (princ)
)
(vl-load-com) (princ)
defun;defun
