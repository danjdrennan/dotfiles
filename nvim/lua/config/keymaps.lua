local keymap = vim.keymap.set

-- Keymaps for better default experience
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- File explorer
keymap("n", "-", "<Cmd>Oil<CR>", { desc = "Open parent directory" })

-- Center on G
keymap("n", "G", "Gzz")

-- Quickfix navigation
keymap("n", "<C-n>", ":cnext<CR>")
keymap("n", "<C-p>", ":cprev<CR>")

-- Buffer management
keymap("n", "<leader>bd", function()
  local curbuf = vim.api.nvim_get_current_buf()
  for buf in pairs(vim.api.nvim_list_bufs()) do
    if buf ~= curbuf and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = "Delete all other buffers" })

-- Edit config
keymap("n", "<leader>ec", function()
  local oil = require("oil")
  oil.open(vim.fn.stdpath("config"))
end, { desc = "Edit config" })

-- Todo lists
keymap("n", "<leader>pt", function()
  local oil = require("oil")
  oil.open("~/todo")
end, { desc = "View todo lists" })

keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
keymap("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Open diagnostics loc list" })
keymap("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Open diagnostics list" })

keymap("n", "<leader>ic", function()
  local input = vim.fn.input("Section Name: ")
  if input == "" then return end

  local width = vim.o.textwidth
  local text = input:upper()

  local cms = vim.bo.commentstring
  local comment_char = cms:gsub("%%s.*", ""):gsub("%s+$", "")

  local padding = math.floor((width - #text) / 2)
  local left_pad = string.rep(" ", padding)

  local border = comment_char .. " " .. string.rep("-", width - 2 - #comment_char)
  local centered_text = comment_char .. left_pad .. text

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, false, { border, centered_text, border, "" })
  pcall(vim.api.nvim_win_set_cursor, 0, { row + 4, 0 })
end, { desc = "Insert centered section comment" })

-- LSP keymaps applied on attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local function map(keys, func, desc)
      keymap("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end


    local ok, fzf = pcall(require, "fzf-lua")
    if ok then
      map("gd", fzf.lsp_definitions, "Goto Definition")
      map("grr", fzf.lsp_references, "Goto References")
      map("gri", fzf.lsp_implementations, "Goto Implementation")
      map("grt", fzf.lsp_typedefs, "Type Definition")
      map("<leader>ds", fzf.lsp_document_symbols, "Document Symbols")
      map("<leader>ws", fzf.lsp_live_workspace_symbols, "Workspace Symbols")
    end

    map("<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
    map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
      vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
  end,
})

keymap("n", "<leader>tf", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
end, { desc = "Toggle Autoformat" })

keymap("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle LSP-derived inlay hints" })

keymap("n", "<leader>f", function()
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
)
