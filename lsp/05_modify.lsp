
; move object without snapping
(defun c:sf()
  (set_snap_off)
  (command "move")
)

; move object with snapping on
(defun c:s()
  (set_snap)
  (command "move")
)

; move object with snapping on 
; base point middle between two points
(defun c:sa()
  (set_snap)
  (setq item (ssget))
  (command "move" item "" "_m2p")
)

; select all elements and scale with factor 100
(defun c:sah()
  (setq selectionall (ssget "_A"))
  (command "scale" selectionall "" '(0 0 0) 100)
  (command "ge" "")
)

; select all elements in model space and copy with basepoint set to 0,0,0
(defun c:sac()
  (command "copybase" '(0 0 0) (ssget "_A") "")
)

; function to toggle autosnap and osmode by "df" command
(defun c:df() 
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


(defun c:ef(/  block_object_entity
               block_object_name)

  (setq block_object_entity (entget (car (entsel)))
        block_object_name   (cdr (assoc 2 block_object_entity))
  );setq
  (command "-bedit" block_object_name)
);defun


; lock vieport 
(defun c:rf()
  (command "mview" "lock" "on")
);defun


; unlock vieport 
(defun c:rg()
  (command "mview" "lock" "off")
);defun
