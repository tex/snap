local _2afile_2a = "fnl/snap/producer/tags/def.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local general = snap.get("producer.tags.general")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  if (request.filter == "") then
    return coroutine.yield(nil)
  else
    return general(request, {args = {"-d", request.filter}, cwd = cwd})
  end
end
return _1_