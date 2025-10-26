local _2afile_2a = "fnl/snap/producer/extcmd/init.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local io = snap.get("common.io")
local string = snap.get("common.string")
local function _3_(_1_)
  local _arg_2_ = _1_
  local cmd = _arg_2_["cmd"]
  local args = _arg_2_["args"]
  local parse = _arg_2_["parse"]
  local ignore_empty_filter = _arg_2_["ignore_empty_filter"]
  local ignore_filter = _arg_2_["ignore_filter"]
  local function _4_(request)
    if (ignore_empty_filter and (request.filter == "")) then
      return coroutine.yield(nil)
    else
      local cwd = snap.getcwd()
      local args0
      local function _5_()
        if (ignore_filter == true) then
          return {}
        else
          return {request.filter}
        end
      end
      args0 = tbl.concat(args, string.split((snap.getparams() or ""), " "), _5_())
      for data, err, cancel in io.spawn(cmd, args0, cwd) do
        if request.canceled() then
          cancel()
          coroutine.yield(nil)
        elseif (err ~= "") then
          local function _6_()
            vim.notify(("cwd: " .. (cwd or ".")))
            vim.notify(("cmd: " .. cmd))
            vim.notify(("args: " .. vim.inspect(args0)))
            vim.notify(("error: " .. vim.inspect(err)))
            return vim.notify(":snap:producer:extcmd error, see :messages", vim.log.levels.ERROR)
          end
          snap.sync(_6_)
          coroutine.yield(nil)
        elseif (data == "") then
          snap.continue()
        else
          coroutine.yield(parse(data))
        end
      end
      return nil
    end
  end
  return _4_
end
return _3_