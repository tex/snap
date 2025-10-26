local _2afile_2a = "fnl/snap/select/common/buffer.fnl"
local function _1_(winnr, type, lines, file_type, buffer_name)
  local winnr0 = winnr
  local buffer = vim.fn.bufnr(buffer_name, true)
  vim.api.nvim_buf_set_option(buffer, "buflisted", true)
  do
    local _2_ = type
    if (_2_ == nil) then
      if (winnr0 ~= false) then
        vim.api.nvim_win_set_buf(winnr0, buffer)
      else
      end
    elseif (_2_ == "vsplit") then
      vim.api.nvim_command("vsplit")
      vim.api.nvim_win_set_buf(0, buffer)
      winnr0 = vim.api.nvim_get_current_win()
    elseif (_2_ == "split") then
      vim.api.nvim_command("split")
      vim.api.nvim_win_set_buf(0, buffer)
      winnr0 = vim.api.nvim_get_current_win()
    elseif (_2_ == "tab") then
      vim.api.nvim_command("tabnew")
      vim.api.nvim_win_set_buf(0, buffer)
      winnr0 = vim.api.nvim_get_current_win()
    else
    end
  end
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  local function _5_()
    return vim.api.nvim_command(("set filetype=" .. file_type))
  end
  return vim.api.nvim_buf_call(buffer, _5_)
end
return _1_