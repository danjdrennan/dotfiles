local augroup = vim.api.nvim_create_augroup

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("StripWhitespace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Format on save via LSP
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup("FormatOnSave", { clear = true }),
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    local formatters = {}
    for _, client in ipairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
        table.insert(formatters, client)
      end
    end

    if #formatters > 0 then
      vim.lsp.buf.format({ id = formatters[1].id })
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
