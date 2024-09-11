local _2afile_2a = "fnl/snap/producer/ripgrep/vimgrep.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local general = snap.get("producer.ripgrep.general")
local vimgrep = {}
local args = {"--line-buffered", "-M", 100, "--vimgrep", "-S"}
local line_args = {"--line-buffered", "-M", 100, "--no-heading", "--column"}
local function if_request_filter(cmd, request, _1_)
  local _arg_2_ = _1_
  local args0 = _arg_2_["args"]
  local cwd = _arg_2_["cwd"]
  if (request.filter ~= "") then
    return cmd(request, {args = args0, cwd = cwd})
  else
    return coroutine.yield(nil)
  end
end
vimgrep.default = function(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return if_request_filter(general, request, {args = tbl.concat(args, {request.filter}), cwd = cwd})
end
vimgrep.hidden = function(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return if_request_filter(general, request, {args = tbl.concat(args, {"--hidden", request.filter}), cwd = cwd})
end
vimgrep.line = function(new_args, cwd)
  local args0 = tbl.concat(line_args, new_args)
  local absolute = (cwd ~= nil)
  local function _4_(request)
    local cmd = (cwd or snap.sync(vim.fn.getcwd))
    return general(request, {args = tbl.concat(args0, {request.filter}), cwd = cwd, absolute = absolute})
  end
  return _4_
end
vimgrep.open_files = function(request)
  local open_files
  local function _5_()
    local function _6_(_2410)
      return vim.api.nvim_buf_get_name(_2410)
    end
    return vim.tbl_map(_6_, vim.api.nvim_list_bufs())
  end
  open_files = snap.sync(_5_)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = tbl.concat(args, tbl.concat(open_files, {request.filter})), cwd = cwd})
end
vimgrep.args = function(new_args, cwd)
  local args0 = tbl.concat(args, new_args)
  local absolute = (cwd ~= nil)
  local function _7_(request)
    local cwd0 = (cwd or snap.sync(vim.fn.getcwd))
    return general(request, {args = tbl.concat(args0, {request.filter}), cwd = cwd0, absolute = absolute})
  end
  return _7_
end
return vimgrep