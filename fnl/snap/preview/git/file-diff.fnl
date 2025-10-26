(local snap (require :snap))
(local file (require :snap.preview.common.file))
(local string (require :snap.common.string))
(local io (require :snap.common.io))

(fn [get-data]
  (fn [request]
    (local cwd (snap.sync vim.fn.getcwd))
    (local file-data (get-data request))
    (local (contents error) (snap.async (partial io.system :git [:diff "--" file-data.path] cwd)))

    (snap.sync (fn []
      (when
        (not (request.canceled))
        (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false (string.split contents))
        (vim.api.nvim_buf_call request.bufnr (fn []
          (vim.api.nvim_command "set filetype=git"))))))))
