vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "G", "Gzz")

vim.keymap.set("n", "<C-n>", ":cnext<CR>")
vim.keymap.set("n", "<C-p>", ":cprev<CR>")

vim.keymap.set("n", "<leader>bl", function() vim.cmd.buffers() end)
vim.keymap.set("n", "<leader>bd", function()
    local current_buff = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current_buff and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
end)
