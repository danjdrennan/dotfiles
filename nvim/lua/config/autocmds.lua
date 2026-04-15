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
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
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

-- Python: resolve language server's formatting settings to update local file
-- settings.
local lsp_opt_resolvers = {
  ruff = function(root)
    for _, name in ipairs({ "ruff.toml", ".ruff.toml", "pyproject.toml" }) do
      local f = io.open(root .. "/" .. name, "r")
      if f then
        for line in f:lines() do
          local m = line:match("^line%-length%s*=%s*(%d+)")
          if m then
            f:close()
            local n = tonumber(m)
            return { textwidth = n, colorcolumn = tostring(n) }
          end
        end
        f:close()
      end
    end
  end,
}

-- Saved pre-override values, keyed by bufnr.
local saved_lsp_opts = {}

vim.api.nvim_create_user_command("LspOptToggle", function()
  local bufnr = vim.api.nvim_get_current_buf()
  if saved_lsp_opts[bufnr] then
    for k, v in pairs(saved_lsp_opts[bufnr]) do
      vim.opt_local[k] = v
    end
    saved_lsp_opts[bufnr] = nil
  else
    local overrides = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
      local resolver = lsp_opt_resolvers[client.name]
      if resolver then
        local result = resolver(client.config.root_dir or vim.fn.getcwd())
        if result then
          for k, v in pairs(result) do overrides[k] = v end
        end
      end
    end
    if next(overrides) then
      local saved = {}
      for k in pairs(overrides) do
        saved[k] = vim.opt_local[k]:get()
      end
      saved_lsp_opts[bufnr] = saved
      for k, v in pairs(overrides) do
        vim.opt_local[k] = v
      end
    end
  end
end, {})

-- Format on save via LSP
vim.g.disable_autoformat = false

vim.api.nvim_create_user_command("FormatToggle", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  print("Autoformat: " .. (vim.g.disable_autoformat and "Disabled" or "Enabled"))
end, {})
