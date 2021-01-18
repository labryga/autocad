
; load project lisp file according to title property of the dwg file

(defun loadProjectLisp( / application
                          activeDocument
                          documentProperties
                          documentPropertyTitle)

  (setq application           (vlax-get-acad-object)
        activeDocument        (vla-get-activeDocument application)
        documentProperties    (vla-get-SummaryInfo activeDocument)
        documentPropertyTitle (vla-get-Title documentProperties))
  (load (strcat "projects\\" documentPropertyTitle ".lsp"))
)

(loadProjectLisp)
