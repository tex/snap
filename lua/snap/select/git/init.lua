local _2afile_2a = "fnl/snap/select/git/init.fnl"
local snap = require("snap")
local layout = require("snap.layout")
local tbl = require("snap.common.tbl")
local snap_string = require("snap.common.string")
local io = require("snap.common.io")
local buffer = require("snap.select.common.buffer")
local filter = require("snap.consumer.fzy")
local function action_layout(actions, has_view, reverse)
  local columns = layout.columns()
  local lines = layout.lines()
  local max_length = tbl["max-length"](actions)
  local width = (max_length * 3)
  local height = (#actions + 3)
  return {input = {width = width, height = 1, col = layout.middle(columns, width), row = (layout.middle(lines, height) - 3)}, results = {width = width, height = height, col = layout.middle(columns, width), row = layout.middle(lines, height)}, view = {width = 0, height = 0, col = 0, row = 0}}
end
local function checkout(selection, winnr, type, on_done)
  vim.notify(string.format("Checking out '%s'", tostring(selection)))
  local function _1_(_241)
    local _2_ = _241.code
    if (_2_ == 0) then
      vim.notify(string.format("Checked out '%s'", tostring(selection)), vim.log.levels.INFO)
      if on_done then
        return vim.schedule(on_done)
      else
        return nil
      end
    elseif true then
      local _ = _2_
      return vim.notify(string.format("Error when checking out '%s':\n%s", tostring(selection), _241.stderr), vim.log.levels.ERROR)
    else
      return nil
    end
  end
  return vim.system({"git", "checkout", (selection.hash or tostring(selection))}, {cwd = snap.getcwd()}, _1_)
end
local function reset_soft(selection)
  local function _5_(_241)
    if (_241.code == 0) then
      return vim.notify(string.format("Soft reset '%s'", tostring(selection)), vim.log.levels.INFO)
    else
      return nil
    end
  end
  return vim.system({"git", "reset", "--soft", tostring(selection)}, {cwd = snap.getcwd()}, _5_)
end
local function reset_hard(selection)
  local function _7_(_241)
    if (_241.code == 0) then
      return vim.notify(string.format("Hard reset '%s'", tostring(selection)), vim.log.levels.INFO)
    else
      return nil
    end
  end
  return vim.system({"git", "reset", "--hard", tostring(selection)}, {cwd = snap.getcwd()}, _7_)
end
local function pull(branch, remote)
  local function _9_()
    local function _10_(_2410)
      if (_2410.code == 0) then
        return vim.notify(string.format("Pulled '%s/%s'", tostring(remote), tostring(branch)), vim.log.levels.INFO)
      else
        return nil
      end
    end
    return vim.system({"git", "pull", tostring(remote), tostring(branch)}, {cwd = snap.getcwd()}, _10_)
  end
  return checkout(branch, 0, 0, _9_)
end
local function pull_list(branch)
  local function _12_(_241)
    if (_241.code == 0) then
      local remotes = snap_string.split(_241.stdout)
      local function _13_()
        local function _14_()
          return remotes
        end
        local function _15_(...)
          return vim.schedule_wrap(pull)(branch, ...)
        end
        local function _16_(...)
          return action_layout(remotes, ...)
        end
        return snap.run({prompt = "Select>", producer = filter(_14_), select = _15_, layout = _16_})
      end
      return vim.schedule(_13_)
    else
      return nil
    end
  end
  return vim.system({"git", "remote"}, {cwd = snap.getcwd()}, _12_)
end
local function select(selection, winnr, type)
  local function _18_(_241)
    if (_241.code == 0) then
      local lines = snap_string.split(_241.stdout)
      local buffer_name = tostring(selection.hash)
      local function _19_()
        return buffer(winnr, type, lines, "git", buffer_name)
      end
      return vim.schedule(_19_)
    else
      return nil
    end
  end
  return vim.system({"git", "diff-tree", "-p", selection.hash}, {cwd = snap.getcwd()}, _18_)
end
local branch_actions
local function _21_(_241)
  return snap.with_metas(_241.label, _241)
end
branch_actions = vim.tbl_map(_21_, {{label = "Select", action = select}, {label = "Checkout", action = checkout}, {label = "Reset (soft)", action = reset_soft}, {label = "Reset (hard)", action = reset_hard}, {label = "Pull", action = pull_list}})
local function branch(selection, winnr, type)
  local function _22_()
    return branch_actions
  end
  local function _23_(_241)
    return _241.action(selection, winnr, type)
  end
  local function _24_(...)
    return action_layout(branch_actions, ...)
  end
  return snap.run({prompt = "Select>", producer = filter(_22_), select = _23_, layout = _24_})
end
return branch