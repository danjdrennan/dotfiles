local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Strip trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("StripWhitespace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.hl.hl_op()
  end,
})

autocmd("BufWritePost", {
  group = augroup("FormatOnSave", { clear = true }),
  pattern = "*",
  callback = function()
    if not vim.g.disable_autoformat then
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
    end
  end,
})
