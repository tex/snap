(local snap (require :snap))
(local file (require :snap.preview.common.file))
(local parse (require :snap.common.vimgrep.parse))

(file
  (fn [selection]
    (local {: filename : lnum : col} (parse (tostring selection)))
    {:path (snap.topath filename)
     : lnum
     : col}))
