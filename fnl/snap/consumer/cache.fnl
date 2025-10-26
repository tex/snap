(let [snap (require :snap)
      tbl (snap.get :common.tbl)]
  (fn [producer]
    "Provides a method to avoid running passed producer multiple times"
    (var cache [])
    (var cache-cwd nil)

    (fn [request]
      (let [cwd (snap.sync snap.getcwd)]
        (if (not (= cache-cwd cwd))
          (do
            (set cache-cwd cwd)
            (set cache []))))
      (if (= (length cache) 0)
        (each [results (snap.consume producer request)]
          (if
            (> (length results) 0)
            (do
              (tbl.acc cache results)
              (coroutine.yield results))
            (snap.continue)))
        cache))))
