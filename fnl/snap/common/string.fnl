(module snap.common.string)

(defn split [str sep]
  (icollect [_ line (ipairs (vim.split str (or sep "\n") true))]
    (let [trimmed (vim.trim line)]
      (if (not= trimmed "") trimmed))))
