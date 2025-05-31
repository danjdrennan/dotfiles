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

vim.api.nvim_create_autocmd("BufWritePost", {
    group = BufferAutos,
    pattern = "*",
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })

        -- Filter clients that can format
        local formatters = {}
        for _, client in ipairs(clients) do
            if client.server_capabilities.documentFormattingProvider then
                table.insert(formatters, client)
            end
        end

        if #formatters == 0 then
            return -- No formatters available, skip silently
        elseif #formatters == 1 then
            vim.lsp.buf.format({ id = formatters[1].id })
        else
            -- Multiple formatters: use first available
            vim.lsp.buf.format({ id = formatters[1].id })
        end
    end
})
