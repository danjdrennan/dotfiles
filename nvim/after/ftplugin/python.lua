-- Display settings; ruff handles formatting and reads pyproject.toml natively.
-- Override the builtin ftplugin's PEP 8 defaults (4-space) with our preference.
-- vim-sleuth will re-override if the file already uses different indentation.
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.textwidth = 80
vim.opt_local.colorcolumn = "80"
vim.opt_local.wrap = false
