
(defun getLayerE41(layer / E41)

  (setq E41 (list
              (list 00 "A-E41-a-211.5-sc-co")
              (list 01 "A-E41-a-211.5-sc-sh")
              (list 02 "A-E41-a-211.5-an-co")
              (list 03 "A-E41-a-211.5-an-sh")
              (list 04 "A-E41-b-211.5-sc-co")
              (list 05 "A-E41-b-211.5-sc-sh")
              (list 06 "A-E41-b-211.5-sc-co")
              (list 07 "A-E41-b-211.5-sc-sh")
              (list 08 "A-E41-n-211.5-sc-co")
              (list 09 "A-E41-n-211.5-sc-sh")
              (list 10 "A-E41-n-211.6-sc-co")
              (list 11 "A-E41-n-211.6-sc-sh")
              ))
  (cadr (nth layer E41))
)


