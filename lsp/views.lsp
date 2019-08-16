; set visual styles via alias


(defun set_visual_style(style)
  (command "-visualstyles" "c" style "" "")
)

(defun c:sva()
  (set_visual_style "w")
)

(defun c:svs()
  (set_visual_style "s")
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
