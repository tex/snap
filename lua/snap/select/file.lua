local _2afile_2a = "fnl/snap/select/file.fnl"
local snap = require("snap")
local file = require("snap.select.common.file")
local tostruct
local function _1_(selection)
  return {filename = snap.topath(selection)}
end
tostruct = _1_
local select
local function _2_(selection)
  return tostruct(selection)
end
select = file(_2_)
local function multiselect(selections, winnr)
  vim.fn.setqflist(vim.tbl_map(tostruct, selections))
  vim.api.nvim_command("copen")
  return vim.api.nvim_command("cfirst")
end
return {select = select, multiselect = multiselect}