local _2afile_2a = "fnl/snap/select/common/multifile.fnl"
local function _1_(get_data)
  local function _2_(selections, winnr)
    local function _3_(selection)
      return get_data(selection)
    end
    vim.fn.setqflist(vim.tbl_map(_3_, selections))
    vim.api.nvim_command("copen")
    return vim.api.nvim_command("cfirst")
  end
  return _2_
end
return _1_