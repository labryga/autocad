; set current layouts
;get current layouts
(defun get_current_layouts(my_document)
    (vla-get-Layouts my_document)
);defun

; set first layout
(defun set_my_layout(my_layout /
                     my_document
                     my_document)
  (setq my_document (get_active_document_object)
        my_layouts  (get_current_layouts my_document)
  );setq

  (vla-put-activelayout my_document (vla-item my_layouts my_layout))
);defun

; (defun c:afd()
;   (command-s "tilemode" 1)
; );defun
;
; (defun c:ac()
;   (set_my_layout 0)
; );defun
;
; (defun c:av()
;   (set_my_layout 1)
; );defun
;
; (defun c:fc()
;   (set_my_layout 2)
; );defun
;
; (defun c:fv()
;   (set_my_layout 3)
; );defun

(defun set_visual_style (visual_style /)
  (command-s "-visualstyles" "c" visual_style)
);defun

; set current visual style to wireframe
(defun c:svw()
  (set_visual_style "w")
)

; set current visual style to realistic
(defun c:svr()
  (set_visual_style "r")
)

; set current visual style to shaded
(defun c:svs()
  (set_visual_style "s")
)

; set current visual style to x-ray
(defun c:svx()
  (set_visual_style "x")
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
  (command-s "ucs" "na" "r" "main")
  (command-s "plan" "")
);defun

(defun c:toggle_osnapz()

);defun
