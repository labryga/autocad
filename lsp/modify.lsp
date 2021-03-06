
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
