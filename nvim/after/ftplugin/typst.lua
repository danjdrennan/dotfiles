-- Display settings; tinymist provides formatting
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.spell = true
vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = "72"
vim.opt_local.wrap = false

vim.opt_local.makeprg = "typst compile"
vim.opt_local.errorformat = '%E File "%f"\\, line %l\\, in %\\+%.%#,' ..
    '%Z%\\s\\+^,' ..
    '%C%\\s%\\+%m,' ..
    '%-G%.%#'
