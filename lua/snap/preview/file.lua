local _2afile_2a = "fnl/snap/preview/file.fnl"
local snap = require("snap")
local file = require("snap.preview.common.file")
local function _1_(selection)
  return {path = snap.topath(selection), lnum = nil, col = nil}
end
return file(_1_)