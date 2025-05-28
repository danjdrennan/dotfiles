require("danjd.remap")
require("danjd.set")
require("danjd.harpoon")

local augroup = vim.api.nvim_create_augroup

local BufferAutos = augroup('BufferAutos', {})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = BufferAutos,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
