(let [snap (require :snap)
      get (snap.get :preview.get)]
  (fn [request]
    (local path (snap.sync (partial vim.fn.fnamemodify (tostring request.selection) ":p")))
    ;; Get the preview
    (var preview (get path))
    ;; Write the preview to the buffer.
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; We don't need a cursorline
        (vim.api.nvim_win_set_option request.winnr :cursorline false)
        (vim.api.nvim_win_set_option request.winnr :cursorcolumn false)
        ;; Set the preview
        (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false preview)
        (set preview nil))))

    ;; Do file type detection
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; In case it's accidently saved
        (local fake-path (.. (vim.fn.tempname) "%" (vim.fn.fnamemodify (tostring request.selection) ":p:gs?/?%?")))
        ;; Use the fake path to enable ftdetection
        (vim.api.nvim_buf_set_name request.bufnr fake-path)
        ;; Detect the file type
        (vim.api.nvim_buf_call request.bufnr (partial vim.api.nvim_command "filetype detect")))))

    ;; Free memory
    (set preview nil)))
