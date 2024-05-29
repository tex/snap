(let [snap (require :snap)
      tbl (snap.get :common.tbl)
      general (snap.get :producer.tags.general)]
    (fn [request]
      (let [cwd (snap.sync vim.fn.getcwd)]
        (if
          (= request.filter "")
          (coroutine.yield nil)
          (general request
                   {:args ["-d" request.filter] : cwd})))))
