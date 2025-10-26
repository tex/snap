(let [snap (require :snap)]
  (fn [producer parse]
    "Scores the result set. Basic scoring based on length, the shorter the better score."
    (fn [request]
      (each [data (snap.consume producer request)]
        (match (type data)
          :table (if
                   (= (length data) 0)
                   (snap.continue)
                   (coroutine.yield
                     (vim.tbl_map #(snap.with_meta $1 :score (- 0 (length ((or parse tostring) $1)))) data)))
          :nil (coroutine.yield nil))))))
