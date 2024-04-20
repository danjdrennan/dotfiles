require("danjd.remap")
require("danjd.set")
require("danjd.harpoon")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local BufferAutos = augroup('BufferAutos', {})

autocmd({ "BufWritePre" }, {
    group = BufferAutos,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
