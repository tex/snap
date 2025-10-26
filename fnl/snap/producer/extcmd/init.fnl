(let [snap (require :snap)
      tbl (snap.get :common.tbl)
      io (snap.get :common.io)
      string (snap.get :common.string)]
  (fn [{: cmd : args : parse : ignore_empty_filter : ignore_filter}]
    "ignore_empty_filter : if true then this producer is not run if filter is empty"
    "ignore_filter : if true then this producer is run without passing filter to external command"
    (fn [request]
      (if
        (and ignore_empty_filter (= request.filter ""))
        (coroutine.yield nil)
        (let [cwd (snap.getcwd)
              args (tbl.concat args
                               (string.split (or (snap.getparams) "") " ")
                               (if (= ignore_filter true) [] [request.filter]))]
          (each [data err cancel (io.spawn cmd args cwd)]
            (if
              (request.canceled) (do (cancel)
                                     (coroutine.yield nil))
              (not= err "") (do (snap.sync (fn []
                                             (vim.notify (.. "cwd: " (or cwd ".")))
                                             (vim.notify (.. "cmd: " cmd))
                                             (vim.notify (.. "args: " (vim.inspect args)))
                                             ; needs to use vim.inspect to remove new lines as they cause
                                             ; "Press ENTER or type command to continue"
                                             (vim.notify (.. "error: " (vim.inspect err)))
                                             (vim.notify ":snap:producer:extcmd error, see :messages" vim.log.levels.ERROR)
                                             ))
                                (coroutine.yield nil))
              (= data "") (snap.continue)
              (coroutine.yield (parse data)))))))))
