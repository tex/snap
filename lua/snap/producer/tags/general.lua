local _2afile_2a = "fnl/snap/producer/tags/general.fnl"
local snap = require("snap")
local io = snap.get("common.io")
local string = snap.get("common.string")
local function _3_(request, _1_)
  local _arg_2_ = _1_
  local args = _arg_2_["args"]
  local cwd = _arg_2_["cwd"]
  print("tags-general")
  print(vim.inspect(args))
  local cmd
  if io.exists((cwd .. "/" .. ".ttags.0.db")) then
    cmd = "ttags"
  elseif io.exists((cwd .. "/" .. "GTAGS")) then
    cmd = "global"
  else
    cmd = coroutine.yield(nil)
  end
  for data, err, cancel in io.spawn(cmd, args, cwd) do
    if request.canceled() then
      cancel()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      snap.continue()
    else
      coroutine.yield(string.split(data))
    end
  end
  return nil
end
return _3_