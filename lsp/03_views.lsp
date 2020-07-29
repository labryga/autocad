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


; regen and set view to extents
(defun c:ge()
  (command "regen")
  (command "zoom" "e")
)

; zoom window
(defun c:gs()
  (command "zoom" "w")
);defun
