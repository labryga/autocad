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

(defun c:dq()
	(if
	  (= (getvar "selectioncycling") -2)
		(setvar "selectioncycling" 2)
		(setvar "selectioncycling" -2)
	)
)
