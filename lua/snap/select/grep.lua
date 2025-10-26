local _2afile_2a = "fnl/snap/select/grep.fnl"
local snap = require("snap")
local parse = require("snap.common.grep.parse")
local file = require("snap.select.common.file")
local multifile = require("snap.select.common.multifile")
local parse_selection
local function _1_(selection)
  local _local_2_ = parse(selection)
  local filename = _local_2_["filename"]
  local lnum = _local_2_["lnum"]
  return {filename = snap.topath(filename), lnum = lnum, col = 0}
end
parse_selection = _1_
local select
local function _3_(selection)
  return parse_selection(selection)
end
select = file(_3_)
local multiselect
local function _4_(selection)
  return parse_selection(selection)
end
multiselect = multifile(_4_)
return {select = select, multiselect = multiselect}