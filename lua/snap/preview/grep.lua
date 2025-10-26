local _2afile_2a = "fnl/snap/preview/grep.fnl"
local snap = require("snap")
local file = require("snap.preview.common.file")
local parse = require("snap.common.grep.parse")
local function _1_(selection)
  local _local_2_ = parse(tostring(selection))
  local filename = _local_2_["filename"]
  local lnum = _local_2_["lnum"]
  return {path = snap.topath(filename), lnum = lnum, col = 0}
end
return file(_1_)