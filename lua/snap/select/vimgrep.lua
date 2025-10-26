local _2afile_2a = "fnl/snap/select/vimgrep.fnl"
local snap = require("snap")
local parse = require("snap.common.vimgrep.parse")
local file = require("snap.select.common.file")
local pwdparse
local function _1_(selection)
  local _local_2_ = parse(selection)
  local filename = _local_2_["filename"]
  local lnum = _local_2_["lnum"]
  local col = _local_2_["col"]
  return {filename = ((snap.getcwd() or ".") .. "/" .. filename), lnum = lnum, col = col}
end
pwdparse = _1_
local select
local function _3_(selection)
  return pwdparse(selection)
end
select = file(_3_)
local function multiselect(selections, winnr)
  vim.fn.setqflist(vim.tbl_map(pwdparse, selections))
  vim.api.nvim_command("copen")
  return vim.api.nvim_command("cfirst")
end
return {select = select, multiselect = multiselect}