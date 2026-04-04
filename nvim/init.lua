-- Set <space> as the leader key (must happen before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap and start lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = {
    colorscheme = { "catppuccin-mocha" },
  },
  checker = { enabled = false },
})

-- Enable LSP servers (configs live in lsp/*.lua, auto-discovered by Neovim)
vim.lsp.enable({
  "clangd",
  "lua_ls",
  "ruff",
  "rust_analyzer",
  "texlab",
  "tinymist",
  "ty",
  "zls",
})
