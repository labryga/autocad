(defun LM:vl-getattributevalue ( blk tag )

  (setq tag (strcase tag))

  (vl-some 
    '(lambda ( att ) 

      (if (= tag (strcase (vla-get-tagstring att))) 
        (vla-get-textstring att))
     ) 

     (vlax-invoke blk 'getattributes)
  )
)
