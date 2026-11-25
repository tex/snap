(local snap (require :snap))
(local string (require :snap.common.string))
(local io (require :snap.common.io))

(fn [request]
  (local cwd (snap.getcwd))
  (local (contents error) (snap.async (partial io.system :git [:diff-tree :-p request.selection.hash :--] cwd)))
  (if (not= error nil) (do (snap.sync (fn []
                                       (vim.notify (.. "cwd: " cwd))
                                       (vim.notify (.. "error: " (vim.inspect error)))
                                       (vim.notify ":snap:preview:git:log error, see :messages" vim.log.levels.ERROR)))))
  (snap.sync (fn []
    (when
      (not (request.canceled))
      (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false (string.split contents))
      (vim.api.nvim_buf_call request.bufnr (fn []
        (vim.api.nvim_command "set filetype=git")))))))
