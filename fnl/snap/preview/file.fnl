(local snap (require :snap))
(local file (require :snap.preview.common.file))

(file
  (fn [selection]
    {:path (snap.topath selection)
     :lnum nil
     :col nil}))
