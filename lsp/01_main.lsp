
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


; toggle selection cycling
(defun c:dq()
  (if
    (= (getvar "selectioncycling") -2)
      (setvar "selectioncycling" 2)
      (setvar "selectioncycling" -2)
  )
)

; get and dump object
(defun c:dt( / objekt objektvl)
  (setq objekt (car(entsel)) )
  (setq objektvl (vlax-ename->vla-object objekt))
  (vlax-dump-object objektvl t)
)


; sum multiple polylines lengths
(defun c:gl( / entities
               entity
               entity_index
               line_length
               total_length)

  (setq total_length 0)

  (setq entity_index 0)

  (setq entities (ssget))

  (repeat (sslength entities)

    (setq entity (ssname entities entity_index))
    (setq entity (vlax-ename->vla-object entity))

    (setq line_length (vlax-get-property entity "length"))
    (setq entity_index (1+ entity_index))
    (setq total_length (+ total_length line_length))
    (princ)
  )

  (print total_length)
  (princ)
 )
