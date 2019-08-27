
; function to determine current document filepath and load project lsp from subfolder
(defun loadProjectLisp( / application currentDocument documentPath lispFilePath)
  (setq application (vlax-get-acad-object))
  (setq currentDocument (vla-get-ActiveDocument application))
  (setq documentPath (vla-get-Path currentDocument))
  (setq lispFilePath (strcat documentPath "\\etc\\lsp\\project.lsp"))
  (load lispFilePath)
)
