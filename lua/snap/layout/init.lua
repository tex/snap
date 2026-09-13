local _2afile_2a = "fnl/snap/layout/init.fnl"
local _2amodule_name_2a = "snap.layout"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local function lines()
  return vim.api.nvim_get_option_value("lines", {})
end
_2amodule_2a["lines"] = lines
local function columns()
  return vim.api.nvim_get_option_value("columns", {})
end
_2amodule_2a["columns"] = columns
local function percent(size, percent0)
  return math.floor((size * percent0))
end
_2amodule_2a["percent"] = percent
local function middle(total, size)
  return math.floor(((total - size) / 2))
end
_2amodule_2a["middle"] = middle
local function centered()
  return {input = {width = columns(), height = 1, row = (lines() - 4), col = 0}, results = {width = columns(), height = 10, row = (lines() - 4 - 12), col = 0}, view = {width = columns(), height = (lines() - 4 - 12 - 2), row = 0, col = 0}}
end
_2amodule_2a["centered"] = centered
return _2amodule_2a