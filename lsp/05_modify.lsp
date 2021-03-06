
(defun c:toggle_autosnap () 
  (if 
    (and 
     (= (getvar "autosnap") 63)
     (= (getvar "osmode") 35)) 

    (progn
      (setvar "autosnap" 0) 
      (setvar "osmode" 0)
      )

    (progn
      (setvar "autosnap" 63) 
      (setvar "osmode" 35)
      )
  )
)

; set snap on 
(defun set_snap()
  (setvar "autosnap" 63)
  (setvar "osmode" 35)
)


; set snap off 
(defun set_snap_off()
  (setvar "autosnap" 0)
  (setvar "osmode" 0)
)


(defun c:toggle_autosnap () 
  (if 
    (and 
     (= (getvar "autosnap") 63)
     (= (getvar "osmode")   35)) 

    (progn
      (setvar "autosnap" 0) 
      (setvar "osmode"   0)
      )

    (progn
      (setvar "autosnap" 63) 
      (setvar "osmode"   35)
      )
  )
);defun


; toggle selection cycling
(defun c:dq()
  (if
    (= (getvar "selectioncycling") -2)
      (setvar "selectioncycling" 2)
      (setvar "selectioncycling" -2)
  )
)


(defun c:rw()
  (command "solidedit" "f" "m")
);defun


; move face of solid
(defun c:eyf()
  (command-s "solidedit" "f" "m")
);defun


(defun c:r()
  (command-s "dynmode" "3")
  (command-s "repositionfrom")
  (command-s "dynmode" "0")
);defun


; move object without snapping off
(defun c:sf()
  (set_snap_off)
  (command-s "move")
)


; move object with snapping on
(defun c:ss()
  (set_snap)
  (command-s "move")
)


; move object with snapping on; base point middle between two points
(defun c:sa()
  (set_snap)
  (setq item (ssget))
  (command-s "move" item "" "_m2p")
)


; rotate object with snapping on 
; base point middle between two points
(defun c:ga()
  ; (set_snap)
  (setq item (ssget))
  (command-s "rotate" item "" "_m2p")
)


; select all elements and scale with factor 100
(defun c:sah()
  (setq selectionall (ssget "_A"))
  (command-s "scale" selectionall "" '(0 0 0) 100)
  (command-s "ge" "")
)


; select all elements in model space and copy with basepoint set to 0,0,0
(defun c:sac()
  (command-s "copybase" '(0 0 0) (ssget "_A") "")
)


(defun c:ef(/  block_object_entity
               block_object_name)

  (setq block_object_entity (entget (car (entsel)))
        block_object_name   (cdr (assoc 2 block_object_entity))
  );setq
  (command-s "-bedit" block_object_name)
);defun

; lock vieport 
(defun c:rf()
  (command-s "selectioncycling" 2)
  (command-s "mview" "lock" "on")
  (command-s "selectioncycling" -2)
  (princ)
);defun


; unlock vieport 
(defun c:rg()
  (command-s "selectioncycling" 2)
  (command-s "mview" "lock" "off")
  (command-s "selectioncycling" -2)
);defun

(defun c:XrefBind (/ tmpObj)
  (vlax-for objs (vla-get-ModelSpace
		   (vla-get-activedocument (vlax-get-acad-object))
		 )
    (if
      (and
	(= (vla-get-ObjectName objs) "AcDbBlockReference")
	(vlax-property-available-p objs 'Path)
	(setq
	  tmpObj (vla-Item
		   (vla-get-Blocks
		     (vla-get-ActiveDocument (vlax-get-Acad-Object))
		   )
		   (vla-get-Name objs)
		 )
	)
	(not (assoc 71 (entget (tblobjname "block" (vla-get-Name objs)))))
      )
       (vla-Bind tmpObj :vlax-true)
    )
  )

  (princ)
)

(defun c:purge_all (/)
  (command-s "-purge" "a" "*" "n")
);defun
