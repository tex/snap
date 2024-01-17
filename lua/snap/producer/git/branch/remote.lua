local _2afile_2a = "fnl/snap/producer/git/branch/remote.fnl"
local snap = require("snap")
local general = require("snap.producer.git.general")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = {"branch", "-r", "--sort", "-committerdate", "--format", "%(refname:short)"}, cwd = cwd})
end
return _1_