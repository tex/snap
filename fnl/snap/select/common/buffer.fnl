(fn [winnr type lines file-type buffer-name]
  (var winnr winnr)
      (local buffer (vim.fn.bufnr buffer-name true))
      (vim.api.nvim_buf_set_option buffer :buflisted true)
      (match type
        nil (when (not= winnr false)
              (vim.api.nvim_win_set_buf winnr buffer))
        :vsplit (do
                  (vim.api.nvim_command "vsplit")
                  (vim.api.nvim_win_set_buf 0 buffer)
                  (set winnr (vim.api.nvim_get_current_win)))
        :split (do
                 (vim.api.nvim_command "split")
                 (vim.api.nvim_win_set_buf 0 buffer)
                 (set winnr (vim.api.nvim_get_current_win)))
        :tab (do
               (vim.api.nvim_command "tabnew")
               (vim.api.nvim_win_set_buf 0 buffer)
               (set winnr (vim.api.nvim_get_current_win))))
      (vim.api.nvim_buf_set_lines buffer 0 -1 false lines)
      (vim.api.nvim_buf_call buffer (fn [] (vim.api.nvim_command (.. "set filetype=" file-type)))) )
