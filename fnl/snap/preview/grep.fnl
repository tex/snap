(local snap (require :snap))
(local file (require :snap.preview.common.file))
(local parse (require :snap.common.grep.parse))

(file
  (fn [selection]
    (local {: filename : lnum} (parse (tostring selection)))
    {:path (snap.topath filename)
     : lnum
     :col 0}))
