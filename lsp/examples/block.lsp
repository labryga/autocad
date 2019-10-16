

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



;;; Command to delete an attribute from a block
(defun c:ATTDEL (/ blkname attname bn bd en ed attlst)
  ;; Ask user for block name
  (setq blkname (getstring "\nEnter the block's name: "))
  ;; Check if block exists
  (if (setq bn (tblobjname "BLOCK" blkname))
    (progn
      ;; Get list of attributes
      (setq bd     (entget bn) ;Block def's data
            en     (cdr (assoc -2 bd)) ;1st entity insie block
            attlst nil ;Initialize list to empty
      ) ;_ end of setq
      (while en ;Step through all entities in block
        (setq ed (entget en)) ;Get entity's data
        ;; Check if entity is an attribute definition
        (if (= "ATTDEF" (cdr (assoc 0 ed)))
          ;; Add to list of attributes
          (setq attlst (cons (cons (strcase (cdr (assoc 2 ed))) (vlax-ename->vla-object en)) attlst))
        ) ;_ end of if
        (setq en (entnext en)) ;Get next entity
      ) ;_ end of while

      ;; Ask user for attribute tag name
      (setq attname (getstring "\nEnter the attribute Tag Name: "))
      ;; Check if attribute exists
      (if (setq en (assoc (strcase attname) attlst))
        (progn
          (setq ed (cdr en)) ;Get the VLA object of the attribute
          (vla-Delete ed)
          (princ
            "\nAttribute successfully deleted from block definition.\nSynchronizing block references ..."
          ) ;_ end of princ
          (command "_.ATTSYNC" "_Name" blkname)
        ) ;_ end of progn
        (princ "\nThat Attribute doesn't exist in this drawing. Exiting ...")
      ) ;_ end of if
    ) ;_ end of progn
    (princ "\nThat Block doesn't exist in this drawing. Exiting ...")
  ) ;_ end of if
  (princ)
) ;_ end of defun






