(defun get_active_document_object()
    (vla-get-ActiveDocument (vlax-get-acad-object))
);defun

(defun c:toggle_full_screen ()
  (if
    (= (getvar "cleanscreenstate") 0)
      (command-s "cleanscreenon")
      (command-s "cleanscreenoff")
  )
);defun

(defun c:load_project_lisp (/ file_directory_path
                              file_name_full
                              file_name_full_length
                              file_name_lisp_length
                              file_name_lisp)

  (setq file_directory_path   (getvar "dwgprefix")
        file_name_full        (getvar "dwgname")
        file_name_full_length (strlen file_name_full)
        file_name_lisp_length (- file_name_full_length 4)
        file_name_lisp        (substr file_name_full 1 file_name_lisp_length)
  );setq
  (load (strcat file_directory_path file_name_lisp))
  (princ)
);defun

(defun c:set_current_layer_to_zero ()
  (setvar "clayer" "0")
);defun

(defun c:save_and_close_file () 
  (command "ge")
  (command "qsave")
  (command "close")
);defun

(defun set_snap()
  (setvar "autosnap" 63)
  (setvar "osmode" 35)
)

(defun set_snap_off()
  (setvar "autosnap" 0)
  (setvar "osmode" 0)
)


; toggle selection cycling
(defun c:dq()
  (if
    (= (getvar "selectioncycling") -2)
       (setvar "selectioncycling"   2)
       (setvar "selectioncycling"  -2)
  )
)


; get and dump object
(defun c:get_and_dump_object( / objekt objektvl)
  (setq objekt (car(entsel)) )
  (setq objektvl (vlax-ename->vla-object objekt))
  (vlax-dump-object objektvl t)
)


; sum multiple polylines lengths
; (defun c:gr( / entities
;                entity
;                entity_index
;                object_length
;                total_length
;                area
;                total_area
;                total_values)
;
;   (setq total_length 0)
;   (setq total_area 0)
;
;   (setq entity_index 0)
;
;   (setq entities (ssget))
;
;   (repeat (sslength entities)
;
;     (setq entity (ssname entities entity_index))
;     (setq entity (vlax-ename->vla-object entity))
;
;     (setq object_length (vlax-get-property entity "length"))
;     (setq entity_index (1+ entity_index))
;     (setq total_length (+ total_length object_length))
;     (princ)
;   )
;
;   (setq total_length (* 0.01 total_length))
;   (setq total_area (* total_length 2.93))
;   (setq (rtos total_length))
;   (setq (rtos total_area))
;   (setq total_values (list 
;                        (strcat total_length " m") 
;                        (strcat total_area) " m²"
;                        ))
;   (print total_values)
;   (princ)
; )


(defun c:sum_multiple_areas ( / entities
                                entity
                                entity_index
                                object_area
                                total_area)

  (setq total_area   0
        entity_index 0
        entities     (ssget))

  (repeat (sslength entities)

    (setq entity (ssname entities entity_index))
    (setq entity (vlax-ename->vla-object entity))

    (setq object_area (vlax-get-property entity "area"))
    (setq entity_index (1+ entity_index))
    (setq total_area (+ total_area object_area))
    (princ)
  )

  (print (* 0.0001 total_area))
  (princ)
 )

; set snap on 
(defun set_snap()
  (setvar "autosnap" 63)
  (setvar "osmode"   35)
)


; set snap off 
(defun set_snap_off()
  (setvar "autosnap" 0)
  (setvar "osmode"   0)
)

(defun c:toggle_selection_cycling ()
  (if
    (= (getvar "selectioncycling") -2)
      (setvar "selectioncycling"    2)
      (setvar "selectioncycling"   -2)
  )
)

(defun c:get_and_dump_object ( / objekt objektvl)

  (setq objekt   (car(entsel)) 
        objektvl (vlax-ename->vla-object objekt))

  (vlax-dump-object objektvl t)
)

; sum multiple polylines length and area
(defun c:sum_multiple_polylines( / entities
                                   entity
                                   entity_index
                                   object_length
                                   total_length
                                   area
                                   total_area
                                   total_values)

  (setq total_length 0
        total_area   0
        entity_index 0)

  (setq entities (ssget))

  (repeat (sslength entities)

    (setq entity (ssname entities entity_index))
    (setq entity (vlax-ename->vla-object entity))

    (setq object_length (vlax-get-property entity "length"))
    (setq entity_index (1+ entity_index))
    (setq total_length (+ total_length object_length))
    (princ)
  )

  (setq total_length (* 0.01 total_length)
        total_area   (* total_length 2.93)
        total_length (rtos total_length)
        total_area   (rtos total_area))

  (setq total_values (list 
                       (strcat total_length " m") 
                       (strcat total_area " m²")
                       ))
  (print total_values)
  (princ)
)


(defun c:sum_multiple_objects_areas ( / entities
                                        entity
                                        entity_index
                                        object_area
                                        total_area)

  (setq total_area   0
        entity_index 0
        entities (ssget)
  );setq

  (repeat (sslength entities)

    (setq entity (ssname entities entity_index))
    (setq entity (vlax-ename->vla-object entity))

    (setq object_area (vlax-get-property entity "area"))
    (setq entity_index (1+ entity_index))
    (setq total_area (+ total_area object_area))
    (princ)
  )

  (print (* 0.0001 total_area))
  (princ)
)

(defun c:wipeout_from_polyline (/)
  (command-s "wipeout" "p" "n")
);defun
