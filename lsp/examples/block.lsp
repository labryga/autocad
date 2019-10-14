(defun somefunc  (lst1 lst2 lst3 / checklst
                                   entname 
                                   i 
                                   prm 
                                   pt1 
                                   tag 
                                   testblk 
                                   val 
                                   vlaobj)

 (and (= (length lst1) (length lst2) (length lst3))
      (mapcar '(lambda (x)
                  (setq vlaobj (vlax-ename->vla-object
                                (setq entname (cdr (assoc 330 (entget (tblobjname "block" (setq testblk (cdr (assoc 2 (entget x))))))))))
                  )

                  (and (not (member entname checklst))
                       (setq checklst (cons entname checklst))
                       (z2fd x)
                       (setq i 0)
                       (while (and (< i (length lst1))
                                   (not (vl-catch-all-error-p (setq pt1 (vl-catch-all-apply 'getpoint '("\nEnter Tag Position :"))))))
                        (setq prm (nth i lst1)
                              tag (nth i lst2)
                              val (nth i lst3))
                        (vla-addattribute vlaobj 20 acattributemodelockposition prm (vlax-3d-point pt1) tag val)
                        (setq i (1+ i))
                        (command-s "._attsync" "_N" testblk))
                  )
                )

                (mapcar 'cadr (ssnamex (ssget "_x" '((0 . "INSERT"))))))
  )
 (princ)
 );defun


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

         (setq def (vla-item (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object))) blk))

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
