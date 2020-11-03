(defun c:sva()
  (set_visual_style "w")
)

(defun c:svs()
  (set_visual_style "e")
)

(defun c:svd()
  (set_visual_style "c")
)

(defun c:svf()
  (set_visual_style "x")
)

(defun c:svr()
  (set_visual_style "r")
)

; toggle perspective status
(defun c:sve()
  (if
    (= (getvar "perspective") 0)
    (setvar "perspective" 1)
    (setvar "perspective" 0)
  )
);defun


; regen and set view to extents
(defun c:ge()
  (command "regen")
  (command "zoom" "e")
)

; zoom window
(defun c:gs()
  (command "zoom" "w")
);defun

; set ucs and plan view
(defun c:we()
  (set_snap)
  (command-s "ucs")
  (command-s "plan" "")
  (command-s "zoom" "c" "0,0" "500")
);defun

(defun c:wr()
  (command-s "ucs" "")
  (command-s "plan" "")
);defun
