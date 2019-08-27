
(defun getLayerE41(layer / E41)

  (setq E41 (list
              "E41-a-211.5-sc-co"
              "E41-a-211.5-sc-sh"
              "E41-b-211.5-sc-co"
              "E41-b-211.5-sc-sh"
              "E41-n-211.5-sc-co"
              "E41-n-211.5-sc-sh"
              "E41-a-211.6-sc-co"
              "E41-a-211.6-sc-sh"
              "E41-b-211.6-sc-co"
              "E41-b-211.6-sc-sh"
              "E41-n-211.6-sc-co"
              "E41-n-211.6-sc-sh"))
  (nth layer E41)
)

; (defun set_current_layer()
;   (command "")
; )

(defun qdf()
  (command)
  (command "-layer" "s" (E41 ))
)
