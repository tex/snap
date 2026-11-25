local _2afile_2a = "fnl/snap/preview/git/log.fnl"
local snap = require("snap")
local string = require("snap.common.string")
local io = require("snap.common.io")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  local contents, error = nil, nil
  local function _3_()
    local _2_ = {"diff-tree", "-p", request.selection.hash, "--"}
    local function _4_(...)
      return io.system("git", _2_, cwd, ...)
    end
    return _4_
  end
  contents, error = snap.async(_3_())
  if (error ~= nil) then
    local function _5_()
      vim.notify(("cwd: " .. cwd))
      vim.notify(("error: " .. vim.inspect(error)))
      return vim.notify(":snap:preview:git:log error, see :messages", vim.log.levels.ERROR)
    end
    snap.sync(_5_)
  else
  end
  local function _7_()
    if not request.canceled() then
      vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, string.split(contents))
      local function _8_()
        return vim.api.nvim_command("set filetype=git")
      end
      return vim.api.nvim_buf_call(request.bufnr, _8_)
    else
      return nil
    end
  end
  return snap.sync(_7_)
end
return _1_