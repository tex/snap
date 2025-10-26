local _2afile_2a = "fnl/snap/preview/git/file-diff.fnl"
local snap = require("snap")
local file = require("snap.preview.common.file")
local string = require("snap.common.string")
local io = require("snap.common.io")
local function _1_(get_data)
  local function _2_(request)
    local cwd = snap.sync(vim.fn.getcwd)
    local file_data = get_data(request)
    local contents, error = nil, nil
    local function _4_()
      local _3_ = {"diff", "--", file_data.path}
      local function _5_(...)
        return io.system("git", _3_, cwd, ...)
      end
      return _5_
    end
    contents, error = snap.async(_4_())
    local function _6_()
      if not request.canceled() then
        vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, string.split(contents))
        local function _7_()
          return vim.api.nvim_command("set filetype=git")
        end
        return vim.api.nvim_buf_call(request.bufnr, _7_)
      else
        return nil
      end
    end
    return snap.sync(_6_)
  end
  return _2_
end
return _1_