local _2afile_2a = "fnl/snap/common/git/parse-log.fnl"
local snap = require("snap")
local function _1_(entry)
  local _end = entry:find(" ")
  return snap.with_metas(entry:sub(1, 200), {hash = entry:sub(1, (_end - 1)), comment = entry:sub((_end + 1), -1)})
end
return _1_