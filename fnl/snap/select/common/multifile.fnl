(fn [get-data]
  (fn [selections winnr]
    (vim.fn.setqflist
      (vim.tbl_map
        (fn [selection] (get-data selection))
        selections))
    (vim.api.nvim_command :copen)
    (vim.api.nvim_command :cfirst)))
