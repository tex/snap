(let [snap (require :snap)
      fzy (require :fzy)]
  (fn [producer filter-mod]
    "All"
    (fn filter [filter results]
      (if
        (= filter "")
        results
        (let [processed []]
          (each [_ [index positions score] (ipairs (fzy.filter filter (vim.tbl_map #(tostring $1) results)))]
            (table.insert processed (snap.with_metas (. results index) {: positions : score})))
          processed)))

    (fn [request]
      (each [results (snap.consume producer request)]
        (match (type results)
          "table" (coroutine.yield (filter (if filter-mod (filter-mod request.filter) request.filter) results))
          "nil" (coroutine.yield nil))))))
