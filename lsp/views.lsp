
(defun set_visual_style(style)
  (command "-visualstyles" "c" style "" "")
)

(defun c:sva()
  (set_visual_style "w")
)

(defun c:svs()
  (set_visual_style "e")
)

(defun c:svd()
  (set_visual_style "s")
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


(defun set_view (view_name)
  (command "-view" "r" view_name)
);defun

(defun c:vsf()
  (set_view "f")
);defun

(defun c:vsg()
  (set_view "g")
);defun


(defun set_perspective (mode)
  (command "perspective" mode)
  (princ)
);defun

(defun c:vsq()
  (set_perspective "1")
);defun

(defun c:vsw()
  (set_perspective "0")
);defun
