(local snap (require :snap))
(local file (require :snap.select.common.file))

(local tostruct
  (fn [selection] {:filename (snap.topath selection)}))

(local select
  (file (fn [selection] (tostruct selection))))

(fn multiselect [selections winnr]
  (vim.fn.setqflist (vim.tbl_map tostruct selections))
  (vim.api.nvim_command :copen)
  (vim.api.nvim_command :cfirst))

{: select
 : multiselect}
