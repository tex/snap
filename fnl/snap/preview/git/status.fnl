(local snap (require :snap))
(local file (require :snap.preview.common.file))
(local string (require :snap.common.string))
(local io (require :snap.common.io))
(local file-diff (require :snap.preview.git.file-diff))

(fn [request]
  (local parts (string.split (tostring request.selection) " "))
  (local status (. parts 1))
  (local filename (. parts 2))
  (if (or (= status :M) (= status :D))
    ((file-diff
       (fn [selection]
         {:path filename})) request)
    ((file
      (fn [selection]
        {:path filename
        :lnum 1
        :col 0})) request)))
