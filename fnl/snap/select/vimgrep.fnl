(local snap (require :snap))
(local parse (require :snap.common.vimgrep.parse))
(local file (require :snap.select.common.file))

(local pwdparse
  (fn [selection]
    (local {: filename : lnum : col} (parse selection))
    {:filename (.. (or (snap.getcwd) ".") "/" filename) : lnum : col}))

(local select
  (file (fn [selection] (pwdparse selection))))

(fn multiselect [selections winnr]
  (vim.fn.setqflist (vim.tbl_map pwdparse selections))
  (vim.api.nvim_command :copen)
  (vim.api.nvim_command :cfirst))

{: select
 : multiselect}
