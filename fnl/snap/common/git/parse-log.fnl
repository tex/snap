(let [snap (require :snap)]
  (fn [entry]
    (local (end) (entry:find " "))
    (snap.with_metas
      ;; TODO: Required because fzy errors when each line is too long
      (entry:sub 1 200)
      { :hash (entry:sub 1 (- end 1))
      :comment (entry:sub (+ end 1) -1)} )))
