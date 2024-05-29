(let [snap (require :snap)
      io (snap.get :common.io)
      string (snap.get :common.string)]
  (fn [request {: args : cwd }]
    (print :tags-general)
    (print (vim.inspect args))
    (let [cmd (if (io.exists (.. cwd "/" ".ttags.0.db")) :ttags
                  (io.exists (.. cwd "/" "GTAGS")) :global
                  (coroutine.yield nil))]
      (each [data err cancel (io.spawn cmd args cwd)]
        (if
          (request.canceled) (do (cancel) (coroutine.yield nil))
          (not= err "") (coroutine.yield nil)
          (= data "") (snap.continue)
          (coroutine.yield (string.split data)))))))
