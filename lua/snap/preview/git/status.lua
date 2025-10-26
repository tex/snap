local _2afile_2a = "fnl/snap/preview/git/status.fnl"
local snap = require("snap")
local file = require("snap.preview.common.file")
local string = require("snap.common.string")
local io = require("snap.common.io")
local file_diff = require("snap.preview.git.file-diff")
local function _1_(request)
  local parts = string.split(tostring(request.selection), " ")
  local status = parts[1]
  local filename = parts[2]
  if ((status == "M") or (status == "D")) then
    local function _2_(selection)
      return {path = filename}
    end
    return file_diff(_2_)(request)
  else
    local function _3_(selection)
      return {path = filename, lnum = 1, col = 0}
    end
    return file(_3_)(request)
  end
end
return _1_