-- ~/.config/nvim/after/ftplugin/python.lua
vim.filetype.add {
  extension = {
    py = "python"
  },
}

-- TODO: Validate that we're inside a proper toml section for these parameters
-- rather than just parsing them from anywhere in the config. This works for
-- now with the projects I'm working on, but is brittle to breaking changes of
-- any kind.
local function parse_pyproject_toml()
  local root = vim.fs.root(0, "pyproject.toml")

  if root == nil then
    return {}
  end

  local pyproject = vim.fs.joinpath(root, 'pyproject.toml')
  local settings = {}

  for _, line in ipairs(vim.fn.readfile(pyproject)) do
    local ll = line:match("line-length%s=%s*(%d+)")
    if ll ~= nil then
      settings.line_length = tonumber(ll)
    end

    local iw = line:match("indent%-width%s=%s*(%d+)")
    if iw ~= nil then
      settings.indent_width = tonumber(iw)
    end

    local is = line:match("indent-style%s=%s*\"(%w+)\"")
    if is ~= nil then
      settings.indent_style = is
    end
  end

  return settings
end

local settings = parse_pyproject_toml()

vim.opt_local.textwidth = settings.line_length or 80
vim.opt_local.colorcolumn = tostring(settings.line_length or 80)

vim.opt_local.tabstop = settings.indent_width or 2
vim.opt_local.shiftwidth = settings.indent_width or 2
vim.opt_local.wrapmargin = settings.indent_width or 2

vim.opt_local.expandtab = (settings.indent_style ~= "tab")

vim.opt_local.wrap = false
vim.opt_local.expandtab = true
vim.b.sleuth_automatic = 0
